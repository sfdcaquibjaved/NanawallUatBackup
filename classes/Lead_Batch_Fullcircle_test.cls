@isTest
public class Lead_Batch_Fullcircle_test
{
    Static testMethod void unittest1(){
    
    list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;
        
        User testUser = TestDataUtility.createUser('admin1' , 'testUser@testing.com');
        insert testUser;

    list<lead> ldList = new list<lead>();
    for(integer i=0; i<=10; i++)
    {
        lead l = new lead();
        l.Phone = '(123) 456-7890';
        l.project_name__c = 'Test Proj';
        l.FirstName = 'testfirst' + i;
        l.LastName = 'testlast';
        l.PostalCode = '12345';
        l.CountryCode = 'US';
        l.Type_of_record__c = 'Commercial';
        l.Project_Application_Industry__c = 'Automotive';
        l.Project_Application__c = 'Dealership';
        l.Project_Site_Zip_Code__c= '12345';
        l.Status='Open - Not Contacted';
        l.OwnerId=testUser.id;
        
        ldList.add(l);
    }
    
    insert ldList;
    
    SLA_Expiration_Profiles__c sp = new SLA_Expiration_Profiles__c();
    sp.Name='System Administrator';
    sp.Active__c=TRUE;
    sp.Current_Status__c='System Administrator';
    
    insert sp;
    
    SLAExpirationTimeFrames__c st = new SLAExpirationTimeFrames__c();
    st.Current_Status__c='Open - Not Contacted';
    st.Name='Open - Not Contacted';
    st.New_Status__c='Close - No Further Action';
    st.Status_Reason__c='SLA Expired';
    st.Timeframe__c=0;
    
    insert st;
    
    test.starttest();
    Lead_Batch_Fullcircle lbf= new Lead_Batch_Fullcircle();
    ID LeadFullBatch = database.executebatch(lbf);
    test.stoptest();    
    }
}