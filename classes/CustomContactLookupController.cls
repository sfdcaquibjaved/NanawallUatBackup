public with sharing class CustomContactLookupController {

  public Contact contact {get;set;} // new Contact to create
    public COntact ContactInfo {get;set;}
  public List<Contact> results{get;set;} // search results
  public string searchString{get;set;} // search keyword

  public CustomContactLookupController() {
    contact = new contact();
    // get the current search string
    searchString = System.currentPageReference().getParameters().get('lksrch');
    runSearch();  
  }

  // performs the keyword search
  public PageReference search() {
    runSearch();
    return null;
  }

  // prepare the query and issue the search command
  @TestVisible
  private void runSearch() {
    // TODO prepare query string for complex serarches & prevent injections
    results = performSearch(searchString);               
  } 

  // run the search and return the records found. 
  @TestVisible
  private List<contact> performSearch(string searchString) {

    String soql = 'select id, name , AccountId ,Account.Name, email from contact';
    if(searchString != '' && searchString != null)
      soql = soql +  ' where name  LIKE \'%' + searchString +'%\'';
    soql = soql + ' limit 25';
    System.debug(soql);
    return database.query(soql); 

  }

  // save the new contact record
  public PageReference saveContact() {
    insert contact;
   
      // reset the contact
    PageReference exitWindow = new PageReference('/apex/exitPage'); 
     exitWindow.setRedirect(false);
    return exitWindow;
    
  }

  // used by the visualforce page to send the link to the right dom element
  public string getFormTag() {
    return System.currentPageReference().getParameters().get('frm');
  }

  // used by the visualforce page to send the link to the right dom element for the text box
  public string getTextBox() {
    return System.currentPageReference().getParameters().get('txt');
  }
    //Exit after contact creation
    public PageReference exitAction(){
         if(contact.lastname !=null){
    	 ContactInfo=[select id,name from contact where lastname =:contact.lastname and firstname =:contact.firstname limit 1];}
		 return null;
  }
    
    

}