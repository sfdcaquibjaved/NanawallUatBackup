public class FlexObjController {

	public FlexObjController() {
		
	}
	
	public String GetMySessionId() {
		return UserInfo.getSessionId();
	}

	public string getServerURL () {
		return ApexPages.currentPage().getHeaders().get('Host');
	}
}