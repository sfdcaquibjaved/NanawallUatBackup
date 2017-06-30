trigger InstallationFormTrigger on Installation_Form__c (after insert) {
    list<Installation_form__c> iflist = new list<Installation_form__c>();
    for(Installation_Form__c ifo: trigger.new){
        if(ifo.recordtypeID == '012A0000000VrvPIAS'){
            iflist.add(ifo);
        }
    }
    System.debug('iflist'+iflist);
    if(iflist.size()>0){
        InstallationTriggerHandler.signaturecaptureaction(iflist);
    }
}