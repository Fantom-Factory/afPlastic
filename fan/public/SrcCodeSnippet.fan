
** Generates snippets of source code, often used to report errors. Example:
** 
** pre>
** file:/C:/test/app/compilationErr.moustache : Line 11
**     - Unbalanced "{" in tag "{ alienHeadSvg }  <span class="brand">{{ title"
** 
**      6:         {{{ bedSheetCss }}}
**      7:     </style>
**      8: </head>
**      9: <body>
**     10:     <header>
** ==> 11:         {{{ alienHeadSvg }
**     12:         <span class="brand">{{ title }}</span>
**     13:     </header>
**     14:
**     15:     <main>
**     16:         {{{ content }}}
** <pre
const class SrcCodeSnippet {
	
	** An arbitrary uri of where the source code originated from. 
	const Uri	srcCodeLocation
	
	** A list of source code lines.
	const Str[]	srcCode

	** Creates a SrcCodeSnippet. 
	** The srcCodeLocation URI may be anything as it is only used for reporting. 
	new make(Uri srcCodeLocation, Str srcCode) {
		this.srcCodeLocation= srcCodeLocation
		this.srcCode		= srcCode.splitLines
	}

	** Returns a snippet of source code, centred on 'lineNo' and padded on either side by an 
	** extra 'linesOfPadding'.
	** 
	** Note that 'lineNo' is ONE based, not zero.
	Str srcCodeSnippet(Int lineNo, Str? msg := null, Int linesOfPadding := 5) {
		buf := StrBuf()
		buf.add("  ${srcCodeLocation}").add(" : Line ${lineNo}\n")
		if (msg != null)
			buf.add("    - ${msg}\n")
		buf.add("\n")
		
		srcCodeSnippetMap(lineNo, linesOfPadding).each |src, line| {
			pointer := (line == lineNo) ? "==>" : "   "
			buf.add("${pointer}${line.toStr.justr(3)}: ${src}\n".replace("\t", "    "))
		}
		
		return buf.toStr
	}

	** Returns a map of line numbers to source code, centred on 'lineNo' and padded on either 
	** side by an extra 'linesOfPadding'.
	** 
	** Note that 'lineNo' is ONE based, not zero.
	Int:Str srcCodeSnippetMap(Int lineNo, Int linesOfPadding := 5) {
		min := (lineNo - 1 - linesOfPadding).max(0)	// -1 so "Line 1" == src[0]
		max := (lineNo - 1 + linesOfPadding + 1).min(srcCode.size)
		lines := Int:Str[:] { it.ordered = true }
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
	
	@NoDoc
	override Str toStr() {
		"${srcCodeLocation} : ${srcCode.size} lines"
	}
}