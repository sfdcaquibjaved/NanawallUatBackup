public class MultipleUploadController
{   
    //Picklist of tnteger values to hold file count
    public List<SelectOption> filesCountList {get; set;}
    //Selected count
    public String FileCount {get; set;}
    
    public List<Attachment> allFileList {get; set;}
    
    public MultipleUploadController(ApexPages.StandardController controller)
    {
        //Initialize  
        filesCountList = new List<SelectOption>() ;
        FileCount = '' ;
        allFileList = new List<Attachment>() ;
        
        //Adding values count list - you can change this according to your need
        for(Integer i = 0 ; i < 11 ; i++)
            filesCountList.add(new SelectOption(''+i , ''+i)) ;
    }
    
    public Pagereference SaveAttachments()
    {
        String insId = System.currentPagereference().getParameters().get('id');
        if(insId == null || insId == '')
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.ERROR,'No record is associated. Please pass record Id in parameter.'));
        if(FileCount == null || FileCount == '')
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.ERROR,'Please select how many files you want to upload.'));

        List<Attachment> listToInsert = new List<Attachment>() ;
        System.debug('File list'+allFileList);
        //Attachment a = new Attachment(parentId = accid, name=myfile.name, body = myfile.body);

        for(Attachment a: allFileList)
        {
            if(a.name != '' && a.name != '' && a.body != null)
                listToInsert.add(new Attachment(parentId = insId , name = a.name, body = a.body)) ;
                System.debug('body'+a.body);

        }
        allFileList.clear();
        System.debug('the list'+listToInsert);
        //Inserting attachments
        if(listToInsert.size() > 0)
        {
            insert listToInsert ;
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.INFO, listToInsert.size() + ' file(s) are uploaded successfully'));
            FileCount = '' ;
        }
        else
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.ERROR,'Please select at-least one file'));
            
        return null;
    }
    
    public PageReference ChangeCount()
    {
        allFileList.clear() ;
        //Adding multiple attachments instance
        for(Integer i = 1 ; i <= Integer.valueOf(FileCount) ; i++)
            allFileList.add(new Attachment()) ;
        return null ;
    }
}