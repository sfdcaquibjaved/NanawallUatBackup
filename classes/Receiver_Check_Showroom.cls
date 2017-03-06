global with sharing class Receiver_Check_Showroom {

webservice static void UpdateDistanceShowroom(string contactid,string showroomid)
{
	try
	{
	Contact c = [select id,refresh_showroom__c from contact where id =:contactid];
	c.refresh_showroom__c=false;
	if (showroomid=='')
		c.showroom__c=null;
	else
		c.showroom__c = showroomid;
	update(c);
	}
	catch (Exception ex)
	{
		Utility.JimDebug(ex, 'update distance showroom');
	}
}

}