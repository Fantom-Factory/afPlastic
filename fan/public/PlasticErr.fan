
** As throw by afPlastic.
const class PlasticErr : Err {
	new make(Str msg, Err? cause := null) : super(msg, cause) {}
}

** As throw by `PlasticCompiler` should Fantom code compilation fail.
const class PlasticCompilationErr : PlasticErr {
	const SrcErrLocation srcErrLoc
	const Int noOfLinesOfPadding

	new make(SrcErrLocation srcErrLoc, Int noOfLinesOfPadding := 5) : super(srcErrLoc.errMsg) {
		this.srcErrLoc = srcErrLoc
		this.noOfLinesOfPadding = noOfLinesOfPadding
	}

	override Str toStr() {
		buf := StrBuf()
		buf.add("${typeof.qname}: ${msg}")
		buf.add("\nPlastic Compilation Err:\n")

		buf.add(srcErrLoc.srcCodeSnippet(noOfLinesOfPadding))
		
		buf.add("\nStack Trace:")
		return buf.toStr
	}
}
