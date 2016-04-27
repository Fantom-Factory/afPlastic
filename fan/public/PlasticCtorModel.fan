
** Models a Fantom ctor.
class PlasticCtorModel {
	PlasticVisibility 	visibility
	Str					name
	Str					signature
	Str					body
	Str?				superCtor
	PlasticFacetModel[]	facets		:= [,]
	

	internal new make(PlasticVisibility visibility, Str name, Str signature, Str body, Str? superCtor := null) {
		this.visibility = visibility
		this.name		= name
		this.signature	= signature
		this.body		= body
		this.superCtor	= superCtor
	}
	
	** Converts the model into Fantom source code.
	Str toFantomCode() {
		code := StrBuf()
		facets.each { code.addChar('\t').add(it.toFantomCode) }
		
		code.addChar('\t')
		code.add(visibility.keyword)
		code.add("new ")
		code.add(name)
		code.addChar('(')
		code.add(signature)
		code.addChar(')')
		code.addChar(' ')
		code.add(superCtorCode)
		code.add("{\n\t\t")
		code.add(indentBody)
		code.add("\n\t}\n\n")

		return code.toStr
	}
	
	private Str indentBody() {
		body.splitLines.join("\n\t\t")
	}
	
	private Str superCtorCode() {
		superCtor == null ? "" : ": ${superCtor} "
	}
}
