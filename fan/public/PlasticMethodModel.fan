
** Models a Fantom method.
class PlasticMethodModel {
	Bool			 	isOverride
	PlasticVisibility 	visibility
	Type				returnType
	Str					name
	Str					signature
	Str					body
	PlasticFacetModel[]	facets		:= [,]

	internal new make(Bool isOverride, PlasticVisibility visibility, Type returnType, Str name, Str signature, Str body) {
		this.isOverride	= isOverride
		this.visibility = visibility
		this.returnType	= returnType
		this.name		= name
		this.signature	= signature
		this.body		= body
	}
	
	** Converts the model into Fantom source code.
	Str toFantomCode(TypeCache typeCache) {
		code := StrBuf()
		facets.each { code.addChar('\t').add(it.toFantomCode) }
		overrideKeyword	:= isOverride ? "override " : ""
		
		code.addChar('\t')
		code.add(overrideKeyword)
		code.add(visibility.keyword)
		code.add(typeCache.signature(returnType))
		code.addChar(' ')
		code.add(name)
		code.addChar('(')
		code.add(signature)
		code.add(") {\n\t\t")
		
		// indent body
		body.splitLines.each {
			code.add(it)
			code.add("\n\t\t")
		}
		code.remove(-1).remove(-1).remove(-1)
		code.add("\n\t}\n\n")

		return code.toStr
	}
	
	@NoDoc override Str toStr() { toFantomCode(TypeCache()) }
}

