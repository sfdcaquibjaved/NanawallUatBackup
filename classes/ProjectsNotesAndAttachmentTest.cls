@isTest
private class ProjectsNotesAndAttachmentTest {

      static testMethod void myUnitTest() {
          
          list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;
          
      test.startTest();
          list<account> acc = new list<account>();
          Account aa = new Account();
        aa.Name = 'Acc';
        aa.Phone = '(123) 456-7890';
        aa.Name = 'Test account';
        aa.BillingState = 'New York';
        aa.BillingCountryCode='US';
        aa.BillingPostalCode='12345';
        aa.BillingStreet = 'xyz street';
        aa.BillingCity = 'new va';
          //aa.CreatedDate=date.today();
          acc.add(aa);
          
          insert acc[0];
          
          Account aaa = new Account();
        aaa.Name = 'Test Acc';
        aaa.Phone = '(123) 456-7890';
        aaa.Name = 'Test account';
        aaa.BillingState = 'New York';
        aaa.BillingCountryCode='US';
        aaa.BillingPostalCode='12345';
        aaa.BillingStreet = 'xyz street';
        aaa.BillingCity = 'new va';
        //aaa.CreatedDate=date.today();
          acc.add(aaa);
          
          insert acc[1];
      
          LIST<Project__c> lstTestProjs = new list<Project__c>();
      Project__c testProj = new project__c();
          testProj.Name='xyz enterprise';
      
        testProj.Project_Country__c='United States';
          testProj.Project_Zip_Code__c='12345';
        testProj.Close_Date__c=Date.newInstance(2015, 12, 12);
        testProj.Stage__c='Prospecting';
            testProj.Application__c = 'Automotive';
             testProj.Application_2__c = 'Dealership';
          	//testProj.CreatedDate = testproj.CreatedDate.date();
        
         lstTestProjs.add(testProj);
          insert lstTestProjs[0];
          
          
          system.debug('test------'+testProj);
         
     Project__c testProj1 = new project__c();
          
        testProj1.Name='xyzww enterprise';
      
        testProj1.Project_Country__c='United States';
          testProj1.Project_Zip_Code__c='12345';
        testProj1.Close_Date__c=Date.newInstance(2015, 12, 12);
        testProj1.Stage__c='Prospecting';
            testProj1.Application__c = 'Automotive';
             testProj1.Application_2__c = 'Dealership';
       lstTestProjs.add(testProj1);
          insert lstTestProjs[1];
            system.debug('test2------'+testProj1);
     
     list<Opportunity> lstOpps = TestDataUtility.createOppTestData();
     Opportunity testOpp = lstOpps[0];
     testOpp.Project_Name__c = testProj.id;
     testOpp.AccountId=acc[0].id;
     insert testOpp;
        
     Opportunity testOpp1 = lstOpps[1];
     testOpp1.Name = 'Opp tested';
     testOpp1.Project_Name__c = testProj1.id;
          testOpp1.AccountId=acc[1].id;
     insert testOpp1;
     
     Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
     Attachment testatt = new Attachment( Body = bodyBlob , Name = 'test attach' , ParentId = testProj.id);
          
          
     insert testatt;
     
          system.debug('test3------'+testatt);
          
     Blob bodyBlob1=Blob.valueOf('Unit Test Attachment of Opp Body');
     Attachment testatt1 = new Attachment( Body = bodyBlob1 , Name = 'test attach of Opp' , ParentId = testOpp.id);
      
       
     insert testatt1;
       
     
        
     Note testnote = new Note(Body = 'test note body' , ParentId = testOpp.id , Title = 'test note');
         
          
     insert testnote;
     
          system.debug('test4------'+testnote);
    
        
     Note testnote1 = new Note(Body = 'test note body of proj' , ParentId = testProj.id , Title = 'test note');
        
        
     insert testnote1;
    
         
     List<Note> lstNote = new List<Note>();
     lstNote.add(testnote);
     lstNote.add(testnote1);
          
          lstNote.sort();
          
         Set<Id> noteAndAttachIds = new Set<Id>();
         noteAndAttachIds.add(testatt.id);
         noteAndAttachIds.add(testatt1.id);
         noteAndAttachIds.add(testnote.id);
         noteAndAttachIds.add(testnote1.id);
       
        
         PageReference ProjectsNotesAndAttachment = Page.ShowNotesAndAttachment;
         Test.setCurrentPage(ProjectsNotesAndAttachment);
          System.debug('test4.5--------'+lstTestProjs[0]);
         ApexPAges.StandardController sc = new ApexPages.StandardController(lstTestProjs[0]);
         System.debug('Test5-----'+sc);
         ProjectsNotesAndAttachment testController = new ProjectsNotesAndAttachment(sc);
         //ProjectsNotesAndAttachment.oppProj testWrapOpp = new ProjectsNotesAndAttachment.oppProj(testOpp);
         //ProjectsNotesAndAttachment.oppProj testWrapProj = new ProjectsNotesAndAttachment.oppProj(lstTestProjs[0]);
         //ProjectsNotesAndAttachment.noteAttach testWrapNote = new ProjectsNotesAndAttachment.noteAttach(testnote, 'Note' ,'Opportunity','Account');
         //ProjectsNotesAndAttachment.noteAttach testWrapAttach = new ProjectsNotesAndAttachment.noteAttach(testatt1 , 'Attachment' , 'Opportunity','Account' );
        
        //testController.doTransfer();
        testController.selectedNoteAttach = noteAndAttachIds;
        //testController.searchResults();
        //testWrapAttach.isSelected = true;
        //testWrapNote.isSelected = true;
        testController.transferPage();
        testController.dosearch();
        testController.searchText = 'Test';
        testController.dosearch();
        testController.searchResults[0].isSelected = true ;
        testController.doTransfer();
        testController.goback();
        testController.selectedNoteAttach = noteAndAttachIds;
        //testWrapNote.isSelected = true;
        //testWrapNote.CreatedDate=date.today();
        testController.transferPage();
        testController.dosearch();
        testController.searchText = 'Test';
        testController.dosearch();
        testController.searchResults[0].isSelected = true ;
        testController.searchResults[1].isSelected = true ;
        testController.doTransfer();
        testController.redNewNoteUrl();
        testController.redNewAttachmentUrl();
        testController.recordId = testnote.id;
        testController.deleteRecord();
        testController.recordId = testatt1.id;
        testController.deleteRecord();
        //testWrapProj.oppProj();
         
        test.stopTest();
    }
}