@isTest
public class Contact_Batch_Fullcircle_test
{
    Static testMethod void unittest1(){
     list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;
        
        User testUser = TestDataUtility.createUser('System Administrator' , 'testUser@testing.com');
        insert testUser;
        
 List<Contact> conlist = new List<Contact>();
       
        for (Integer i= 0 ; i <=10 ; i++){
        Contact con = new Contact();
        con.FirstName = 'foo' + i;
        con.LastName = 'bar' + i;
        con.MailingStreet = 'street';
        con.MailingCity = 'city'; 
        con.MailingstateCode = 'CA';
        con.MailingPostalCode = '12345';
        con.MailingCountryCode = 'US';
        con.FCRM__FCR_Status__c='Open - Not Contacted';
        con.Ownerid=testUser.id;
        conlist.add(con);  
        }
    
    insert conlist;
    
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
    Contact_Batch_Fullcircle cbf= new Contact_Batch_Fullcircle();
    ID ContactFullBatch = database.executebatch(cbf);
    test.stoptest();    
    }
}