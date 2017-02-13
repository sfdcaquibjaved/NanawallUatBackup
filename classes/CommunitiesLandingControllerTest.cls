/**
 * An apex page controller that takes the user to the right start page based on credentials or lack thereof
 */
@IsTest 
public with sharing class CommunitiesLandingControllerTest {
  
    static testmethod void testCommunitiesLandingController() {
        
   // PageReference pageRef = Page.communitiesLanding;
   // Test.setCurrentPage(pageRef);

        // Instantiate a new controller with all parameters in the page
        CommunitiesLandingController controller = new CommunitiesLandingController();
        controller.forwardToStartPage();
      }
}