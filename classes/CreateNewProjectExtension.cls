public class CreateNewProjectExtension {
    
    public Boolean showFields {get;set;}
    public Boolean showRecTypeSection {get;set;}
    public Boolean showProjectLookup {get;set;}
    public Project__c newProject {get;set;}
    public Project__c newProject2 {get;set;}
    public Opportunity opp {get;set;}
    public List<SelectOption> getProjectType() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Existing','Existing'));
        options.add(new SelectOption('New','New'));
        return options;
    }
    public String projectTypeSelected {get;set;}
    public List<SelectOption> getRecType() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Residential','Residential'));
        options.add(new SelectOption('Commercial','Commercial'));
        return options;
    }
    public String recTypeSelected {get;set;}
    public String resRecTypeId = Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Residential Project').getRecordTypeId();
    public String comRecTypeId = Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Commercial Projects').getRecordTypeId();
    public Project__c resProj;
    public Project__c comProj;
    public Id contactId;
    public Id accountId;
    public string oppStage;
    
    //Default construtor. Initalize all the variables used by the VF page
    public CreateNewProjectExtension (ApexPages.StandardController controller){
        ContactID = ApexPages.currentPage().getParameters().get('contactID');
        AccountID = ApexPages.currentPage().getparameters().get('accountID');
        opp = new Opportunity();
        showFields = false;
        showRecTypeSection = false;
        showProjectLookup = true; 
        
         try{
            resProj = new Project__c(RecordtypeId=resRectypeId,project_country__c = 'United States');
            comProj = new Project__c(RecordTypeId=comRecTypeId,project_country__c = 'United States');
            newProject = resProj;
        }
        catch(Exception Ex){
            System.Debug('>>> The Project record could not be found.');
        }
        
    }
    
    public void projectTypeSelection(){
        
        if(projectTypeSelected == 'New'){
            showRecTypeSection = true;
            showFields = true;
            showProjectLookup = false;
        }
        if(projectTypeSelected == 'Existing'){
            showRecTypeSection = false;
            showFields = false;
            showProjectLookup = true;
        }            
    }
    
    public void recTypeSelection(){
        
        if(recTypeSelected == 'Residential'){
            showFields = true;
            try{
                newProject = resProj;
            }
            catch(Exception Ex){
                System.Debug('>>> The Residential Project record could not be found.');
            }
        }
        if(recTypeSelected == 'Commercial'){
            showFields = true;
            try{
                 newProject = comProj;
            }
            catch(Exception Ex){
                System.Debug('>>> The Commercial Project record could not be found.');
            }
        } 
    }
    public pageReference copyAddressFields (){
        if(contactID !=null){
            showFields=true;
            Contact exisCont = [SELECT id,name,MailingStreet,MailingCountry,MailingCity,MailingPostalCode,MailingState from Contact where ID =: contactID];
            newProject.Project_Zip_Code__c = exisCont.MailingPostalCode;
            newProject.Project_Street_Address__c = exisCont.MailingStreet;
            newProject.Project_Country__c = exisCont.MailingCountry;
            newProject.Project_State__c = exisCont.MailingState;
            newProject.Project_City__c = exisCont.MailingCity;
        }
        return null;

    }
    
    public boolean validateFields() {
        string zipUS = '\\d{5}(-\\d{4})?';
        string zipCan= '((?i)[ABCEGHJKLMNPRSTVXY]\\d[A-Z]?\\s?\\d[A-Z]\\d)?';
        boolean Validated = true;
    
        if( (newProject.project_country__c == 'United States' || newProject.project_Country__c == 'Canada') && (newProject.project_zip_code__c=='' || newProject.project_zip_code__c==null)) {
            Validated=false;
            ApexPages.addMessage( new ApexPages.message(ApexPages.Severity.ERROR,'Zip code is required for the selected country'));
        } 
        else if(newProject.Project_Country__c!=null && (newProject.project_zip_code__c!=''|| newProject.project_zip_code__c !=null) && ((newProject.Project_Country__c=='United States'&& !(pattern.matches(ZipUS,newProject.project_zip_code__c)))||(newProject.Project_Country__c=='Canada'&& !(pattern.matches(zipCan,newProject.project_zip_code__c))))){
                Validated=False;
                newProject.project_zip_code__c.adderror('Please enter a valid Zip code');
               
            } 
        else if(newProject.Project_Country__c=='Mexico' && (newProject.Project_State__c==null || newProject.Project_State__c=='')){
        Validated=false;
            ApexPages.addMessage( new ApexPages.message(ApexPages.Severity.ERROR,'Project State is required for the selected country')); 
        }
        return Validated;
    }

    public pageReference saveProject(){
        String redirectURL,resolutionDate;
        pageReference pr;
        if(projectTypeSelected =='New'&&!validateFields()){
        ApexPages.addMessage( new ApexPages.message(ApexPages.Severity.ERROR, 'Please check all of your entries. You missed some required information.' ));         
            return null;
        }
        
        if(projectTypeSelected == 'Existing'){
            try{
                Project__c exisProj = [SELECT Id, Name, RecordTypeId,Stage__c, Close_Date__c FROM Project__c WHERE Id = :opp.Project_Name__c LIMIT 1];
                if(exisProj.stage__c == 'Prospecting'){
                oppStage='Need Analysis';
                } else oppStage='Quote - Requested';
                
                redirectURL = '/006/e?nooverride=1&opp11='+oppStage+'&opp3=Fills_Automatically&retURL=%2F006%2Fo&accid='+accountID+'&conid='+contactID+'&'+Label.ProjectSourceID+'='+EncodingUtil.URLENCODE(exisProj.Name,'UTF-8')+'&'+Label.ProjectSourceLkdID+'='+exisProj.Id;
                if(resRecTypeId.contains(exisProj.RecordTypeId)){
                    redirectURL = redirectURL + '&RecordType=' + Label.Residential_Opp;
                }
                else{
                    redirectURL = redirectURL + '&RecordType=' + Label.Commercial_Opp;
                }
                if(exisProj.Close_Date__c != null && exisProj.close_date__c >= system.today()){ 
                    redirectURL = redirectURL + '&opp9=' + exisProj.Close_Date__c.format(); 
                } else {
                   redirectURL = redirectURL + '&opp9=' + system.today().adddays(180).format();
                   }
                pr = new pageReference(redirectURL);
                pr.setReDirect(true);
                return pr;
            }
            catch(Exception ex){
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error,'There was a problem in associating existing Project. Please contact your Administrator. Error is :: '+ex.getMessage()));
                System.Debug('>>> Problem in saving the Project Record. Error :: ' + ex.getMessage());
                return null;
            } 
        }
        else{
            if(recTypeSelected == 'Residential'){
                newProject.RecordTypeId = resRecTypeId;
            }
            else{
                newProject.RecordTypeId = comRecTypeId;
            }
            newProject.Application__c = newProject.Application__c;
            newProject.Application_2__c = newProject.Application_2__c;
            oppStage='Quote - Requested';
            //resolutionDate = newProject.Close_Date__c.format();
            try{
                INSERT newProject;
                redirectURL = '/006/e?nooverride=1&opp11='+oppStage+'&opp3=Fills_Automatically&retURL=%2F006%2Fo&accid='+accountID+'&conid='+contactID+'&'+Label.ProjectSourceID+'='+EncodingUtil.URLENCODE(newProject.Name,'UTF-8')+'&'+Label.ProjectSourceLkdID+'='+newProject.Id;
                if(recTypeSelected == 'Residential'){
                    redirectURL = redirectURL + '&RecordType=' + Label.Residential_Opp;
                }
                else{
                    redirectURL = redirectURL + '&RecordType=' + Label.Commercial_Opp;
                }
                if(newProject.Close_Date__c == null){ 
                    redirectURL = redirectURL + '&opp9=' + system.today().adddays(180).format(); 
                } 
                pr = new pageReference(redirectURL);
                pr.setReDirect(true);
                return pr;
            }
            catch(Exception ex){
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error,'There was a problem in Project Creation. Please contact your Administrator. Error is :: '+ex.getMessage()));
                System.Debug('>>> Problem in saving the Project Record. Error :: ' + ex.getMessage());
                return null;
            }
        }
    }
  
}