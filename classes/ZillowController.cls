public class ZillowController {

//Account a= null;
//Opportunity op = null;
//Contact con = null;
Lead le = null;
Project__c prj = null;
string address,state,city;

public ZillowController(ApexPages.StandardController sc)
{
    sObject  so = sc.getRecord();
    /*if (so.getSObjectType() == Opportunity.sObjectType)
    {
        op = (Opportunity)so;
        address = op.Shipping_Street_Address__c;
        state = op.Shipping_State__c;
        city = op.Shipping_City__c;
    }
    else if (so.getSObjectType() == Account.sObjectType)
    {
        a = (Account)so;
        address = a.BillingStreet;
        state = a.BillingState;
        city  = a.BillingCity;
    }
    else if (so.getSObjectType() == Contact.sObjectType)
    {
        con = (Contact)so;
        address = con.MailingStreet;
        state = con.MailingState;
        city  = con.MailingCity;
    }
    if (so.getSObjectType() == Lead.sObjectType)
    {
        le = (Lead)so;
        address = le.Project_Site_Street__c;
        state = le.Project_Site_State__c;
        city = le.Project_Site_City__c;
    }*/
    if (so.getSObjectType() == project__c.sObjectType)
    {
        prj = (project__c)so;
        address = prj.Project_Street_Address__c;
        state = prj.Project_State__c;
        city = prj.Project_City__c;
    }
    
    MyEstimate();
}
 
public string MyEstimate()
{
    try
    { 
            ZillowService p = new ZillowService() ;
            ZillowTypes.PropertySearchResponse r = p.searchZillow( address,city, state) ;
            LocationValue = r.getZEstimateAmount() ;
            LocationDetailsLink = r.getHomeDetailsLink();
            //LocationValue =1;
    }
    catch (Exception ex)
    {
        //Utility.JimDebug(ex,'Zillow');
        LocationDetailsLink = 'Error: ' + ex + ' ; line number: ' + ex.getLineNumber();
    }       
            return '';
        
}

public string LocationDetailsLink
{
    get
    {
        return LocationDetailsLink;
    }
    set
    {
        LocationDetailsLink=value;
    }
}

public string LocationValueString
{
    get
    {
        if (LocationValue==null )
            return '';
        else
            return '$' + Decimal.valueOf(LocationValue).format();
    }
    set
    {
        LocationValueString=value;
    }
}


public double LocationValue
{
    get
    {
        return LocationValue;
    }
    set
    {
        LocationValue= value;
    }
}

public string getobjtype()
{
    return 'test';
}

}