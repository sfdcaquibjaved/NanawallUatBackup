public with sharing class newQuoteButtonOverRide {
  
  public quote__c custquote ;
  
  
  public newQuoteButtonOverRide(ApexPages.StandardController controller) {
    custQuote = (quote__c) controller.getRecord();
  }
  
  public pageReference redirect(){
    if(System.currentPageReference().getParameters().containsKey('set')){
    string oppParam = System.currentPageReference().getParameters().get('CF00NA0000001O58u');
    string oppParam2 = System.currentPageReference().getParameters().get('CF00NA0000001O58u_lkid');
    string url ='/apex/NewQuote?'+'CF00NA0000001O58u='+EncodingUtil.URLENCODE(oppParam,'UTF-8')+'&CF00NA0000001O58u_lkid='+oppParam2;
     PageReference redUrl = new PageReference(url);
      redUrl.setRedirect(true);
      return redUrl ;
    }
    else {
    String url = '/apex/Quote_Wizard_Project_Clone_Page';
    
      PageReference redUrl = new PageReference(url);
      redUrl.setRedirect(true);
      return redUrl ;
  }
  }

}