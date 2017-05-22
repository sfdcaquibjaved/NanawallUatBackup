public class demolist 
{
	list<account> demo =[select id, name,(select name,  Purchaser_Account__C from Projects4__r where Purchaser_Account__C='001A000001Ledoc' ) from account where parent.id='001A000001Ledoc'];
}