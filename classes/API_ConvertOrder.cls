global with sharing class API_ConvertOrder {

   //Define an object in apex that is exposed in apex web service
   global class InputData {
      webservice String SFQuoteID;
   }

   webservice static void doConvert(InputData Input) {
       
        Map<String, Object> params = new Map<String, Object>();
        params.put('QuoteID', Input.SFQuoteID); 
        system.debug('ParamsData'+params);    
        Flow.Interview.Quote_to_Order convertFlow = new Flow.Interview.Quote_to_Order(params);
        convertFlow.start();
       

		Order thisorder = null;       
        for ( Order o :  [SELECT Id, Status FROM Order WHERE QuoteID = :Input.SFQuoteID] )
        {
            thisorder = o;
            break;
        } 

		if( thisorder != null )
		{
			//need to comment out for the backfill 
			thisorder.Status = 'Order Created';
			update thisorder;
		}
		
       return;
  }
  
    
}