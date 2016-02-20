using build

class Build : BuildPod {

	new make() {
		podName = "afPlastic"
		summary = "A library for dynamically generating and compiling Fantom code"
		version = Version("1.1.0")

		meta = [	
			"proj.name"		: "Plastic",
			"afIoc.module"	: "afPlastic::PlasticModule",
			"repo.internal"	: "true",
			"repo.tags"		: "system",
			"repo.public"	: "false"
		]

		depends = [
			"sys          1.0.68 - 1.0", 
			"concurrent   1.0.67 - 1.0", 
			"compiler     1.0.67 - 1.0",
			"compilerJava 1.0.67 - 1.0",
			
			// ---- Core ----
			"afBeanUtils  1.0.4  - 1.0"
		]

		srcDirs = [`fan/`, `fan/internal/`, `fan/internal/utils/`, `fan/public/`, `fan/public/advanced/`, `test/`]
		resDirs = [`doc/`]
	}
}
