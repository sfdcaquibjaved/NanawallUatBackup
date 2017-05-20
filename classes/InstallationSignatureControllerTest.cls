@IsTest
public class InstallationSignatureControllerTest {

    public static List<Attachment> attached;
    public static list<Account> accounts;
    public static list<Zip_Codes_Master__c> zipcode; 
    public static list<Order> order;
    
    static testMethod void InstallationSignatureControllerMethod1() {
    
    zipcode=TestDataUtility.getTerritoryMaster();
    insert zipcode;
    
    accounts=TestDataUtility.createAccountTestData();
    insert accounts;
    insert new Zip_Code_Range_for_Paul_Nalette__c(Name = 'Zip Range',Start_Value__c = 40000,End_Value__c = 48000);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'Northern NJ',Zip_Code_del__c = 7000,Zip_Code_End_Value__c = 8999);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'NY State',Zip_Code_del__c = 500,Zip_Code_End_Value__c = 15000);
        Project__c prolist = new Project__c();
        prolist.Project_Zip_Code__c = '94040';
        prolist.Name = 'Test Project CompetitorHelper_Test';
             prolist.Application__c = 'Automotive';
             prolist.Application_2__c = 'Dealership';
        insert prolist;
        list<Installation__c> instlist = TestDataUtility.createInsTestData();
        for(Integer i=0;i<instlist.size();i++){
            instlist[i].Project__c = prolist.id;
        }
        insert instlist;
    Installation__c Inst=new Installation__c();
    Inst.Name='12345';
    Inst.Account__c=accounts[0].id;
    Inst.Project__c = prolist.id;
    insert Inst;
    
    Installation_Form__c InstForm = new Installation_Form__c();
    InstForm.Installation_Number__c=Inst.id;   
    insert InstForm;                           
    
                                        
    /*order=TestDataUtility.createOrderTestData();
    insert order;   */                        
                                               
                                              
    /*Attached = TestDataUtility.createAttachmentTestData();
    attached.parentId=order.id;                             
    insert attached;   */
    
   /* attachment attach = new attachment();
    attach.parentid=inst.id;
    attach.Name = 'test attach';
    attach.Body = Blob.valueOf('Unit Test Attachment Body');
    Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
    insert attach; */                       
    
    PageReference pageRef = Page.InstallationSignature;
    Test.setCurrentPageReference(pageRef);

    ApexPages.StandardController sc = new ApexPages.standardController(InstForm);
    InstallationSignatureController sic = new InstallationSignatureController (sc);
     InstallationSignatureController.uploadSignature('abc','def');
    }
}