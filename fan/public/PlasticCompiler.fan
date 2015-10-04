using concurrent
using compiler

** (Service) - 
** Compiles Fantom source code and afPlastic models into usable Fantom code.
** 
** This class is available in IoC v3 as a service in the 'root' scope, with id 'afPlastic::PlasticCompiler'.
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
	Pod compileCode(Str fantomPodCode, Str? podName := null) {
		podName = podName ?: generatePodName

		if (Pod.of(this).log.isDebug)
			Pod.of(this).log.debug("Compiling code for pod: ${podName}\n${fantomPodCode}")
		
		try {
			input 		    := CompilerInput()
			input.podName 	= podName
	 		input.summary 	= "Alien-Factory Transient Pod"
			input.version 	= Version.defVal
			input.log.level = LogLevel.silent	// we'll raise our own Errs - less noise to std.out
			input.isScript 	= true
			input.output 	= CompilerOutputMode.transientPod
			input.mode 		= CompilerInputMode.str
			input.srcStrLoc	= Loc(podName)
			input.srcStr 	= fantomPodCode
	
			compiler 		:= Compiler(input)
			pod 			:= compiler.compile.transientPod
			return pod		

		} catch (CompilerErr err) {
			srcCode := SrcCodeSnippet(`${podName}`, fantomPodCode)
			throw PlasticCompilationErr(srcCode, err.line, err.msg, srcCodePadding)
		}
	}
	
	** Different pod names prevents "sys::Err: Duplicate pod name: <podName>".
	** We internalise podName so we can guarantee no duplicate pod names
	Str generatePodName() {
		index := podIndex.getAndIncrement.toStr.padl(3, '0')		
		return "afPlastic${index}"
	}
}

