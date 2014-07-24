using build

class Build : BuildPod {

	new make() {
		podName = "afPlastic"
		summary = "A library for dynamically generating and compiling Fantom code"
		version = Version("1.0.16")

		meta = [	
			"proj.name"		: "Plastic",
			"internal"		: "true",
			"tags"			: "system",
			"repo.private"	: "false"
		]

		depends = [
			"sys 1.0", 
			"concurrent 1.0", 
			"compiler 1.0",
			
			"afBeanUtils 1.0.0+"
		]

		srcDirs = [`test/`, `fan/`, `fan/public/`, `fan/internal/`, `fan/internal/utils/`]
		resDirs = [,]
	}
}
