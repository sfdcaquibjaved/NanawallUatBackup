public class test2 {
    public void newmwthod1(){
           map<id,list<opportunity>> map1 = new map<id,list<opportunity>>();
list<project__c> pro = [select id,stage__c from project__c where stage__c =: 'Closed Complete - Ordered - Paid'];        
        for(project__c p:pro){
            map1.put(p.id,p.opportunities__r);
                }
              system.debug(map1);
            }
        
    
}