/*************************************************************************\
    @ Author        : Nitish Kumar
    @ Date          : June 2015
    @ Test File     : NA
    Function        : Apex Class for ShowNotesAndAttachment And TransferNotesAndAttachment Page 
    @ Audit Trial   : Repeating block for each change to the code
    -----------------------------------------------------------------------------
    
******************************************************************************/
global class ProjectsNotesAndAttachment {
    
    //Global Variables
    public list<noteAttach> notesAttaclst {get;set;}
    public String recordId {get; set;}
    public Project__c project ;
    public Set<Id> selectedNoteAttach { get ; set;}
    public String searchText { get ; set;}
    public list<oppProj> searchResults {get;set;}
    public boolean isInRep { get ; set;}

   //Constructor
   public ProjectsNotesAndAttachment(ApexPages.StandardController controller)
    {
        //To avoid SOQL 
         if (!Test.isRunningTest()) {
            //Adding these fields to avoid additional SOQL query.
            controller.addFields(new List < String > {
                'name'
            });
        }
        
        isInRep = false ;   
        
        if(Network.getNetworkId() == null ){
        isInRep = false ;   
        }
        else{
        isInRep = true ;
        }
        
      project = (Project__c) controller.getRecord();    //Get Project from controller
      
       Set<Id> oppId = new Set<Id>() ;
       Map<Id, String> oppMap = new Map<Id,String>() ;
       Map<Id,string> oppAccMap = new Map<Id,string>();
      
      //Populating the Wrapper object which gives Notes and Attachment list
      List<Opportunity> opplist =[Select Id, AccountID,Account.Name,Name,Project_Name__r.Name from Opportunity where Project_Name__c =: project.Id order by Account.Name ASC ] ;
      
      for (Opportunity opp : opplist){
      
      oppId.add(opp.Id);
      oppMap.put(opp.Id, opp.Name);
      
      oppAccMap.put(opp.Id,opp.Account.Name);
      
      }
      
      
      //Query the Notes of all the Opportunity and Project
      List<Note> notelist = [Select Id,Title,ParentId,LastModifiedById,LastModifiedBy.Name, CreatedById,CreatedBy.Name ,CreatedDate,LastModifiedDate from Note where ParentId =: oppId or ParentId =: project.Id order by CreatedDate DESC ];
      notelist.sort();
      //Query the Attachment of all the Opportunity and Project
      list<Attachment> attachmentlst = [Select Id , Name , ParentId ,LastModifiedById,LastModifiedBy.Name, CreatedById, CreatedBy.Name,CreatedDate,LastModifiedDate from Attachment where ParentId =: oppId or ParentId =: project.Id order by CreatedDate DESC];
      attachmentlst.sort();
      notesAttaclst = new list<noteAttach>();
      
      //Populating the Wrapper object which gives Notes and Attachment list
      for (Attachment att : attachmentlst){
           if (oppId.contains(att.ParentId)){
            noteAttach ntAttopp = new noteAttach(att,'Opportunity',oppMap.get(att.ParentId),oppAccMap.get(att.ParentId));
            notesAttaclst.add(ntAttopp);
            
           }
           else{
            noteAttach ntAttProj = new noteAttach(att,'Project',project.Name,'');
            notesAttaclst.add(ntAttProj);
            
           }
      }
      
      for (Note note : notelist){
           if (oppId.contains(note.ParentId)){
            noteAttach ntAttopp = new noteAttach(note,'Opportunity',oppMap.get(note.ParentId),oppAccMap.get(note.ParentId));
            notesAttaclst.add(ntAttopp);
             
           }
           else{
            noteAttach ntAttProj = new noteAttach(note,'Project',project.Name,'');
            notesAttaclst.add(ntAttProj);
             
           }
       }
       
       notesAttaclst.sort();
       
      
    }
    
    /***********************************************************************************************************************************************
             * @author :- Nitish Kumar
             * @date  :-  June-2015
             * @description :- Public pageReference method which does the transfer of Notes and Attachment from one record to another.
                               Since salesforce does not allow to update ParentId field of Notes and Attachment, the work around has been cloning the
                               existing notes and attachment and deleting the previous ones.
             * @param :- NA
    ***********************************************************************************************************************************************/
    
    public pageReference doTransfer(){
        
        String selectedId ;
        Boolean hasnotSelected = false ;
        Boolean selectedMoreThanOne = false ;
        Integer selectedCount = 0 ;
        
        if(searchResults != null){
        for (oppProj oppPr : searchResults){
            if (oppPr.isSelected){
                selectedId = oppPr.recordId ;
                selectedCount = selectedCount + 1 ;
            }
         }
       }
       //Error message when user clicks on Transfer button without clicking on Search
       else{
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please search with Opportunity/Project Name and select one to transfer the Notes and Attachment'));
       }
        
        if (selectedCount == 0){
            hasnotSelected = true ;
        }
        
        if (selectedCount > 1){
            selectedMoreThanOne = true ;
        }
        
        //If all the conditions are met
        If(!hasnotSelected && !selectedMoreThanOne){
        
        list<Note> notelist = [Select Title, SystemModstamp, ParentId, OwnerId, LastModifiedDate, LastModifiedById, IsPrivate, IsDeleted, Id, CreatedDate, CreatedById, Body from note where Id =: selectedNoteAttach];
        list<Note> noteToInsert = new list<Note>();
        
        for (Note note : notelist){
            Note insertnote = note.clone(); //to insert
            insertnote.ParentId = selectedId ;
            noteToInsert.add(insertnote);
        }
        
        list<Attachment> attachlist = [Select SystemModstamp, ParentId, OwnerId, Name, LastModifiedDate, LastModifiedById, IsPrivate, IsDeleted, Id, Description, CreatedDate, CreatedById, ContentType, BodyLength, Body From Attachment where Id =: selectedNoteAttach];
        list<Attachment> attachToInsert = new list<Attachment>();
        
        for (Attachment attach : attachlist){
            Attachment insertAttach = attach.clone();//to insert
            insertAttach.ParentId = selectedId ;
            attachToInsert.add(insertAttach);
        }
        
        //Inserting the new Notes
        if (noteToInsert.size() >0){
            insert noteToInsert ;
        }
        
        //Inserting the new Attachment
        if (attachToInsert.size() >0){
            insert attachToInsert ;
        }
        
        //Deleting the Notes from previous location
        if (notelist.size() >0){
            delete notelist ;
        }
        
        //Deleting the Attachment from previous location
        if (attachlist.size() >0){
            delete attachlist ;
          }
          
         //Success Message 
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'The selected Notes and Attachment has been transferred successfully')); 
         searchResults.clear();
        }
        
        //Error Messages
        else{
            if (hasnotSelected){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select one record where you want to tranfer the Notes and Attachments'));
            }
            if (selectedMoreThanOne){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You can not transfer Notes and Attachment to more than one record'));
            }
        }
        
        return null ;
    }
    
     /***********************************************************************************************************************************************
             * @author :- Nitish Kumar
             * @date  :-  June-2015
             * @description :- Public pageReference method which redirects the user to Transfer page from ShowNotesAndAttachment page
             * @param :- NA
    ***********************************************************************************************************************************************/
    
    public pageReference transferPage(){
    
    selectedNoteAttach = new set<Id>();
    Boolean hasSelected = false ;
        
     for (noteAttach nAtt : notesAttaclst){
        if(nAtt.isSelected){
        selectedNoteAttach.add(nAtt.recordId);
        hasSelected = true ;
        }
     }
     //Error Message if the user does not select any notes and attachment
     if (!hasSelected){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select at least one record'));
        return null ;
     }
     else{
     PageReference pageRef = Page.TransferNotesAndAttachments ;
     pageRef.setRedirect(false);
     return pageRef;
     }
    }
    
      /***********************************************************************************************************************************************
             * @author :- Nitish Kumar
             * @date  :-  June-2015
             * @description :- Public pageReference method which preforms the search. The Search results are stored in a list of wrapper object which 
                               contains both opportunity and Project records
             * @param :- NA
    ***********************************************************************************************************************************************/
    
    public pageReference dosearch(){
        
        searchResults = new list<oppProj>() ;
        Boolean noSearchResults = true ;
            
        String searhOpp = 'Select Id, Name,CreatedDate from Opportunity' + ' where Name like \'%'+searchText+'%\' order by Name Limit 500'; //querying the first 500 records
        String searhProj = 'Select Id, Name ,CreatedDate from Project__c' + ' where Name like \'%'+searchText+'%\' order by Name Limit 500'; //querying the first 500 records
        
        list<Opportunity> opplist = Database.query(searhOpp); 
        list<Project__c> projlist = Database.query(searhProj); 
        
        if (opplist.size() > 0 || projlist.size() > 0){
            noSearchResults = false ;
        }
        
        //Warning message if the search didn't return any result
        if (noSearchResults){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Your search did not return any result.'));    
        }
        
        for (Opportunity opp : opplist){
            oppProj oppWrapp = new oppProj(opp);
            searchResults.add(oppWrapp);
        }
        
        for (Project__c proj : projlist){
            oppProj projWrapp = new oppProj(proj);
            searchResults.add(projWrapp);
        }
        
        return null ;
    }
    
     /***********************************************************************************************************************************************
             * @author :- Nitish Kumar
             * @date  :-  June-2015
             * @description :- Public pageReference method which deletes the individual notes and attachment and redirects the user to the same page.
             * @param :- NA
    ***********************************************************************************************************************************************/
    
    public pageReference deleteRecord(){
        
     String url = ApexPages.currentPage().getURL(); 
     PageReference pageRef = new PageReference(url);
        
     List<Note> notelist = [Select Id from Note where Id =: recordId];  
    
     if (notelist.size() > 0){
        delete notelist ;
     }
     
     List<Attachment> attachlist = [Select Id from Attachment where Id =: recordId];    
    
     if (attachlist.size() > 0){
        delete attachlist ;
     }
     
     pageRef.setRedirect(true);
     return pageRef;
        
    }
    
    
     /***********************************************************************************************************************************************
             * @author :- Nitish Kumar
             * @date  :-  June-2015
             * @description :- Public pageReference method which redirects the user to new Note creating page
             * @param :- NA
    ***********************************************************************************************************************************************/
    
    public Pagereference redNewNoteUrl(){
      if(!(isInRep)){
      String url = '/002/e?parent_id='+ String.valueOf(project.Id).subString(0,15) + '&retURL=' + String.ValueOf(project.Id).subString(0,15) ;
      PageReference redUrl = new PageReference(url);
      redUrl.setRedirect(true);
      return redUrl ;
      }
      else{
      String url = '/002/e?parent_id='+ String.valueOf(project.Id).subString(0,15) + '&retURL=reps/' + String.ValueOf(project.Id).subString(0,15) ;
      PageReference redUrl = new PageReference(url);
      redUrl.setRedirect(true);
      return redUrl ;
      }
        
    }
    
    /***********************************************************************************************************************************************
             * @author :- Nitish Kumar
             * @date  :-  June-2015
             * @description :- Public pageReference method which redirects the user to new Attachment creating page
             * @param :- NA
    ***********************************************************************************************************************************************/
    
    public PageReference redNewAttachmentUrl(){
        
    if(!isInRep){
    String url = '/p/attach/NoteAttach?pid='+ String.valueOf(project.Id).subString(0,15) + '&parentname=' + project.name + '&retURL=' + String.valueOf(project.Id).subString(0,15) ;
    PageReference redUrl = new PageReference(url);
    redUrl.setRedirect(true);
    return redUrl ;
    }
    else{
    String url = '/p/attach/NoteAttach?pid='+ String.valueOf(project.Id).subString(0,15) + '&parentname=' + project.name + '&retURL=reps/' + String.valueOf(project.Id).subString(0,15) ;
    PageReference redUrl = new PageReference(url);
    redUrl.setRedirect(true);
    return redUrl ; 
    }
    }
    
    public PageReference goback(){
    String url = '/' + project.Id ;
    PageReference redUrl = new PageReference(url);
    redUrl.setRedirect(true);
    return redUrl ;
    }
    

    
    //Wrapper class for storing both Notes and Attachment
    global class noteAttach  implements Comparable {
        
     public Note note {get ; set;}
     public Attachment attach { get ; set;}
     public String objectName {get ; set;}
     Public String Type {get ; set;}
     Public String recordId {get ; set;}
     Public String ParentObjectName {get ; set;}
     public boolean isSelected {get ; set;}
     public string AccountName {get ; set ;}
     public Date CreatedDate{get ; set ;}
     public Date LastModifiedDate{get ; set ;}
     
     public noteAttach (Note nt , String obj, String parentName ,string Accountname){
        this.note = nt ;
        this.objectName = obj ;
        this.ParentObjectName = parentName ;
        this.Type = 'Note' ;
        this.recordId = nt.Id ;
        this.isSelected = false ;
        if(Accountname!=null){
        this.AccountName=Accountname ;
        }
        this.CreatedDate = nt.CreatedDate.date();
        this.LastModifiedDate=nt.LastModifiedDate.date();
        
     }
     
     public noteAttach (Attachment att , String obj,String parentName ,string Accountname){
        this.attach = att ;
        this.objectName = obj ;
        this.ParentObjectName = parentName ;
        this.Type = 'Attachment' ;
        this.recordId = att.Id ;
        this.isSelected = false ;
        if(Accountname!=null){
        this.AccountName=Accountname ;
        }
        this.CreatedDate = att.CreatedDate.date();
        this.LastModifiedDate=att.LastModifiedDate.date();
        
        
     }
    
      global integer compareTo(Object ObjToCompare) {
          
          
              return AccountName.CompareTo(((noteAttach )ObjToCompare).AccountName);
              
        }

    
  
    }
    
    // For Searching Opportunity or Projects 
     public class oppProj {
        
        public Project__c project {get ;set;}
        public Opportunity opportunity {get;set;}
        public boolean isSelected {get;set;}
        public String objtype {get;set;}
        public String recName {get;set;}
        public String recordId {get;set;}
        public Date CreatedDate {get;set;}
        
        public oppProj (Opportunity opp){
            this.opportunity = opp ;
            this.isSelected = false ;
            this.objtype = 'Opportunity' ;
            this.recName = opp.Name;
            this.recordId = opp.Id ;
            this.CreatedDate =opp.CreatedDate.date();
        }
        
        public oppProj (Project__c proj){
            this.project = proj ;
            this.isSelected = false ;
            this.objtype = 'Project' ;
            this.recName = proj.Name;
            this.recordId = proj.Id ;
            this.CreatedDate =proj.CreatedDate.date();
        }
     }  
}