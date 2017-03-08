public with sharing class ShowroomUtility {


	public static id GetShowroomByOwnerID(string ownerid) {
	
		/*non-us showrooms*/
		if( ownerid == '005A0000001BElBIAW')
		{
			return 'a0DA00000017Yp6MAE';
		} else if( ownerid == '005A0000000N1loIAC' )
		{
			return 'a0DA0000002wo6TMAQ';
		}// else if( ownerid == '005A0000000O65SIAS')
	//	{
	//		return 'a0DA0000008QNVoMAO';
		//}
		 else if( ownerid == '005A0000000N1loIAC' )
		{
			return 'a0DA0000002wo6TMAQ';
		} else if( ownerid == '005A0000000N1jsIAC' )
		{
			return 'a0DA0000008PjYpMAK';
		} else if( ownerid == '005A0000000N7poIAC' )
		{
			return 'a0DA0000002wo64MAA';
		} 
		else if( ownerid == '005A0000000N1mmIAC' )
		{
//005A0000000N1mmIAC  /  a0DA00000017YpEMAU
			//return 'a0DA00000017YpEMAU';
		}
		else if( ownerid == '005A0000000N1kvIAC' )
		{
//005A0000000N1kvIAC / a0DA00000017Yp9MAE
			return 'a0DA00000017Yp9MAE';
		}
		else if( ownerid == '005A0000000N1klIAC' )
		{
//005A0000000N1klIAC / a0DA00000017YpFMAU
			return 'a0DA00000017YpFMAU';
		}
		else if( ownerid == '005A0000000N1o4IAC' )
		{
//005A0000000N1o4IAC / a0DA00000017YpGMAU
			return 'a0DA00000017YpGMAU';
		}
		else if( ownerid == '005A0000000MOJqIAO' )
		{
//005A0000000MOJqIAO / a0DA00000017YozMAE
			return 'a0DA00000017YozMAE';
		}
		else if( ownerid == '005A0000000N1o4IAC' )
		{
//005A0000000N1o4IAC / a0DA00000017Yp3MAE
			return 'a0DA00000017Yp3MAE';
		}
		else if( ownerid == '005A0000000N1i8IAC' )
		{
//005A0000000N1i8IAC / a0DA00000017Yp8MAE
			return 'a0DA00000017Yp8MAE';
		}
		else if( ownerid == '005A0000000N1l5IAC' )
		{
//005A0000000N1l5IAC / a0DA00000017YpDMAU
			return 'a0DA00000017YpDMAU';
		}
		else if( ownerid == '005A0000000MOi1IAG' )
		{
//005A0000000MOi1IAG / a0DA00000017Yp0MAE
			return 'a0DA00000017Yp0MAE';
		}
		else if( ownerid == '005A0000000N1mcIAC' )
		{
//005A0000000N1mcIAC / a0DA00000017Yp5MAE
			return 'a0DA00000017Yp5MAE';
		}
//		else if( ownerid == '005A0000000N1mIIAS' )
//		{
//005A0000000N1mIIAS / a0DA00000017Yp7MAE
	//		return 'a0DA00000017Yp7MAE';
	//	}
		else if( ownerid == '005A0000001BElBIAW' )
		{
//005A0000001BElBIAW / a0DA00000017Yp6MAE
			return 'a0DA00000017Yp6MAE';
		}
		else if( ownerid == '005A0000000N1jLIAS' )
		{
//005A0000000N1jLIAS / a0DA00000017YoyMAE
			return 'a0DA00000017YoyMAE';
		}
		else if( ownerid == '005A0000000MOfjIAG' )
		{
//005A0000000MOfjIAG / a0DA00000017Yp2MAE
			return 'a0DA00000017Yp2MAE';
		}
		else if( ownerid == '005A0000000MOi7IAG' )
		{
//005A0000000MOi7IAG / a0DA0000002xZT2MAM
			return 'a0DA0000002xZT2MAM';
		}
		else if( ownerid == '005A0000001AyJMIA0' )
		{
//005A0000001AyJMIA0 / a0DA00000017YpCMAU
			return 'a0DA00000017YpCMAU';
		}
		else if( ownerid == '005A0000000N1kHIAS' )
		{
//005A0000000N1kHIAS / a0DA00000017Yp4MAE
			return 'a0DA00000017Yp4MAE';
		}
		else if( ownerid == '005A0000000N1nuIAC' )
		{
//005A0000000N1nuIAC / a0DA00000017YpAMAU
			return 'a0DA00000017YpAMAU';
		}
		else if( ownerid == '005A0000000MOhbIAG' )
		{
//005A0000000MOhbIAG / a0DA00000017YpBMAU 			
			return 'a0DA00000017YpBMAU';
		}
		/*us showrooms */
/*		

NOUSER / a0DA0000008QNVoMAO
NOUSER / a0DA00000017Yp1MAE
NOUSER / a0DA0000002wo6TMAQ
NOUSER / a0DA0000002wo64MAA
NOUSER / a0DA0000008PjYpMAK

*/		
		return null;
	}


    public static id GetShowroomByZip(string country2,string zip2)
	{
		if (zip2==null || country2==null)
			return null;
		string zip = zip2.toLowerCase();
		
		string subZip =zip;
		if( zip.length() > 5 )
			subzip = zip.substring(0, 5);
		
system.debug('showroom checkinf zip ' + subzip);		    	    
		string country = country2.toLowerCase();
		if (country=='mexico' || country=='mex')
		{
system.debug('its in mexico');			
			if (zip2 >= '21000' && zip <'24000')
				return 'a0DA00000017Yp6MAE'; //OK //matt galloro
			else
				return null; //none for 005A0000000N7pUIAS
		} else if( GetUserFromAddress.IsCaribbeanCountry(country))
		{
system.debug('its carib');			
			return null;
		} else if (country=='canada' || country=='can')
		{
system.debug('its in canada');			
		    if (zip.startsWith('v'))
		     {
		        if (zip.contains('v0a') ||
		            zip.contains('v0b') ||
		            zip.contains('v0e') ||
		            zip.contains('v0g') ||
		            zip.contains('v0h') ||
		            zip.contains('v1a') ||
		            zip.contains('v1b') ||
		            zip.contains('v1c') ||
		            zip.contains('v1e') ||
		            zip.contains('v1h') ||
		            zip.contains('v1l') ||
		            zip.contains('v1n') ||
		            zip.contains('v1p') ||
		            zip.contains('v1r') ||
		            zip.contains('v1s') ||
		            zip.contains('v1t') ||
		            zip.contains('v1v') ||
		            zip.contains('v1w') ||
		            zip.contains('v1x') ||
		            zip.contains('v1y') ||
		            zip.contains('v1z') ||
		            zip.contains('v2a') ||
		            zip.contains('v2b') ||
		            zip.contains('v2c') ||
		            zip.contains('v2e') ||
		            zip.contains('v2h') ||
		            zip.contains('v4t') ||
		            zip.contains('v4v'))
		        {
		            return 'a0DA0000002wo6TMAQ'; //OK
		        }
		  //      else
		  //      {
		   //         return 'a0DA0000008QNVoMAO'; //OK
		   //     }
		    }
		    else if (zip.startsWith('t') || zip.startsWith('r') || zip.startsWith('s'))
		    {
		        return 'a0DA0000002wo6TMAQ'; //OK
		    }
		    else if (zip.startsWith('j') || zip.startsWith('g') || zip.startsWith('h') || zip.startsWith('e') || zip.startsWith('a') || zip.startsWith('b') || zip.startsWith('c'))
		    {
		        return 'a0DA0000008PjYpMAK'; //OK
		    }
		    else if (zip.startsWith('x') || zip.startsWith('l') || zip.startsWith('p') || zip.startsWith('n') || zip.startsWith('m') || zip.startsWith('k'))
		    {
		        return 'a0DA0000002wo64MAA'; //OK
		    }          
		    return null;//005A0000000MOJpIAO - not found
		}
		else if (country != 'united states' && country !='usa')
			return null; //none for 005A0000000MOJpIAO
		else if (zip=='1')
		    return null; //none for 005A0000000M8piIAC
		else if (subzip>='00601' && subzip <='00908') 
		{
			
		    return 'a0DA0000002xZT2MAM'; //OK
		}
		else if (subzip>='01000' && subzip <='02799') 
		{
		    return null; //none for 005A0000000N1mXIAS
		}
		else if (subzip>='02800' && subzip <='02999') 
		{
		    return null; //none for 005A0000000N1mXIAS
		}
		else if (subzip>='03000' && subzip <='03899') 
		{
		    return null; //none for 005A0000000N1mXIAS
		}
		else if (subzip>='03900' && subzip <='04999') 
		{
		    return null; //none for 005A0000000N1mXIAS
		}
		else if (subzip>='05000' && subzip <='05999') 
		{
		    return null; //none for 005A0000000N1mXIAS
		}
		else if (subzip>='06000' && subzip <='06999') 
		{
		    return null; //none for 005A0000000N1mXIAS
		}
		else if (subzip>='07000' && subzip <='07699') 
		{
		    return 'a0DA00000017YpBMAU'; //OK
		}
		else if (subzip>='07700' && subzip <='07799') 
		{
		    return 'a0DA00000017YpBMAU'; //OK
		}
		else if (subzip>='07800' && subzip <='07999') 
		{
		    return 'a0DA00000017YpBMAU'; //OK
		}
		else if (subzip>='08000' && subzip <='08799') 
		{
		    return null; //none for 005A0000000N1jOIAS
		}
		else if (subzip>='08800' && subzip <='08999') 
		{
		    return 'a0DA00000017YpBMAU'; //OK
		}
		else if (subzip>='10000' && subzip <='11999') 
		{
		    return 'a0DA00000017YpBMAU'; //OK
		}
		else if (subzip>='12000' && subzip <='12399') 
		{
		    return 'a0DA00000017YpBMAU'; //OK
		}
		else if (subzip>='12400' && subzip <='12799') 
		{
		    return 'a0DA00000017YpBMAU'; //OK
		}
		else if (subzip>='12800' && subzip <='14999') 
		{
		    return 'a0DA00000017YpBMAU'; //OK
		}
		else if (subzip>='15000' && subzip <='16899') 
		{
		    return null;//'a0DA00000017YpEMAU'; //OK
		}
		else if (subzip>='16900' && subzip <='17199') 
		{
		    return null; //none for 005A0000000N1jOIAS
		} 
		else if (subzip>='17200' && subzip <='17299') 
		{
		 	return null;//   return 'a0DA00000017YpEMAU'; //OK
		}
		else if (subzip>='17300' && subzip <='19699') 
		{
		    return null; //none for 005A0000000N1jOIAS
		}
		else if (subzip>='19700' && subzip <='19999') 
		{
		    return 'a0DA00000017YpFMAU'; //OK
		}
		else if (subzip>='20000' && subzip <='21999') 
		{
		    return 'a0DA00000017YpFMAU'; //OK
		}
		else if (subzip>='22000' && subzip <='24699') 
		{
		    return 'a0DA00000017YpFMAU'; //OK
		}
		else if (subzip>='24700' && subzip <='26899') 
		{
		    return 'a0DA00000017YpFMAU'; //OK
		}
		else if (subzip>='27000' && subzip <='28999') 
		{
		    return null; //none for 005A0000000N1j5IAC
		}
		else if (subzip>='29000' && subzip <='29999') 
		{
		    return null; //none for 005A0000000N1j5IAC
		}
		else if (subzip>='30000' && subzip <='31999') 
		{
		    return 'a0DA00000017Yp5MAE'; //OK
		}
		else if (subzip>='32000' && subzip <='32299') 
		{
		    return 'a0DA0000002xZT2MAM'; //OK//walker
		}
		else if (subzip>='32300' && subzip <='32399') 
		{
		    return 'a0DA00000017Yp8MAE'; //OK//wingate
		}
		else if (subzip>='32400' && subzip <='32599') 
		{
		    return null; //none for '005A0000000N1lPIAS';
		}
		else if (subzip>='32600' && subzip <='32699') 
		{
		    return 'a0DA00000017Yp8MAE'; //OK
		}
		else if (subzip>='32700' && subzip <='32959') 
		{
		    return 'a0DA0000002xZT2MAM'; //OK //ron walker
		}
		else if (subzip>='32960' && subzip <='32971') 
		{
		    return null; //none for '005A0000000N1j6IAC';
		}
		else if (subzip>='32972' && subzip <='32999') 
		{
		    return 'a0DA0000002xZT2MAM'; //OK
		}
		else if (subzip>='33000' && subzip <='33499') 
		{
		    return null; //none for '005A0000000N1j6IAC';
		}
		else if (subzip>='33500' && subzip <='33899') 
		{
		    return 'a0DA00000017Yp8MAE'; //OK
		}
		else if (subzip>='33900' && subzip <='33999') 
		{
		    return null; //none for '005A0000000N1j6IAC';
		}
		else if (subzip>='34000' && subzip <='34100') 
		{
		    return null; //none for 005A0000000MOItIAO
		}
		else if (subzip>='34100' && subzip <='34199') 
		{
		    return null; //none for '005A0000000N1j6IAC';
		}
		else if (subzip>='34200' && subzip <='34299') 
		{
		    return 'a0DA00000017Yp8MAE'; //OK //robert wingate
		}
		else if (subzip>='34300' && subzip <='34399') 
		{
		    return null; //none for 005A0000000MOItIAO
		}
		else if (subzip>='34400' && subzip <='34499') 
		{
		    return 'a0DA00000017Yp8MAE'; //OK
		}
		else if (subzip>='34600' && subzip <='34699') 
		{
		    return 'a0DA00000017Yp8MAE'; //OK
		}
		else if (subzip>='34700' && subzip <='34799') 
		{
		    return 'a0DA0000002xZT2MAM'; //OK
		}
		else if (subzip>='34900' && subzip <='34999') 
		{
		    return null; //none for '005A0000000N1j6IAC';
		}
		else if (subzip>='35000' && subzip <='36499') 
		{
		    return null; //none for '005A0000000N1lPIAS';
		}
		else if (subzip>='36500' && subzip <='36699') 
		{
		    return 'a0DA00000017Yp0MAE';//OK
		}
		else if (subzip>='36700' && subzip <='36999') 
		{
		    return null; //none for '005A0000000N1lPIAS';
		}
		else if (subzip>='37000' && subzip <='37299') 
		{
		    return null; //none for '005A0000000N2nHIAS';
		}
		else if (subzip>='37300' && subzip <='37499') 
		{
		    return null; //none for '005A0000000N1lPIAS';
		}
		else if (subzip>='37500' && subzip <='37599') 
		{
		    return null; //none for '005A0000000N2nHIAS';
		}
		else if (subzip>='37600' && subzip <='37999') 
		{
		    return null; //none for '005A0000000N1lPIAS';
		}
		else if (subzip>='38000' && subzip <='38599') 
		{
		    return null; //none for '005A0000000N2nHIAS';
		}
		else if (subzip>='38600' && subzip <='38999') 
		{
		    return null; //none for '005A0000000N2nHIAS';
		}
		else if (subzip>='39000' && subzip <='39699') 
		{
		    return 'a0DA00000017Yp0MAE';//OK
		}
		else if (subzip>='39700' && subzip <='39799') 
		{
		    return null; //none for '005A0000000N2nHIAS';
		}
		else if (subzip >='39801' && subzip <='39999')
		{
			return 'a0DA00000017Yp5MAE'; //OK
		}
		else if (subzip>='40000' && subzip <='42799') 
		{
			return null;//    return 'a0DA00000017YpEMAU'; //OK
		}
		else if (subzip>='43000' && subzip <='43299') 
		{
			return null;//    return 'a0DA00000017YpEMAU'; //OK
		}
		else if (subzip>='43300' && subzip <='43699') 
		{
		    return 'a0DA00000017YpGMAU'; //OK
		}
		else if (subzip>='43700' && subzip <='43999') 
		{
			return null;//    return 'a0DA00000017YpEMAU'; //OK
		}
		else if (subzip>='44000' && subzip <='44599') 
		{
		    return 'a0DA00000017YpGMAU'; //OK
		}
		else if (subzip>='44600' && subzip <='44799') 
		{
		    return 'a0DA00000017YpGMAU'; //OK
		}
		else if (subzip>='44800' && subzip <='44999') 
		{
		    return 'a0DA00000017YpGMAU'; //OK
		}
		else if (subzip>='45000' && subzip <='45799') 
		{
			return null;//    return 'a0DA00000017YpEMAU'; //OK
		}
		else if (subzip>='45800' && subzip <='45899') 
		{
		    return 'a0DA00000017YpGMAU'; //OK
		}
		else if (subzip>='46000' && subzip <='47999') 
		{
		    return 'a0DA00000017YpGMAU'; //OK  //paul nalette
		}
		else if (subzip>='48000' && subzip <='48999') 
		{
		    return 'a0DA00000017YoyMAE'; // OK
		}
		else if (subzip>='49000' && subzip <='49199') 
		{
		    return 'a0DA00000017YoyMAE'; // OK
		}
		else if (subzip>='49200' && subzip <='49299') 
		{
		    return 'a0DA00000017YoyMAE'; // OK
		}
		else if (subzip>='49300' && subzip <='49599') 
		{
		    return 'a0DA00000017YoyMAE'; // OK
		}
		else if (subzip>='49600' && subzip <='49999') 
		{
		    return 'a0DA00000017YoyMAE'; // OK
		}
	//	else if (subzip>='50000' && subzip <='52999') 
	//	{
	//	    return 'a0DA00000017Yp7MAE'; //OK
	//	}
		else if (subzip>='53000' && subzip <='53999') 
		{
		    return 'a0DA00000017Yp9MAE'; //OK
		}
		else if (subzip>='54000' && subzip <='54099') 
		{
		    return null; //'005A0000000PaleIAC'; does not exist in zip lookup
		}
		else if (subzip>='54100' && subzip <='54599') 
		{
		    return 'a0DA00000017Yp9MAE'; //OK
		}
		else if (subzip>='54600' && subzip <='54899') 
		{
		    return null; //'005A0000000PaleIAC'; does not exist in zip lookup
		}
		else if (subzip>='54900' && subzip <='54999') 
		{
		    return 'a0DA00000017Yp9MAE'; //OK
		}
		else if (subzip>='55000' && subzip <='56999') 
		{
		    return null; //'005A0000000PaleIAC'; does not exist in zip lookup
		}
		else if (subzip>='57000' && subzip <='57999') 
		{
		    return null; //'005A0000000PaleIAC'; does not exist in zip lookup
		}
		else if (subzip>='58000' && subzip <='58999') 
		{
		    return null; //'005A0000000PaleIAC'; does not exist in zip lookup
		}
		else if (subzip>='59000' && subzip <='59399') 
		{
		    return 'a0DA00000017YozMAE'; // OK
		}
		else if (subzip>='59400' && subzip <='59499') 
		{
		    return 'a0DA00000017Yp2MAE'; //OK
		}
		else if (subzip>='59500' && subzip <='59599') 
		{
		    return 'a0DA00000017YozMAE'; // OK
		}
		else if (subzip>='59600' && subzip <='59999') 
		{
		    return 'a0DA00000017Yp2MAE'; //OK
		}
		else if (subzip>='60000' && subzip <='61999') 
		{
		    return 'a0DA00000017Yp9MAE'; //OK
		}
//		else if (subzip>='62000' && subzip <='62999') 
//		{
//		    return 'a0DA00000017Yp7MAE'; //OK
//		}
	//	else if (subzip>='63000' && subzip <='65999') 
//		{
	//	    return 'a0DA00000017Yp7MAE'; //OK
//		}
	//	else if (subzip>='66000' && subzip <='67999') 
	//	{
	//	    return 'a0DA00000017Yp7MAE'; //OK
	//	}
	//	else if (subzip>='68000' && subzip <='68999') 
	//	{
	//	    return 'a0DA00000017Yp7MAE'; //OK
	//	}
	//	else if (subzip>='69000' && subzip <='69399') 
	//	{
	//	    return 'a0DA00000017Yp7MAE'; //OK
	//	}
		else if (subzip>='70000' && subzip <='71599') 
		{
		    return 'a0DA00000017Yp0MAE';//OK
		}
		else if (subzip>='71600' && subzip <='72999') 
		{
		    return null; //none for '005A0000000N2nHIAS';
		}
		else if (subzip>='73000' && subzip <='74999') 
		{
		    return 'a0DA00000017Yp4MAE'; //OK
		}
		else if (subzip>='75000' && subzip <='76499') 
		{
		    return 'a0DA00000017Yp4MAE'; //OK
		}           
		else if (subzip >='76500' && subzip <='76599')
		{
			return null;//005A0000000O0zyIAC is not even in the zip lookups
		}
		else if (subzip>='76600' && subzip <='76799') 
		{
		    return 'a0DA00000017Yp4MAE'; //OK
		}  
		else if (subzip >='76800' && subzip <='76999')
		{
			return null;//005A0000000O0zyIAC is not even in the zip lookups
		}
		else if (subzip>='77000' && subzip <='77999') 
		{
		    return 'a0DA00000017Yp0MAE';//OK
		}
		else if (subzip >='78000' && subzip <='78299')
		{
			return null;//005A0000000O0zyIAC is not even in the zip lookups
		}
		else if (subzip>='78300' && subzip <='78599') 
		{
		    return 'a0DA00000017Yp0MAE';//OK
		}
		else if (subzip >='78600' && subzip <='78999')
		{
			return null;//005A0000000O0zyIAC is not even in the zip lookups
		}
		
		else if (subzip>='79000' && subzip <='79699') 
		{
		    return 'a0DA00000017Yp4MAE'; //OK
		}
		else if (subzip >='79700' && subzip <='79999')
		{
			return null;//005A0000000O0zyIAC is not even in the zip lookups
		}
		else if (subzip>='80000' && subzip <='83199') 
		{
		    return 'a0DA00000017YozMAE'; // OK
		}
		else if (subzip>='83200' && subzip <='83899') 
		{
		    return 'a0DA00000017Yp2MAE'; //OK
		}
		else if (subzip>='83200' && subzip <='83999') 
		{
		    return 'a0DA00000017Yp2MAE'; //OK
		}
		else if (subzip>='84000' && subzip <='84799') 
		{
		    return 'a0DA00000017YpAMAU'; // OK
		}
		else if (subzip>='85000' && subzip <='86599') 
		{
		    return 'a0DA00000017YpCMAU'; //OK //tracy carpenter az
		}
		else if (subzip=='88901' || subzip =='88905') 
		{
		    return 'a0DA00000017YpCMAU'; //OK 
		}
		else if (subzip>='87000' && subzip <='88999') 
		{
		    return 'a0DA00000017YozMAE'; // OK
		}
		else if (subzip>='89000' && subzip <='89199') 
		{
		
		    return 'a0DA00000017YpCMAU'; //OK 
		}
		else if (subzip>='89300' && subzip <='89899') 
		{
		    return 'a0DA00000017YpDMAU'; //OK
		}
		else if (subzip>='90000' && subzip <='93599') 
		{
		    return 'a0DA00000017Yp6MAE'; //OK
		}
		else if (subzip>='93600' && subzip <='96199') 
		{
		    return 'a0DA00000017YpDMAU'; //OK
		}
		else if (subzip>='96700' && subzip <='99999') 
		{
		    return 'a0DA00000017Yp2MAE'; //OK
		} else if( zip == 'TEST' || zip == 'test' ) 
			return GlobalStrings.DefaultShowroom(); //need for unit tests
		else
			return GlobalStrings.DefaultShowroom(); //this is for sandbox testing
	}
}