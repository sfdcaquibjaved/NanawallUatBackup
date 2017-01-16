trigger contactownerassignmentTrigger on Contact (before insert, before update, After insert, After Update) {
list<Contact> lstContacts= new list<Contact>();
 if(trigger.isbefore){
   if(Trigger.isInsert || Trigger.isUpdate){
     for(Contact conRec : trigger.New){
       if((Trigger.isInsert || (Trigger.isUpdate && 
       (((Trigger.oldMap.get(conRec.Id).mailingPostalCode!= null && Trigger.oldMap.get(conRec.Id).mailingPostalCode!=conRec.mailingPostalCode) || Trigger.oldMap.get(conRec.Id).mailingPostalCode== null)  || Trigger.oldMap.get(conRec.Id).mailingstatecode!=conRec.mailingstatecode || Trigger.oldMap.get(conRec.Id).mailingCountryCode!=conRec.mailingCountryCode || (conRec.owner_assignment__c)))) &&
       contactOwnerAssignment.validateZip(conRec)){
         lstContacts.add(conRec);
       }}}
     }
      if(lstContacts!=null && lstContacts.size()>0){
         contactOwnerAssignment.assignOwner(lstContacts);
      }
      
      
     /* if(Trigger.isAfter && (Trigger.isUpdate || Trigger.isInsert))
      {
       
     set<Id> AccId = new set<Id>();
     for( Contact c : trigger.new){
         AccId.add(c.AccountId);
        
       }
    
    Account acc = [Select Id, Name , Cero__c  from account where id = :AccId ];
    
    for (Contact c1 : Trigger.new){
         if(c1.CERO__C == True)
         {
           acc.CERO__c = True ;
         }
        
       }
       update acc; 
      }*/
       
       
      
}