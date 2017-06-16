public class AssignInstallerNY_Controller {
    public String selectedInstaller{get;set;}
    public list<SelectOption> options{get;set;}
    public String Bill;
    public String Paul;
    public AssignInstallerNY_Controller(){
        options = new list<SelectOption>();
    }
    public list < selectOption > getRegionlist() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('--None--', '--None--'));
        options.add(new SelectOption('No Installer to be assigned', 'No Installer to be assigned'));
        list < Assign_Installer__c > tnlist = Assign_Installer__c.getall().values();
        String uid = UserInfo.getUserId();
        Bill = Label.Bill_Leon_UserId;
        Paul = Label.Paul_Nalette_UserId;
        tnlist.sort();
        for (Assign_Installer__c tn: tnlist) {
            if(tn.User_Name__c == uid && tn.User_Name__c == Bill){
            options.add(new SelectOption(tn.name, tn.name));
                System.debug('Bill');
            }
            else if(tn.User_Name__c == uid && tn.User_Name__c == Paul){
            options.add(new SelectOption(tn.name, tn.name));
                System.debug('For Paul');
            }
            else if(tn.User_Name__c != uid && uid != Paul && uid != Bill){
            options.add(new SelectOption(tn.name, tn.name));
                System.debug('Others');
            }
        }
System.debug('options'+options);
        return options;
    }
  
    /*public List <SelectOption > getTypeOptions() {
        //list<SelectOption> inscompany = new list<SelectOption>();
        //System.debug('list'+lstCS);
        String strCurrentUserId = UserInfo.getUserId();
        System.debug('user id'+strCurrentUserId);
        for (Assign_Installer__c ai: Assign_Installer__c.getall().values()) {
               system.debug('valu?'+ai);
               if (ai.User_Name__c == strCurrentUserId) {
                   inscompany.add(new SelectOption(ai.Name, ai.Name));
               }
           }
        System.debug('inscompany'+inscompany);
        return null;
    }*/
    
    public PageReference save(){
        
        Id pageid = ApexPages.currentPage().getParameters().get('id');
      //  ID InstallerContactID = [SELECT ID FROM CONTACT WHERE Account.Name =: selectedInstaller].ID;
        List <Contact> InstallerContact = [SELECT ID , AccountID , Account.Name FROM Contact WHERE Account.Name =: selectedInstaller AND Default_Installer__c = TRUE ] ;
        List <Installation__c> lstInstall = [SELECT ID, Installer_Account__c , Installer_Contact__c FROM Installation__c WHERE ID =: pageid] ; 
        System.debug('is Contact'+InstallerContact);
        System.debug('The installation'+lstInstall);
        List < Installation__c> lstUpdateInstall = new List < Installation__c> () ;
        
        for(Installation__c i : lstInstall){
            
            if(selectedInstaller == 'No Installer to be assigned'){
                i.Status__c = 'No Installer To Be Assigned' ; 
                lstUpdateInstall.add(i) ; 
            }
            else {
            for(Contact c : InstallerContact ){
                System.debug('Should be in else'+c);
                 i.Installer_Account__c =  c.AccountID ; 
                 i.Installer_Contact__c = c.ID ; 
                 lstUpdateInstall.add(i);
            } 
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