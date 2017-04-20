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
            
            if( (NewFeed.Type == 'TextPost') && (NewFeed.Body.contains('you have been assigned')) ){
                NewFeed.CreatedById = label.Lee_User_ID ; 
                NewFeed.Visibility = 'AllUsers';
                
            }
            String ParentIDofFeed = NewFeed.ParentId ; 
                if(String.valueOf(ParentIDofFeed).substring(0,3) == 'a5x' ){
                     NewFeed.Visibility = 'AllUsers';
                }
                      
                     
        }
    } 
  }