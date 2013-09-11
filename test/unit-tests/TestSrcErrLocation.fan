
internal class TestSrcErrLocation : PlasticTest {
	
	Void testSimple() {
		src := """l 1
		          l 2
		          l 3
		          l 4
		          l 5"""
		info := SrcCodeSnippet(``, src)

		srcy := info.srcCodeSnippetMap(3, 0)
		verifyEq(srcy.size, 1)
		verifyEq(srcy[3], "l 3")

		srcy = info.srcCodeSnippetMap(3, 1)
		verifyEq(srcy.size, 3)
		verifyEq(srcy[2], "l 2")
		verifyEq(srcy[3], "l 3")
		verifyEq(srcy[4], "l 4")

		srcy = info.srcCodeSnippetMap(3, 2)
		verifyEq(srcy.size, 5)
		verifyEq(srcy[1], "l 1")
		verifyEq(srcy[2], "l 2")
		verifyEq(srcy[3], "l 3")
		verifyEq(srcy[4], "l 4")
		verifyEq(srcy[5], "l 5")

		// test min / max limits
		srcy = info.srcCodeSnippetMap(3, 20)
		verifyEq(srcy.size, 5)
		verifyEq(srcy[1], "l 1")
		verifyEq(srcy[2], "l 2")
		verifyEq(srcy[3], "l 3")
		verifyEq(srcy[4], "l 4")
		verifyEq(srcy[5], "l 5")
	}
	
	Void testTrim() {
		src := """ \t l 1
		           \t  l 2
		           \t   l 3
		           \t  l 4
		           \t l 5"""
		info := SrcCodeSnippet(``, src)
		
		srcy := info.srcCodeSnippetMap(3, 2)
		verifyEq(srcy.size, 5)
		verifyEq(srcy[1], "l 1")
		verifyEq(srcy[2], " l 2")
		verifyEq(srcy[3], "  l 3")
		verifyEq(srcy[4], " l 4")
		verifyEq(srcy[5], "l 5")
	}
	
	Void test() {
		scs:=SrcCodeSnippet(`dude`, "1\n2\n3\n4")
		pce:=PlasticCompilationErr(scs, 1, "pow", 2)
		Env.cur.err.printLine(pce.toStr)
	}
}
