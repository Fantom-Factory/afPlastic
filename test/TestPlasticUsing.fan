
internal class TestPlasticUsingModel : PlasticTest {

	Void testUsingErr() {
		verifyPlasticErrMsg("UsingStr 'using dude' must not start with 'using'") |->| {
			plasticModel := PlasticUsingModel("using dude")
		}
	}

	Void testUsingStr() {
		model := PlasticUsingModel("dude")
		verifyEq(model.toFantomCode, "using dude\n")
	}

	Void testUsingPod() {
		model := PlasticUsingModel(this.typeof.pod)
		verifyEq(model.toFantomCode, "using afPlastic\n")
	}

	Void testUsingType() {
		model := PlasticUsingModel(this.typeof)
		verifyEq(model.toFantomCode, "using afPlastic::TestPlasticUsingModel\n")
	}

	Void testUsingTypeAs() {
		model := PlasticUsingModel(this.typeof, "Dude")
		verifyEq(model.toFantomCode, "using afPlastic::TestPlasticUsingModel as Dude\n")
	}
	
	Void testEquals() {
		list := [PlasticUsingModel(this.typeof, "Dude"), PlasticUsingModel("afPlastic::TestPlasticUsingModel as Dude")]
		verifyEq(list.unique.size, 1)
	}
	
}
