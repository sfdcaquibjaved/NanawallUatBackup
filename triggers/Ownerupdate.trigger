trigger Ownerupdate on Zip_Codes_Master__c (after update) {
objectsOwnerUpdatefromZip.assignobjectowner(trigger.old,trigger.new);
}