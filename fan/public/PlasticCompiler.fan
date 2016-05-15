using concurrent
using compiler

** (Service) - 
** Compiles Fantom source code and afPlastic models into usable Fantom code.
** 
** Note: This class is available as a service in IoC v3 under the 'root' scope with an ID of 'afPlastic::PlasticCompiler'.
const class PlasticCompiler {
	
	** static because pods are shared throughout the JVM, not just the IoC 
	private static const AtomicInt podIndex	:= AtomicInt(1)

	** When generating code snippets to report compilation Errs, this is the number of lines of src 
	** code the erroneous line should be padded with. 
	** 
	** Value is mutable. Defaults to '5'.  
	public Int 	srcCodePadding {
		get { _srcCodePadding.val }
		set { _srcCodePadding.val = it }
	}
	
	private const AtomicInt _srcCodePadding	:= AtomicInt(5)

	** Creates a 'PlasticCompiler'.
	new make(|This|? in := null) { in?.call(this) }
	
	** Compiles the given class model into a pod and returns the associated Fantom type.
	** If no pod name is given, a unique one will be generated.
	Type compileModel(PlasticClassModel model, Str? podName := null) {
		podName = podName ?: generatePodName
		pod		:= compileCode(model.toFantomCode, podName)
		type	:= pod.type(model.className)
		return type
	}

	Type[] compileModels(PlasticClassModel[] models, Str? podName := null) {
		if (models.isEmpty)	return Type[,]
		
		podName = podName ?: generatePodName
		
		podCode	:= models.first
		models.eachRange(1..-1) { podCode.usings.addAll(it.usings); it.usings.clear }
		fanCode	:= models.map { it.toFantomCode }.join("\n")
		
		pod		:= compileCode(fanCode, podName)
		types	:= models.map { pod.type(it.className) }
		return types
	}
	
	** Compiles the given Fantom code into a pod. 
	** If no pod name is given, a unique one will be generated.
	** 
	** 'srcCodeLocation' is just used to report errors. If not given, the 'podName' is used.
	Pod compileCode(Str fantomPodCode, Str? podName := null, Uri? srcCodeLocation := null ) {
		input 		    := CompilerInput()
		input.output 	= CompilerOutputMode.transientPod
		return compile(input, fantomPodCode, podName, srcCodeLocation).transientPod
	}
	
	** Compiles the given Fantom code into a pod file. 
	** If no pod name is given, a unique one will be generated.
	** 
	** 'srcCodeLocation' is just used to report errors. If not given, the 'podName' is used.
	** 
	** Note the returned file is deemed to be transient, so is deleted on exit.
	** 
	** Note: Fantom 1.0.68 needs [this patch]`http://fantom.org/forum/topic/2536` in order to work.
	File compileCodeToPodFile(Str fantomPodCode, Str? podName := null, Uri? srcCodeLocation := null ) {
		input 		    	:= CompilerInput()
		input.output 		= CompilerOutputMode.podFile
		input.outDir		= Env.cur.tempDir
		input.includeDoc	= true
		input.includeSrc	= true
		return compile(input, fantomPodCode, podName, srcCodeLocation).podFile.deleteOnExit
	}
	
	** Different pod names prevents "sys::Err: Duplicate pod name: <podName>".
	** We internalise podName so we can guarantee no duplicate pod names
	Str generatePodName() {
		index := podIndex.getAndIncrement.toStr.padl(3, '0')		
		return "afPlastic${index}"
	}
	
	private CompilerOutput compile(CompilerInput input, Str fantomPodCode, Str? podName, Uri? srcCodeLocation) {
		podName = podName ?: generatePodName

		if (Pod.of(this).log.isDebug)
			Pod.of(this).log.debug("Compiling code for pod: ${podName}\n${fantomPodCode}")

		try {
			input.podName 	= podName
			input.summary 	= "Dynamic Pod compiled by Alien-Factory Plastic"
			input.version 	= Version.defVal
			input.log.level = LogLevel.silent	// we'll raise our own Errs - less noise to std.out
			input.isScript 	= true
			input.mode 		= CompilerInputMode.str
			input.srcStrLoc	= Loc(podName)
			input.srcStr 	= fantomPodCode

			compiler 		:= Compiler(input)
			output 			:= compiler.compile
			return output

		} catch (CompilerErr err) {
			srcCode := SrcCodeSnippet(srcCodeLocation ?: podName.toUri, fantomPodCode)
			throw PlasticCompilationErr(srcCode, err.line ?: 1, err.msg, srcCodePadding)
		}
	}
}

