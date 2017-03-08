public with sharing class Contact_Check_Showroom {
    private final Contact c;
    public Contact_Check_Showroom(ApexPages.StandardController stdController) {
        this.c = (Contact)stdController.getRecord();
    }

	public string getOutput() {
		string output='';
		if( c.Refresh_Showroom__C )
		{
			output='Updating ..,';
		}				
		else
		{
			output = c.ShowroomInfo__c;
		}
		
		return output;
		
	}
}