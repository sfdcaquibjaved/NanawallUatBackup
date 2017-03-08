public with sharing class Quote_CaseComment_Controller {

	public string BaseUrl{ 
		get { return GlobalStrings.HostName(); }
		set;
	}
	public string CloseID {
		get;
		set;
	}

	
	public class CaseWrapper implements Comparable {
	
		public string Id { get; set; }
		public string CaseNumber { get; set; }
		public string Subject { get; set; }
		public Datetime CreatedDate { get; set; }
		public string Priority { get; set; }

		public string ServiceQuoteList { get; set; }		
		
		public string Type { get; set; }		
		public string Status { get; set; }
		public string ContactName { get; set; }
		
		public string CaseComment_Body { get; set; }
		public string CaseComment_DateTime { get; set; }
		
		
		
		public Integer compareTo(Object compareTo) {
    
			CaseWrapper compareToCase = (CaseWrapper)compareTo;
        
	        // The return value of 0 indicates that both elements are equal. 
			Integer returnValue = 0;
			if (CreatedDate > compareToCase.CreatedDate) {
	        	// Set return value to a positive value. 
				returnValue = -1;
			} else if (CreatedDate < compareToCase.CreatedDate) {
		        // Set return value to a negative value. 
				returnValue = 1;
			}
			return returnValue;       
		}		
	}
	

	public list<Case> getCases2()
	{
		return [SELECT c.Id, c.CaseNumber, c.Subject, c.CreatedDate, c.Priority, c.Quote__c, c.Type, c.Status, c.Contact.FirstName, c.Contact.LastName, (SELECT Id, CommentBody, CreatedDate FROM Case.CaseComments) FROM Case c WHERE c.Quote__c = :this.q.Id ORDER BY CreatedDate DESC];
	}

	public list<CaseWrapper> getCases() {



	
		map<Id, CaseWrapper> cases = new map<Id,CaseWrapper>();
		for( Case c : [SELECT c.Id, c.CaseNumber, c.Subject, c.CreatedDate, c.Priority, c.Quote__c, c.Type, c.Status, c.Contact.FirstName, c.Contact.LastName, (SELECT Id, CommentBody, CreatedDate FROM Case.CaseComments ORDER BY CreatedDate DESC) FROM Case c WHERE c.Quote__c = :this.q.Id ORDER BY CreatedDate DESC] )
		{
			
			CaseWrapper caseWrapper = new CaseWrapper();
			caseWrapper.Id = c.Id;
			caseWrapper.CaseNumber = c.CaseNumber;
			caseWrapper.Subject = c.Subject;
			caseWrapper.CreatedDate = c.CreatedDate;
			caseWrapper.Priority = c.Priority;
			caseWrapper.ServiceQuoteList = '';
			caseWrapper.Type = c.Type;
			caseWrapper.Status = c.Status;
			if( c.Contact != null)
				caseWrapper.ContactName = c.Contact.FirstName + ' ' + c.Contact.LastName;
			
			cases.put( c.Id, caseWrapper);
		}
				
		for( Service_Quote__c sq : [SELECT Id, Name, Case__c FROM Service_Quote__c WHERE Case__c in :cases.keySet() ] )
		{
//, Name			sq.Name;
			cases.get(sq.Case__c).ServiceQuoteList += ( cases.get(sq.Case__c).ServiceQuoteList != null && cases.get(sq.Case__c).ServiceQuoteList != '' ? ', ' : '') + '<a href="javascript:redirectToServiceQuote(\''+sq.Id+'\')">' + sq.Name + '</a>';
		}
		
		list<CaseWrapper> caseList = cases.values();
		caseList.sort();
		
		return caseList;
	}



    private final Quote__c q;
    public Quote_CaseComment_Controller(ApexPages.StandardController stdController) {
        this.q = (Quote__c)stdController.getRecord();
    }


}