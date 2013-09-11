
** As throw by afPlastic.
const class PlasticErr : Err {
	internal new make(Str msg, Err? cause := null) : super(msg, cause) {}
}

** As throw by `PlasticCompiler` should Fantom code compilation fail.
const class PlasticCompilationErr : PlasticErr, SrcCodeErr {
	const override SrcCodeSnippet 	srcCode
	const override Int 				errLineNo
	private const  Int 				linesOfPadding

	internal new make(SrcCodeSnippet srcCode, Int errLineNo, Str errMsg, Int linesOfPadding) : super(errMsg) {
		this.srcCode = srcCode
		this.linesOfPadding = linesOfPadding
	}
	
	override Str toStr() {
		print(msg, linesOfPadding)
	}
}

** A mixin for Errs that report errors in source code.
const mixin SrcCodeErr {
	
	** The source code where the error occurred.
	abstract SrcCodeSnippet	srcCode()
	
	** The line number in the source code where the error occurred. 
	abstract Int errLineNo()

	Str print(Str msg, Int linesOfPadding) {
		buf := StrBuf()
		buf.add("${typeof.qname}: ${msg}\n")
		buf.add("\n${typeof.name.toDisplayName}:\n")
		buf.add(srcCode.srcCodeSnippet(linesOfPadding, msg, linesOfPadding))
		buf.add("\nStack Trace:")
		return buf.toStr
	}	
}
