@isTest
public class testnroppTeamController {
    static testmethod void oppteam(){
        profile p = [select id from Profile where name = 'Standard User'];
        test.startTest();
        UserRole ur = new UserRole(Name = 'Finance');
	    insert ur;
        User u = new User(alias = 'testme', email = 'testme@noemail.com', emailencodingkey = 'UTF-8', lastname = 'test', languagelocalekey = 'en_US',
            localesidkey = 'en_US', profileid = p.Id,userroleid = ur.id, country = 'United Kingdom', timezonesidkey = 'Europe/London', username = 'testme@noemail.com');
        insert u;
        test.stopTest();
    }
}