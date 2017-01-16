trigger nrOppTeamMemberDelete on nrOpportunityTeamMember__c (after delete) {

/*
    trigger purpose
        cleans up the underlying opportunityshare object when a team member is deleted
        
*/

    List<OpportunityShare> oppShares = new List<OpportunityShare>();
    for( nrOpportunityTeamMember__c nrOTM : trigger.old )
    {
            try
            {
                OpportunityShare os = [SELECT OpportunityAccessLevel, Id, RowCause FROM OpportunityShare WHERE OpportunityID = :nrOTM.Opportunity__c AND UserOrGroupId = :nrOTM.User__c];
                if( os.RowCause !=  'Owner' )
                {
                    oppShares.add( os );                
                }
            } catch(Exception e) {}
    }
    try {
        delete oppShares;
    }catch ( Exception e )
    {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'kristian.stout@a-stechnologies.com'}; 
        mail.setToAddresses( toAddresses );
        mail.setReplyTo('admin@a-stechnologies.com');   
        mail.setSenderDisplayName('Salesforce - Nana Delete Salesteam Member Trigger Proglem');
        mail.setSubject('An exception occurred when trying to delete a salesteam member.');
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.setPlainTextBody(' An exception occurred when trying to delete a salesteam member.<br><br>\n\n ' + e   );
        mail.setHtmlBody(' An exception occurred when trying to delete a salesteam member.<br><br>\n\n ' + e  );
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });           
        
    }
}