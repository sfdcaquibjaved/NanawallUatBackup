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
    
    Installation__c Inst=new Installation__c();
    Inst.Name='12345';
    Inst.Account__c=accounts[0].id;
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