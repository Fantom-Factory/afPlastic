
** Models a Fantom field.
class PlasticFieldModel {
	Bool			 	isOverride
	PlasticVisibility 	visibility
	Bool				isConst
	Type				type
	Str					name
	Str? 				getBody
	Str? 				setBody
	Str?				initValue
	PlasticFacetModel[]	facets		:= [,]
	
	internal new make(Bool isOverride, PlasticVisibility visibility, Bool isConst, Type type, Str name, Str? getBody, Str? setBody) {
		this.isOverride	= isOverride
		this.visibility = visibility
		this.isConst	= isConst
		this.type		= type
		this.name		= name
		this.getBody	= getBody
		this.setBody	= setBody
	}
	
	This withInitValue(Str initValue) {
		// TODO: check get & set are null
		this.initValue = initValue
		return this
	}

	PlasticFacetModel addFacet(Type type, Str:Str params := [:]) {
		facetModel := PlasticFacetModel(type, params)
		facets.add(facetModel)
		return facetModel
	}
	
	This addFacetClone(Facet toClone) {
		facets.add(PlasticFacetModel(toClone))
		return this
	}
	
	** Converts the model into Fantom source code.
	Str toFantomCode(TypeCache typeCache) {
		field := ""
		facets.each { field += "\t" + it.toFantomCode }
		overrideKeyword	:= isOverride ? "override " : ""
		// fields can not be const if they have a getter - see afEfan::EfanCompiler._af_eval
		constKeyword	:= (isConst && getBody == null) ? "const " : "" 
		field +=
		"	${overrideKeyword}${visibility.keyword}${constKeyword}${typeCache.signature(type)} ${name}"
		if (initValue != null)
			field += " := ${initValue}"
		if (getBody != null || setBody != null) {
			field += " {\n"
			if (getBody != null)
				field += "		get { ${getBody} }\n"
			if (setBody != null)
				field += "		set { ${setBody} }\n"
			field += "	}"
		}
		field += "\n\n"
		return field
	}
}

