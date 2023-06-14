
internal class TestPlasticFields : PlasticTest {

// const fields need not be const if they're synthetic
//	Void testFieldsForConstTypeMustByConst() {
//		plasticModel := PlasticClassModel("TestImpl", true)
//		plasticModel.extendMixin(T_PlasticService01#)
//		verifyErrMsg(PlasticMsgs.constTypesMustHaveConstFields("TestImpl", T_PlasticService02#, "wotever")) {
//			plasticModel.addField(T_PlasticService02#, "wotever")
//		}
//	}

	// fields can not be const if they're synthetic
	Void testSytheticFieldsForConstTypeAreNotConst() {
		plasticModel := PlasticClassModel("TestImpl", true)
		fieldModel 	 := plasticModel.addField(Str#, "_af_eval", "throw Err()", "echo(it)")
		verifyFalse(fieldModel.toFantomCode(TypeCache()).contains("const"))
	}

	Void testOverrideFieldsMustBelongToSuperType() {
		plasticModel := PlasticClassModel("TestImpl", true)
		plasticModel.extend(T_PlasticService01#)
		verifyPlasticErrMsg("Field sys::Int.minVal does not belong to super type sys::Obj, afPlastic::T_PlasticService01") |->| {
			plasticModel.overrideField(Int#minVal, "wotever")
		}
	}
	
	Void testOverrideFieldsMustHaveProtectedScope() {
		plasticModel := PlasticClassModel("TestImpl", false)
		plasticModel.extend(T_PlasticService07#)
		verifyPlasticErrMsg("Field afPlastic::T_PlasticService07.oops must have 'public' or 'protected' scope") |->| {
			plasticModel.overrideField(T_PlasticService07#oops, "wotever")
		}
	}

	Void testGetSetAndInit() {
		plasticModel := PlasticClassModel("TestImpl", false)
		f := plasticModel.addField(Str#, "str", "&str", "&str = it")
		f.initValue = "\"Dude\""
		myClass	:= PlasticCompiler().compileModel(plasticModel)
	}

	Void testJavaFields() {
		plasticModel := PlasticClassModel("TestImpl", false)
		plasticModel.extend(T_PlasticService16#)
		plasticModel.overrideField(T_PlasticService16#jdate1, "null")
		plasticModel.overrideField(T_PlasticService16#jdate2, "null")
		myClass	:= PlasticCompiler().compileModel(plasticModel)
	}	
}

