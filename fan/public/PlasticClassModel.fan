
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
	private PlasticCtorModel[]		ctors		:= [,]

	** Creates a class model with the given name. 
	new make(Str className, Bool isConst) {
		this.isConst 	= isConst
		this.className	= className
		
		extends.add(superClass)
		addCtor("make", "|This|? f := null", "f?.call(this)")
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
	PlasticFieldModel overrideField(Field field, Str? getBody := null, Str? setBody := null, Type[] facets := Type#.emptyList) {
		if (!extends.any { it.fits(field.parent) })
			throw PlasticErr(PlasticMsgs.overrideFieldDoesNotBelongToSuperType(field, extends))
		if (field.isPrivate || field.isInternal)
			throw PlasticErr(PlasticMsgs.overrideFieldHasWrongScope(field))
		
		fieldModel := PlasticFieldModel(true, PlasticVisibility.visPublic, field.isConst, field.type, field.name, getBody, setBody, facets)
		fields.add(fieldModel)
		return fieldModel
	}

	** Add a method.
	** 'signature' does not include (brackets).
	** 'body' does not include {braces}
	PlasticMethodModel addMethod(Type returnType, Str methodName, Str signature, Str body) {
		methodModel := PlasticMethodModel(false, PlasticVisibility.visPublic, returnType, methodName, signature, body)
		methods.add(methodModel)
		return methodModel
	}

	** Add a method.
	** The given method must exist in a super class / mixin.
	** 'body' does not include {braces}
	PlasticMethodModel overrideMethod(Method method, Str body) {
		if (!extends.any { it.fits(method.parent) })
			throw PlasticErr(PlasticMsgs.overrideMethodDoesNotBelongToSuperType(method, extends))
		if (method.isPrivate || method.isInternal)
			throw PlasticErr(PlasticMsgs.overrideMethodHasWrongScope(method))
		if (!method.isVirtual)
			throw PlasticErr(PlasticMsgs.overrideMethodsMustBeVirtual(method))
		if (method.params.any { it.hasDefault })
			throw PlasticErr(PlasticMsgs.overrideMethodsCanNotHaveDefaultValues(method))
		
		methodModel := PlasticMethodModel(true, PlasticVisibility.visPublic, method.returns, method.name, method.params.join(", "), body)
		methods.add(methodModel)
		return methodModel
	}

	** Add a ctor.
	** 'signature' does not include (brackets).
	** 'body' does not include {braces}
	PlasticCtorModel addCtor(Str ctorName, Str signature, Str body) {
		ctorModel := PlasticCtorModel(PlasticVisibility.visPublic, ctorName, signature, body)
		ctors.add(ctorModel)
		return ctorModel
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
		extendsKeyword	:= extends.exclude { it == Obj#}.isEmpty ? "" : " : " + extends.unique.exclude { it == Obj#}.map { it.qname }.join(", ") 
		
		code += "${constKeyword}class ${className}${extendsKeyword} {\n\n"
			fields	.each { code += it.toFantomCode }
			ctors	.each { code += it.toFantomCode }
			methods	.each { code += it.toFantomCode }
		code += "}\n"
		return code
	}
}
