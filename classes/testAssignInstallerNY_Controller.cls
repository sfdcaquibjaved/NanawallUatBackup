@isTest
public class testAssignInstallerNY_Controller {
    static testmethod void method1(){
       // insert new Bill_Leon_UserId(newUser.id);
        test.startTest(); 
        insert new Assign_Installer__c(Name = 'Aaco Glass',USer_Name__c = LAbel.Bill_Leon_UserId); 
        
        PageReference pageRef = Page.AssignInstallerNY;
        Test.setCurrentPage(pageRef);
        AssignInstallerNY_Controller controller = new AssignInstallerNY_Controller();
        list<SelectOption> sopt= controller.getRegionlist();
        controller.Bill = Label.Bill_Leon_UserId;
        controller.Paul = Label.Paul_Nalette_UserId;
        controller.selectedInstaller = 'Aaco Glass';
        controller.save();
        test.stopTest();
        
    }
    
}