public with sharing class JunkTest {
	static string GetJunk() {
		return 'junk 2';
	}
	static void CallJunk() {
		GetJunk();		 
	} 
	static void runmoretests3() {
		GetJunk();		
	}
	static void runmoretests4() {
		GetJunk();		
	}
	static void runmoretests5() {
		GetJunk();		
	}
	static void runmoretests6() {
		GetJunk();		
	}
	static void runmoretests7() {
		GetJunk();		
	}	
	static void runmoretests8() {
		GetJunk();		
	}
	static void runmoretests9() {
		GetJunk();		 
	}					
	static void runmoretests10() {
		GetJunk();		
	}
	@isTest(SeeAllData=false)
	static  void RunTests () {
		JunkTest.CallJunk(); 
//	 	JunkTest.runmoretests();
//	 	JunkTest.runevenmoreteests();
	 	JunkTest.runmoretests3();
	 	JunkTest.runmoretests4();
	 	JunkTest.runmoretests5();
	 	JunkTest.runmoretests6();
	 	JunkTest.runmoretests7();
	 	JunkTest.runmoretests8();
	 	JunkTest.runmoretests9();
	 	JunkTest.runmoretests10();
//		JunkTest_2.CallMoreJunk();
	}
	
}