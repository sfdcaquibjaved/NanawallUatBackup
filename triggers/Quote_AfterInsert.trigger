trigger Quote_AfterInsert on Quote__c (after insert) {
    
    /*
    trigger purpose
        complicated aggregate calls to set the Max_Quote_Contact__c on opportunities when quotes are inserted
    */
    
    /*
    Set<ID> oppidsone=new Set<ID>();
    Set<ID> contidsone=new Set<ID>();

    for (Quote__c q : trigger.new) 
    {
        if (!oppidsone.contains(q.opportunity__c))
        {
            oppidsone.add(q.opportunity__c);
            q.Stage__C='Open'
        }

        if( !contidsone.contains(q.contact__c))
            contidsone.add(q.contact__c);       
    }
    AggregateResult[] results=[select count(name) cnt,opportunity__c,contact__c from quote__c where opportunity__c in:oppidsone group by rollup (quote__c.opportunity__c,quote__c.contact__c)];
    Map<ID,Opportunity> maxqs = new Map<ID,Opportunity>([select id,max_quote_contact__c from opportunity where id in :oppidsone]);


    Map<ID,integer> opps= new Map<ID,integer>();
    string summary ='';
    for (AggregateResult ar : results)
    {
        integer count = Integer.valueOf(ar.get('cnt'));
        ID oppid = String.valueOf(ar.get('opportunity__c'));
        ID cont = String.valueOf(ar.get('contact__c'));
        if (ar.get('opportunity__c') == null || ar.get('contact__c')==null)
            continue;
        summary += 'opp='+oppid + ' count='+count + ' contact='+cont;
        decimal maxq=0;
        //Utility.jimdebug(null,String.valueOf(maxqs.get(oppid).max_quote_contact__c) + ' max q c');
        //return;
        try
        {
        if (maxqs.get(oppid).max_quote_contact__c!=null)
            maxq = maxqs.get(oppid).max_quote_contact__c;
        }
        catch(Exception ex){}
        if (!opps.containsKey(oppid) && count>maxq)
        {
            opps.put(oppid,count);
        }
        else if(opps.containsKey(oppid))
        {
            integer c = opps.get(oppid);
            if (count>c)
            {
                opps.put(oppid,count);
            }
        }
    }
//  Utility.JimDebug(null,summary);
    Map<ID,Opportunity> updates = new Map<ID,Opportunity>([select id,Max_Quote_Contact__c from Opportunity where id in:opps.keySet()]);
    
    for (Opportunity o : updates.Values())
    {
        o.Max_Quote_Contact__c = opps.get(o.ID);
        
    }
    
    update updates.Values();
    
    //flag all the contacts with the appropriate values
//  System.debug('start the contact aggregate lookup');
    if( contidsone.size() > 0 )
    {
        list<Contact> conts = Quote_Utility.GetQuoteCountContactUpdates(contidsone);
        if( conts.size() > 0 )
        {
            SYstem.debug('updating '+ conts.size() + ' contacts in the Quote.AfterINsert trigger');
            update conts;
        
        }
    }
    */

}