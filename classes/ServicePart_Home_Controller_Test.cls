@IsTest
public class ServicePart_Home_Controller_Test {
    public static List < Service_Part__c > olstServicePart;
    
    
    static testmethod void createmethod1() {
       
        olstServicePart=TestDataUtility.createServicePartTestData();
        insert olstServicePart;
        
          /*list < Service_Part__c > sp = new list < Service_Part__c >(); */
        
      /*  Service_Part__c spart=new Service_Part__c();
        spart.Name='abc';
        spart.Stocked__c=true;
        spart.Reorder_Level__c=12;
        spart.Number_Stocked__c=30;
        spart.Part_Name__c='xyz';
        spart.Location__c=10;
        spart.Vendor_Cost__c=110;
        spart.Retail_Cost__c=100;
        
        insert spart;*/
        
        
        
        PageReference pageRef = Page.ServicePart_Home;
        Test.setCurrentPage(pageRef);
        
        ServicePart_Home_Controller cc = new ServicePart_Home_Controller();
        cc.getTypes();
        
        cc.dosort();
        cc.searchParts();
        
      
		//List < SelectOption > getse = cc.searchParts();
        //List < SelectOption > getlo = cc.getLocations();
        
    }
}