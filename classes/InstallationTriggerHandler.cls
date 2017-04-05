/*************************************************************************\
    @ Author        : Absyz Software Consulting Pvt. Ltd.
    @ Date          : June-2016
    @ Description   : Handler class for InstallationTrigger
    @ Audit Trial   : Added comments , Case Sharing with Installer
    @ Test Class    : InstallationTriggerHandler_Test
    @ Last Modified Date : 02-January-2017
  
****************************************************************************/

public class InstallationTriggerHandler {
     
       /*  
         Method Name    : CreateOwnerTask
         Purpose        : This Method serves the pupose of creating task and event for Installer.
         Input Parameter: List of Installation
         Created Date   : September 2016
         */
    public static void CreateOwnerTask(List < Installation__c > newTrigger){
       
         List < Task > lTask = new List < Task > ();
         List< Event > lEvent = new List < Event >();
         List <id> lConId = new List <id>();
        
        for(Installation__c ins : newTrigger){
            
            lConId.add(ins.contact__c);
        }
        
        if(!lConId.isEmpty()){
            system.debug('The value in lConId' +lConId);
        List< Contact > lContact = [SELECT Phone , Email FROM CONTACT WHERE id IN: lConId limit 10];
           system.debug('The value of lContact' +lcontact);
        
        for (Installation__c Ins: newTrigger) {
          if((Ins.Assigned_to__c != null ) &&  (lContact.size() > 0 )) {
              for(Contact con : lContact ){
                  if((ins.recordTypeID != label.Pre_Site_Visit_Record_ID ) && (Ins.Installation_Date__c != null) ){
              task t = new Task(
                        whatID = Ins.id,
                        
                        Subject = 'Confirm Installation',
                        Type = 'Contact Customer',
                        Priority = 'Normal',
                        Status = 'Not Started',
                        ActivityDate = SYSTEM.TODAY() + 1 ,
                        ownerID = Ins.Assigned_to__c ,
                        Phone_Number__c = Con.Phone , 
                        Email_Address__c = Con.Email , 
                        WhoId = Ins.Contact__c
                    );
                task tNew = new Task(
                        whatID = Ins.id,
                        
                        Subject = 'Installation for assigned ticket ' + ins.name ,
                        Priority = 'Normal',
                        Type = 'Site Visit',
                        Status = 'Not Started',
                        ActivityDate = ins.Installation_Date__c - 1 ,
                        ownerID = Ins.assigned_to__c ,
                        Phone_Number__c = Con.Phone , 
                        Email_Address__c = Con.Email , 
                        WhoId = Ins.Contact__c
                    );
            
             //creating event
                    Event event = new Event(
                            OwnerId = Ins.assigned_to__c ,
                            WhatId = Ins.id,
                            StartDateTime = Ins.Installation_Date__c,
                            EndDateTime = Ins.Installation_Date__c,
                            ActivityDateTime = Ins.Installation_Date__c, 
                            Subject = 'Installation for '+Ins.Name
                           
                    
                        ); 
              lEvent.add(event); 
              lTask.add(t );
              lTask.add(tNew);
                            
                  }
                  
                  else{
                       task t = new Task(
                        whatID = Ins.id,
                        
                        Subject = 'Confirm Site Visit',
                        Type = 'Contact Customer',
                        Priority = 'Normal',
                        Status = 'Not Started',
                        ActivityDate = SYSTEM.TODAY() + 1 ,
                        ownerID = Ins.Assigned_to__c ,
                        Phone_Number__c = Con.Phone , 
                        Email_Address__c = Con.Email , 
                        WhoId = Ins.Contact__c
                    );
                      lTask.add(t );
                  }
             
              
              
          }
        }
        }
    }
         try {
                insert lTask;
                insert lEvent;
             
            } catch (exception e) {
                system.debug('Exception is: ' + e);
            }
    }
    
    
     /*  
         Method Name    : updateTaskEventOwner
         Purpose        : When Installer is manually changed , this method updates the task and event Owner to the new Installer
         Input Parameter: List of Installation
         Created Date   : January 2017
         */
    
    public static void updateTaskEventOwner(List < Installation__c > newTrigger){
            List <ID> lstInstallationId = new List<ID> () ;
            List <Task> lstTaskUpdate = new List <Task> () ;
            List <Event> lstEventUpdate = new List <Event> () ;
        
            for(Installation__c i : newTrigger ){
                    lstInstallationId.add(i.ID) ; 
                }
        
            Integer countActivity = [SELECT Count() FROM Task WHERE WhatID in : lstInstallationId] ; 
            if(countActivity > 0){
                        List <Task> lstRelatedTasks = [SELECT id , OwnerID  FROM Task WHERE WhatID in :  lstInstallationId ] ; 
                for(Installation__c ins : newTrigger ){
                    for(Task t : lstRelatedTasks){
                                t.OwnerID = ins.Assigned_to__c ; 
                                lstTaskUpdate.add(t);
                        }
                }
            }
                Integer countEvent = [SELECT Count() FROM Event WHERE WhatID in : lstInstallationId] ; 
            if(countEvent > 0){
                    List <Event> lstRelatedEvent = [SELECT id , OwnerID  FROM Event WHERE WhatID in :  lstInstallationId ] ;
                    for(Installation__c ins : newTrigger ){
                        for(Event e : lstRelatedEvent){
                                e.OwnerID = ins.Assigned_to__c ; 
                                lstEventUpdate.add(e);
                        }
                    } 
            
                }
                
                try{
                    if(lstTaskUpdate.size() > 0){
                        update lstTaskUpdate ; 
                        
                    }
                    if (lstEventUpdate .size() > 0) {
                            update lstEventUpdate ;
                       }
                    
                }
                catch(exception e){
                    System.debug('Exception is:' +e.getMessage()) ;
                }
                
                
        
    }
    
    
    
     
    
    /*
             Method Name: AssignInstaller
             Purpose: Assign Installer automatically based on Territory
             Input Parameter : List of Installation
             Created Date: August 2016
             */
    public static void AssignInstaller(List < Installation__c > newTrigger)
    {
        
        set <string> setZipCode = new set<string>() ; 
        System.debug('change?'+newTrigger);
        
        for(Installation__C i : newTrigger){
            system.debug(i.Project_Country_Canada__c);
            if(i.Project_Country_Canada__c){
                if(i.Project_Zip_Code__c!= null && i.Project_Zip_Code__c!=''){
                    string zip = i.Project_Zip_Code__c.ToUpperCase();
                    setZipCode.add(zip.substring(0,3));
                    }
               }
               else if(i.Project_Zip_Code__c!= null && i.Project_Zip_Code__c!='')
                 setZipCode.add(i.Project_Zip_Code__c);
        }
        system.debug(setZipCode);
        List<Zip_Codes_Master__c> zipCodeList = [SELECT id ,Zip_Code__c ,Territory__c , Installer_Contact__c , Installer_Account__c , Installer_User__c FROM Zip_Codes_Master__c WHERE Zip_Code__c in: setZipCode ];

        system.debug(zipCodeList);
        for(Installation__c i : newTrigger){
            if(zipCodeList.size() > 0){
                for(Zip_Codes_Master__c zip : zipCodeList){
                    if(((i.Project_Country_Canada__c && i.Project_Zip_Code__c.toUppercase().substring(0,3) == zip.Zip_Code__c) ||(!i.Project_Country_Canada__c && i.Project_Zip_Code__c == zip.Zip_Code__c))&&((zip.Installer_Contact__c != null) || (zip.Installer_Account__c != null)||(zip.Installer_User__c != null))){
                            if(zip.Installer_Contact__c != null){
                                    i.Installer_Contact__c = zip.Installer_Contact__c ; 
                            }
                            if(zip.Installer_Account__c != null){
                                    i.Installer_Account__c = zip.Installer_Account__c ;
                            }
                            if(zip.Installer_User__c != null){
                                    i.Assigned_to__c = zip.Installer_User__c ;
                                    i.OwnerID = zip.Installer_User__c ;
                            }
                        i.Installer_Manager__c = i.Installer_Name__c	 ; 
                }
            }
        }
        }

    }
    
    
    
    
    /*
             Method Name: updateInstallerUser
             Purpose: Assign Installer User as per Installer Contact
             Input Parameter : List of Installation
             Created Date: August 2016
             */
    
   /* public static void updateInstallerUser(List < Installation__c > newTrigger) {
        List<id> EmailAddress = new List<id>() ; 
      
        for(Installation__c s : newTrigger ){
            string ContactEmail = s.Installer_Contact__c ;
            EmailAddress.add(ContactEmail);
        }
         list < user > userId = [SELECT id, email, ContactId FROM USER WHERE ContactId IN: EmailAddress Limit 1];
                     system.debug('UserId'+userId);
        for(Installation__c Ins : newTrigger) {
            system.debug('Debug New' + Ins.Installer_Contact__c);
            if(ins.Installer_Contact__c != null ){
            
             system.debug('UserId'+userId);
                for(User u : userId){
                    if(userId.size() > 0){
                Ins.Assigned_to__c = u.id ;
                Ins.OwnerId = Ins.Assigned_to__c;
                }
            }
            }
             
        }
       
        
    } */
    
    /*
             Method Name: manualShareRead
             Purpose: To give read acces on Account
             Input Parameter : List of Installation
             Created Date: Aug 2016
             */
     public static void manualShareRead(List < Installation__c > newTrigger){
         List<AccountShare> sharesToCreate = new List<AccountShare>();
       //   ID groupId = [select id from Group where Name= 'Nana Installers' Limit 1].id;
       //   ID TyeGroup = [select id from Group where Name ='TenApogee Corporation' Limit 1].id ;
        
         List<Project__Share> ShareProject = new List<Project__Share>();
         List<Installation__Share> ShareInstallation = new List<Installation__Share>();
           List<OpportunityShare> OppToShare = new List<OpportunityShare>();
         List<CaseShare> ShareCase = new List<CaseShare>();
         List<OrderShare> OrderToShare = new List<OrderShare> () ;
         List<ContactShare> ContactToShare = new List<ContactShare> () ; 
        // List<OrderOwnerSharingRule> OrderToSharenew = new List<OrderOwnerSharingRule>();         
         for (Installation__c ins : newTrigger) {
             //To share Account
             if((ins.Account__c != null)&& (ins.Assigned_to__c != null)){
                 AccountShare acc = new AccountShare();
                 acc.AccountAccessLevel = 'Read';
                 acc.AccountId = ins.Account_Id__c;
                 acc.UserOrGroupId = ins.Assigned_to__c;
                 acc.OpportunityAccessLevel = 'Read';
                 sharesToCreate.add(acc);

             }
             // To share Project
             if((ins.Project__c != null) && (ins.Assigned_to__c != null)){
                 Project__Share pro = new Project__Share ();
                 pro.AccessLevel = 'Read';
                 pro.ParentId = ins.Project_Id__c ;
                 pro.UserOrGroupId =  ins.Assigned_to__c;
                 ShareProject.add(pro);
                
             }
             
            // To share Case
             
             if((ins.Case__c != null) && (ins.Assigned_to__c != null)){
                 CaseShare cs  = new CaseShare();
                 cs.CaseAccessLevel = 'Read';
                 cs.CaseId = ins.Case__c;
                 cs.UserOrGroupId = ins.Assigned_to__c;
                 ShareCase.add(cs);
             }
             // To share Installation
           /* if(ins.Assigned_to__c != null){
                 Installation__Share InsShare = new Installation__Share ();
                 InsShare.AccessLevel = 'Edit';
                 InsShare.ParentId = Ins.Id ; 
                 
                 InsShare.UserOrGroupId =  Ins.Assigned_to__c;
                 ShareInstallation.add(InsShare);
             } */
             
              // To share Order
              /*if((ins.Order__c != null)&& (ins.Assigned_to__c != null)){
                 OrderShare shareOrder = new OrderShare ();
                shareOrder.OrderAccessLevel = 'Read';
                 shareOrder.OrderID = Ins.Order__c ; 
                 shareOrder.UserOrGroupId = ins.Assigned_to__c;
                 
                 OrderToShare.add(shareOrder); 
             } */
             /*if((ins.Order__c != null) &&(ins.Assigned_to__c != null)){
             OrderOwnerSharingRule rule = new OrderOwnerSharingRule();
                 rule.OrderAccessLevel = 'Read';
                 rule.OrderId = Ins.Order__c;
                 rule.UserOrGroupId = Ins.Assigned_to__c;
                 
                 OrdertoSharenew.add(rule);
             }*/
               // To share Contact
          /*    if((ins.Contact__c != null)&& (ins.Assigned_to__c != null)){
                 ContactShare shareContact = new ContactShare ();
                shareContact.ContactAccessLevel = 'Read';
                 shareContact.ContactID = Ins.Contact__c ; 
                 shareContact.UserOrGroupId = ins.Assigned_to__c;
                 
                 ContactToShare.add(shareContact); 
             } */
             
             
             
             // To share Quote 

            
          if((ins.Quote_Name__c != null)&& (ins.Assigned_to__c != null)){
                 OpportunityShare OppShare = new OpportunityShare ();
                 OppShare.OpportunityAccessLevel = 'Read';
                 OppShare.OpportunityID = Ins.Opportunity_ID__c ; 
                 OppShare.UserOrGroupId = ins.Assigned_to__c;
                 
                 OppToShare.add(OppShare);
             }          
         }
         
          if (!OrderToShare.isEmpty())
                   //   insert OrderToShare;
         
         // do the DML to create shares
             if (!sharesToCreate.isEmpty())
                      insert sharesToCreate;

         if(!ShareProject.isEmpty())
                  insert ShareProject ;
         
            if(!ShareInstallation.isEmpty())
                insert ShareInstallation ; 


         if(!ShareCase.isEmpty())
             insert ShareCase;
         
        if(!OppToShare.isEmpty())
                insert OppToShare ; 

         
      
   }
    
    
    
       
    /*
             Method Name: updateInstallationName
             Purpose: To handle naming convention for Installation
             Input Parameter : List of Installation
             Created Date: August 2016
             */
    public static void updateInstallationName(list<Installation__c> installList){
       system.debug('Inside updateInstallationName');
        set<id> setOrderId = new set<id>();
        set<id> setQuoteId = new set<id>();
       List<Installation__c> InsList = new List<Installation__c>() ;  
        
        for(Installation__c i : InstallList){
               // Id ord = i.Order_Id__c ; 
            if(i.Order_Number__c != null){          
                setOrderId.add(i.Order_Id__c);
            }
            else if(i.Quote_Number__c != null){
                setQuoteId.add(i.Quote_Name__c);
            }

        }
        system.debug('The set is'+setOrderId);
        Integer count = [SELECT COUNT() FROM Installation__c Where Order__c IN: setOrderId ];
        Integer countQuote = [SELECT COUNT() FROM Installation__c Where Quote_Name__c IN: setQuoteId ];
         system.debug('Value of count' + count);
     
        if((count > 0) && (countQuote == 0)){
            count = Count +1 ;
            system.debug('I am here4' +countQuote);
            system.debug('Inside if');
            for(Installation__c i : InstallList){
                if(i.Order_Number__c != Null){
                i.Name = 'INS'+ i.Order_Number__c +'_'+count ;
                 i.Status__c = 'Assigned' ;
                   
                        
                    
                InsList.add(i) ; 
                }
               
            }
        }
        else if((count == 0) && (countQuote == 0)){
            system.debug('I am here3' +countQuote);
            for(Installation__c i : InstallList){
              if(i.Order_Number__c != Null){
                i.Name = 'INS'+ i.Order_Number__c  ;
                i.Status__c = 'Assigned' ;
                   
                  
                InsList.add(i) ; 
              }
                else if(i.Quote_Number__c != Null){
                i.Name = 'INS'+ i.Quote_Number__c  ;
                i.Status__c = 'Assigned' ;
                    
                InsList.add(i) ; 
                }
                
            }
        }
    
        else if((count == 0) && (countQuote != 0)){
            
             countQuote = countQuote +1 ;
                system.debug('I am here' +countQuote);
            for(Installation__c i : InstallList) {
            i.Name = 'INS'+ i.Quote_Number__c +'_'+countQuote ;
                i.Status__c = 'Assigned' ;
                 
                InsList.add(i) ; 
            }
        }

        else if((count != 0) && (countQuote != 0)){
            countQuote = countQuote +1 ;
            count = count+1 ; 
            system.debug('I am here2' +countQuote);
            for(Installation__c i : InstallList){
              if(i.Order_Number__c != Null){
                i.Name = 'INS'+ i.Order_Number__c +'_'+count  ;
                i.Status__c = 'Assigned' ;
                   
                InsList.add(i) ; 
              }
                else if(i.Quote_Number__c != Null){
                i.Name = 'INS'+ i.Quote_Number__c +'_'+countQuote  ;
                i.Status__c = 'Assigned' ;
                     
                InsList.add(i) ; 
                }
                
            }
        }
         
        
    }
    
     /*
             Method Name: udpateInstallationPosition
             Purpose: To create Position as a copy of quote detail under Installation
             Input Parameter : List of Installation
             Created Date: August 2016
             */
    
    public static void udpateInstallationPosition(list<Installation__c> installList){
       
       
        set<id> QuoteSetIds = new set<id>();
        
            for(Installation__c ins : installList){
                    
                  QuoteSetIds.add(ins.Quote_Name__c);
                 }
        
     list<Quote_Detail__c> lstQuoteDetail = 
[SELECT ActiveSide_Description__c,ActiveSide_Notes__c,ActiveSide__c,Aluminum_Description__c,Aluminum_Lookup_Price__c,Aluminum_Notes__c,Aluminum_Quoted_Price__c,Aluminum__c,AngleChanges_Description__c,AngleChanges_Lookup_Price__c,AngleChanges_Notes__c,AngleChanges_Quoted_Price__c,AngleChanges__c,Base_Lookup_Price__c,Base_Quoted_Price__c,BottomRail_Description__c,BottomRail_Notes__c,BottomRail__c,CEROType_Description__c,CEROType_Name__c,CEROType_Quoted_Price__c,Choice_Info__c,Code__c,Configuration_Notes__c,Configuration__c,ConnectionReceivedId,ConnectionSentId,CornerFinish_Description__c,CornerFinish_Notes__c,CornerFinish__c,CPD__c,CreatedById,CreatedDate,CustodialHardware_Description__c,CustodialHardware_Lookup_Price__c,CustodialHardware_Notes__c,CustodialHardware_Quoted_Price__c,CustodialHardware__c,Direction_Description__c,Direction_Notes__c,Direction__c,Discount__c,Extended_Subtotal__c,Florida_Approved__c,FoldFlat_Description__c,FoldFlat_Notes__c,FoldFlat__c,GlazingDesignation_Description__c,GlazingDesignation_Notes__c,GlazingDesignation__c,Glazing_Description__c,Glazing_Lookup_Price__c,Glazing_Notes__c,Glazing_Override__c,Glazing_Price__c,Glazing_Quoted_Price__c,Glazing__c,HandleFinish_Description__c,HandleFinish_Notes__c,HandleFinish__c,HandleLeftRight_Description__c,HandleLeftRight_Name__c,HandleLeftRight_Quoted_Price__c,HandleLeft_Description__c,HandleLeft_Name__c,HandleLeft_Quoted_Price__c,HandleRight_Description__c,HandleRight_Name__c,HandleRight_Quoted_Price__c,HardwareColor_Description__c,HardwareColor_Notes__c,HardwareColor__c,HardwareHeight_Description__c,HardwareHeight_Notes__c,HardwareHeight__c,Hardware_Description__c,Hardware_Lookup_Price__c,Hardware_Notes__c,Hardware_Quoted_Price__c,Hardware__c,Height_Denominator__c,Height_Feet__c,Height_Inches__c,Height_MM__c,Height_Numerator__c,Height__c,HingeFinish_Description__c,HingeFinish_Notes__c,HingeFinish__c,HingePin_Description__c,HingePin_Notes__c,HingePin__c,HingeType_Description__c,HingeType_Notes__c,HingeType__c,Id,IncorpSwingDoor_Description__c,IncorpSwingDoor_Lookup_Price__c,IncorpSwingDoor_Notes__c,IncorpSwingDoor_Quoted_Price__c,IncorpSwingDoor__c,IsDeleted,Kickplate_Description__c,Kickplate_Lookup_Price__c,Kickplate_Notes__c,Kickplate_Quoted_Price__c,Kickplate__c,LastActivityDate,LastModifiedById,LastModifiedDate,LeftStack_Description__c,LeftStack_Notes__c,LeftStack__c,Lites_Description__c,Lites_Lookup_Price__c,Lites_Notes__c,Lites_Quoted_Price__c,Lites__c,Local_Production_Time_Per_Panel__c,Manufacturer__c,Metric_UValue__c,Model__c,Mounting_Description__c,Mounting_Notes__c,Mounting_Performance__c,Mounting__c,Name,NDG_Drawing_Link__c,Negative_Windload__c,NFRC__c,Order_Finalized_Date__c,Order_Number__c,Panels__c,ParkingBay_Description__c,ParkingBay_Lookup_Price__c,ParkingBay_Notes__c,ParkingBay_Quoted_Price__c,ParkingBay__c,Performance_Description__c,Position_Discount__c,Position_Subtotal__c,Position__c,Positive_Windload__c,Price__c,Quote_Detail_ID__c,Quote__c,ReinforcedLocking_Description__c,ReinforcedLocking_Lookup_Price__c,ReinforcedLocking_Quoted_Price__c,ReinforcedLocking__c,RightStack_Description__c,RightStack_Notes__c,RightStack__c,Sales_Rep__c,ScreenFinish_Description__c,ScreenFinish_Notes__c,ScreenFinish__c,ScreenOneConfiguration_Description__c,ScreenOneConfiguration_Name__c,ScreenOneFinish_Description__c,ScreenOneFinish_Name__c,ScreenOneFinish_Quoted_Price__c,ScreenOneMesh_Description__c,ScreenOneMesh_Name__c,ScreenOneMesh_Quoted_Price__c,ScreenOneNumber_Description__c,ScreenOneNumber_Name__c,ScreenOneNumber_Quoted_Price__c,ScreenType_Description__c,ScreenType_Lookup_Price__c,ScreenType_Notes__c,ScreenType_Quoted_Price__c,ScreenType__c,Screen_Description__c,Screen_Notes__c,Screen__c,SHGC_Label__c,SHGC__c,SillColor_Description__c,SillColor_Notes__c,SillColor__c,Sill_Description__c,Sill_Lookup_Price__c,Sill_Notes__c,Sill_Performance__c,Sill_Quoted_Price__c,Sill__c,SlidingPanel_Description__c,SlidingPanel_Name__c,SlidingPanel_Quoted_Price__c,Socket_Description__c,Socket_Name__c,Socket_Quoted_Price__c,SpacerBar_Description__c,SpacerBar_Notes__c,SpacerBar__c,StackingDirection_Description__c,StackingDirection_Notes__c,StackingDirection__c,Stile_Description__c,Stile_Lookup_Price__c,Stile_Notes__c,Stile_Quoted_Price__c,Stile__c,SwingDoorHinge_Description__c,SwingDoorHinge_Notes__c,SwingDoorHinge__c,SwingPanelWidth_Description__c,SwingPanelWidth_Name__c,SwingPanelWidth_Quoted_Price__c,SwingPanel_Name__c,SwingPanel_Quoted_Price__c,SystemModstamp,TinderBoxEmbedCode__c,TotalPanels_LocalProductionTime__c,Total_Panels__c,Units__c,Unit_Base_Price__c,Unit_Subtotal__c,UValue_Label__c,UValue__c,Visible_Transmittance__c,Weight__c,Width_Denominator__c,Width_Feet__c,Width_Inches__c,Width_MM__c,Width_Numerator__c,Width__c,WistiaContentID__c,WoodFinish_Description__c,WoodFinish_Lookup_Price__c,WoodFinish_Notes__c,WoodFinish_Quoted_Price__c,WoodFinish__c,Wood_Description__c,Wood_Lookup_Price__c,Wood_Notes__c,Wood_Quoted_Price__c,Wood__c FROM Quote_Detail__c WHERE Quote__c IN: QuoteSetIds]; 
        
        list<Position__c> lstPosition = new list<Position__c>();
        
        system.debug('Inside udpateInstallationPosition , lstQuoteDetail ' + lstQuoteDetail);
        
        if(lstQuoteDetail.size() > 0 ){
        for (Quote_Detail__c q : lstQuoteDetail){
            
                for(Installation__c i : installList){
                  if(q.Quote__c == i.Quote_Name__c){
                      lstPosition.add( new Position__c(
                            Installation__c = i.id ,
                            Nana_Quote__c = i.Quote_Name__c ,
                             Name=q.Name , 
               
                  CODE__C  = q.CODE__C , 
                  Order_Detail__c = q.Order_Number__c   ,
                  CONFIGURATION__C = q.CONFIGURATION__C ,
                  DISCOUNT__C = q.DISCOUNT__C , 
                  MODEL__C = q.MODEL__C ,
                  NEGATIVE_WINDLOAD__C = q.NEGATIVE_WINDLOAD__C, 
                  PANELS__C = q.PANELS__C  , 
                  POSITION__C = q.POSITION__C ,
                  POSITIVE_WINDLOAD__C = q.POSITIVE_WINDLOAD__C , 
                  PRICE__C = q.PRICE__C , 
                //  QUOTE_DETAIL_ID__C  = q.QUOTE_DETAIL_ID__C  ,
                  SHGC__C  = q.SHGC__C  , 
                  UVALUE__C   = q.UVALUE__C   , 
                  CHOICE_INFO__C  = q.CHOICE_INFO__C  ,
                  WIDTH_FEET__C   = q.WIDTH_FEET__C   ,
                  WIDTH_INCHES__C = q.WIDTH_INCHES__C , 
                  WIDTH_NUMERATOR__C  = q.WIDTH_NUMERATOR__C  ,
                  WIDTH_DENOMINATOR__C    = q.WIDTH_DENOMINATOR__C   ,
                  HEIGHT_FEET__C  = q.HEIGHT_FEET__C  ,
                  HEIGHT_INCHES__C    = q.HEIGHT_INCHES__C , 
                  HEIGHT_NUMERATOR__C = q.HEIGHT_NUMERATOR__C, 
                  HEIGHT_DENOMINATOR__C   = q.HEIGHT_DENOMINATOR__C , 
                  UNITS__C    = q.UNITS__C   ,
                  ACTIVESIDE__C   = q.ACTIVESIDE__C   ,
                  ALUMINUM__C = q.ALUMINUM__C ,
                  ANGLECHANGES__C = q.ANGLECHANGES__C ,
                  BOTTOMRAIL__C  = q.BOTTOMRAIL__C  , 
                  CUSTODIALHARDWARE__C = q.CUSTODIALHARDWARE__C ,
                  DIRECTION__C    = q.DIRECTION__C   , 
                  GLAZING__C  = q.GLAZING__C ,
                  GLAZINGDESIGNATION__C  = q.GLAZINGDESIGNATION__C ,
                  HANDLEFINISH__C = q.HANDLEFINISH__C , 
                  HARDWARE__C = q.HARDWARE__C,
                  HARDWAREHEIGHT__C  = q.HARDWAREHEIGHT__C ,
                  HINGEFINISH__C  = q.HINGEFINISH__C  , 
                  HINGETYPE__C   = q.HINGETYPE__C  ,
                  INCORPSWINGDOOR__C  = q.INCORPSWINGDOOR__C  ,
                  KICKPLATE__C  =q.KICKPLATE__C  , 
                  LITES__C = q.LITES__C  , 
                  MOUNTING__C = q.MOUNTING__C ,
                  PARKINGBAY__C  = q.PARKINGBAY__C, 
                  REINFORCEDLOCKING__C  = q.REINFORCEDLOCKING__C  ,
                  SCREEN__C = q.SCREEN__C ,
                  SCREENFINISH__C = q.SCREENFINISH__C , 
                  SCREENTYPE__C  = q.SCREENTYPE__C , 
                  SILL__C = q.SILL__C,
                  SILLCOLOR__C= q.SILLCOLOR__C ,
                  SPACERBAR__C = q.SPACERBAR__C ,
                  WOOD__C = q.WOOD__C , 
                  WOODFINISH__C = q.WOODFINISH__C  , 
                  HARDWARECOLOR__C = q.HARDWARECOLOR__C ,
                  STILE__C = q.STILE__C , 
                 
                  
                  LEFTSTACK__C   = q.LEFTSTACK__C ,
                  RIGHTSTACK__C   = q.RIGHTSTACK__C ,
                  CORNERFINISH__C = q.CORNERFINISH__C ,
                  STACKINGDIRECTION__C    = q.STACKINGDIRECTION__C ,
                  SWINGDOORHINGE__C   = q.SWINGDOORHINGE__C   , 
                  GLAZING_DESCRIPTION__C  = q.GLAZING_DESCRIPTION__C  ,
                  DIRECTION_DESCRIPTION__C    = q.DIRECTION_DESCRIPTION__C    ,
                  
                  SILL_DESCRIPTION__C = q.SILL_DESCRIPTION__C ,
                  ORDER_FINALIZED_DATE__C = q.ORDER_FINALIZED_DATE__C ,
                  METRIC_UVALUE__C   = q.METRIC_UVALUE__C  ,
                 
                 ACTIVESIDE_DESCRIPTION__C   = q.ACTIVESIDE_DESCRIPTION__C ,
                  ALUMINUM_DESCRIPTION__C = q.ALUMINUM_DESCRIPTION__C ,
                  ANGLECHANGES_DESCRIPTION__C = q.ANGLECHANGES_DESCRIPTION__C,
                  BOTTOMRAIL_DESCRIPTION__C   = q.BOTTOMRAIL_DESCRIPTION__C   ,
                  CORNERFINISH_DESCRIPTION__C = q.CORNERFINISH_DESCRIPTION__C ,
                   CUSTODIALHARDWARE_DESCRIPTION__C     = q.CUSTODIALHARDWARE_DESCRIPTION__C    ,
                   GLAZINGDESIGNATION_DESCRIPTION__C   = q.GLAZINGDESIGNATION_DESCRIPTION__C   ,
                   HANDLEFINISH_DESCRIPTION__C = q.HANDLEFINISH_DESCRIPTION__C  , 
                   HARDWARE_DESCRIPTION__C = q.HARDWARE_DESCRIPTION__C , 
                  HARDWARECOLOR_DESCRIPTION__C     = q.HARDWARECOLOR_DESCRIPTION__C    ,
                   HARDWAREHEIGHT_DESCRIPTION__C   = q.HARDWAREHEIGHT_DESCRIPTION__C   ,
                   HINGEFINISH_DESCRIPTION__C  = q.HINGEFINISH_DESCRIPTION__C  ,
                   HINGETYPE_DESCRIPTION__C    = q.HINGETYPE_DESCRIPTION__C    ,
                   INCORPSWINGDOOR_DESCRIPTION__C  = q.INCORPSWINGDOOR_DESCRIPTION__C  ,
                   KICKPLATE_DESCRIPTION__C    = q.KICKPLATE_DESCRIPTION__C    ,
                  LEFTSTACK_DESCRIPTION__C    = q.LEFTSTACK_DESCRIPTION__C    ,
                  LITES_DESCRIPTION__C    = q.LITES_DESCRIPTION__C    ,
                  MOUNTING_DESCRIPTION__C  = q.MOUNTING_DESCRIPTION__C  ,
                  PARKINGBAY_DESCRIPTION__C   = q.PARKINGBAY_DESCRIPTION__C  , 
                  REINFORCEDLOCKING_DESCRIPTION__C    = q.REINFORCEDLOCKING_DESCRIPTION__C    ,
                  RIGHTSTACK_DESCRIPTION__C    = q.RIGHTSTACK_DESCRIPTION__C   ,
                  SCREEN_DESCRIPTION__C   =q.SCREEN_DESCRIPTION__C   ,
                  SCREENFINISH_DESCRIPTION__C = q.SCREENFINISH_DESCRIPTION__C , 
                  SCREENTYPE_DESCRIPTION__C   = q.SCREENTYPE_DESCRIPTION__C   ,
                  SPACERBAR_DESCRIPTION__C    = q.SPACERBAR_DESCRIPTION__C  , 
                  STACKINGDIRECTION_DESCRIPTION__C    = q.STACKINGDIRECTION_DESCRIPTION__C    ,
                  STILE_DESCRIPTION__C    = q.STILE_DESCRIPTION__C    ,
                  SWINGDOORHINGE_DESCRIPTION__C   = q.SWINGDOORHINGE_DESCRIPTION__C   ,
                  WOOD_DESCRIPTION__C = q.WOOD_DESCRIPTION__C ,
                  WOODFINISH_DESCRIPTION__C   = q.WOODFINISH_DESCRIPTION__C   ,
                   SILLCOLOR_DESCRIPTION__C    = q.SILLCOLOR_DESCRIPTION__C    ,
                   LOCAL_PRODUCTION_TIME_PER_PANEL__C = q.LOCAL_PRODUCTION_TIME_PER_PANEL__C,
                  
                   VISIBLE_TRANSMITTANCE__C    = q.VISIBLE_TRANSMITTANCE__C    ,
                   FOLDFLAT__C = q.FOLDFLAT__C ,
                   FOLDFLAT_DESCRIPTION__C = q.FOLDFLAT_DESCRIPTION__C ,
                   HINGEPIN__C =q.HINGEPIN__C ,
                   HINGEPIN_DESCRIPTION__C  = q.HINGEPIN_DESCRIPTION__C , 
                   ACTIVESIDE_NOTES__C =q.ACTIVESIDE_NOTES__C ,
                   ALUMINUM_NOTES__C   = q.ALUMINUM_NOTES__C   , 
                   ANGLECHANGES_NOTES__C    = q.ANGLECHANGES_NOTES__C   , 
                   BOTTOMRAIL_NOTES__C  = q.BOTTOMRAIL_NOTES__C ,
                   CORNERFINISH_NOTES__C    = q.CORNERFINISH_NOTES__C   ,
                   CUSTODIALHARDWARE_NOTES__C   = q.CUSTODIALHARDWARE_NOTES__C  ,
                   DIRECTION_NOTES__C   = q.DIRECTION_NOTES__C  ,
                   FOLDFLAT_NOTES__C    = q.FOLDFLAT_NOTES__C   , 
                   GLAZING_NOTES__C    = q.GLAZING_NOTES__C    ,
                   GLAZINGDESIGNATION_NOTES__C = q.GLAZINGDESIGNATION_NOTES__C ,
                   HANDLEFINISH_NOTES__C    =q.HANDLEFINISH_NOTES__C   ,
                   HARDWARE_NOTES__C    = q.HARDWARE_NOTES__C   , 
                  HARDWARECOLOR_NOTES__C  = q.HARDWARECOLOR_NOTES__C  , 
                   HARDWAREHEIGHT_NOTES__C = q.HARDWAREHEIGHT_NOTES__C ,
                   HINGEFINISH_NOTES__C    =q.HINGEFINISH_NOTES__C    ,
                   HINGEPIN_NOTES__C   = q.HINGEPIN_NOTES__C   ,
                   HINGETYPE_NOTES__C  = q.HINGETYPE_NOTES__C  ,
                  INCORPSWINGDOOR_NOTES__C    =q.INCORPSWINGDOOR_NOTES__C    ,
                  KICKPLATE_NOTES__C  = q.KICKPLATE_NOTES__C  , 
                  LEFTSTACK_NOTES__C  =q.LEFTSTACK_NOTES__C  , 
                   LITES_NOTES__C  = q.LITES_NOTES__C  ,
                  MOUNTING_NOTES__C   =q.MOUNTING_NOTES__C  , 
                  PARKINGBAY_NOTES__C  =q.PARKINGBAY_NOTES__C ,
                   RIGHTSTACK_NOTES__C =q.RIGHTSTACK_NOTES__C ,
                   SCREEN_NOTES__C =q.SCREEN_NOTES__C , 
                  SCREENFINISH_NOTES__C   = q.SCREENFINISH_NOTES__C   , 
                  SCREENTYPE_NOTES__C =q.SCREENTYPE_NOTES__C ,
                  SILLCOLOR_NOTES__C  = q.SILLCOLOR_NOTES__C  ,
                  SILL_NOTES__C   =q.SILL_NOTES__C   ,
                  SPACERBAR_NOTES__C  =q.SPACERBAR_NOTES__C  ,
                  STACKINGDIRECTION_NOTES__C  = q.STACKINGDIRECTION_NOTES__C  ,
                  STILE_NOTES__C  =q.STILE_NOTES__C  ,
                   SWINGDOORHINGE_NOTES__C =q.SWINGDOORHINGE_NOTES__C , 
                   WOOD_NOTES__C   =q.WOOD_NOTES__C   ,
                   WOODFINISH_NOTES__C =q.WOODFINISH_NOTES__C ,
                   CPD__C  =q.CPD__C  ,
                  
                 
                   NDG_DRAWING_LINK__C =q.NDG_DRAWING_LINK__C ,
                  
                   WISTIACONTENTID__C  =q.WISTIACONTENTID__C  ,
                 
                  GLAZING_OVERRIDE__C = q.GLAZING_OVERRIDE__C ,
                   GLAZING_PRICE__C    = q.GLAZING_PRICE__C    ,
                  ALUMINUM_LOOKUP_PRICE__C    =q.ALUMINUM_LOOKUP_PRICE__C    ,
                   ALUMINUM_QUOTED_PRICE__C    =q.ALUMINUM_QUOTED_PRICE__C    ,
                  ANGLECHANGES_LOOKUP_PRICE__C    =q.ANGLECHANGES_LOOKUP_PRICE__C    ,
                  ANGLECHANGES_QUOTED_PRICE__C    =q.ANGLECHANGES_QUOTED_PRICE__C    , 
                   BASE_LOOKUP_PRICE__C    =q.BASE_LOOKUP_PRICE__C    ,
                   BASE_QUOTED_PRICE__C=q.BASE_QUOTED_PRICE__C,
                   CUSTODIALHARDWARE_LOOKUP_PRICE__C   =q.CUSTODIALHARDWARE_LOOKUP_PRICE__C   ,
                   CUSTODIALHARDWARE_QUOTED_PRICE__C   =q.CUSTODIALHARDWARE_QUOTED_PRICE__C   ,
                  GLAZING_LOOKUP_PRICE__C =q.GLAZING_LOOKUP_PRICE__C ,
                  GLAZING_QUOTED_PRICE__C= q.GLAZING_QUOTED_PRICE__C,
                  HARDWARE_LOOKUP_PRICE__C    =q.HARDWARE_LOOKUP_PRICE__C    ,
                 HARDWARE_QUOTED_PRICE__C    =q.HARDWARE_QUOTED_PRICE__C    , 
                  INCORPSWINGDOOR_LOOKUP_PRICE__C =q.INCORPSWINGDOOR_LOOKUP_PRICE__C , 
                  INCORPSWINGDOOR_QUOTED_PRICE__C = q.INCORPSWINGDOOR_QUOTED_PRICE__C  , 
                  KICKPLATE_LOOKUP_PRICE__C   =q.KICKPLATE_LOOKUP_PRICE__C   , 
                  KICKPLATE_QUOTED_PRICE__C   =q.KICKPLATE_QUOTED_PRICE__C   ,
                  LITES_LOOKUP_PRICE__C   =q.LITES_LOOKUP_PRICE__C   ,
                   LITES_QUOTED_PRICE__C   =q.LITES_QUOTED_PRICE__C   , 
                   PARKINGBAY_LOOKUP_PRICE__C  =q.PARKINGBAY_LOOKUP_PRICE__C  ,
                   PARKINGBAY_QUOTED_PRICE__C  =q.PARKINGBAY_QUOTED_PRICE__C  ,
                  REINFORCEDLOCKING_LOOKUP_PRICE__C   =q.REINFORCEDLOCKING_LOOKUP_PRICE__C   ,
                 REINFORCEDLOCKING_QUOTED_PRICE__C   =q.REINFORCEDLOCKING_QUOTED_PRICE__C   ,
                 SCREENTYPE_LOOKUP_PRICE__C  =q.SCREENTYPE_LOOKUP_PRICE__C  ,
                 SCREENTYPE_QUOTED_PRICE__C  =q.SCREENTYPE_QUOTED_PRICE__C  ,
                 SILL_LOOKUP_PRICE__C    =q.SILL_LOOKUP_PRICE__C    ,
                   SILL_QUOTED_PRICE__C    =q.SILL_QUOTED_PRICE__C    ,
                  STILE_LOOKUP_PRICE__C   =q.STILE_LOOKUP_PRICE__C   ,
                STILE_QUOTED_PRICE__C   = q.STILE_QUOTED_PRICE__C   ,
                   WOODFINISH_LOOKUP_PRICE__C  =q.WOODFINISH_LOOKUP_PRICE__C  , 
                  WOODFINISH_QUOTED_PRICE__C  =q.WOODFINISH_QUOTED_PRICE__C  ,
                   WOOD_LOOKUP_PRICE__C    =q.WOOD_LOOKUP_PRICE__C    ,
                   WOOD_QUOTED_PRICE__C = q.WOOD_QUOTED_PRICE__C,
                   POSITION_DISCOUNT__C    =q.POSITION_DISCOUNT__C    , 
                  WIDTH_MM__C =q.WIDTH_MM__C ,
                   HEIGHT_MM__C    =q.HEIGHT_MM__C    ,
                    UNIT_BASE_PRICE__C =  q.UNIT_BASE_PRICE__C ,                 
                   UNIT_SUBTOTAL__C    =q.UNIT_SUBTOTAL__C    , 
                   EXTENDED_SUBTOTAL__C    =q.EXTENDED_SUBTOTAL__C    ,
                  POSITION_SUBTOTAL__C    =q.POSITION_SUBTOTAL__C    ,
                   NFRC__C =q.NFRC__C , 
                    WEIGHT__C   =q.WEIGHT__C   ,
                    UVALUE_LABEL__C =q.UVALUE_LABEL__C , 
                    SHGC_LABEL__C=q.SHGC_LABEL__C, 
                    FLORIDA_APPROVED__C  =q.FLORIDA_APPROVED__C , 
                    HANDLELEFT_NAME__C  =q.HANDLELEFT_NAME__C  , 
                     HANDLELEFT_DESCRIPTION__C=q.HANDLELEFT_DESCRIPTION__C, 
                   HANDLELEFT_QUOTED_PRICE__C  =q.HANDLELEFT_QUOTED_PRICE__C  ,
                    HANDLERIGHT_NAME__C =q.HANDLERIGHT_NAME__C ,
                    HANDLERIGHT_DESCRIPTION__C =q.HANDLERIGHT_DESCRIPTION__C , 
                    HANDLERIGHT_QUOTED_PRICE__C =q.HANDLERIGHT_QUOTED_PRICE__C , 
                    HANDLELEFTRIGHT_NAME__C =q.HANDLELEFTRIGHT_NAME__C , 
                    HANDLELEFTRIGHT_DESCRIPTION__C   =q.HANDLELEFTRIGHT_DESCRIPTION__C  , 
                    HANDLELEFTRIGHT_QUOTED_PRICE__C  =q.HANDLELEFTRIGHT_QUOTED_PRICE__C , 
                    SCREENONENUMBER_NAME__C  = q.SCREENONENUMBER_NAME__C , 
                    SCREENONENUMBER_DESCRIPTION__C  =q.SCREENONENUMBER_DESCRIPTION__C  , 
                    SCREENONENUMBER_QUOTED_PRICE__C = q.SCREENONENUMBER_QUOTED_PRICE__C , 
                    SCREENONEFINISH_NAME__C=q.SCREENONEFINISH_NAME__C, 
                    SCREENONEFINISH_DESCRIPTION__C   = q.SCREENONEFINISH_DESCRIPTION__C  , 
                   SCREENONEFINISH_QUOTED_PRICE__C =q.SCREENONEFINISH_QUOTED_PRICE__C , 
                      SCREENONEMESH_NAME__C    =q.SCREENONEMESH_NAME__C   , 
                      SCREENONEMESH_DESCRIPTION__C =q.SCREENONEMESH_DESCRIPTION__C, 
                    SCREENONEMESH_QUOTED_PRICE__C = q.SCREENONEMESH_QUOTED_PRICE__C , 
                      SCREENONECONFIGURATION_NAME__C  =q.SCREENONECONFIGURATION_NAME__C  , 
                    SCREENONECONFIGURATION_DESCRIPTION__C   =q.SCREENONECONFIGURATION_DESCRIPTION__C   , 
                    SOCKET_NAME__C  =q.SOCKET_NAME__C  , 
                    SOCKET_DESCRIPTION__C    =q.SOCKET_DESCRIPTION__C   , 
                     SOCKET_QUOTED_PRICE__C =q.SOCKET_QUOTED_PRICE__C , 
                      SLIDINGPANEL_NAME__C  = q.SLIDINGPANEL_NAME__C ,
                       SLIDINGPANEL_DESCRIPTION__C =q.SLIDINGPANEL_DESCRIPTION__C, 
                       SLIDINGPANEL_QUOTED_PRICE__C    =q.SLIDINGPANEL_QUOTED_PRICE__C, 
                        SWINGPANEL_NAME__C =q.SWINGPANEL_NAME__C,
                          SWINGPANEL_QUOTED_PRICE__C =q.SWINGPANEL_QUOTED_PRICE__C, 
                            SWINGPANELWIDTH_NAME__C  = q.SWINGPANELWIDTH_NAME__C, 
                   SWINGPANELWIDTH_DESCRIPTION__C = q.SWINGPANELWIDTH_DESCRIPTION__C ,
                    SWINGPANELWIDTH_QUOTED_PRICE__C =q.SWINGPANELWIDTH_QUOTED_PRICE__C, 
                     CEROTYPE_NAME__C =q.CEROTYPE_NAME__C, 
                         CEROTYPE_DESCRIPTION__C=q.CEROTYPE_DESCRIPTION__C, 
                    CEROTYPE_QUOTED_PRICE__C =q.CEROTYPE_QUOTED_PRICE__C, 
                        CONFIGURATION_NOTES__C  =q.CONFIGURATION_NOTES__C 
                      
                      
                      ));
                }
                }
        }
    }
      //  system.debug('Value in lstPosition' +lstPosition[0]);
        try{
            if(lstPosition.size()>0){
                system.debug('Inside try of position insert');
                system.debug('ID of lstPosition' +lstPosition[0].id);
               insert lstPosition ;
                
               } 
        }
        catch(exception e){
            system.debug('Exception is:' +e);
        }
    }
    
    
       
    
    
    
    
    /********************************************
    Method:updateEntitlement
    purpose:To update the entitlements if there is a certified installer in Installation
    *********************************************/
    public static void updateEntitlement(List<Installation__c> installs,map<id,Installation__c> oldInstal){
        List<Installation__c> instalList = new List<Installation__c>();
        List<id> quoteList = new List<id>();
        List<Entitlement> updatingEntitlements = new lIST<Entitlement>(); //To update the entitlements
        List<string> modelList = new List<string>();
        try{
       //Querying the Certified Accounts
       List<Account> acts = [select id,Certified_Installer__c from Account where Certified_Installer__c = TRUE];
       system.debug('The certified accounts list::::'+acts);
       map<id,boolean> actsMap = new map<id,boolean>();
       for(Account act:acts){
        actsMap.put(act.id,act.Certified_Installer__c);
       }
       system.debug('The actsMap is:::'+actsMap);
       
       //if(oldInstal.size()==0){
       //Query the Installation records
       for(Installation__c inst:installs){
       if(inst.Installer_Account__c !=null)
       instalList.add(inst);
       system.debug('The instalList is:::'+instalList);
       }
       //
       
       List<Position__c> positionList = [select id,Installation__c,Model__c, Nana_Quote__c from Position__c where Installation__c IN:instalList];
       system.debug('The positionList is:::'+positionList);
       
       for(Position__c pt:positionList){
       if(pt.Nana_Quote__c != NULL){
       quoteList.add(pt.Nana_Quote__c);
       modelList.add(pt.Model__c);
       }
       }
       List<Entitlement> entList = [select id, Nana_Quote__c,StartDate, Quote_Detail__c, Product_Name__c,Certified_Installer__c from Entitlement where Nana_Quote__c in: quoteList and Product_Name__c in:modelList];  
            
            if(oldInstal.size()==0){
            for(Installation__c inst:instalList){
            for(Entitlement ent:entList){
            if(ent.Nana_Quote__c == inst.Quote_Name__c){
                if(actsMap.containskey(inst.Installer_Account__c) && inst.Installer_Account__c != null){
                    ent.Certified_Installer__c = true;
                    updatingEntitlements.add(ent);
                }
                else if(!(actsMap.containskey(inst.Installer_Account__c)) && inst.Installer_Account__c != null){
                    ent.Certified_Installer__c = false;
                    updatingEntitlements.add(ent);
                }
               
                }
            }
        }
        }
        else{
        for(Installation__c inst:instalList){
            for(Entitlement ent:entList){
            if(ent.Nana_Quote__c == inst.Quote_Name__c){
            if( inst.Installer_Account__c !=oldInstal.get(inst.id).Installer_Account__c){
                if(actsMap.containskey(inst.Installer_Account__c)){
                    ent.Certified_Installer__c = true;
                    updatingEntitlements.add(ent);
                }
                else if(!(actsMap.containskey(inst.Installer_Account__c))){
                    ent.Certified_Installer__c = false;
                    updatingEntitlements.add(ent);
                }
               
                }
                }
            }
        }
        }
        if(updatingEntitlements.size()>0){
                Database.SaveResult[] srList = Database.update(updatingEntitlements, false);
                ErrorLogUtility.processErrorLogs(srList, updatingEntitlements,'InstallationTriggerHandler','updateEntitlement','Entitlement','update');
           // update updatingEntitlements;
        }
       //}
       
       }catch(exception e){}
     /*  List<id> orderids = new List<Id>();
       FOR(Installation__c inst:installs){
           orderids.add(inst.Order__c);
           system.debug('The value of installation order' + inst.Order__c);
       }
            system.debug('The size of orderids' +orderids.size() + 'And the value of orderids' +orderids);
       //Querying the order products based on Installation
       //List<Orderitem> oItems = [select id,Installation__c from OrderItem where installation__c in:installs];
       //system.debug('The orderitems are'+oItems);
       List<Position__c> positionItems = [Select id,Installation__c,Order__c from Position__c where Installation__c IN:installs];
       system.debug('The positionItems are'+ positionItems);
       //Querying the entitlements based on the order product
       // List<Entitlement> entitleList = [select id,Order__c,StartDate, Order_Product__c from Entitlement where Order_Product__c in:oItems];
            if(! orderids.isEmpty()){
        List<Entitlement> entitleList = [select id,Order__c,StartDate, Order_Product__c from Entitlement where Order__c in: orderids];       
        system.debug('The entitleList is::'+entitleList);
        List<Entitlement> updatingEntitlements = new lIST<Entitlement>(); //To update the entitlements
        for(Installation__c inst:installs){
            for(Entitlement ent:entitleList){
                if(actsMap.containskey(inst.Installer_Account__c) && inst.Installer_Account__c != null){
                    ent.Certified_Installer__c = true;
                    updatingEntitlements.add(ent);
                }
                else if(!(actsMap.containskey(inst.Installer_Account__c)) && inst.Installer_Account__c != null){
                    ent.Certified_Installer__c = false;
                    updatingEntitlements.add(ent);
                }
                else if(inst.Installer_Account__c == null){
                    ent.Certified_Installer__c = false;
                    updatingEntitlements.add(ent);
                }
            }
        }
        
        if(updatingEntitlements.size()>0){
                Database.SaveResult[] srList = Database.update(updatingEntitlements, false);
                ErrorLogUtility.processErrorLogs(srList, updatingEntitlements,'InstallationTriggerHandler','updateEntitlement','Entitlement','update');
           // update updatingEntitlements;
        }
       }*/
       
      // }catch(exception e){}
  } 
  //end of updateEntitlement method
  /*
             Method Name: changeInstaller
             Purpose: To handle change in Installer Contact Name for Installation
             Input Parameter : List of Installation
             Created Date: March 2017
             */
    public static void changeInstaller(List < Installation__c > newTrigger){
        set<Id> ConId = new set<Id>();
        for(Installation__c i:newTrigger){
            ConId.add(i.Installer_Contact__c);
        }
        System.debug('new installer contact'+conId);
       // list<Contact> conlist = [Select id,AccountId from Contact where id in:ConId Limit 1];
        list<User> usercon = [Select id,ContactId,Contact.AccountID from User where ContactId in:ConId Limit 1];
        //System.debug('contact'+conlist);
        System.debug('user'+usercon);
        for(Installation__c i:newTrigger){
            /*for(Contact c:conlist){
            i.Installer_Contact__c = c.id;
            i.Installer_Account__c = c.AccountID;
            }*/
            for(User u:usercon){
                if(i.installer_Contact__c == u.ContactID){
               //i.Installer_Contact__c = u.ContactId;
               i.Installer_Account__c = u.Contact.AccountID;
               i.Assigned_To__c = u.id;
               i.OwnerId = u.id;
                }
             }
        }
    }

     
}