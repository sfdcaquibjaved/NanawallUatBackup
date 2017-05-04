public class AssignInstallerNY_Controller {
	public String selectedInstaller{get;set;}
    
    public AssignInstallerNY_Controller(){
    }
    
    
    public PageReference save(){
        
        Id pageid = ApexPages.currentPage().getParameters().get('id');
      //  ID InstallerContactID = [SELECT ID FROM CONTACT WHERE Account.Name =: selectedInstaller].ID;
        List <Contact> InstallerContact = [SELECT ID , AccountID , Account.Name FROM Contact WHERE Account.Name =: selectedInstaller AND Default_Installer__c = TRUE ] ;
        List <Installation__c> lstInstall = [SELECT ID, Installer_Account__c , Installer_Contact__c FROM Installation__c WHERE ID =: pageid] ; 
       	
        List < Installation__c> lstUpdateInstall = new List < Installation__c> () ;
        
        for(Installation__c i : lstInstall){
            for(Contact c : InstallerContact ){
                 i.Installer_Account__c =  c.AccountID ; 
                 i.Installer_Contact__c = c.ID ; 
                 lstUpdateInstall.add(i);
            } 
        }
        
        try{
            update lstUpdateInstall ;  
        }
        catch(exception e) {
            system.debug('Exception is: '+e.getMessage());
        }
        return null;
    }
}