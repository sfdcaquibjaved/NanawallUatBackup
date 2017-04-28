global class MultiAttachment_InlineController {
    public list<cvfile> filelist { get; set;}
    public String prId {get; set;}
    public Project__c project ;
    public String recordId {get;set;}
    public Boolean shouldRedirect {public get; private set;}
    public String redirectUrl {public get; private set;}
    public MultiAttachment_InlineController(ApexPages.StandardController controller){
        project = (Project__c) controller.getRecord(); 
        prId = (ID) controller.getRecord().Id;
        System.debug('project id'+prId);
        shouldRedirect = false;
        //Get Project from controller
        ID filter = prID;
        Set<Id> fileId = new Set<Id>() ;
        list<ContentDocumentLink> elm=[SELECT ContentDocumentId,LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId =: filter];        
        for(ContentDocumentLink fi:elm){
            fileId.add(fi.ContentDocumentId);
        }
        list<ContentVersion> cvlist = [Select Id , Title ,LastModifiedDate, CreatedDate, CreatedById, CreatedBy.Name,Type_of_File__c from ContentVersion where ContentDocumentId in:fileId order by CreatedDate DESC];
        
        filelist = new list<cvfile>();
        for(ContentVersion v:cvlist){
            cvfile cvk = new cvfile(v.Id,v,v.Type_of_file__c,v.LastModifiedDate,v.Title,v.CreatedBy.Name,v.CreatedDate);
        //System.debug('Hello'+ntAttopp);
        filelist.add(cvk);
      }
       
    }
    public pageReference deleteRecord(){
     String url = ApexPages.currentPage().getURL(); 
     PageReference pageRef = new PageReference(url);
     List<ContentVersion> contentlist = [Select Id,ContentDocumentId from ContentVersion where Id =: recordId];
     set<id> cdids = new set<id>();
     for(ContentVersion cv:contentlist){
         cdids.add(cv.ContentDocumentId);
     }    
     list<ContentDocument> cdlist = [Select id from ContentDocument where id in:cdids];
     if (cdlist.size()> 0){
        delete cdlist ;
     }
     pageRef.setRedirect(true);
     return pageRef;
        
    }
    public pageReference redirect(){
        Id pageid = ApexPages.currentPage().getParameters().get('id');
        redirectUrl = '/apex/multiAttachment_newvf?id='+pageid;
        PageReference pageRef = new PageReference(redirectUrl);
        pageRef.setRedirect(true);
        shouldRedirect = true;
        return null;
    }
    // Wrapper Class
    global class cvfile{
      public ContentVersion c {get;set;}
      public Date LMDate { get; set;}
      public String typeoffile { get; set;}
      public String Title {get;set;}
      public String CBName {get ; set ;}
      public Id recordId {get; set;}
      public Datetime created {get; set;}
     
     public cvfile (Id newid,ContentVersion f,String typef,Datetime lm,String t, String cbname, Datetime crd){
      this.recordId = f.id;
      this.c = f;
      this.Title = t;
      this.LMDate = date.newinstance(f.LastModifiedDate.year(), f.LastModifiedDate.month(), f.LastModifiedDate.day());
      this.typeoffile = typef;
      this.CBName = cbname;
      this.created = crd;
    }
        
}
}