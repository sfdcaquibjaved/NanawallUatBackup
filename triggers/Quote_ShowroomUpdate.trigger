trigger Quote_ShowroomUpdate on Quote__c (before update,before insert) {
    /*
    trigger purpose
        updates qutoes commission showroom when a quote is created or edited(and the zip changes)
    */
    
    /*
    string line = '0';
    for (Quote__c q: trigger.new)
    {   
        try
        {
            line='1';

            if (trigger.isInsert || (trigger.oldmap.get(q.id).Zip__c != q.Zip__c) || q.State__c=='Quebec')
            {
                line='3';
                List<Zip_Lookup__c> zl = [select id,Showroom_Commission__c from Zip_Lookup__c where name=:q.Zip__c];
                line='4';
                if (zl.size() > 0)
                    q.Commission_Showroom__c = zl[0].Showroom_Commission__c;
                if (q.State__c == 'Quebec')
                {
                    q.Commission_Showroom__c='a0DA0000002wo64';
                }
                line='5';
            }
            
        }
        catch (Exception ex)   
        { 
            Utility.JimDebug(ex, 'get showroom for quote ' + q.Name + ' ' + line); 
        }
    } 
    */
}