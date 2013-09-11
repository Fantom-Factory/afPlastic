
internal class TestDocExample : PlasticTest {
	
	Void testDocExample() {
		model 	:= PlasticClassModel("MyClass", true)
		model.addMethod(Str#, "hello", "Str name", """ "Hello \${name}!" """)
		myClass	:= PlasticCompiler().compileModel(model)
		
		// --> Hello Mum!
		mum	:= myClass.make->hello("Mum")
		verifyEq(mum, "Hello Mum!")
	}
}
