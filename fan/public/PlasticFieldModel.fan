
** Models a Fantom field.
class PlasticFieldModel {
	Bool			 	isOverride
	PlasticVisibility 	visibility
	Bool				isConst
	Type				type
	Str					name
	Str? 				getBody
	Str? 				setBody
	Type[] 				facetTypes
	Str?				initValue
	
	internal new make(Bool isOverride, PlasticVisibility visibility, Bool isConst, Type type, Str name, Str? getBody, Str? setBody, Type[] facetTypes) {
		this.isOverride	= isOverride
		this.visibility = visibility
		this.isConst	= isConst
		this.type		= type
		this.name		= name
		this.getBody	= getBody
		this.setBody	= setBody
		this.facetTypes	= facetTypes
	}
	
	This withInitValue(Str initValue) {
		// TODO: check get & set are null
		this.initValue = initValue
		return this
	}
	
	** Converts the model into Fantom source code.
	Str toFantomCode() {
		field := ""
		facetTypes.each { field += "	@${it.qname}\n" }
		overrideKeyword	:= isOverride ? "override " : ""
		// fields can not be const if they have a getter - see afEfan::EfanCompiler._af_eval
		constKeyword	:= (isConst && getBody == null) ? "const " : "" 
		field +=
		"	${overrideKeyword}${visibility.keyword}${constKeyword}${type.signature} ${name}"
		if (getBody != null || setBody != null) {
			field += " {\n"
			if (getBody != null)
				field += "		get { ${getBody} }\n"
			if (setBody != null)
				field += "		set { ${setBody} }\n"
			field += "	}"
		}
		if (initValue != null)
			field += " := ${initValue}"
		field += "\n\n"
		return field
	}
}

