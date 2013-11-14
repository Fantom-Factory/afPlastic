
** Models a Fantom ctor.
class PlasticCtorModel {
	PlasticVisibility 	visibility
	Str					name
	Str					signature
	Str					body
	PlasticFacetModel[]	facets		:= [,]
	

	internal new make(PlasticVisibility visibility, Str name, Str signature, Str body) {
		this.visibility = visibility
		this.name		= name
		this.signature	= signature
		this.body		= body
	}
	
	** Converts the model into Fantom source code.
	Str toFantomCode() {
		code := ""
		facets.each { code += "\t" + it.toFantomCode }
		code +=
		"	${visibility.keyword}new ${name}(${signature}) {
		 		${indentBody}
		 	}\n\n"
		return code
	}
	
	private Str indentBody() {
		body.splitLines.join("\n\t\t")
	}
}
