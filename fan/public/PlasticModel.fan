
** Models a Fantom class.
** 
** All types are generated with a standard serialisation ctor:
** 
**   new make(|This|? f := null) { f?.call(this) }
** 
** All added fields and methods will be public. As you will never compile against the generated 
** code, this should not be problematic. 
class PlasticClassModel {
		** Set to 'true' if this class is 'const'
		const Bool 					isConst
	
		** The name of the class.
		const Str 					className
		
		** The superclass type.
			Type					superClass	:= Obj#		{ private set }
	
		** A list of mixin types the model extends. 
			Type[]					mixins		:= [,]		{ private set }	// for user info only

	private Pod[] 					usingPods	:= [,]
	private Type[] 					usingTypes	:= [,]
	private Type[] 					extends		:= [,]
	private PlasticFieldModel[]		fields		:= [,]
	private PlasticMethodModel[]	methods		:= [,]

	** Creates a class model with the given name. 
	new make(Str className, Bool isConst) {
		this.isConst 	= isConst
		this.className	= className
		
		extends.add(superClass)
	}

	** 'use' the given pod.
	This usingPod(Pod pod) {
		usingPods.add(pod)
		return this
	}

	** 'use' the given type.
	This usingType(Type type) {
		usingTypes.add(type)
		return this
	}

	** Sets the given type as the superclass. 
	** If this model is const, then the given type must be const also.
	** This method may only be called once.
	** The superclass must be an acutal 'class' (not a mixin) and be public.  
	This extendClass(Type classType) {
		if (isConst && !classType.isConst)
			throw PlasticErr(PlasticMsgs.constTypeCannotSubclassNonConstType(className, classType))
		if (!isConst && classType.isConst)
			throw PlasticErr(PlasticMsgs.nonConstTypeCannotSubclassConstType(className, classType))
		if (superClass != Obj#)
			throw PlasticErr(PlasticMsgs.canOnlyExtendOneClass(className, superClass, classType))
		if (!classType.isClass)
			throw PlasticErr(PlasticMsgs.canOnlyExtendClass(classType))
		if (classType.isInternal)
			throw PlasticErr(PlasticMsgs.superTypesMustBePublic(className, classType))
		
		extends = extends.exclude { it == superClass}.add(classType)
		superClass = classType
		return this	
	}

	** Extend the given mixin. 
	** The mixin must be public.  
	This extendMixin(Type mixinType) {
		if (isConst && !mixinType.isConst)
			throw PlasticErr(PlasticMsgs.constTypeCannotSubclassNonConstType(className, mixinType))
		if (!isConst && mixinType.isConst)
			throw PlasticErr(PlasticMsgs.nonConstTypeCannotSubclassConstType(className, mixinType))
		if (!mixinType.isMixin)
			throw PlasticErr(PlasticMsgs.canOnlyExtendMixins(mixinType))
		if (mixinType.isInternal)
			throw PlasticErr(PlasticMsgs.superTypesMustBePublic(className, mixinType))

		mixins.add(mixinType)
		extends.add(mixinType)
		return this
	}

	** Add a field.
	** 'getBody' and 'setBody' are code blocks to be used in the 'get' and 'set' accessors.
	PlasticFieldModel addField(Type fieldType, Str fieldName, Str? getBody := null, Str? setBody := null, Type[] facets := Type#.emptyList) {
		// synthetic fields may be non-const - how do we check if field is synthetic?
//		if (isConst && !fieldType.isConst)
//			throw PlasticErr(PlasticMsgs.constTypesMustHaveConstFields(className, fieldType, fieldName))

		fieldModel := PlasticFieldModel(false, PlasticVisibility.visPublic, fieldType.isConst, fieldType, fieldName, getBody, setBody, facets)
		fields.add(fieldModel)
		return fieldModel
	}

	** Override a field. 
	** The given field must exist in a super class / mixin.
	** 'getBody' and 'setBody' are code blocks to be used in the 'get' and 'set' accessors.
	This overrideField(Field field, Str? getBody := null, Str? setBody := null) {
		if (!extends.any { it.fits(field.parent) })
			throw PlasticErr(PlasticMsgs.overrideFieldDoesNotBelongToSuperType(field, extends))
		if (field.isPrivate || field.isInternal)
			throw PlasticErr(PlasticMsgs.overrideFieldHasWrongScope(field))
		
		fields.add(PlasticFieldModel(true, PlasticVisibility.visPublic, field.isConst, field.type, field.name, getBody, setBody, Facet#.emptyList))
		return this
	}

	** Add a method.
	** 'signature' does not include (brackets).
	** 'body' does not include {braces}
	This addMethod(Type returnType, Str methodName, Str signature, Str body) {
		methods.add(PlasticMethodModel(false, PlasticVisibility.visPublic, returnType, methodName, signature, body))
		return this
	}

	** Add a method.
	** The given method must exist in a super class / mixin.
	** 'body' does not include {braces}
	This overrideMethod(Method method, Str body) {
		if (!extends.any { it.fits(method.parent) })
			throw PlasticErr(PlasticMsgs.overrideMethodDoesNotBelongToSuperType(method, extends))
		if (method.isPrivate || method.isInternal)
			throw PlasticErr(PlasticMsgs.overrideMethodHasWrongScope(method))
		if (!method.isVirtual)
			throw PlasticErr(PlasticMsgs.overrideMethodsMustBeVirtual(method))
		if (method.params.any { it.hasDefault })
			throw PlasticErr(PlasticMsgs.overrideMethodsCanNotHaveDefaultValues(method))
		
		methods.add(PlasticMethodModel(true, PlasticVisibility.visPublic, method.returns, method.name, method.params.join(", "), body))
		return this
	}

	** Converts the model into Fantom source code.
	** 
	** All types are generated with a standard serialisation ctor:
	** 
	**   new make(|This|? f := null) { f?.call(this) }
	Str toFantomCode() {
		code := ""
		usingPods.unique.each  { code += "using ${it.name}\n" }
		usingTypes.unique.each { code += "using ${it.qname}\n" }
		code += "\n"
		constKeyword 	:= isConst ? "const " : ""
		extendsKeyword	:= extends.exclude { it == Obj#}.isEmpty ? "" : " : " + extends.exclude { it == Obj#}.map { it.qname }.join(", ") 
		
		code += "${constKeyword}class ${className}${extendsKeyword} {\n\n"
		fields.each { code += it.toFantomCode }
		
		code += "\n"
		code += "	new make(|This|? f := null) {
		         		f?.call(this)
		         	}\n"
		code += "\n"

		methods.each { code += it.toFantomCode }
		code += "}\n"
		return code
	}
}

** Models a Fantom field.
class PlasticFieldModel {
	Bool			 	isOverride
	PlasticVisibility 	visibility
	Bool				isConst
	Type				type
	Str					name
	Str? 				getBody
	Str? 				setBody
	Type[] 				facetTypes
	
	internal new make(Bool isOverride, PlasticVisibility visibility, Bool isConst, Type type, Str name, Str? getBody, Str? setBody, Type[] facetTypes) {
		this.isOverride	= isOverride
		this.visibility = visibility
		this.isConst	= isConst
		this.type		= type
		this.name		= name
		this.getBody	= getBody
		this.setBody	= setBody
		this.facetTypes	= facetTypes
	}
	
	** Converts the model into Fantom source code.
	Str toFantomCode() {
		field := ""
		facetTypes.each { field += "	@${it.qname}\n" }
		overrideKeyword	:= isOverride ? "override " : ""
		constKeyword	:= isConst ? "const " : "" 
		field +=
		"	${overrideKeyword}${visibility.keyword}${constKeyword}${type.signature} ${name}"
		if (getBody != null || setBody != null) {
			field += " {\n"
			if (getBody != null)
				field += "		get { ${getBody} }\n"
			if (setBody != null)
				field += "		set { ${setBody} }\n"
			field += "	}\n"
		}
		field += "\n"
		return field
	}
}

** Models a Fantom method.
class PlasticMethodModel {
	Bool			 	isOverride
	PlasticVisibility 	visibility
	Type				returnType
	Str					name
	Str					signature
	Str					body

	internal new make(Bool isOverride, PlasticVisibility visibility, Type returnType, Str name, Str signature, Str body) {
		this.isOverride	= isOverride
		this.visibility = visibility
		this.returnType	= returnType
		this.name		= name
		this.signature	= signature
		this.body		= body
	}
	
	** Converts the model into Fantom source code.
	Str toFantomCode() {
		overrideKeyword	:= isOverride ? "override " : ""
		return
		"	${overrideKeyword}${visibility.keyword}${returnType.signature} ${name}(${signature}) {
		 		${indentBody}
		 	}\n"
	}
	
	private Str indentBody() {
		body.splitLines.join("\n\t\t")
	}
}

** A list of Fantom visibilities.
enum class PlasticVisibility {
	** Private scope.
	visPrivate	("private "),
	** Internal scope.
	visInternal	("internal "),
	** Protected scope.
	visProtected("protected "),
	** Public scope.
	visPublic	("");
	
	** The keyword to be used in Fantom source code. 
	const Str keyword
	
	private new make(Str keyword) {
		this.keyword = keyword
	}

	** Returns the visibility of the given field / method.
	static PlasticVisibility fromSlot(Slot slot) {
		if (slot.isPrivate)
			return visPrivate
		if (slot.isInternal)
			return visInternal
		if (slot.isProtected)
			return visProtected
		if (slot.isPublic)
			return visPublic
		throw Err("What visibility is ${slot.signature}???")
	}
}
