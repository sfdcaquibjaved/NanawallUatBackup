@isTest
Private class Testzillowconf{
static testMethod void zillow(){
Test.startTest();
try{
ZillowConfig testZillowConfig = new ZillowConfig();
ZillowService p = new ZillowService() ;
ZillowTypes.PropertySearchResponse r = p.searchZillow( '2114 Bigelow Ave', 'Seattle, WA') ;
Double d = r.getZEstimateAmount() ;
System.debug( '**** HOME VALUATION RETURNED = ' +d ) ;
}
catch( ZillowTypes.ZillowException e){
System.debug( '**** Caught Exception' +e ) ;
}


}
}