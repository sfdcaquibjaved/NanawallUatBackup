/*********************************************************************************************************************
Trigger Name: emailMesagesTrigger
Events: after insert and before insert
Description: Trigger which copies email messages to case comments
**********************************************************************************************************************/

trigger emailMesagesTrigger on EmailMessage( before insert , after insert) {

    EmailMessageTriggerUtility.EmailCommentHandler(Trigger.new);
    list<EmailMessage>emlist = new list<EmailMessage>();
    if(trigger.isBefore && trigger.isInsert){

    for(EmailMessage em: trigger.new){
        if(em.Subject.contains( '[ ref:_') && em.ParentId !=  null){
            emlist.add(em);
        }
    }
    if(emlist.size()>0){
        System.debug('emlist'+emlist);
        //sendResponsefromCaseClass.sendreplytofromCase(emlist);
    }
    }
    
    
}