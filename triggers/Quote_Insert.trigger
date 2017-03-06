trigger Quote_Insert on Quote__c (before insert) {

    /*
    trigger purpose
        I THINK the only useful thing this does anymore is fix the stagenamewhen a user inserts a new quote with the stage as "Past  ERD"  
        
        i moved this to after insert in the quote aggregate because .. why not ?
    */

/*
    string lineNbr = '1';
    string oppIDList = '';
    try {
        set<id> oppIDs = new set<id>();
        for( quote__c q : trigger.new ) 
        {
            if( q.Opportunity__c != null )
            {
                oppIDs.add( q.Opportunity__c );
                oppIDList += q.Opportunity__c + ' ; ';
            }
        }
         lineNbr = '2';
        
        list<opportunity> opps = [SELECT id, application__c, CloseDate,StageName FROM opportunity WHERE id in :oppIDs ];
         lineNbr = '3';
    
        for( Opportunity o : opps ) 
        {
            try {
                lineNbr = '3a';
                if ( o.StageName != null
                    && ( o.StageName == 'Quotes Passed Expected Resolution Date' ||
                        o.StageName =='Closed - Lost' ) 
                    )
                {
                    o.StageName = 'Considered';
                    o.Reason_Opportunity_Lost__c='';
                }

                 lineNbr = '5';
            } catch( Exception ex )
            {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {'kristian.stout@gmail.com'}; 
                mail.setToAddresses( toAddresses );
                mail.setReplyTo('admin@a-stechnologies.com');   
                mail.setSenderDisplayName('Salesforce - create trigger');
                mail.setSubject('Quote Create Trigger Problem in loop after line ' + lineNbr + ' ; ids = '+ oppIDList );
                mail.setBccSender(false);
                mail.setUseSignature(false);
                mail.setPlainTextBody(' ' + ex  );
                mail.setHtmlBody('  ' + ex );
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });      
            
            }
            
        }
         lineNbr = '6';
        
        if( opps.size() > 0 )
            update opps;
         lineNbr = '7';
    } catch (Exception ex ) {
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {'kristian.stout@gmail.com'}; 
                mail.setToAddresses( toAddresses );
                mail.setReplyTo('admin@a-stechnologies.com');   
                mail.setSenderDisplayName('Salesforce - create trigger');
                mail.setSubject('Quote Create Trigger Problem for update after line ' + lineNbr + ' ; ids = '+ oppIDList );
                mail.setBccSender(false);
                mail.setUseSignature(false);
                mail.setPlainTextBody(' ' + ex  );
                mail.setHtmlBody('  ' + ex );
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });      
                
    
    }
    */
}