/*************************************************************************
    @ Author        : Absyz Software Consulting Pvt. Ltd.
    @ Date          : August-2016
    @ Description   : This class serves the pupose of code coverage of LightningForgotPasswordController class
    @ Audit Trial   : 
    @ Last Modified Date :
  
****************************************************************************/
@isTest(SeeAllData = false)

public class LightningForgotPasswordController_Test {
    public static User testUser;
    
    static testMethod void unitTest() {
        
        //Creating test data for user
        testUser = TestDataUtility.createUser('Standard User', 'testUserName@testing.com');
        try {
            testUser.Username = '';
            insert testUser;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        
        string username = testUser.userName ; 
        string Email = testUser.Email ;
       
        LightningForgotPasswordController.forgotPassowrd(username , Email);
        
    }
    
    /*static testMethod void unitTest2() {
        
        //Creating test data for user
        testUser = TestDataUtility.createUser('Standard User', 'testUserName@testing.com');
        try {
            insert testUser;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        
        string username = 'testUsername@abcde.com' ; 
        string Email = testUser.Email ;
       
        LightningForgotPasswordController.forgotPassowrd(username , Email);
        
    }*/
    
}