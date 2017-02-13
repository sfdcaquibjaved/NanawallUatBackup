public with sharing class createNewProject {

public Project__c newproject{get; set;}
public String sAppIndus{get;set;}
public String sApplication {get; set;}
public string selectedType {get; set;}

       public List<selectOption> getrecType() {
         List<SelectOption> options = new List<SelectOption>();
         options.add(new SelectOption ('Residential','Residential'));
         options.add(new SelectOption ('Commercial','Commercial'));
         return options;
         }
         
         public list<SelectOption> getAppItems()
         {
             List<SelectOption> lstOptions = new List<SelectOption>();
             lstOptions.add(new SelectOption('--None--','--None--'));
             
             if(selectedType=='Residential')
             {
             lstOptions.add(new SelectOption('Residential','Residential'));
             }
            else
            {
            lstOptions.add(new SelectOption('Automotive','Automotive'));
            lstOptions.add(new SelectOption('Education','Education'));
            lstOptions.add(new SelectOption('Health Care','Health Care'));
            lstOptions.add(new SelectOption('Hospitality','Hospitality'));
            lstOptions.add(new SelectOption('Other Industries','Other Industries'));   
            lstOptions.add(new SelectOption('Recreation/Entertainment','Recreation/Entertainment'));
            lstOptions.add(new SelectOption('Religious Institution','Religious Institution')); 
            lstOptions.add(new SelectOption('Retail','Retail')); 
            lstOptions.add(new SelectOption('Sports','Sports'));         
            } 
             return lstOptions;
         }
          
         public list<selectOption> getApplications()
         {   list <selectoption> lstApp = new List<selectOption>();
            if(!String.isblank(sAppIndus) && sAppIndus !='--None--'){
           lstApp.add(new SelectOption('--None--','--None--'));
           
           list<string> newApp = app_value__c.getinstance(sAppIndus).application__c.split(',');
          
           if(newApp.size()>0){
            for(string s : newApp){
            lstApp.add(new selectOption(s,s));
            }
           
           }
           return lstApp;
           
           }else { lstApp.add(new SelectOption('--None--','--None--'));
               return lstApp; }
           }
           
           public void createproject() 
           
               {	
                   system.debug('Chck for values::'+newproject);
                     newproject.recordTypeID = Schema.getGlobalDescribe().get('Project__c').getDescribe().getRecordTypeInfosByName().get(Record_type_assign__c.getinstance(selectedType).Project_record_type_name__c).getRecordTypeId();
                     if(sAppIndus!='--None--')
                     newProject.Application__c = sAppIndus;
                     newProject.Application_2__c=sApplication;
                     newProject.stage__c='Prospecting';
                    insert newproject ;
                     
                    }
                    
           }