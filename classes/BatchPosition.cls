/*************************************************************************\
    @ Author        : Absyz Software Consulting Pvt. Ltd.
    @ Date          : January-2017
    @ Description   : Batch Class to add Positions on Installations
    @ Audit Trial   : 
    @ Test Class    : 
    @ Last Modified Date : 18-Jan-2017
  
****************************************************************************/
global class BatchPosition implements Database.Batchable < sObject > {
    
     String query;

    // Start Method of Batch class 
    global Database.querylocator start(Database.BatchableContext BC) {
    
        Query = 'SELECT ID , Quote_Name__c FROM INSTALLATION__c WHERE NUMBER_OF_POSITIONS__C = 0 AND Quote_Name__c != Null ';
        system.debug('Value of Query' + Query);
        return Database.getQueryLocator(query);
        
    }
    
     //Execute Method of Batch class
    global void execute(Database.BatchableContext BC, List < Installation__c > ins) {
      	system.debug('Value of INS' +ins);
        Set<ID> setQuoteID = new Set<ID> () ;
        
        for(Installation__c i : ins){
            	if(i.Quote_Name__c != null){
        			setQuoteID.add(i.Quote_Name__c) ;
        
           		 } 
        }
        
         list<Quote_Detail__c> lstQuoteDetail = 
			[SELECT ActiveSide_Description__c,ActiveSide_Notes__c,ActiveSide__c,Aluminum_Description__c,Aluminum_Lookup_Price__c,Aluminum_Notes__c,Aluminum_Quoted_Price__c,Aluminum__c,AngleChanges_Description__c,AngleChanges_Lookup_Price__c,AngleChanges_Notes__c,AngleChanges_Quoted_Price__c,AngleChanges__c,Base_Lookup_Price__c,Base_Quoted_Price__c,BottomRail_Description__c,BottomRail_Notes__c,BottomRail__c,CEROType_Description__c,CEROType_Name__c,CEROType_Quoted_Price__c,Choice_Info__c,Code__c,Configuration_Notes__c,Configuration__c,ConnectionReceivedId,ConnectionSentId,CornerFinish_Description__c,CornerFinish_Notes__c,CornerFinish__c,CPD__c,CreatedById,CreatedDate,CustodialHardware_Description__c,CustodialHardware_Lookup_Price__c,CustodialHardware_Notes__c,CustodialHardware_Quoted_Price__c,CustodialHardware__c,Direction_Description__c,Direction_Notes__c,Direction__c,Discount__c,Extended_Subtotal__c,Florida_Approved__c,FoldFlat_Description__c,FoldFlat_Notes__c,FoldFlat__c,GlazingDesignation_Description__c,GlazingDesignation_Notes__c,GlazingDesignation__c,Glazing_Description__c,Glazing_Lookup_Price__c,Glazing_Notes__c,Glazing_Override__c,Glazing_Price__c,Glazing_Quoted_Price__c,Glazing__c,HandleFinish_Description__c,HandleFinish_Notes__c,HandleFinish__c,HandleLeftRight_Description__c,HandleLeftRight_Name__c,HandleLeftRight_Quoted_Price__c,HandleLeft_Description__c,HandleLeft_Name__c,HandleLeft_Quoted_Price__c,HandleRight_Description__c,HandleRight_Name__c,HandleRight_Quoted_Price__c,HardwareColor_Description__c,HardwareColor_Notes__c,HardwareColor__c,HardwareHeight_Description__c,HardwareHeight_Notes__c,HardwareHeight__c,Hardware_Description__c,Hardware_Lookup_Price__c,Hardware_Notes__c,Hardware_Quoted_Price__c,Hardware__c,Height_Denominator__c,Height_Feet__c,Height_Inches__c,Height_MM__c,Height_Numerator__c,Height__c,HingeFinish_Description__c,HingeFinish_Notes__c,HingeFinish__c,HingePin_Description__c,HingePin_Notes__c,HingePin__c,HingeType_Description__c,HingeType_Notes__c,HingeType__c,Id,IncorpSwingDoor_Description__c,IncorpSwingDoor_Lookup_Price__c,IncorpSwingDoor_Notes__c,IncorpSwingDoor_Quoted_Price__c,IncorpSwingDoor__c,IsDeleted,Kickplate_Description__c,Kickplate_Lookup_Price__c,Kickplate_Notes__c,Kickplate_Quoted_Price__c,Kickplate__c,LastActivityDate,LastModifiedById,LastModifiedDate,LeftStack_Description__c,LeftStack_Notes__c,LeftStack__c,Lites_Description__c,Lites_Lookup_Price__c,Lites_Notes__c,Lites_Quoted_Price__c,Lites__c,Local_Production_Time_Per_Panel__c,Manufacturer__c,Metric_UValue__c,Model__c,Mounting_Description__c,Mounting_Notes__c,Mounting_Performance__c,Mounting__c,Name,NDG_Drawing_Link__c,Negative_Windload__c,NFRC__c,Order_Finalized_Date__c,Order_Number__c,Panels__c,ParkingBay_Description__c,ParkingBay_Lookup_Price__c,ParkingBay_Notes__c,ParkingBay_Quoted_Price__c,ParkingBay__c,Performance_Description__c,Position_Discount__c,Position_Subtotal__c,Position__c,Positive_Windload__c,Price__c,Quote_Detail_ID__c,Quote__c,ReinforcedLocking_Description__c,ReinforcedLocking_Lookup_Price__c,ReinforcedLocking_Quoted_Price__c,ReinforcedLocking__c,RightStack_Description__c,RightStack_Notes__c,RightStack__c,Sales_Rep__c,ScreenFinish_Description__c,ScreenFinish_Notes__c,ScreenFinish__c,ScreenOneConfiguration_Description__c,ScreenOneConfiguration_Name__c,ScreenOneFinish_Description__c,ScreenOneFinish_Name__c,ScreenOneFinish_Quoted_Price__c,ScreenOneMesh_Description__c,ScreenOneMesh_Name__c,ScreenOneMesh_Quoted_Price__c,ScreenOneNumber_Description__c,ScreenOneNumber_Name__c,ScreenOneNumber_Quoted_Price__c,ScreenType_Description__c,ScreenType_Lookup_Price__c,ScreenType_Notes__c,ScreenType_Quoted_Price__c,ScreenType__c,Screen_Description__c,Screen_Notes__c,Screen__c,SHGC_Label__c,SHGC__c,SillColor_Description__c,SillColor_Notes__c,SillColor__c,Sill_Description__c,Sill_Lookup_Price__c,Sill_Notes__c,Sill_Performance__c,Sill_Quoted_Price__c,Sill__c,SlidingPanel_Description__c,SlidingPanel_Name__c,SlidingPanel_Quoted_Price__c,Socket_Description__c,Socket_Name__c,Socket_Quoted_Price__c,SpacerBar_Description__c,SpacerBar_Notes__c,SpacerBar__c,StackingDirection_Description__c,StackingDirection_Notes__c,StackingDirection__c,Stile_Description__c,Stile_Lookup_Price__c,Stile_Notes__c,Stile_Quoted_Price__c,Stile__c,SwingDoorHinge_Description__c,SwingDoorHinge_Notes__c,SwingDoorHinge__c,SwingPanelWidth_Description__c,SwingPanelWidth_Name__c,SwingPanelWidth_Quoted_Price__c,SwingPanel_Name__c,SwingPanel_Quoted_Price__c,SystemModstamp,TinderBoxEmbedCode__c,TotalPanels_LocalProductionTime__c,Total_Panels__c,Units__c,Unit_Base_Price__c,Unit_Subtotal__c,UValue_Label__c,UValue__c,Visible_Transmittance__c,Weight__c,Width_Denominator__c,Width_Feet__c,Width_Inches__c,Width_MM__c,Width_Numerator__c,Width__c,WistiaContentID__c,WoodFinish_Description__c,WoodFinish_Lookup_Price__c,WoodFinish_Notes__c,WoodFinish_Quoted_Price__c,WoodFinish__c,Wood_Description__c,Wood_Lookup_Price__c,Wood_Notes__c,Wood_Quoted_Price__c,Wood__c FROM Quote_Detail__c WHERE Quote__c IN: setQuoteID
        ] ;
        list<Position__c> lstPosition = new list<Position__c>();
        
         if(lstQuoteDetail.size() > 0 ){
        for (Quote_Detail__c q : lstQuoteDetail){
            
                for(Installation__c i : ins){
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
    
     global void finish(Database.BatchableContext BC) {

    }

}