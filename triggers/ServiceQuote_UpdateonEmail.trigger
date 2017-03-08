trigger ServiceQuote_UpdateonEmail on Service_Quote__c (before insert,before update) {
        ServiceQuote_UpdateonEmailHelper.getEmails(trigger.new);         
    }