public class fileUpload_Redirect {

Apexpages.StandardController controller;
 public Installation__c InstallationRecord;
public fileUpload_Redirect(ApexPages.StandardController sc) {
    this.controller= sc;
    InstallationRecord= (Installation__c) sc.getRecord();
}

public  PageReference redirect() {
 String userAgent =
ApexPages.currentPage().getHeaders().get('USER-AGENT');
Id pageid = ApexPages.currentPage().getParameters().get('id');

    //String fullUrl = 'https://' + ApexPages.currentPage().getHeaders().get('Host');
    String fullUrl = Site.getPathPrefix();
    System.debug('fullUrl'+fullUrl);
System.debug('userAgent'+userAgent);
if(userAgent.contains('iPhone')) {
    System.debug('iphone');
    
    String  myUrl=Site.getPathPrefix()+'/apex/MultipleFileUpload?id='+pageid;
        
             PageReference redUrl1 = new PageReference(myUrl);
             redUrl1.getParameters().put('Installation__c.ID', InstallationRecord.Id);
redUrl1.setRedirect(true);
return redUrl1;
}
    else{
        System.debug('Android');
                //id i = InstallationRecord.ID ; 
                 String  myUrl=Site.getPathPrefix()+'/apex/MultipleAttachmentsVFpage?id='+pageid;
             PageReference redUrl1 = new PageReference(myUrl);
            redUrl1.getParameters().put('Installation__c.ID', InstallationRecord.Id);
            
redUrl1.setRedirect(true);
return redUrl1;
    }
    Return null;
}
}