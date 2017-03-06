trigger Contact_RepeatCustomer on Contact (after update) {
   
    /*
    trigger purpose
        this trigger is taking a contact that has the repeat customer flag and making sure all that contacts oppcontroles are 
        flagged as repeat customers; 
        
        I think we might be able to optimize this ( check if flag changes, do we need a duplicate flag on the wrapper too ?)    
        
        I cant find anywhere that actually relied on the nrOppCont repeat customer field; i think we can delete this trigger. jim is chicken
        
    */   
   
  List<id> ids=new List<id>();
  for (Contact c : trigger.new)
  {
    if (c.repeat_customer__c)
        ids.add(c.id); 
  } 
  if (ids.size()==0)
  return;
  map<id,contact> contacts = new map<id,contact>([select id,repeat_customer__c,
    (select id,repeat_Customer__C from nropportunitycontactroles__r) from contact 
    where id in :ids and repeat_customer__C =true]);
  map<id,nropportunitycontactrole__c> updateroles=new map<id,nropportunitycontactrole__c>();
  integer start = Limits.getScriptStatements();
  for (Contact c:contacts.values())
  {
    for (nropportunitycontactrole__c cr : c.nropportunitycontactroles__r)
    {
        if (!updateroles.containskey(cr.id) && cr.repeat_customer__c != c.repeat_customer__c)
        {
            cr.repeat_customer__c = c.Repeat_Customer__c;
            updateroles.put(cr.id,cr);
        }
    }
  }
  integer ending1 = Limits.getScriptStatements();
  update(updateroles.values());
  integer ending = Limits.getScriptStatements();
  //utility.jimdebug(null,'script statements in trigger ' + (ending-start) + ' before update ' + (ending1-start));
}