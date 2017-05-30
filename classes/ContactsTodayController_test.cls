@isTest
public class ContactsTodayController_test {

    @IsTest(SeeAllData=true)
    public static void TestContactsTodayController() {
        
        
        Map<Id,Profile> profileIds = new Map<id,profile>([SELECT Id,UserLicenseId,Name FROM Profile where UserLicenseId  in (SELECT Id FROM UserLicense where name ='Salesforce') AND name='System Administrator']);

		//	user standardProfileUsers = [select id from user where profileId in:profileIds.Keyset() limit 1];
        
        
       user u= [ SELECT Name FROM User WHERE IsActive = true AND profileId in:profileIds.Keyset() limit 1];
             
       // User u = [SELECT Name From User where name='Anshul Jain' limit 1];
        
        
        
            Contact c = new Contact(FirstName = 'Joe', LastName = 'Test', MailingPostalCode='12345');
            insert c;
            
            Date td = Date.today();
            Task t = new Task(Subject = 'test', WhoId = c.Id, Status = 'Open');
            insert t;
            
              Case ca = new Case(Subject = 'test', ContactId = c.Id, Description = 'Open');
            insert ca;
            c.Description='Because of Case "'+ca.Subject+'"';
            update c;
            
            System.assertNotEquals(0,ContactsTodayController.getContactsForToday().size());
         
      
        
    }
    
}