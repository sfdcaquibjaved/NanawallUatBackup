trigger sendResponsefromCase on EmailMessage (before insert) {
    list<EmailMessage>emlist = new list<EmailMessage>();
    for(EmailMessage em: trigger.new){
        if(em.Subject.contains( '[ ref:_') && em.ParentId !=  null){
            emlist.add(em);
        }
    }
    if(emlist.size()>0){
        System.debug('emlist'+emlist);
        sendResponsefromCaseClass.sendreplytofromCase(emlist);
    }
}