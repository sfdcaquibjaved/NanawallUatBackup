public with sharing class Service_Quote_Detail_AddEditController {

//https://c.cs3.visual.force.com/apex/Service_Quote_Detail_AddEdit?scontrolCaching=1&id=a1UQ0000000B7Xh
    public Service_Quote_Detail__c serviceQuoteDetail { get; set; }

    public Service_Quote__c serviceQuote { get; set; }

    private void loadServiceQuote( string sqid ) 
    {
        serviceQuote = [SELECT id,Discount__c,Responsibility__c,NonStock_Responsibility__c FROM Service_Quote__c WHERE Id = :sqid ];    
    }
    
    public boolean getuseVendorPrice() {
        
    
        set<string> vendorPrice_responsibility = new Set<string>{ 'solarlux nana llc','solarlux faltsysteme', 'nanawall systems'};
    
        string resp = ( serviceQuote.Responsibility__c != null ? serviceQuote.Responsibility__c.toLowerCase() : '' );
        string nonstockresp = ( serviceQuote.NonStock_Responsibility__c != null ? serviceQuote.NonStock_Responsibility__c.toLowerCase() : '' );
    
        return  ( vendorPrice_responsibility.contains(resp) || vendorPrice_responsibility.contains(nonstockresp) );
    }

    public Service_Quote_Detail_AddEditController(ApexPages.StandardController controller) {
        if( controller.getrecord() != null && controller.getRecord().Id != null)
        {
            serviceQuoteDetail = (Service_Quote_Detail__c)controller.getrecord();
            if(serviceQuoteDetail.Service_Part__c != null)
            {
                Service_Part__c sp = [SELECT Id, Part_Name__c FROM Service_Part__c WHERE id =:serviceQuoteDetail.Service_Part__c];
                ServicePartItemID = sp.Id;
                ServicePartName = sp.Part_Name__c;
            } else {
                ServicePartItemID = '';
                ServicePartName = '';  
            
            }
            loadServiceQuote( serviceQuoteDetail.Service_Quote__c );
            
        } else 
        {
             string FieldID = label.Service_Quote_Field_ID ;
            string sqId = Apexpages.currentPage().getParameters().get(FieldID);
            if( sqId == null || sqId == '' )
            {//if this is coming in from a related list, we wont have the param we need.
                string temp = Apexpages.currentPage().getParameters().get('retURL');
                sqId = temp.substring(1,temp.length() );
            
            }
            loadServiceQuote( sqId);
            
            serviceQuoteDetail = new Service_Quote_Detail__c();         
            serviceQuoteDetail.Quantity__c = 1;
            serviceQuoteDetail.Discount__c = serviceQuote.Discount__c;
            serviceQuoteDetail.Service_Quote__c = serviceQuote.id;
            
            Decimal defaultPosition = 1;
            for( Service_Quote_Detail__c sqd : [SELECT Position__c FROM Service_Quote_Detail__c WHERE Service_Quote__c = :sqId] )
            {
                if( sqd.Position__c >= defaultPosition )
                    defaultPosition = sqd.Position__c +1;
            }
            
            serviceQuoteDetail.Position__c = defaultPosition;
            
        }  
    }
    
    
    public string ServicePartItemID { get; set; }
    public string ServicePartName { get; set; }
    
    public PageReference cancel() {
        return new PageReference('/' + serviceQuoteDetail.Service_Quote__c);
    }
    
    public PageReference save() {
        if( ServicePartItemID == null 
        || ServicePartItemID == '' )
        {
            ApexPages.addMessage(new Apexpages.Message( apexpages.Severity.ERROR, 'Error! You must select a service part item in order to continue.') );        
            return null;
        }
        

        serviceQuoteDetail.Service_Part__c = ServicePartItemID;

        if(serviceQuoteDetail.Id == null )
            insert serviceQuoteDetail;
        else update serviceQuoteDetail;

        return new PageReference('/' + serviceQuoteDetail.Service_Quote__c);

    }

}