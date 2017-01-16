/*************************************************************************\
    @ Author        : Absyz Software Consulting Pvt. Ltd.
    @ Date          : 18-July-2016
    @ Test File     : 
    @ Description   : To make feeds available for Partner User
    @ Audit Trial   : Added comments
    @ Last Modified Date : 25-July-2016
  
****************************************************************************/ 


public class FeedItemTriggerHandler { 
    /*
             Method Name: FeedVisiblity
             Purpose: To change the visiblity of feed item.
             Input Parameter : List of FeedItem
             Created Date: June 2016
             */
     public static void FeedVisiblity(List < FeedItem > newTrigger) {

        for (FeedItem NewFeed: newTrigger) {
           
                      NewFeed.Visibility = 'AllUsers';
                    
        }
    } 
  }