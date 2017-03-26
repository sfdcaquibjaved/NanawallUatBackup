public with sharing class URLTokenizer {

    public string urlString{ get; set; }
    
    public pagereference tokenizeURL() {
        
        urlString = Encodingutil.urlDecode( ApexPages.currentPage().getParameters().get('url'), 'utf-8' );
        system.debug('URL1'+ urlstring);
        DateTime now = DateTime.now();
        now = now.addHours(7); //add 7 hours to get us to UTC .. this will be a problem around daylight savings but the GMT stuff was being super weird
        string timeString = now.format('yyyyMMddHHmmss');
        
        string hash = '';
        Blob b = Crypto.generateMac('HMacSHA1', Blob.valueOf(timeString ), Blob.valueOf('nanaenc-2.0') );
        string base64 = EncodingUtil.base64Encode(b).replace('+','|plus|');
        hash = EncodingUtil.urlEncode(base64, 'UTF-8');
         system.debug('HASH'+ hash);
        urlString += '&t='+timeString+'&tk='+hash;
         system.debug('URL2'+ urlstring);
    
        
     //return null;    
        return new PageReference(urlString);
    }
}