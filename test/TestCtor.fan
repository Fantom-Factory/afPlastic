
internal class TestCtor : PlasticTest {
	
	Void testCtor() {
		model 	:= PlasticClassModel("MyClass", false)
		model.addField(Str#, "judge")
		model.addCtor("makeWithJudge", "Str judge", "this.judge = judge")
		
		myClass	:= PlasticCompiler().compileModel(model)
		
		// --> Hello Mum!
		mum	:= myClass.method("makeWithJudge").call("dredd")
		verifyEq(mum->judge, "dredd")
	}
}
