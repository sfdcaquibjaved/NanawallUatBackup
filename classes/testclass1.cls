public class testclass1 {
    public void testmethod1(){
        list<project__c> proid = [SELECT id,opportunity_count__c,opportunity_name__c FROM Project__c where stage__c =: 'Quoted'];
        list<id> oppid = new list<id>();
        
            for(project__c pp:proid){
                if(pp.opportunity_count__c > 0){
                    oppId.add(pp.opportunity_name__c);
                }
                system.debug(oppId);
                
    }
}
}