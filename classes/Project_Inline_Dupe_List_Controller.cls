public with sharing class Project_Inline_Dupe_List_Controller
{
    private final sObject primaryRecord;
    public List<DupeData> dupes { get; set; }
    
    /*********************************************************************/
    /* Change the "project__c" class below to the API name of the    */
    /* custom object you're adding support for.  There are two instances */
    /* that have to be changed within the DupeData class.                */
    /*********************************************************************/
    public class DupeData
    {
        public project__c dupeRecord { get; set; }
        public CRMfusionDBR101__Potential_Duplicate__c potDupe { get; set; }
        
        public DupeData( sObject dupeRecord, CRMfusionDBR101__Potential_Duplicate__c  potDupe )
        {
            this.dupeRecord = (project__c)dupeRecord;
            this.potDupe = potDupe;
        }
    }
        
    // The extension constructor initializes the private member
    // variable acct by using the getRecord method from the standard
    // controller.
    /*****************************************************************************/
    /* The name of this method (the constructor) must be the same as the name of */
    /* this Apex class.  You must also replace "project__c" below with the   */
    /* API name of the custom object you're modifying this class for.            */
    /*****************************************************************************/
    public Project_Inline_Dupe_List_Controller( ApexPages.StandardController stdController )
    {
        this.primaryRecord = stdController.getRecord();
        loadDupes();
    }
    
    private void loadDupes()
    {
        this.dupes = new List<DupeData>();
    
        // Find all warnings related to this object.
        // Limit to 200 dupes for now.
        Set<Id> warnings = new Set<Id>();
        for ( CRMfusionDBR101__Potential_Duplicate__c potDupe : [SELECT CRMfusionDBR101__Duplicate_Warning__c
              FROM CRMfusionDBR101__Potential_Duplicate__c
              WHERE CRMfusionDBR101__Generic_Object__c = :primaryRecord.id
              AND CRMfusionDBR101__Duplicate_Warning__c != null] )
              warnings.add( potDupe.CRMfusionDBR101__Duplicate_Warning__c );
        
        // If we found no warning, exit.
        if ( warnings == null || warnings.isEmpty() )
            return;
        
        // Load the potential duplicate, warning and scenario data needed for display and
        // cache the object Ids we need to load for object data.
        // Only store the first potential duplicate record for a given duplicate object so we're
        // not displaying the same record in the dupes list multiple times.
        Map<Id, CRMfusionDBR101__Potential_Duplicate__c> potDupes = new Map<Id, CRMfusionDBR101__Potential_Duplicate__c>();
        for ( CRMfusionDBR101__Potential_Duplicate__c dupe : [SELECT CRMfusionDBR101__Generic_Object__c,
              CRMfusionDBR101__Duplicate_Warning__c, CRMfusionDBR101__Duplicate_Warning__r.Name,
              CRMfusionDBR101__Scenario__c, CRMfusionDBR101__Scenario__r.Name
              FROM CRMfusionDBR101__Potential_Duplicate__c 
              WHERE CRMfusionDBR101__Duplicate_Warning__c IN :warnings AND
              CRMfusionDBR101__Generic_Object__c != null
              AND CRMfusionDBR101__Generic_Object__c != :primaryRecord.id
              ORDER BY CRMfusionDBR101__Duplicate_Warning__r.Name DESC, CreatedDate DESC  LIMIT 200] )
        {
            if ( !potDupes.containsKey( dupe.CRMfusionDBR101__Generic_Object__c  ) )
                potDupes.put( dupe.CRMfusionDBR101__Generic_Object__c, dupe );
        }
        
        // Load display data for the duplicate records we've found and store it in our dupes list along
        // with the related potential duplicate record.
        /*****************************************************************************/
        /* MODIFY THIS SECTION TO ADD/REMOVE FIELDS RELATED TO THE PRIMARY OBJECT    */
        /* TO QUERY FOR DISPLAY ON THE PAGE.                                         */
        /* For supporting other custom objects you'll need to modify the SOQL and    */
        /* change the "project__c" to the API name of the custom object needed.  */
        /* Also, ensure all selected fields exist and are accessible on the new      */
        /* custom object.                                                            */
        /*****************************************************************************/
        for ( sObject record : [SELECT Id, Name, OwnerId, Owner.Name FROM project__c WHERE Id IN :potDupes.keySet()] )
            this.dupes.add( new DupeData( record, potDupes.get( record.Id ) ) );
    }
}