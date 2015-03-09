
internal class TestPlasticMethods : PlasticTest {

	Void testJavaMethods() {
		plasticModel := PlasticClassModel("TestImpl", false)
		plasticModel.extend(T_PlasticService17#)
		plasticModel.overrideMethod(T_PlasticService17#getDate1, "null")
		plasticModel.overrideMethod(T_PlasticService17#getDate2, "null")
		myClass	:= PlasticCompiler().compileModel(plasticModel)
	}	
}

