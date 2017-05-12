global class Multiple_Upload_Controller {
    public string recrdId {
        get;
        set;
    }
    public Multiple_Upload_Controller() {

    }
    @RemoteAction
    global static String attachBlob(String parentId, String attachmentId, String fileName, String valuetosend, String contentType, String base64BlobValue) {
            /*
            parentId: The sfdc object Id this file will be attached to
            attachmentId: The record of the current Attachment file being processed
            fileName: Name of the attachment
            contentTye: Content Type of the file being attached
            base64BlobValue: Base64 encoded string of the file piece currently processing
            */

            //If recordId is blank this is the first part of a multi piece upload

            Integer totalchunks = Integer.valueof(valuetosend) - 1;
            System.debug('byteChunkArray' + totalchunks);
            if (attachmentId == '' || attachmentId == null) {
                System.debug('attachmentID' + attachmentId);
                /*ContentVersion att = new ContentVersion(
                    // data fields
                    pathonclient = '/'+ filename,
                    VersionData = EncodingUtil.Base64Decode(base64BlobValue),
                    Title = 'INS_'+fileName
          );*/
                Attachment att = new Attachment();
                if (totalchunks == 0) {
                    att.ParentId = parentId;
                    att.Name = 'INS_Complete' + filename;
                    att.Body = EncodingUtil.Base64Decode(base64BlobValue);

                } else {
                    att.ParentId = parentId;
                    att.Name = 'INS_' + filename;
                    att.Body = EncodingUtil.Base64Decode(base64BlobValue);

                }
                try {
                    insert att;
                    System.debug('Success!');
                } catch (Exception e) {
                    System.debug('Failed' + e);
                }
                system.debug('I am here with att' + att);
                //system.debug('ContentDocumentId' +att.ContentDocumentId);
                //           ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.INFO, att.Title + ' File uploaded successfully'));



                /*ContentDocumentLink CDL = new ContentDocumentLink(
                                    linkedEntityId = parentId ,
                                    ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: att.Id].ContentDocumentId ,
                                     shareType = 'V',
                                     visibility = 'AllUsers'
                    
                ) ; */
                //system.debug('I am here with CDL' +CDL);
                //insert CDL ;


                //Return the new file Id 
                return att.id;
            } else {
                for (Attachment atm: [select Id, Name, Body from Attachment where Id =: attachmentId]) {
                    //Take the body of the current attachment, convert to base64 string, append base64 value sent from page, then convert back to binary for the body
                   
                    if (totalchunks > 0) {
                        System.debug('totalchunks' + totalchunks);
                        atm.name = 'INS_' + fileName;
                        atm.Body = EncodingUtil.Base64Decode(EncodingUtil.Base64Encode(atm.Body) + base64BlobValue);

                            // update new Attachment(Id = attachmentId, Name = 'INS_'+fileName,Body = EncodingUtil.Base64Decode(EncodingUtil.Base64Encode(atm.Body) + base64BlobValue));
                        }
                        else if (totalchunks == 0) {
                            atm.name = 'INS_Complete' + fileName;
                            atm.Body = EncodingUtil.Base64Decode(EncodingUtil.Base64Encode(atm.Body) + base64BlobValue); 
                            System.debug('totalchunks' + totalchunks);
                                //update new Attachment(Id = attachmentId, Name = 'INS_Complete'+fileName,Body = EncodingUtil.Base64Decode(EncodingUtil.Base64Encode(atm.Body) + base64BlobValue));
                            }
                            update atm;
                        }

                        //Return the Id of the attachment we are currently processing
                        //return attachmentId;
                        return attachmentId;
                    }

                }
            }