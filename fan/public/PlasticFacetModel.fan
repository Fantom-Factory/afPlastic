
** Models a Fantom facet.
class PlasticFacetModel {
	const Type?	type
	Str:Str		params

	new make(Type type, Str:Str params := [:]) {
		this.type 	= type
		this.params = params
	}

	new makeFromFacet(Facet toClone) {
		this.type 	= toClone.typeof
		this.params	= [:]
		sBuf := StrBuf()
		toClone.typeof.fields.each |field| {
			// a nasty little gotcha - facet defVals are not serialiazable!
			if (field.name == "defVal")
				return
			
			value := field.get(toClone)
			// all facets are serializable 
			// see http://fantom.org/doc/docLang/Facets.html#classes
			sBuf.clear.out.writeObj(value).close
			// Add cast for null values
			// see http://fantom.org/sidewalk/topic/2320
			params[field.name] = "(${field.type.signature}) ${sBuf.toStr}"
		}
	}

	** Converts the model into Fantom source code.
	Str toFantomCode() {
		pCode	:= ""
		if (!params.isEmpty) {
			pCode = " {" + params.join("; ") |v, k->Str| { "$k=$v" } + "}"
		}
		
		code 	:= "@${type.qname}${pCode}\n"
		return code
	}
}
