/*********************************************************************************************************************
Trigger Name: CaseCommentTrigger
Description: To send out email notification to all case team member if the comment added on the case is public
LastChangedDate: 12/05/2016
**********************************************************************************************************************/
trigger CaseCommentTrigger on CaseComment(after insert, after update,before insert, before update) {
    CaseCommentEmailHelper Obj = new CaseCommentEmailHelper();
    if(trigger.isafter){
    Obj.SendCaseCommentEmail(Trigger.new);
    }
}