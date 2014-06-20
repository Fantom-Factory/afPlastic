using build

class Build : BuildPod {

	new make() {
		podName = "afPlastic"
		summary = "(Internal) A library for dynamically generating and compiling Fantom code"
		version = Version("1.0.13")

		meta = [	
			"proj.name"		: "Plastic",
			"tags"			: "system",
			"repo.private"	: "true"		
		]

		depends = [
			"sys 1.0", 
			"concurrent 1.0", 
			"compiler 1.0",
			
			"afBeanUtils 0.0.4+"
		]

		srcDirs = [`test/`, `fan/`, `fan/public/`, `fan/internal/`, `fan/internal/utils/`]
		resDirs = [,]

		docApi = true
		docSrc = true
	}
}
