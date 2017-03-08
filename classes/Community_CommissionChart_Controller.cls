public with sharing class Community_CommissionChart_Controller {


	public string url {
		get 
		{
			string u = '/reps/apex/SalesCommissionChart';
			if(Network.getNetworkId() == null )
			{
				u = '/apex/SalesCommissionChart';
			}
			return u;
		}
		
		set;
	}

	public string networkid {
		get 
		{
			string u = Network.getNetworkId();
			return u;
		}
		
		set;
	}

}