trigger Contact_Delete on Contact (after delete,after insert, after update, after undelete) 
{
    /*
    trigger purpose
        there are also a variety of precache flush calls 
    */
    
    if(trigger.isAfter && trigger.isdelete){

    set<id> wCompMasterIDs = new set<id>();
    for( Contact c : trigger.old ) 
    {
        if( c.MasterRecordId != null)
            wCompMasterIDs.add( c.MasterRecordId );
    }
    
    try {
        if( wCompMasterIDs.size() > 0 )
        {
            list<id> contLookupList = new List<id>( wCompMasterIDs );
            
            set<id> oppsToFlush = new set<id>();
            set<id> quotesToFlush = new set<id>();
            for( nrOpportunityContactRole__c ocr : [SELECT id, Opportunity__c from nrOpportunityContactRole__c WHERE Contact__c in :contLookupList]  )
            {
                if(  !oppsToFlush.contains(ocr.opportunity__c)  )
                    oppsToFlush.add(ocr.Opportunity__c);
            }
            for( Quote__c quote : [SELECT id from Quote__c WHERE Contact__c in :contLookupList]  )
            {
                if(  !quotesToFlush.contains(quote.id)  )
                    quotesToFlush.add(quote.id);
            }
         
            if( oppsToFlush.size() > 0 )
            {
                Async_WebServiceCaller.FlushNanaCache(oppsToFlush, 'Opportunity');
            }
        
            if( quotesToFlush.size() > 0 )
            {
                Async_WebServiceCaller.FlushNanaCache(quotesToFlush, 'Quote');
            }
        }
    } catch(exception ex ) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'kristian.stout@gmail.com'}; 
        mail.setToAddresses( toAddresses );
        mail.setReplyTo('admin@a-stechnologies.com');   
        mail.setSenderDisplayName('Salesforce - contact delete trigger');
        mail.setSubject('Got an exception with contact delete trigger' );
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.setPlainTextBody('Got an exception with contact delete trigger: ' + ex  );
        mail.setHtmlBody('Got an exception with contact delete trigger: ' + ex  );
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });           
    
    }
    }
    
    
    /*
    For updating the Account.Person_Engagement_Score_Max__c field on Account object
   */
        set<id> actlst = new set<id>();
        set<id> actlist1 = new set<id>();
        if(trigger.isInsert){
            for(Contact con : Trigger.new){
            actlst.add(con.Accountid);
          }
        }
        else if(trigger.isDelete)
        {
            for(Contact con : Trigger.old){
            actlst.add(con.Accountid);
            }
        }
        else if(trigger.isUnDelete){
            for(Contact con : Trigger.new){
            actlst.add(con.Accountid);
            }
        }
        else if(trigger.isUpdate){
            for(Contact con : trigger.new){
                if((trigger.oldmap.get(con.id).Accountid!=con.Accountid) || (trigger.oldmap.get(con.id).Person_Engagement_Score_Max__c!=con.Person_Engagement_Score_Max__c)){
                    actlst.add(con.Accountid);
            
                }
            }
        }  
    
    
        map<id, List<Contact>> maplist = new map<id, List<contact>>();
        List<contact> conlist = new List<Contact>([select Name,id,accountid, Person_Engagement_Score_Max__c from contact where Accountid IN:actlst]);
        set<Contact> conlist1 = new set<Contact>();
        List<Account> actlist2 = new List<Account>([select id, Account_Person_Engagement_Score_Max__c from Account where id IN:actlst]);
        set<Account> actlist3 = new set<Account>();
        List<Account> actlist4 = new List<Account>();
    
        for(Account acc1:actlist2)
        {
          for(Contact con1:conlist)
          {
             if(con1.accountid == acc1.id)
             {
                conlist1.add(con1);             
             }         
          }
     // maplist.put(acc1.id,conlist1);
            decimal i=0;
            for(Contact con:conlist1)
            {
                if(con.Person_Engagement_Score_Max__c>i)         
                {
                  i=con.Person_Engagement_Score_Max__c;
                  system.debug('the value is::'+con.Person_Engagement_Score_Max__c);
          
                }          
                   system.debug('The actlst2 is:::::'+i);       
             }      
                   acc1.Account_Person_Engagement_Score_Max__c=i;
                   actlist3.add(acc1); 
                   conlist1.clear();
        }
                   actlist4.addall(actlist3);
                   update actlist4;

    }