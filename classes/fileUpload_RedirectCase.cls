public class fileUpload_RedirectCase {
Apexpages.StandardController controller;
 public Case CaseRecord;
public fileUpload_RedirectCase(ApexPages.StandardController sc) {
    this.controller= sc;
    CaseRecord= (Case) sc.getRecord();
}

public  PageReference redirect() {
 String userAgent =
ApexPages.currentPage().getHeaders().get('USER-AGENT');
Id pageid = ApexPages.currentPage().getParameters().get('id');

    //String fullUrl = 'https://' + ApexPages.currentPage().getHeaders().get('Host');
    String fullUrl = Site.getPathPrefix();
    System.debug('fullUrl'+fullUrl);
System.debug('userAgent'+userAgent);
if( !userAgent.contains('Android')) {
    System.debug('iphone');
    
    String  myUrl=Site.getPathPrefix()+'/apex/MultipleAttachmentsVFCase?id='+pageid;
        
             PageReference redUrl1 = new PageReference(myUrl);
             redUrl1.getParameters().put('Case.ID', CaseRecord.Id);
redUrl1.setRedirect(true);
return redUrl1;
}
    else{
        System.debug('Android');
                //id i = InstallationRecord.ID ; 
                 String  myUrl=Site.getPathPrefix()+'/apex/MultipleAttachmentsVFCase?id='+pageid;
             PageReference redUrl1 = new PageReference(myUrl);
            redUrl1.getParameters().put('Case.ID', CaseRecord.Id);
            
redUrl1.setRedirect(true);
return redUrl1;
    }
    Return null;
}
}