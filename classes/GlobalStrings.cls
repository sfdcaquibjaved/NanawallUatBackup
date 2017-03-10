public with sharing class GlobalStrings {
    public static string HostName() { return 'cs3.salesforce.com'; }
    public static string NanaServerAddress() { return '66.209.91.78'; } 
    public static string RequiredProfileIDForSharePool() { return '00eA0000000Qn2V'; }
    public static string CatchallUserIDForAssignment() { return '005A0000000M8pi';  }
    public static string QuoteEmailTemplateID() { return '00XA0000000IFUt';  }
    public static string QuoteEmailTemplateName() { return 'Quote_Template_DO_NOT_DELETE';  }
    public static string RepQuoteEmailTemplateName() { return 'Rep_Quote_Template_DO_NOT_DELETE';  }
    
    
    public static string NDGEmailEmailTemplateID() { return '00XA0000001hyeb';  }
        public static string NDGPublicEmailTemplateName() { return 'NDG_Public_Template_DO_NOT_DELETE';  }
    
	public static string NewSaleTeamMemberLink( string id ) { 
		  return '/apex/nrOppTeamMemberNew?CF00NA0000001O58B=OPPNAME&CF00NA0000001O58B_lkid='+id+'&scontrolCaching=1&retURL=%2Fapex%2FnrOpportunityView%3Fid%3D'+id+'%26sfdc.override%3D1%26core.apexpages.devmode.url%3D1&sfdc.override=1';
		//return '/apex/nrOppTeamMemberNew?CF00NA0000001O58B=OPPNAME&CF00NA0000001O58B_lkid='+id+'&scontrolCaching=1&retURL=/apex/nrOpportunityView%3Fid%3D'+id+'%26sfdc.override%3D1&sfdc.override=1'; 
	}
	public static string CaribbeanUserID() { return '005A0000000MOi7IAG'; }
	
	public static string DefaultOrgWideEmailAddressID() { return '0D2A0000000TNDL'; }
	
	public static string MailBookResponsibleRep() { return '005A0000004v12H'; } //005A0000004v12H
	
	public static string DefaultShowroom() { return ''; }
	
}