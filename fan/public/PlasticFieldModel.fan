
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
		field := StrBuf()
		facets.each { field.addChar('\t').add(it.toFantomCode) }
		overrideKeyword	:= isOverride ? "override " : ""
		// fields can not be const if they have a getter - see afEfan::EfanCompiler._af_eval
		constKeyword	:= (isConst && getBody == null) ? "const " : ""
		field.addChar('\t')
		field.add(overrideKeyword)
		field.add(visibility.keyword)
		field.add(constKeyword)
		field.add(typeCache.signature(type))
		field.addChar(' ')
		field.add(name)
		
		if (initValue != null) {
			field.add(" := ")
			field.add(initValue)
		}
		if (getBody != null || setBody != null) {
			field.add(" {\n")
			if (getBody != null) {
				field.add("\t\tget { ")
				field.add(getBody)
				field.add(" }\n")
			}
			if (setBody != null) {
				field.add("\t\tset { ")
				field.add(setBody)
				field.add(" }\n")				
			}
			field.addChar('\t').addChar('}')
		}
		field.addChar('\n').addChar('\n')
		return field.toStr
	}
}

