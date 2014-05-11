using build

class Build : BuildPod {

	new make() {
		podName = "afPlastic"
		summary = "(Internal) A library for dynamically generating and compiling Fantom code"
		version = Version("1.0.11")

		meta = [	
			"org.name"		: "Alien-Factory",
			"org.uri"		: "http://www.alienfactory.co.uk/",
			"proj.name"		: "Plastic",
			"proj.uri"		: "http://www.fantomfactory.org/pods/afPlastic",
			"vcs.uri"		: "https://bitbucket.org/AlienFactory/afplastic",
			"license.name"	: "The MIT Licence",
			"repo.private"	: "true",
			
			"tags"			: "system"
		]

		depends = [
			"sys 1.0", 
			"concurrent 1.0", 
			"compiler 1.0"
		]

		srcDirs = [`test/`, `fan/`, `fan/public/`, `fan/internal/`, `fan/internal/utils/`]
		resDirs = [`licence.txt`, `doc/`]

		docApi = true
		docSrc = true
	}
	
	@Target { help = "Compile to pod file and associated natives" }
	override Void compile() {
		// see "stripTest" in `/etc/build/config.props` to exclude test src & res dirs
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
