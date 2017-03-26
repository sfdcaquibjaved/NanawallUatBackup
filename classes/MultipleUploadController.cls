public class MultipleUploadController
{   
    //Picklist of tnteger values to hold file count
   // public List<SelectOption> filesCountList {get; set;}
    //Selected count
    // the parent object it
   public Id sobjId {get; set;}
    
    // list of existing attachments - populated on demand
    public List<Attachment> attachments;
    
    // list of new attachments to add
    public List<Attachment> newAttachments {get; set;}
    
    // the number of new attachments to add to the list when the user clicks 'Add More'
    public static final Integer NUM_ATTACHMENTS_TO_ADD=9;
    // constructor
    public MultipleUploadController()
  {
        // instantiate the list with a single attachment
        newAttachments=new List<Attachment>{new Attachment(),new Attachment(),new Attachment(),new Attachment(),
            new Attachment(),new Attachment(),new Attachment(),new Attachment(),new Attachment(),new Attachment()};
            
       
    }   
    
    // retrieve the existing attachments
    public List<Attachment> getAttachments()
    {
        // only execute the SOQL if the list hasn't been initialised
        if (null==attachments)
        {
            attachments=[select Id, ParentId, Name, Description from Attachment where parentId=:sobjId];
        }
        
        return attachments;
    }

    // Add more attachments action method
    
    // Save action method
    public void SaveAttachments()
    {
        List<Attachment> toInsert=new List<Attachment>();
        for (Attachment newAtt : newAttachments)
        {
            if (newAtt.Body!=null)
            {
                newAtt.parentId=sobjId;
                toInsert.add(newAtt);
            }
        }
        if(toInsert.size() > 0){
        insert toInsert;
        ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.INFO, toInsert.size() + ' file(s) uploaded successfully'));

        }
        else{
         ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.ERROR,'Please select at-least one file'));  
        }
        newAttachments.clear();
        for (Integer idx=0; idx<=NUM_ATTACHMENTS_TO_ADD; idx++){
        newAttachments.add(new Attachment());
        }
        // null the list of existing attachments - this will be rebuilt when the page is refreshed
        attachments=null;
    }
}