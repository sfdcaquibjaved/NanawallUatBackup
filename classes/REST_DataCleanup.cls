@RestResource(urlMapping='/DataCleanup/*')
global with sharing class REST_DataCleanup {
    
    @HttpGet
    global static string cleanupPerformanceLabels() {


        return 'ok response';
    }
}