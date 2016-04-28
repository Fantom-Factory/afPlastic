
abstract internal class PlasticTest : Test {
	
	Void verifyPlasticErrMsg(Str errMsg, |Obj| func) {
		verifyErrMsg(PlasticErr#, errMsg, func)
	}

}
