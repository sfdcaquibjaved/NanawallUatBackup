// Full Circle Response Reanimator, V1.8, 11/13/15
public with sharing class FC_ResponseReanimator {

    private static FC_ResponseReanimateManager__c setting = FC_ResponseReanimateManager__c.getInstance('default');

    public static void requestHandler(Map<Id, CampaignMember> newMap)
    {
        Set<Id> respPromptCampaignIds = FCRM.FCR_SupportAPI.GetResponsePromptCampaignIDs();
        Map<Id, CampaignMember> respByrespPromptPersonId = new Map<Id, CampaignMember>();        
        
        Map<Id, Campaign> camps = new Map<Id, Campaign>([Select Id, FC_Defer_To_Reanimation__c, FC_Exclude_From_Reanimation__c From Campaign Where Id IN :respPromptCampaignIds]);
        
        for (CampaignMember cm : newMap.values())
        {           
            if (cm.HasResponded && ((respPromptCampaignIds.contains(cm.CampaignId) && camps.get(cm.CampaignId).FC_Defer_To_Reanimation__c) 
                || (respPromptCampaignIds.contains(cm.FCRM__FCR_Campaign_Repeat_Parent__c) && camps.get(cm.FCRM__FCR_Campaign_Repeat_Parent__c).FC_Defer_To_Reanimation__c)))
            {
                respByrespPromptPersonId.put(cm.ContactId == null ? cm.LeadId : cm.ContactId, cm);
            }
        }         
        
        system.debug('respByrespPromptPersonId' + respByrespPromptPersonId);
        
        // Exit if no campaign member records are part of a response prompt campaign and have FC_Defer_To_Reanimation__c = true
        if (respByrespPromptPersonId != null && respByrespPromptPersonId.size() == 0) return;
        
        Map<Id, sObject> personRecById = new Map<Id, sObject>([Select Id From Contact Where Id IN :respByrespPromptPersonId.keySet()]);
        Map<Id, sObject> leadRecById = new Map<Id, sObject>([Select Id From Lead Where Id IN :respByrespPromptPersonId.keySet()]);
        personRecById.putAll(leadRecById);

        // Remove persons with an active response
        List<Id> personRecIds = new List<Id>();
        for (Id personRecId : respByrespPromptPersonId.keySet()) personRecIds.add(personRecId);     
        List<CampaignMember> activeResponses = FCRM.FCR_SupportAPI.GetActiveResponses(personRecIds);
        for (CampaignMember cm : activeResponses)
        {
            Id personId = cm.ContactId != null ? cm.ContactId : cm.LeadId;
            if (!newMap.containsKey(cm.Id)) respByrespPromptPersonId.remove(personId);
        }
        
        // Exit if remaining person records have active responses
        if (respByrespPromptPersonId.size() == 0) return; 
        
        List<String> unanimatedStatusValues = setting.Response_Status_Values_to_Consider__c.split(';');
        Date minResponseDate = Date.today() - (Integer)setting.Last_X_Days_Responded_For_Reopen__c; 
        
        List<Id> personRecIds2 = new List<Id>();
        for (Id personRecId : respByrespPromptPersonId.keySet()) personRecIds2.add(personRecId);          
        List<CampaignMember> unanimatedResponses = FindDQdOrUnopenedResponses(newMap.keySet(), personRecIds2, unanimatedStatusValues, minResponseDate);  
        
        system.debug('unanimatedResponses' + unanimatedResponses);
        
        if (unanimatedResponses.size() > 0)
        {
            Set<Id> respPromptsToDelete = new Set<Id>();
            List<CampaignMember> respToReopen = new List<CampaignMember>();
            Set<Id> personIdsSeen = new Set<Id>();              
            for (CampaignMember cm : unanimatedResponses)
            {
                Id personId = cm.ContactId == null ? cm.LeadId : cm.ContactId;
                if (!personIdsSeen.contains(personId))
                {
                    // Delete the response Prompt Campaign and re-open DQ'd marketing Campaign
                    CampaignMember respPrompt = respByrespPromptPersonId.get(personId);
                    respPromptsToDelete.add(respPrompt.Id);
                    respToReopen.add(cm);
                    // First person seen will be the most recently created response because of Order By clause 
                    personIdsSeen.add(personId);
                }
            }
            reopenResponses(respToReopen, personRecById);
            deleteResponses(respPromptsToDelete);                                              
            
        }       
    }   
    
    public class UnanimatedCM implements Comparable {
    
        public CampaignMember cm;
        public DateTime dt;
        
        public unanimatedCM(CampaignMember cm, DateTime dt) {
            this.cm = cm;
            this.dt = dt;
        } 
        
        public Integer compareTo(Object compareTo) {            
            unanimatedCM compareToCM = (unanimatedCM)compareTo;
            Integer returnValue = 0;
            if ((cm.FCRM__FCR_Response_Date__c != null ? cm.FCRM__FCR_Response_Date__c : cm.CreatedDate) < compareToCM.dt) { 
                returnValue = 1;
            } else if ((cm.FCRM__FCR_Response_Date__c != null ? cm.FCRM__FCR_Response_Date__c : cm.CreatedDate) > compareToCM.dt) {
                returnValue = -1;
            }           
            return returnValue;       
        }
    }    
    
    public static List<CampaignMember> FindDQdOrUnopenedResponses(
        Set<Id> incomingCMIds,      
        List<Id> personIds, 
        List<String> unanimatedStatusValues,
        Date minResponseDate)
    {
        Set<String> unanimatedStatusValuesSet = new Set<String>(unanimatedStatusValues);
        List<CampaignMember> responses = new List<CampaignMember>();
        List<CampaignMember> unanimatedResponses = new List<CampaignMember>();
        List<CampaignMember> unanimatedNonResponses = new List<CampaignMember>(); 
        
        // Get a map of campaign member status values that are considered Responded for each campaign Id        
        Map<Id, Set<String>> cmStatusesByCampaignId = new Map<Id, Set<String>>();
        List<CampaignMemberStatus> cmstatuses = [Select Label, CampaignId From CampaignMemberStatus Where HasResponded = true]; 
        for (CampaignMemberStatus cms : cmstatuses)
        {
            if (!cmStatusesByCampaignId.keySet().contains(cms.CampaignId)) cmStatusesByCampaignId.put(cms.CampaignId, new Set<String>{cms.Label});
            else cmStatusesByCampaignId.get(cms.CampaignId).add(cms.Label);
        }
        
        // Grab the most recent unanimated response
        unanimatedResponses = [Select Id, ContactId, Campaign.FC_Exclude_From_Reanimation__c, FCRM__FCR_Response_Status__c,FC_Reanimation_Date__c, FCRM__FCR_Response_Date__c, LeadId From CampaignMember 
            Where (LeadId IN :personIds or ContactId IN :personIds) 
                and FCRM__FCR_Response_Status__c IN :unanimatedStatusValuesSet
                and Campaign.FC_Exclude_From_Reanimation__c = false
                and FC_Reanimation_Date__c = null
                and FCRM__FCR_Response_Date__c > :minResponseDate
                and Id NOT IN :incomingCMIds
            Order By FCRM__FCR_Response_Date__c DESC Limit 1];
        
        // Grab the most recent unanimated non-response 
        unanimatedNonResponses = [Select Id, FCRM__FCR_Response_Date__c, Status, Campaign.Animated_Non_Response_Member_Status__c, Campaign.FC_Exclude_From_Reanimation__c, FC_Reanimation_Date__c, ContactId, CampaignId, CreatedDate, LeadId From CampaignMember 
            Where (LeadId IN :personIds or ContactId IN :personIds)
                and FCRM__FCR_Response_Date__c = null
                and FC_Reanimation_Date__c = null
                and Campaign.FC_Exclude_From_Reanimation__c = false
                and Campaign.Animated_Non_Response_Member_Status__c != null
                and CreatedDate > :minResponseDate
                and HasResponded = false
                and Id NOT IN :incomingCMIds
            Order By CreatedDate DESC];         
            
        system.debug('Unanimated Responses: ' + unanimatedResponses);   
        system.debug('Unanimated Non-Responses: ' + unanimatedNonResponses);                    
        
        // Add most recent DQ'd or Unopened response
        List<UnanimatedCM> unanimatedCms = new List<UnanimatedCM>();
        
        // Select either most recent response or non-response 
        if (setting.Top_of_Animate_Hierarchy__c == 'Response or Non-Response')
        {
            for (CampaignMember cm : unanimatedResponses) unanimatedCms.add(new UnanimatedCM(cm, cm.FCRM__FCR_Response_Date__c));                   
            for (CampaignMember cm : unanimatedNonResponses) 
            {
                if (cmStatusesByCampaignId.get(cm.CampaignId).contains(cm.Campaign.Animated_Non_Response_Member_Status__c))
                {
                    unanimatedCms.add(new UnanimatedCM(cm, cm.CreatedDate));
                    break;
                }
                                 
            }           
            responses.addAll(getRecentResponses(unanimatedCms));            
        }
        // Select most recent response over non-response
        else if (setting.Top_of_Animate_Hierarchy__c == 'Response')
        {
            for (CampaignMember cm : unanimatedResponses) unanimatedCms.add(new UnanimatedCM(cm, cm.FCRM__FCR_Response_Date__c));           
            if (unanimatedCms.size() == 0)  
            {
                for (CampaignMember cm : unanimatedNonResponses) 
                {
                    if (cmStatusesByCampaignId.get(cm.CampaignId).contains(cm.Campaign.Animated_Non_Response_Member_Status__c))
                    {
                        unanimatedCms.add(new UnanimatedCM(cm, cm.CreatedDate));
                        break;
                    }            
                }                                           
            }   
            responses.addAll(getRecentResponses(unanimatedCms));                
        }
        // Select most recent non-response over response
        else if (setting.Top_of_Animate_Hierarchy__c == 'Non-Response')
        {                                   
            for (CampaignMember cm : unanimatedNonResponses) 
            {
                if (cmStatusesByCampaignId.get(cm.CampaignId).contains(cm.Campaign.Animated_Non_Response_Member_Status__c))
                {
                    unanimatedCms.add(new UnanimatedCM(cm, cm.CreatedDate));
                    break;
                }            
            }                                                   
            if (unanimatedCms.size() == 0)
            {
                for (CampaignMember cm : unanimatedResponses) unanimatedCms.add(new UnanimatedCM(cm, cm.FCRM__FCR_Response_Date__c)); 
            }       
            responses.addAll(getRecentResponses(unanimatedCms));                
        }           
                                    
        return responses;
    }
    
    // Returns a list of the first CampaignMembers per person id seen in cms. 
    // Assumes the list of CampaignMembers is ordered by most recent (FCRM__FCR_Response_Date__c) in descending order  
    public static List<CampaignMember> getRecentResponses(List<UnanimatedCM> cms)
    {

        Set<Id> personIdsSeen = new Set<Id>();
        List<CampaignMember> recentResponse = new List<CampaignMember>();
        if (cms.size() == 0) return recentResponse;
        cms.sort();
        for (UnanimatedCM ucm : cms)
        {
            CampaignMember cm = ucm.cm;
            if (!personIdsSeen.contains(cm.ContactId) && !personIdsSeen.contains(cm.LeadId))
            {
                recentResponse.add(cm);
                personIdsSeen.add(cm.ContactId != null ? cm.ContactId : cm.LeadId);
            }
        }
        return recentResponse;
    }        
    
    // Reopen marketing responses that are currently Disqualified
    public static void reopenResponses(List<CampaignMember> responses, Map<Id, sObject> personRecById)
    {        
        List<Id> contactsToReopen = new List<Id>();
        List<Id> leadsToReopen = new List<Id>();
        List<CampaignMember> responsesToReanimate = new List<CampaignMember>();
        List<CampaignMember> nonResponsesToReanimate = new List<CampaignMember>();
        
        // Reopen responses
        for (CampaignMember cm : responses)
        {           
            Id personRecId = cm.ContactId != null ? cm.ContactId : cm.LeadId;
            sObject personRec = personRecById.get(personRecId);     
            
            for (Schema.FieldSetMember fieldSetToNow : Schema.SObjectType.CampaignMember.FieldSets.FC_Response_Reanimator_Fields_Set_To_Now.getFields())
            {
                if (fieldSetToNow.getType() == DisplayType.Datetime) cm.put(fieldSetToNow.getFieldPath(), Datetime.now());
                else if (fieldSetToNow.getType() == DisplayType.Date) cm.put(fieldSetToNow.getFieldPath(), Date.today());
            }

            for (Schema.FieldSetMember fieldToClear : Schema.SObjectType.CampaignMember.FieldSets.FC_Response_Reanimator_Fields_To_Clear.getFields())
            {
                if (fieldToClear.getType() == DisplayType.Boolean) cm.put(fieldToClear.getFieldPath(), false);
                else cm.put(fieldToClear.getFieldPath(), null);
            }               

            cm.FC_Reanimation_Date__c  = Datetime.now();            
            cm.FCRM__FCR_Status_Last_Set__c = Datetime.now();
            cm.FCRM__FCR_Response_Status__c = setting.Response_Active_Status_Value__c;          
            if (cm.FCRM__FCR_Response_Date__c != null)
            {
                if (cm.ContactId != null) contactsToReopen.add(cm.ContactId);
                else leadsToReopen.add(cm.LeadId);
                responsesToReanimate.add(cm);               
            }
            else 
            {
                cm.Status = cm.Campaign.Animated_Non_Response_Member_Status__c;
                nonResponsesToReanimate.add(cm);
            }                       
        }
        
        if (responsesToReanimate.size() > 0) update responsesToReanimate;                   
        
        if (nonResponsesToReanimate.size() > 0)
        {
            FCRM.FCR_SupportAPI.TreatNextCampaignAssociationsAsResponsePrompts();
            update nonResponsesToReanimate;
            for (CampaignMember cm : nonResponsesToReanimate) cm.Status = cm.Campaign.Animated_Non_Response_Member_Status__c;
            update nonResponsesToReanimate;
        }         
        
        // Reopen associated person record  
        if (contactsToReopen.size() > 0)
        {
            List<Contact> contacts = [Select FCRM__FCR_Status__c From Contact Where Id IN :contactsToReopen];
            for (Contact c : contacts) c.FCRM__FCR_Status__c = setting.Response_Active_Status_Value__c;
            update contacts;
        }
        else if (leadsToReopen.size() > 0)
        {
            List<Lead> leads = [Select Status From Lead Where Id IN :leadsToReopen];
            for (Lead l : leads) l.Status = setting.Response_Active_Status_Value__c;
            update leads;           
        }                       
                                      
    }

    // Delete response prompt campaigns
    public static void deleteResponses(Set<Id> responseIds)
    {       
        FCRM.FCR_SupportAPI.DisableApplicationForContext(); 
        delete [Select Id From CampaignMember Where Id IN :responseIds];
        FCRM.FCR_SupportAPI.UndoDisableApplicationForContext(); 
    }

}