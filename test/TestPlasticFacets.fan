
@T_Facet1
internal class TestPlasticFacetModel : PlasticTest {
	
	Void testModelCopyCtor() {
		facetModel := PlasticFacetModel(this.typeof.facets.find { it.typeof == T_Facet1# })
		fantomCode := facetModel.toFantomCode
		verify(fantomCode.startsWith("@afPlastic::T_Facet1 {"))
		verify(fantomCode.contains(Str<|num=(afPlastic::T_Enum) afPlastic::T_Enum("one")|>))
		verify(fantomCode.contains(Str<|ting=(afPlastic::T_Thing) afPlastic::T_Thing|>))
		verify(fantomCode.contains(Str<|str=(sys::Str) "String"|>))
		verify(fantomCode.contains(Str<|uri=(sys::Uri) `Uri`|>))
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
