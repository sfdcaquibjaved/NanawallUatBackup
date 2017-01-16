public with sharing class Dispatcher_Edit_Controller {

    private final ApexPages.StandardController controller;
	public Dispatcher_Edit_Controller(ApexPages.StandardController controller) {
		this.controller = controller;
    }
 
    public PageReference getRedir() {
        PageReference newPage;
///* comment out the old code
        if ( Apexpages.currentPage().getParameters().get('finished') != null )
        {        
        	 
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,  'I was not able to redirect you correctly. My apologies.' ));		
			//PERFORM THE SYNC HERE!
			/*
			try {
				
				if( string.valueof( this.controller.getrecord().getSObjectType() ) == 'Contact' )
				{ 

					Contact c = (Contact)this.controller.getrecord();
					WebServiceCaller_200909.CallContactWebService(c.id);
					c.IsDirty__c = false;
					c.SyncInProgress__c = true;
			        update c;

				} else if( string.valueof( this.controller.getrecord().getSObjectType() ) == 'Opportunity' )
				{

					Opportunity o  = (Opportunity)this.controller.getrecord();
					if( !o.is_a_dupe__c )
					{
						WebServiceCaller_200909.CallOpportunityWebService(o.id, false);
						o.IsDirty__c = false;
						o.SyncInProgress__c = true;
				        update o;
					}			

				} else if( string.valueof( this.controller.getrecord().getSObjectType() ) == 'Account' )
				{

					Account a = (Account)this.controller.getrecord();
		            WebServiceCaller_200909.CallAccountWebService(a.id);
		            a.IsDirty__c = false;
		            a.SyncInProgress__c = true;
		            update a;

//throw new ResyncManager.ResyncException('test exception to generate the resync code');
				
				}
				
			} catch( Exception e )
			{
				Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
				String[] toAddresses = new String[] {'kristian.stout@a-stechnologies.com'}; 
				mail.setToAddresses( toAddresses );
				mail.setReplyTo('admin@a-stechnologies.com');   
				mail.setSenderDisplayName('Salesforce - Nana Sync Department');
				mail.setSubject('An exception occurred when syncing a(n) '+string.valueof( this.controller.getrecord().getSObjectType() )+ '  in the dispatcher.' );
				mail.setBccSender(false);
				mail.setUseSignature(false);
				mail.setPlainTextBody(' An exception occurred when syncing: ' + this.controller.getrecord().Id +  '  ; <br /> ' + e   );
				mail.setHtmlBody('An exception occurred when syncing an opportunity in the view controller. ' + this.controller.getrecord().id + '<br /> ' +e );
				Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });           

				//this tells the system to queue the resync for the next pass of the resync'er
				ResyncManager_20100910.QueueResync(string.valueof( this.controller.getrecord().getSObjectType() ), this.controller.getrecord().id );
				
			}
			*/
//			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,  'type: ' + this.controller.getrecord().getSObjectType() ));		
	
			string redirURL = Apexpages.currentPage().getParameters().get('oldRedir');
			if( redirURL != null )
			{
				newPage = new Pagereference(  Encodingutil.base64Decode(redirURL).toString() );
			} else
			{
				newPage = new PageReference( '/' + this.controller.getrecord().id  );
			}
        } else
        {
	        
	        if( string.valueof( this.controller.getrecord().getSObjectType() ) == 'Quote_Detail__c'  )
	        {
	        	Quote_Detail__c qd = (Quote_Detail__c)this.controller.getRecord();
	        	Quote__c q = [SELECT id, Quote_ID__c FROM Quote__c WHERE id = :qd.quote__c ];

//		        //redirect to position builder
//		        newPage = new PageReference('/apex/PositionBuilder?SFQuoteID='+q.id+'&QuoteID=' + q.quote_id__c + '&QuoteDetailID=' + qd.quote_detail_id__c  );

		        //redirect to position builder
		        newPage = new PageReference('/apex/PositionEditor?SFQuoteID='+q.id+'&QuoteID=' + q.quote_id__c + '&QuoteDetailID=' + qd.quote_detail_id__c  );
	        	
	        } else 
	        {
		        //redirect to normal edit page
		        newPage = new PageReference('/' + this.controller.getrecord().id + '/e' );
				newPage.getParameters().put('nooverride', '1');
				//note the lame string of Sobjecttype below -- gotta name the VForce page    Dispatcher_{SOBJECTYPE}Edit for this code to work. sorry - ks
		        newPage.getParameters().put('retURL', Encodingutil.urlEncode( '/apex/Dispatcher_'+this.controller.getrecord().getSObjectType()+'Edit?id=' + this.controller.getrecord().id + '&finished=true&oldRedir=' + Encodingutil.base64Encode( blob.valueof(Apexpages.currentPage().getParameters().get('retURL'))) , 'UTF-8') );
	        }
        }
	
		return newPage;
    }
 

}