@isTest
private class ZVFSignaturePadControllerTest {
    static testMethod void runPositiveTestCases(){
        
        Opportunity o = new Opportunity();
        o.name = 'test';
        o.amount = 12345;
        o.StageName = 'Qualification';
        o.CloseDate = date.newInstance(2016, 1, 30);
        insert o;
        System.assert(o.id!=null);
        ApexPages.StandardController sc = new ApexPages.StandardController(o);
        ZVFSignaturePadController sp = new ZVFSignaturePadController(sc);
        String result = ZVFSignaturePadController.uploadSignature('123456',O.ID);
        System.debug('Result is ' + result);
        System.assert(result!=null);
    }
}