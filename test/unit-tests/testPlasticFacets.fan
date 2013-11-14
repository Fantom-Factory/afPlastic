
@T_Facet1
internal class testPlasticFacetModel : PlasticTest {
	
	Void testModelCopyCtor() {
		facetModel := PlasticFacetModel(this.typeof.facets.find { it.typeof == T_Facet1# })
		verifyEq(facetModel.toFantomCode, """@afPlastic::T_Facet1 {num=afPlastic::T_Enum("one"); ting=afPlastic::T_Thing; str="String"; uri=`Uri`}\n""")
	}
	
}

internal facet class T_Facet1 {
	const Str 		str 	:= "String"
	const Uri		uri 	:= `Uri`
	const T_Enum	num		:= T_Enum.one
	const T_Thing	ting	:= T_Thing()
}

internal enum class T_Enum {
	one, two
}

@Serializable
internal const class T_Thing { }
