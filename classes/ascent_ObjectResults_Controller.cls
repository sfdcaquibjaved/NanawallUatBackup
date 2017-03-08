public with sharing class ascent_ObjectResults_Controller {

	public list<Project__c> getProjects()
	{
//		return [SELECT id, Name FROM Project__c WHERE Id != :this.proj.Id];
		list<Project__c> projs = new list<Project__c>();
		
		return projs;
	}
	
	public List<ChartData> getChartData() {

		/*
			"ascent_history__c":[ { "date": "9/14/2015", "value": 1},{ "date": "9/7/2015", "value": 1},{ "date": "9/1/2015", "value": 2},{ "date": "8/24/2015", "value": 3} ]
		*/
        List<ChartData> data = new List<ChartData>();
		

		Project__c p = [SELECT id, Ascent_history__c FROM Project__c WHERE id = :this.proj.id];
		if( p.Ascent_history__c == null || p.Ascent_History__c == '' )
			return data;

		JSONParser parser = JSON.createParser( p.ascent_history__c);
		date d  = null;
		string v = null;
		map<Date, string> dateValues = new map<Date,string>();
		while (parser.nextToken() != null) 
		{
		
			if(parser.getCurrentToken() == JSONToken.START_OBJECT)
		    {
		  		while(parser.nextToken() != null)
		        {
		  			if(parser.getCurrentToken() == JSONToken.FIELD_NAME)
		            {
		                if(parser.getText() == 'date')
		                {
							parser.nextToken();
//		                    d = parser.getDateValue();
							d = Date.parse( parser.getText());
		                    //this.start.gDateTime = parser.getDateTimeValue()                    
							system.debug('date: ' + d );
		  				} else if( parser.getText() == 'value')
		                {
		                    parser.nextToken();
		                    v = parser.getText();
		                    system.debug('value: ' + parser.getText() );
		                }
		  			} else //if( parser.getCurrentToken() == JSONToken.END_OBJECT)
		            {
		            	dateValues.put(d,v);
		            	d = null;
		            	v = null;
		                break; //no more fields in the object
		            }
		  		}
		  	} 
		    //else system.debug( 'No Match: ' + parser.getText() );
		
		}
		
		for( Date da : dateValues.keySet() )
		{
	        data.add(new ChartData( da.format(), da.format(),  Integer.valueOf(  dateValues.get(da) )  ));			
		}

/*
		for( integer i=0; i<30; i++ )
		{
	        data.add(new ChartData('Day ' + i, i,  Integer.valueOf(   Math.round(5*Math.random()) )  ));
		}
*/
        return data;
    }

	public string StarsRank { get; set; }

    // Wrapper class
    public class ChartData {

        public String name { get; set; }
        public String day { get; set; }
        public Integer value { get; set; }
        public Integer invertedvalue { get; set; }

        public ChartData(String name, String day, Integer value) {
            this.name = name;
            this.day = day;
            this.value = value;
            if( value == 1 ) this.invertedvalue = 3;
            else if( value == 2 ) this.invertedvalue = 2;
            else if( value == 3 ) this.invertedvalue = 1;
            else this.invertedvalue = 0;
        }
    }
    
    private final Project__c proj;
	public  ascent_ObjectResults_Controller(ApexPages.StandardController stdController)
	{

        this.proj = (Project__c)stdController.getRecord();    

		// ascent_rank ; rank 1 = 3 stars, rank 2 = 2 stars, rank 3 = 1

		if( this.proj.ascent_rank__c == 1 )
		{
			StarsRank  = '<i class="fa fa-star"></i><i class="fa fa-star"></i><i class="fa fa-star"></i>';
		} else if( this.proj.ascent_rank__c == 2 )
		{
			StarsRank  = '<i class="fa fa-star"></i><i class="fa fa-star"></i>';		
		} else if( this.proj.ascent_rank__c == 3)
		{
			StarsRank  = '<i class="fa fa-star"></i>';				
		} else StarsRank = '';

		system.debug( ApexPages.currentPage().getParameters() );
		
	}

}