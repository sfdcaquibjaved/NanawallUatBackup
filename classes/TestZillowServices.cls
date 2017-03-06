@isTest
private class TestZillowServices{
//public Static List<Contact> olstContact;
static testMethod void Zillow(){
 /*olstContact=TestDataUtility.createConTestData();
 olstContact[0].MailingStreet='Blossom Hill Road';
 olstContact[0].MailingCountry='United States';
 olstContact[0].MailingState='California';
 olstContact[0].MailingCity='San Jose';
 olstContact[0].MailingPostalcode='12345';
 insert olstContact;*/
    Test.startTest();
try{
ZillowService p = new ZillowService() ;
ZillowTypes.PropertySearchResponse r = p.searchZillow( '2114 Bigelow Ave', 'Seattle, WA') ;
Double d = r.getZEstimateAmount() ;
System.debug( '**** HOME VALUATION RETURNED = ' +d ) ;
}
catch( ZillowTypes.ZillowException e){
System.debug( '**** Caught Exception' +e ) ;
}
//static testMethod void Zillow1(){
    try{
ZillowService p = new ZillowService() ;
ZillowTypes.PropertySearchResponse r = p.searchZillow( '2114 Bigelow Ave', 'Seattle, WA','CA','12345') ;
Double d = r.getZEstimateAmount() ;
System.debug( '**** HOME VALUATION RETURNED = ' +d ) ;
}
catch( ZillowTypes.ZillowException e){
System.debug( '**** Caught Exception' +e ) ;
}
//}
try{
ZillowService p = new ZillowService() ;
ZillowTypes.PropertySearchResponse r = p.searchZillow( '2114 Bigelow Ave', 'Seattle, WA','CA') ;
Double d = r.getZEstimateAmount() ;
System.debug( '**** HOME VALUATION RETURNED = ' +d ) ;
}
catch( ZillowTypes.ZillowException e){
System.debug( '**** Caught Exception' +e ) ;
}
  Test.stopTest(); 
 }
 }