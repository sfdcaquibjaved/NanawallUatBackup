/*************************************************************************\
    @ Author        : Nitish Kumar
    @ Date          : 25-June-2015
    @ Test File     : 
    @ Description   : This class is used to log errors. Inserts records in Error Log object
    @ Audit Trial   : Repeating block for each change to the code
  
****************************************************************************/
public class ErrorLogUtility {

    /*********************************************************************************************************************
   Method : processErrorLogs
   Input  : Database.SaveResult List, List<Sobject>, 3 Strings 
   Return Type : void 
   Desc   : Logs the Errors that occur while a Save operation is Executed
********************************************************************************************************************/

    public static void processErrorLogs(Database.SaveResult[] saveResult, List < Sobject > listOfObjects, String className, String methodName, String objectName, String operation) {

        // Temporary variables
        Database.Error err;
        List < Error_Logs__c > errorsList = new List < Error_Logs__c > ();
        Error_Logs__c el;
        // Loop over the results and find erorrs
        for (Integer count = 0; count < saveResult.size(); count++) {
            system.debug('In Success in processErrorLogs ' + saveResult[count].isSuccess());
            if (!saveResult[count].isSuccess()) {
                err = saveResult[count].getErrors()[0];
                el = new Error_Logs__c( Record_ID__c = listOfObjects[count].Id, Class_Name__c = className, Error_Description__c = (err.getMessage()).left(250), Object__c = objectName, Error_Status_Code__c = err.getStatusCode().name(), Method_Name__c = methodName, Operation__c = operation);
                errorsList.add(el);
            }
            // Reset temporary variables
            err = null;
        }
        if (!errorsList.isEmpty()) {
            Database.SaveResult[]
            sr = Database.insert(errorsList, false);
            ErrorLogUtility.processErrorLogs(sr, errorsList, 'ErrorLogUtility', 'processErrorLogs', 'Error_Logs__c', 'Insert');
        }

    }

    /*********************************************************************************************************************
   Method : processDeleteErrorLogs
   Input  : Database.DeleteResult List, List<Sobject>, 3 Strings 
   Return Type : void 
   Desc   : Logs the Errors that occur while a Delete operation is Executed
********************************************************************************************************************/

    public static void processDeleteErrorLogs(Database.DeleteResult[] deleteResult, List < Sobject > listOfObjects, String className, String methodName, String objectName, String operation) {

        // Temporary variables
        Database.Error err;
        List < Error_Logs__c > errorsDelList = new List < Error_Logs__c > ();
         errorsDelList.clear();
        Error_Logs__c el;
        // Loop over the results and find erorrs
        for (Integer count = 0; count < deleteResult.size(); count++) {
          system.debug('In Success in processDeleteErrorLogs ' + deleteResult[count].isSuccess());
            if (!deleteResult[count].isSuccess()) {
              
                err = deleteResult[count].getErrors()[0];
               // system.debug('In processDeleteErrorLogs' + err.getMessage());
                el = new Error_Logs__c(Record_ID__c = listOfObjects[count].Id, Class_Name__c = className, Error_Description__c = (err.getMessage()).left(250), Object__c = objectName, Error_Status_Code__c = err.getStatusCode().name(), Method_Name__c = methodName, Operation__c = operation);
                errorsDelList.add(el);
            }
            // Reset temporary variables
            err = null;
        }
        if (!errorsDelList.isEmpty()) {
            Database.SaveResult[]
            sr = Database.insert(errorsDelList, false);
            ErrorLogUtility.processErrorLogs(sr, errorsDelList, 'ErrorLogUtility', 'processDeleteErrorLogs', 'Error_Logs__c', 'Insert');
        }

    }
    
     /*********************************************************************************************************************
   Method : processUpsertErrorLogs
   Input  : Database.UpsertResult List, List<Sobject>, 3 Strings 
   Return Type : void 
   Desc   : Logs the Errors that occur while a upsert operation is Executed
********************************************************************************************************************/

    public static void processUpsertErrorLogs(Database.UpsertResult[] upsertResult, List < Sobject > listOfObjects, String className, String methodName, String objectName, String operation) {

        // Temporary variables
        Database.Error err;
        List < Error_Logs__c > errorsList = new List < Error_Logs__c > ();
        Error_Logs__c el;
        // Loop over the results and find erorrs
        for (Integer count = 0; count < upsertResult.size(); count++) {
            if (!upsertResult[count].isSuccess()) {
                err = upsertResult[count].getErrors()[0];
                el = new Error_Logs__c(Record_ID__c = listOfObjects[count].Id, Class_Name__c = className, Error_Description__c = (err.getMessage()).left(250), Object__c = objectName, Error_Status_Code__c = err.getStatusCode().name(), Method_Name__c = methodName, Operation__c = operation);
                errorsList.add(el);
            }
            // Reset temporary variables
            err = null;
        }
        if (!errorsList.isEmpty()) {
            Database.SaveResult[]
            sr = Database.insert(errorsList, false);
            ErrorLogUtility.processErrorLogs(sr, errorsList, 'ErrorLogUtility', 'processErrorLogs', 'Error_Logs__c', 'Insert');
        }

    }

}