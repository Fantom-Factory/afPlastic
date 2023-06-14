using build

class Build : BuildPod {

	new make() {
		podName = "afPlastic"
		summary = "A library for dynamically generating and compiling Fantom code"
		version = Version("1.1.8")

		meta = [	
			"pod.dis"		: "Plastic",
			"afIoc.module"	: "afPlastic::PlasticModule",
			"repo.internal"	: "true",
			"repo.tags"		: "system",
			"repo.public"	: "true",

			// ---- SkySpark ----
			"ext.name"		: "afPlastic",
			"ext.icon"		: "afPlastic",
			"ext.depends"	: "afBeanUtils",
			"skyarc.icons"	: "true",
		]
	
		index	= [
			"skyarc.ext"	: "afPlastic"
		]

		depends = [
			"sys          1.0.68 - 1.0", 
			"concurrent   1.0.68 - 1.0",	// for AtomicInt to keep a JVM unique pod name 
			"compiler     1.0.68 - 1.0", 
			"compilerJava 1.0.68 - 1.0",
		]

		srcDirs = [`fan/`, `fan/internal/`, `fan/public/`, `fan/public/advanced/`, `test/`]
		resDirs = [`doc/`, `svg/`]
	}
}
