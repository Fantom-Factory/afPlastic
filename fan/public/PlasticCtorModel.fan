
** Models a Fantom ctor.
class PlasticCtorModel {
	PlasticVisibility 	visibility
	Str					name
	Str					signature
	Str					body

	internal new make(PlasticVisibility visibility, Str name, Str signature, Str body) {
		this.visibility = visibility
		this.name		= name
		this.signature	= signature
		this.body		= body
	}
	
	** Converts the model into Fantom source code.
	Str toFantomCode() {
		return
		"	${visibility.keyword}new ${name}(${signature}) {
		 		${indentBody}
		 	}\n\n"
	}
	
	private Str indentBody() {
		body.splitLines.join("\n\t\t")
	}
}
