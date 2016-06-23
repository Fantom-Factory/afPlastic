using build

class Build : BuildPod {

	new make() {
		podName = "afPlastic"
		summary = "A library for dynamically generating and compiling Fantom code"
		version = Version("1.1.2")

		meta = [	
			"proj.name"		: "Plastic",
			"afIoc.module"	: "afPlastic::PlasticModule",
			"repo.internal"	: "true",
			"repo.tags"		: "system",
			"repo.public"	: "true"
		]

		depends = [
			"sys          1.0.68 - 1.0", 
			"concurrent   1.0.68 - 1.0", 
			"compiler     1.0.68 - 1.0",	// for AtomicInt to keep a JVM unique pod name 
			"compilerJava 1.0.68 - 1.0",
			
			// ---- Core ----
			"afBeanUtils  1.0.8  - 1.0"
		]

		srcDirs = [`fan/`, `fan/internal/`, `fan/public/`, `fan/public/advanced/`, `test/`]
		resDirs = [`doc/`]
	}
}
