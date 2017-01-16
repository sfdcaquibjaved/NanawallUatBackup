public class FetchingSalesRepsfromTerritories {
	

	public static set<string> getsalesreps(string regionname) {

		//Local Variables
		set < string > ownerNameset = new set < string > ();

			if (regionname == 'Eastern Sales') 
			{
                                        
                list < EasternSalesReps__c > eslist = EasternSalesReps__c.getall().values();
                  for (EasternSalesReps__c es: eslist) {
                        ownerNameset.add(es.name);
                       }
            } else if (regionname == 'Mid Eastern Sales') {
                                        
                list < MidEasternSalesReps__c > mslist = MidEasternSalesReps__c.getall().values();
                    for (MidEasternSalesReps__c es: mslist) {
                         ownerNameset.add(es.name);
                        }
            } else if (regionname == 'Midwest Sales') {
                                        
                list < MidWestSalesReps__c > lslist = MidWestSalesReps__c.getall().values();
                    for (MidWestSalesReps__c es: lslist) {
                        ownerNameset.add(es.name);
                        }
            } else if (regionname == 'Western Sales') {
                                        
                list < WesternSalesReps__c > kslist = WesternSalesReps__c.getall().values();
                    for (WesternSalesReps__c es: kslist) {
                        ownerNameset.add(es.name);
                        }
            } 

            return ownerNameset;	
	}
}