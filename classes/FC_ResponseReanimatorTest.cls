@isTest (SeeAllData=true)
public with sharing class FC_ResponseReanimatorTest {


    private static FC_ResponseReanimateManager__c setting {
        get {
            if (setting == null)
            {
                FC_ResponseReanimateManager__c newsetting = FC_ResponseReanimateManager__c.getInstance('default');
                if (newsetting == null)
                {
                    newsetting = new FC_ResponseReanimateManager__c(
                        name = 'default',
                        Last_X_Days_Responded_For_Reopen__c = 45,
                        Response_Active_Status_Value__c = 'Open',
                        Response_Status_Values_to_Consider__c = 'Disqualified',
                        Top_of_Animate_Hierarchy__c = 'Response or Non-Response'
                    ); 
                    insert newsetting;
                }
                setting = newsetting;
            }
            return setting;         
        }
        set;
    }
    
    private static String getRespondedCampaignMemberStatus(Id campaignId)
    {
        Map<Id, Set<String>> cmStatusesByCampaignId = new Map<Id, Set<String>>();
        List<CampaignMemberStatus> cmstatuses = [Select Label, CampaignId From CampaignMemberStatus Where HasResponded = true and CampaignId = :campaignId]; 
        return cmstatuses[0].Label;     
    }
    
    static testMethod void TestResponseAndNonResponseReanimation() 
    
    {
        User testUser2 = TestDataUtility.createUser('System Administrator','test@testingupdate.com');
        insert testUser2;
          
        list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;
        
        setting.Top_of_Animate_Hierarchy__c = 'Response or Non-Response';
        update setting;
        FCRM.FCR_SupportAPI.SetRepeatResponseUserForContext();
        
        List<Contact> cts = initTestContacts('cts', 1);
        insert cts;
        
        List<Campaign> camps = initTestCampaigns('cmp', 2);
        camps[0].FC_Exclude_From_Reanimation__c = false;
        camps[1].FC_Exclude_From_Reanimation__c = false;
        insert camps;        
        
        camps[0].Animated_Non_Response_Member_Status__c = getRespondedCampaignMemberStatus(camps[0].Id);
        update camps[0];
        
        // Create non response
        CampaignMember cm = new CampaignMember(Status='Sent', ContactID = cts[0].id, CampaignID = camps[0].id);                
        insert cm;
        
        // Create response
        CampaignMember cm2 = new CampaignMember(Status='Responded', FCRM__FCR_Response_Date__c=Date.today() - 2, ContactID = cts[0].id, CampaignID = camps[1].id);                
        FCRM.FCR_SupportAPI.TreatNextCampaignAssociationsAsResponsePrompts();
        insert cm2;    
        List<String> unanimatedStatusValues = setting.Response_Status_Values_to_Consider__c.split(';');
        cm2.FCRM__FCR_Response_Status__c = unanimatedStatusValues[0];
        update cm2;            
        
        Set<Id> respPromptCampaignIds = FCRM.FCR_SupportAPI.GetResponsePromptCampaignIDs();
        List<Id> respPromptCampaignIdList = new List<Id>();
        for (Id cid : respPromptCampaignIds) respPromptCampaignIdList.add(cid); 
        List<Campaign> respPromptCamps = [Select Id, FC_Defer_to_Reanimation__c, FC_Exclude_from_Reanimation__c From Campaign Where Id IN :respPromptCampaignIdList];
        if(respPromptCamps.size()>0){          
        respPromptCamps[0].FC_Defer_to_Reanimation__c = true; 
        update respPromptCamps[0];
        
        CampaignMember responsePrompt = new CampaignMember(Status='Responded', ContactID = cts[0].id,  CampaignID = respPromptCamps[0].id);       
        
        Test.startTest();   
        insert responsePrompt; 
        Test.stopTest();                     
        }                
    }
    
    static testMethod void TestNonResponseAnimation() 
    {
        User testUser2 = TestDataUtility.createUser('System Administrator','test@testingupdate.com');
        insert testUser2;
          
        list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;
        
        setting.Top_of_Animate_Hierarchy__c = 'Non-Response';
        update setting;
        FCRM.FCR_SupportAPI.SetRepeatResponseUserForContext();
        
        List<Contact> cts = initTestContacts('cts', 1);
        insert cts;
        
        List<Campaign> camps = initTestCampaigns('cmp', cts.size());
        camps[0].FC_Exclude_From_Reanimation__c = false;
        insert camps;        
        
        camps[0].Animated_Non_Response_Member_Status__c = getRespondedCampaignMemberStatus(camps[0].Id);
        update camps[0];        
        
        CampaignMember cm = new CampaignMember(Status='Sent', ContactID = cts[0].id, CampaignID = camps[0].id);                
        insert cm;
        
        Set<Id> respPromptCampaignIds = FCRM.FCR_SupportAPI.GetResponsePromptCampaignIDs();
        List<Id> respPromptCampaignIdList = new List<Id>();
        for (Id cid : respPromptCampaignIds) respPromptCampaignIdList.add(cid); 
        List<Campaign> respPromptCamps = [Select Id, FC_Defer_to_Reanimation__c, FC_Exclude_from_Reanimation__c From Campaign Where Id IN :respPromptCampaignIdList];
        if(respPromptCamps.size()>0){          
        respPromptCamps[0].FC_Defer_to_Reanimation__c = true; 
        respPromptCamps[0].FC_Exclude_from_Reanimation__c = false;
        update respPromptCamps[0];
        
        CampaignMember responsePrompt = new CampaignMember(Status='Responded', ContactID = cts[0].id,  CampaignID = respPromptCamps[0].id);       
        
        Test.startTest();   
        insert responsePrompt; 
        Test.stopTest();                    
        }                
    }     
   
    static testMethod void TestResponseReanimation() 
    {
        User testUser2 = TestDataUtility.createUser('System Administrator','test@testingupdate.com');
        insert testUser2;
          
        list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;
        
        setting.Top_of_Animate_Hierarchy__c = 'Response';
        update setting;
        FCRM.FCR_SupportAPI.SetRepeatResponseUserForContext();
        
        List<Contact> cts = initTestContacts('cts', 1);
        insert cts;
        
        List<Campaign> camps = initTestCampaigns('cmp', cts.size());
        camps[0].FC_Exclude_From_Reanimation__c = false;
        insert camps;        
        
        CampaignMember cm = new CampaignMember(Status='Responded', FCRM__FCR_Response_Date__c=Date.today() - 2, ContactID = cts[0].id, CampaignID = camps[0].id);        
        
        FCRM.FCR_SupportAPI.TreatNextCampaignAssociationsAsResponsePrompts();
        insert cm;
        
        List<String> unanimatedStatusValues = setting.Response_Status_Values_to_Consider__c.split(';');
        cm.FCRM__FCR_Response_Status__c = unanimatedStatusValues[0];
        update cm;
        
        Set<Id> respPromptCampaignIds = FCRM.FCR_SupportAPI.GetResponsePromptCampaignIDs();
        List<Id> respPromptCampaignIdList = new List<Id>();
        for (Id cid : respPromptCampaignIds) respPromptCampaignIdList.add(cid); 
        List<Campaign> respPromptCamps = [Select Id, FC_Defer_to_Reanimation__c, FC_Exclude_from_Reanimation__c From Campaign Where Id IN :respPromptCampaignIdList];
         if(respPromptCamps.size()>0){         
        respPromptCamps[0].FC_Defer_to_Reanimation__c = true; 
        update respPromptCamps[0];
        
        CampaignMember responsePrompt = new CampaignMember(Status='Responded', ContactID = cts[0].id,  CampaignID = respPromptCamps[0].id);       
        
        Test.startTest();   
        insert responsePrompt; 
        Test.stopTest();                
         }               
    }
    
    static testMethod void TestLeadResponseReanimation() 
    {
        User testUser2 = TestDataUtility.createUser('System Administrator','test@testingupdate.com');
        insert testUser2;
          
        list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;
        
        setting.Top_of_Animate_Hierarchy__c = 'Response';
        update setting;
        FCRM.FCR_SupportAPI.SetRepeatResponseUserForContext();
        
        List<Lead> lds = initTestLeads('lds', 1);
        insert lds;
        
        List<Campaign> camps = initTestCampaigns('cmp', lds.size());
        camps[0].FC_Exclude_From_Reanimation__c = false;
        insert camps;        
        
        CampaignMember cm = new CampaignMember(Status='Responded', FCRM__FCR_Response_Date__c=Date.today() - 2, LeadId = lds[0].id, CampaignID = camps[0].id);        
        
        FCRM.FCR_SupportAPI.TreatNextCampaignAssociationsAsResponsePrompts();
        insert cm;
        
        List<String> unanimatedStatusValues = setting.Response_Status_Values_to_Consider__c.split(';');
        cm.FCRM__FCR_Response_Status__c = unanimatedStatusValues[0];
        update cm;
        
        Set<Id> respPromptCampaignIds = FCRM.FCR_SupportAPI.GetResponsePromptCampaignIDs();
        List<Id> respPromptCampaignIdList = new List<Id>();
        for (Id cid : respPromptCampaignIds) respPromptCampaignIdList.add(cid); 
        List<Campaign> respPromptCamps = [Select Id, FC_Defer_to_Reanimation__c, FC_Exclude_from_Reanimation__c From Campaign Where Id IN :respPromptCampaignIdList];
         if(respPromptCamps.size()>0){         
        respPromptCamps[0].FC_Defer_to_Reanimation__c = true; 
        update respPromptCamps[0];
        
        CampaignMember responsePrompt = new CampaignMember(Status='Responded', LeadId = lds[0].id,  CampaignID = respPromptCamps[0].id);       
        
        Test.startTest();   
        insert responsePrompt; 
        Test.stopTest();                
         }               
    }   
    
    public static List<Lead> initTestLeads(String prefix, Integer count)  
    {    
        List<Lead>lds = new List<Lead>();    
        for(Integer x=1;x<count+1;x++)    
        {      
          lds.add(new Lead(
              Company= prefix + '_' + String.valueOf(x), 
              OwnerId = UserInfo.getUserId(), 
              LastName = prefix + '_' + String.valueOf(x), 
              FirstName = prefix + '_last_' + String.valueOf(x),
              PostalCode = '08619',
              Status='Nurture/Marketing'
          ));    
        }    
        return lds;  
    } 
    
    public static List<Contact> initTestContacts(String prefix, Integer count)  
    {    
        List<Contact>cts = new List<Contact>();    
        for(Integer x=1;x<count+1;x++)    
        {      
          cts.add(new Contact(LastName = prefix + '_' + String.valueOf(x), 
              FirstName = prefix + '_last_' + String.valueOf(x),
              MailingPostalCode = '08619'
          ));
        }
        return cts;  
    }


    public static List<Campaign> initTestCampaigns(String prefix, Integer count)
    {
        List<Campaign> camps = new List<Campaign>();
        for(Integer x=1; x<count+1; x++)
        {
          camps.add(new Campaign(Name = prefix+'_'+ String.ValueOf(x), FC_Exclude_from_Reanimation__c=false, 
            FC_Defer_to_Reanimation__c=true, FCRM__FCR_Repeat_Responses_Allowed__c=true, FCRM__FCR_Bypass_Nurture_Timeout__c=true, IsActive = true));
        }
        return camps;
    } 

}