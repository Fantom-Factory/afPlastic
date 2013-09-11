
** Generates snippets of source code centred on an error line.
**// SrcCodeErr
const class SrcErrLocation {
	
	** An arbitrary uri of where the source code originated from. 
	const Uri	srcCodeLocation
	
	** A list of source code lines.
	const Str[]	srcCode
	
	** The line number in the source code where the error occurred. 
	const Int 	errLineNo
	
	** The error message.
	const Str 	errMsg

	** Creates a SrcErrLocation.
	new make(Uri srcCodeLocation, Str srcCode, Int errLineNo, Str errMsg) {
		this.srcCodeLocation= srcCodeLocation
		this.srcCode		= srcCode.splitLines
		this.errLineNo		= errLineNo
		this.errMsg			= errMsg
	}

	** Returns a snippet of source code, centred on `errLineNo` and padded on either side by an 
	** extra 'noOfLinesOfPadding' lines.
	Str srcCodeSnippet(Int noOfLinesOfPadding := 5) {
		buf := StrBuf()
		buf.add("  ${srcCodeLocation}").add(" : Line ${errLineNo}\n")
		buf.add("    - ${errMsg}\n\n")
		
		srcCodeSnippetMap(noOfLinesOfPadding).each |src, lineNo| {
			pointer := (lineNo == errLineNo) ? "==>" : "   "
			buf.add("${pointer}${lineNo.toStr.justr(3)}: ${src}\n".replace("\t", "    "))
		}
		
		return buf.toStr
	}

	** Returns a map of line numbers to source code, centred on `errLineNo` and padded on either 
	** side by an extra 'noOfLinesOfPadding' lines.
	Int:Str srcCodeSnippetMap(Int noOfLinesOfPadding := 5) {
		min := (errLineNo - 1 - noOfLinesOfPadding).max(0)	// -1 so "Line 1" == src[0]
		max := (errLineNo - 1 + noOfLinesOfPadding + 1).min(srcCode.size)
		lines := Utils.makeMap(Int#, Str#)
		(min..<max).each { lines[it+1] = srcCode[it] }
		
		// uniformly remove extra whitespace 
		while (canTrim(lines))
			trim(lines)
		
		return lines
	}

	private Bool canTrim(Int:Str lines) {
		lines.vals.all { it.size > 0 && it[0].isSpace }
	}

	private Void trim(Int:Str lines) {
		lines.each |val, key| { lines[key] = val[1..-1]  }
	}
	
	** Returns `srcCodeSnippet`
	override Str toStr() {
		srcCodeSnippet
	}
}