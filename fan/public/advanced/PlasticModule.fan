
@NoDoc	// advanced use only
const class PlasticModule {
	
	Str:Obj defineModule() {
		[
			"services"	: [
				[
					"id"	: PlasticCompiler#.qname,
					"type"	: PlasticCompiler#,
					"scopes": ["root"]
				]
			],
			
			"contributions"	: [
				[
					"serviceId"	: "afBedSheet::ErrPrinterStr",
					"key"		: "afPlastic.srcCodeErrs",
					"value"		: #printSrcCodeErrsToStr.func,
					"before"	: "afBedSheet.iocOperationTrace",
					"after"		: "afBedSheet.stackTrace"
				],
				[
					"serviceId"	: "afBedSheet::ErrPrinterHtml",
					"key"		: "afPlastic.srcCodeErrs",
					"value"		: #printSrcCodeErrsToHtml.func,
					"before"	: "afBedSheet.iocOperationTrace",
					"after"		: "afBedSheet.stackTrace"
				]
			]
		]
	}

	private static Void printSrcCodeErrsToStr(StrBuf buf, Err? err) {
		forEachCause(err, SrcCodeErr#) |SrcCodeErr srcCodeErr->Bool| {
			title	:= srcCodeErr.typeof.name.toDisplayName	
			buf.add("\n${title}:\n")
			buf.add(srcCodeErr.toSnippetStr)
			return false
		}
	}

	private static Void printSrcCodeErrsToHtml(OutStream out, Err? err) {
		forEachCause(err, SrcCodeErr#) |SrcCodeErr srcCodeErr->Bool| {
			srcCode 	:= srcCodeErr.srcCode
			title		:= srcCodeErr.typeof.name.toDisplayName

			PlasticModule.title(out, title)

			out.print("<p>").print(srcCode.srcCodeLocation).print(" : Line ${srcCodeErr.errLineNo}").print("<br/>")
			out.print("&#160;&#160;-&#160;").writeXml(srcCodeErr.msg).print("</p>")
			
			out.print("<div class=\"srcLoc\">")
			out.print("<table>")
			srcCode.srcCodeSnippetMap(srcCodeErr.errLineNo, srcCodeErr.linesOfPadding).each |src, line| {
				if (line == srcCodeErr.errLineNo) { out.print("<tr class=\"errLine\">") } else { out.print("<tr>") }
				out.print("<td>").print(line).print("</td>").print("<td>").print(src.toXml).print("</td>")
				out.print("</tr>")
			}
			out.print("</table>")
			out.print("</div>")
			return false
		}
	}
	
	private static Void forEachCause(Err? err, Type causeType, |Obj->Bool| f) {
		done := false
		while (err != null && !done) {
			if (err.typeof.fits(causeType))
				done = f(err)
			err = err.cause			
		}		
	}
	
	** If you're thinking of generating a ToC, think about those contributions not in BedSheet...
	** ...and if we add a HTML Helper - do we want add a dependency to BedSheet?
	private static Void title(OutStream out, Str title) {
		out.print("<h2 id=\"${title.fromDisplayName}\">${title}</h2>")
	}
}
