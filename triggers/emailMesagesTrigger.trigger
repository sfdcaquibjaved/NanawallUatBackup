/*********************************************************************************************************************
Trigger Name: emailMesagesTrigger
Events: after insert and before insert
Description: Trigger which copies email messages to case comments
**********************************************************************************************************************/

trigger emailMesagesTrigger on EmailMessage( before insert , after insert) {

    EmailMessageTriggerUtility.EmailCommentHandler(Trigger.new);
    
    
}