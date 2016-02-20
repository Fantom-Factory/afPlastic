
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
		code := ""
		facets.each { code += "\t" + it.toFantomCode }
		code +=
		"	${visibility.keyword}new ${name}(${signature}) ${superCtorCode}{
		 		${indentBody}
		 	}\n\n"
		return code
	}
	
	private Str indentBody() {
		body.splitLines.join("\n\t\t")
	}
	
	private Str superCtorCode() {
		superCtor == null ? "" : ": ${superCtor} "
	}
}
