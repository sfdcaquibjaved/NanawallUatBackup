@IsTest
public class CaseOwnerTest {
 public static List < Case > olstTestCase;
    static testmethod void testmethod1() {
        olstTestCase=TestDataUtility.createCaseTestData();
        olstTestCase[0].Origin='Email';
        olstTestCase[0].Status='New';
        olstTestCase[0].Priority='Medium';
        olstTestCase[0].Subject='Test';
        olstTestCase[0].Description='Test Description';
        insert olstTestCase;
        CaseOwner.ChangeOwner(olstTestCase);
    }
}