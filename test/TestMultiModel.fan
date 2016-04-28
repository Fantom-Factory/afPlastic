
internal class TestMultiModel : PlasticTest {
	
	Void testSingle() {
		model1 	:= PlasticClassModel("Mum", true)
		model1.addMethod(Str#, "greet", "", """ "Hello Mum!" """)
		model1.usingStr("concurrent")
		
		types	:= PlasticCompiler().compileModels([model1])

		verifyEq(types[0].make->greet, "Hello Mum!")		
	}

	Void testDouble() {
		model1 	:= PlasticClassModel("Mum", true)
		model1.addMethod(Str#, "greet", "", """ "Hello Mum!" """)
		model1.usingStr("concurrent")

		model2 	:= PlasticClassModel("Dad", true)
		model2.addMethod(Str#, "greet", "", """ "Hello Dad!" """)
		model2.usingStr("concurrent")
		
		types	:= PlasticCompiler().compileModels([model1, model2])

		verifyEq(types[0].make->greet, "Hello Mum!")		
		verifyEq(types[1].make->greet, "Hello Dad!")		
	}
	
}
