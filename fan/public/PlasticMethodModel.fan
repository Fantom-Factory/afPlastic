
** Models a Fantom method.
class PlasticMethodModel {
	Bool			 	isOverride
	PlasticVisibility 	visibility
	Type				returnType
	Str					name
	Str					signature
	Str					body

	internal new make(Bool isOverride, PlasticVisibility visibility, Type returnType, Str name, Str signature, Str body) {
		this.isOverride	= isOverride
		this.visibility = visibility
		this.returnType	= returnType
		this.name		= name
		this.signature	= signature
		this.body		= body
	}
	
	** Converts the model into Fantom source code.
	Str toFantomCode() {
		overrideKeyword	:= isOverride ? "override " : ""
		return
		"	${overrideKeyword}${visibility.keyword}${returnType.signature} ${name}(${signature}) {
		 		${indentBody}
		 	}\n\n"
	}
	
	private Str indentBody() {
		body.splitLines.join("\n\t\t")
	}
}

