trigger deleteCases on Case(after insert) {
    List<Case> casesToDelete=new List<Case>();
   Group Queuename=[select Id from Group where Name = 'EmailtoSalesforce' and Type = 'Queue'];
 
  
    for(case record: Trigger.new){
       if(record.ownerId==Queuename.Id){
            casesToDelete.add(record);
}
}
   
    delete casesToDelete;
}