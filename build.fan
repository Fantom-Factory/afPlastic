using build::BuildPod

class Build : BuildPod {

	new make() {
		podName = "afPlastic"
		summary = "(Internal) A library for dynamically generating and compiling Fantom code"
		version = Version("1.0.10")

		meta	= [	"org.name"		: "Alien-Factory",
					"org.uri"		: "http://www.alienfactory.co.uk/",
					"vcs.uri"		: "https://bitbucket.org/AlienFactory/afplastic",
					"proj.name"		: "Plastic",
					"license.name"	: "BSD 2-Clause License",
					"repo.private"	: "true"
				]

		depends = ["sys 1.0", "concurrent 1.0", "compiler 1.0"]
		srcDirs = [`test/`, `test/unit-tests/`, `fan/`, `fan/public/`, `fan/internal/`, `fan/internal/utils/`]
		resDirs = [`doc/`]

		docApi = true
		docSrc = true
		
		// exclude test code when building the pod
		srcDirs = srcDirs.exclude { it.toStr.startsWith("test/") }		
	}
	
	@Target { help = "Compile to pod file and associated natives" }
	override Void compile() {
		super.compile
		
		destDir := Env.cur.homeDir.plus(`src/${podName}/`)
		destDir.delete
		destDir.create		
		`fan/`.toFile.copyInto(destDir)
		
		log.indent
		log.info("Copied `fan/` to ${destDir.normalize}")
		log.unindent
	}	
}
