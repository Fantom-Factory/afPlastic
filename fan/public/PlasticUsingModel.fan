
class PlasticUsingModel {

	Str? usingStr
	
	new makeFromPod(Pod pod) {
		this.usingStr = pod.name		
	}

	new makeFromType(Type type, Str? usingAs := null) {
		this.usingStr = type.qname
		if (usingAs != null)
			this.usingStr += " as ${usingAs}"
	}

	new makeFromStr(Str usingStr) {
		if (usingStr.trim.lower.startsWith("using "))
			throw PlasticErr(PlasticMsgs.usingStrMustNotStartWithUsing(usingStr))
		this.usingStr = usingStr
	}
	
	Str toFantomCode() {
		"using ${usingStr}\n"
	}
	
	override Bool equals(Obj? that) {
		(that as PlasticUsingModel)?.usingStr?.lower == usingStr.lower
	}

	override Int hash() {
		usingStr.lower.hash
	}
}
