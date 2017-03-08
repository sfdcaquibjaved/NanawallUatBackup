trigger Attachment_Trigger_on_Project on Attachment (before insert, after insert, after update, after delete) {
    list<attachment> attlist = new list<attachment>();
    list<attachment> attachlist2 = new list<attachment>();
    list<attachment> attlistdelete = new list<attachment>();
    List<string> attid=  new list<string>();
    List<string> proid=  new list<string>();
    List<string> quoteid=  new list<string>();
   list<dsfs__DocuSign_Status__c> dd = new list<dsfs__DocuSign_Status__c>();
    if(trigger.isInsert && trigger.isAfter)
    {
        list<Attachment> attachlist = [select id, body, Name, parentid from Attachment where id IN: Trigger.newMap.keySet()];
        for(Attachment att: attachlist )
        {
            attid.add(att.parentid);
        }
        list < dsfs__DocuSign_Status__c > dslist = [select id, Nana_Quote__r.Project__c from dsfs__DocuSign_Status__c where id IN: attid]; 
        for(Attachment att: trigger.new)
        {
            for(dsfs__DocuSign_Status__c ds: dslist)
            {     
                if(att.parentid==ds.id)
                {          
                    Attachment a2 = new Attachment();
                    a2.body=att.body;
                    a2.Name=att.Name;
                    a2.ParentId=ds.Nana_Quote__r.Project__c;
                    attlist.add(a2);
                }
            }
            
        }
        if(attlist.size()>0)
        {
            insert attlist;
        }
           
    }
    
    if(trigger.isDelete && trigger.isAfter)
    {
    
        for(Attachment at: trigger.old)
        {
            quoteid.add(at.parentid);
            attachlist2.add(at);
        }
                System.debug('attttttttttttttttt'+attachlist2);
        list < dsfs__DocuSign_Status__c > dslist = [select id, Nana_Quote__r.Project__c from dsfs__DocuSign_Status__c where id IN: quoteid]; 
         for(dsfs__DocuSign_Status__c dss: dslist)
         {
             proid.add(dss.Nana_Quote__r.Project__c);
         }
           System.debug('Docusignnnnnnn'+dslist);
           list<Attachment> attachlistdelete= [select id, body, Name, parentid, createddate from Attachment where parentid IN: proid];
           System.debug('deleteeeeeeeeeee'+attachlistdelete);
        for(Attachment att: attachlistdelete)
        {
            for(Attachment att2: attachlist2)
            {     
                if(att.Name==att2.Name)
                {                       
                    attlistdelete.add(att);
                }
            }
            
        }
        if(attlistdelete.size()>0)
        {
            delete attlistdelete;
        }
    }
}