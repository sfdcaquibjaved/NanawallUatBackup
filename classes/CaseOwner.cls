/*
Apex Class Name: CaseOwner
Purpose: Changing default owner for email to case functionality
Trigger associated with : CaseTrigger
*/
public class CaseOwner {

// Purpose: Change the owner of the case in email to case functionality

    public static void ChangeOwner(List < Case > newTrigger) {
        Group g = [Select Id from Group where name =: 'Email2Case'
            Limit 1
        ];


        for (
            case newCase:
                newTrigger) {
            if (newCase.Origin == 'Email') {
              newCase.OwnerId = g.id;
			
            }


        }

    }
}