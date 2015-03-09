
** Converts Java types to more usable Str signatures. 
** 
** @see [Error using java class]`https://bitbucket.org/AlienFactory/afplastic/issue/1/error-using-java-class`
class TypeCache {
	** A map of Java Types and their cached names
	Type:Str	javaTypes	:= Type:Str[:]
	
	** Return the Type signature. Fantom types are returned as are, Java types are converted to more usable Strs.  
	Str signature(Type type) {
		if (type.qname.startsWith("[java]")) {
			jType := javaTypes.getOrAdd(type) {
				// add a random number to prevent name clash
				"Java" + type.name + Int.random(0..<10000).toStr.padl(4, '0')
			}
			return type.isNullable ? "${jType}?" : jType
		}
		return type.signature
	}
	
	Void addTo(PlasticUsingModel[] usings) {
		javaTypes.each |v, k| { usings.add(PlasticUsingModel.makeFromStr("${k.toNonNullable.signature} as ${v}")) }
	}
}
