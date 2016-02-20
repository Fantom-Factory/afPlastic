using [java] java.util::Date as jDate

internal class TestPlasticClass : PlasticTest {
	
	Void testNonConstProxyCannotOverrideConst() {
		plasticModel := PlasticClassModel("TestImpl", false)
		verifyPlasticErrMsg(PlasticMsgs.nonConstTypeCannotSubclassConstType("TestImpl", T_PlasticService01#)) |->| {
			plasticModel.extend(T_PlasticService01#)
		}
	}

	Void testConstProxyCannotOverrideNonConst() {
		plasticModel := PlasticClassModel("TestImpl", true)
		verifyPlasticErrMsg(PlasticMsgs.constTypeCannotSubclassNonConstType("TestImpl", T_PlasticService02#)) |->| {
			plasticModel.extend(T_PlasticService02#)
		}
	}

	Void testOverrideMethodsMustBelongToSuperType() {
		plasticModel := PlasticClassModel("TestImpl", true)
		plasticModel.extend(T_PlasticService01#)
		verifyPlasticErrMsg(PlasticMsgs.overrideMethodDoesNotBelongToSuperType(Int#abs, [Obj#, T_PlasticService01#])) |->| {
			plasticModel.overrideMethod(Int#abs, "wotever")
		}
	}

	Void testOverrideMethodMayExistInMixinChain() {
		plasticModel := PlasticClassModel("TestImpl", true)
		plasticModel.extend(T_PlasticService10#)
		plasticModel.overrideMethod(T_PlasticService09#deeDee, "wotever")
	}

	Void testOverrideMethodsMustHaveProtectedScope() {
		plasticModel := PlasticClassModel("TestImpl", false)
		plasticModel.extend(T_PlasticService05#)
		verifyPlasticErrMsg(PlasticMsgs.overrideMethodHasWrongScope(T_PlasticService05#oops)) |->| {
			plasticModel.overrideMethod(T_PlasticService05#oops, "wotever")
		}
	}

	Void testOverrideMethodsMustBeVirtual() {
		plasticModel := PlasticClassModel("TestImpl", false)
		plasticModel.extend(T_PlasticService06#)
		verifyPlasticErrMsg(PlasticMsgs.overrideMethodsMustBeVirtual(T_PlasticService06#oops)) |->| {
			plasticModel.overrideMethod(T_PlasticService06#oops, "wotever")
		}
	}

	Void testCanNotGuessDefaultParamValue1() {
		plasticModel := PlasticClassModel("TestImpl", false)
		plasticModel.extend(T_PlasticService14#)
		verifyPlasticErrMsg(PlasticMsgs.overrideMethodsCanNotHaveDefaultValues(T_PlasticService14#obj, T_PlasticService14#obj.params.first)) |->| {
			plasticModel.overrideMethod(T_PlasticService14#obj, "wotever")			
		}
	}
	
	Void testCanNotGuessDefaultParamValue2() {
		plasticModel := PlasticClassModel("TestImpl", false)
		plasticModel.extend(T_PlasticService15#)
		verifyPlasticErrMsg(PlasticMsgs.overrideMethodsCanNotHaveDefaultValues(T_PlasticService15#obj, T_PlasticService15#obj.params.first)) |->| {
			plasticModel.overrideMethod(T_PlasticService15#obj, "wotever")
		}
	}
	
	Void testCanNotGuessDefaultParamValue3() {
		plasticModel := PlasticClassModel("TestImpl", false)
		plasticModel.extend(T_PlasticService18#)
		plasticModel.overrideCtor(T_PlasticService18#makeStuff, "wotever")

		meth := plasticModel.ctors.find { it.name == "makeStuff" }
		verifyEq(meth.superCtor, """super.makeStuff(sys::Str judge := "Fred")""")
	}
	
	Void testDefaultParamGuessing() {
		plasticModel := PlasticClassModel("TestImpl", false)
		plasticModel.extend(T_PlasticService13#)
		plasticModel.overrideMethod(T_PlasticService13#bool, 		"return bool")
		plasticModel.overrideMethod(T_PlasticService13#checked, 	"return checked")
		plasticModel.overrideMethod(T_PlasticService13#nullable, 	"return obj")
		plasticModel.overrideMethod(T_PlasticService13#int, 		"return int")
		plasticModel.overrideMethod(T_PlasticService13#str, 		"return str")
		plasticModel.overrideMethod(T_PlasticService13#listInt,		"return ints")
		plasticModel.overrideMethod(T_PlasticService13#listStr,		"return strs")
		plasticModel.overrideMethod(T_PlasticService13#map,			"return map")
		plasticModel.overrideMethod(T_PlasticService13#objCtor,		"return obj")
		
		p13 := PlasticCompiler().compileModel(plasticModel).make as T_PlasticService13
		
		verifyEq(p13.bool, 		false)
		verifyEq(p13.checked,	true)
		verifyEq(p13.nullable,	null)
		verifyEq(p13.int,		0)
		verifyEq(p13.str,		"")
		verifyEq(p13.listInt,	Int[,])
		verifyEq(p13.listStr,	Str[,])
		verifyEq(p13.map,		Int:Str[:])
		verifyEq(p13.objCtor.typeof,	T_PlasticService04#)
	}
	
	Void testConstTypeCanHaveFields() {
		plasticModel := PlasticClassModel("TestImpl", true)
		plasticModel.addField(Str#, "wotever")
	}

	// @see http://fantom.org/sidewalk/topic/2216
	Void testUnnecessaryMixinsAreNotAdded() {
		plasticModel := PlasticClassModel("TestImpl", true)
		plasticModel.extend(T_PlasticService12#)
		plasticModel.extend(T_PlasticService11#)
		verifyEq(plasticModel.mixins.size, 1)
		verifyEq(plasticModel.mixins.first, T_PlasticService12#)
	}

	// @see http://fantom.org/sidewalk/topic/2216
	Void testLowerOrderMixinsAreRemoved() {
		plasticModel := PlasticClassModel("TestImpl", true)
		plasticModel.extend(T_PlasticService11#)
		plasticModel.extend(T_PlasticService12#)
		verifyEq(plasticModel.mixins.size, 1)
		verifyEq(plasticModel.mixins.first, T_PlasticService12#)
	}

	// @see http://fantom.org/sidewalk/topic/2216
	Void testMixinsAreNotDuped() {
		plasticModel := PlasticClassModel("TestImpl", true)
		plasticModel.extend(T_PlasticService11#)
		plasticModel.extend(T_PlasticService11#)
		verifyEq(plasticModel.mixins.size, 1)
		verifyEq(plasticModel.mixins.first, T_PlasticService11#)
	}
}

@NoDoc
const mixin T_PlasticService01 { }

@NoDoc
mixin T_PlasticService02 { }

@NoDoc
mixin T_PlasticService03 { }

@NoDoc
class T_PlasticService04 { }

@NoDoc
mixin T_PlasticService05 { 
	internal abstract Str oops()
}

@NoDoc
mixin T_PlasticService06 { 
	Str oops() { "oops" }
}

@NoDoc
mixin T_PlasticService07 { 
	internal abstract Str oops
}

@NoDoc
const mixin T_PlasticService09 {
	abstract Void deeDee()
}

@NoDoc
const mixin T_PlasticService10 : T_PlasticService09 { }

@NoDoc
const mixin T_PlasticService11 { }

@NoDoc
const mixin T_PlasticService12 : T_PlasticService11 { }

@NoDoc
mixin T_PlasticService13 {
	abstract Obj? bool(Bool bool := false)
	abstract Obj? checked(Bool checked := true)
	abstract Obj? nullable(Int? obj := null)
	abstract Obj? int(Int int := 0)
	abstract Obj? str(Str str := Str.defVal)
	abstract Obj? listInt(Int[] ints := [,])
	abstract Obj? listStr(Str[] strs := Str#.emptyList)
	abstract Obj? map(Int:Str map := [:])
	abstract Obj? objCtor(T_PlasticService04 obj := T_PlasticService04())
}

@NoDoc
mixin T_PlasticService14 { 	
	abstract Obj? obj(Obj obj := 69)
}

@NoDoc
class T_PlasticService08 { 	
	new make(Int wotever) { }
}

@NoDoc
mixin T_PlasticService15 { 	
	abstract Obj? obj(T_PlasticService08 obj := T_PlasticService08(3))
}

@NoDoc
mixin T_PlasticService16 { 	
	abstract jDate? jdate1
	abstract jDate? jdate2
}

@NoDoc
mixin T_PlasticService17 { 	
	abstract jDate? getDate1()
	abstract jDate? getDate2()
}

@NoDoc
class T_PlasticService18 { 	
	new makeStuff(Str judge := "Fred") { }
}
