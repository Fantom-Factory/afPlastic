
internal class TestDocExample : PlasticTest {
	
	Void testDocExample() {
		model 	:= PlasticClassModel("MyClass", true)
		model.addMethod(Str#, "greet", "Str name", """ "Hello \${name}!" """)
		
		myClass	:= PlasticCompiler().compileModel(model)
		
		// --> Hello Mum!
		mum	:= myClass.make->greet("Mum")
		verifyEq(mum, "Hello Mum!")
	}
}
