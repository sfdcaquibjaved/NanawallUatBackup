trigger ContactSetIsDirty on Contact (before insert, before update) {
    
    /*
    this trigger: 
        phone numbers are cleaned of invalid characters;
    */
    Map<string,string> statemap =null;

     for( Contact c : Trigger.new )
    {  
            
        if (c.Phone != NULL)
        {
            if (c.Phone.startsWith('+1')) 
            {
                c.Phone = c.Phone.substring(3);
                c.Phone = c.Phone.replace('.','-');
                c.Phone = c.Phone.replaceFirst('(^[0-9][0-9][0-9]).','($1) ');
            }
            c.Phone = c.Phone.replace('.','-');
        }
        if (c.Fax != NULL)
        {
            if (c.Fax.startsWith('+1'))
            {
                c.Fax = c.Fax.substring(3);
                c.Fax = c.Fax.replace('.','-');
                c.Fax = c.Fax.replaceFirst('(^[0-9][0-9][0-9]).','($1) ');
            }
            c.Fax = c.Fax.replace('.','-');
        }
        
        
    }
}