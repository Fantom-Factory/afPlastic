
** Models a Fantom class.
** 
** If not defined already, types are generated with a standard it-block ctor:
** 
**   syntax: fantom
**   new make(|This|? f := null) { f?.call(this) }
** 
** All added fields and methods will be public. As you will never compile against the generated 
** code, this should not be problematic.
// Class Model is correct, to be paired with MixinModel!
class PlasticClassModel {
	** Set to 'true' if this class is 'const'
	const Bool			isConst

	** The name of the class.
	const Str			className
	
	** The superclass type.
	Type				superClass	:= Obj#		{ private set }

	** A list of mixin types the model extends. 
	Type[]				mixins		:= [,]		{ private set }	// for user info only

	PlasticUsingModel[]		usings	{ private set }
	PlasticFacetModel[]		facets	{ private set }
	PlasticFieldModel[]		fields	{ private set }
	PlasticMethodModel[]	methods	{ private set }
	PlasticCtorModel[]		ctors	{ private set }	

	private Type[] 			extends() {
		[superClass].addAll(mixins)
	}
	
	** Creates a class model with the given name. 
	new make(Str className, Bool isConst) {
		this.isConst 	= isConst
		this.className	= className
		this.usings		= [,]
		this.facets		= [,]
		this.fields		= [,]
		this.methods	= [,]
		this.ctors		= [,]
	}

	** 'use' the given pod.
	This usingPod(Pod pod) {
		usings.add(PlasticUsingModel(pod))
		return this
	}

	** 'use' the given type.
	This usingType(Type type, Str? usingAs := null) {
		usings.add(PlasticUsingModel(type, usingAs))
		return this
	}

	** 'use' the given Str, should not start with using.
	This usingStr(Str usingStr) {
		usings.add(PlasticUsingModel(usingStr))
		return this
	}

	PlasticFacetModel addFacet(Type type, Str:Str params := [:]) {
		facetModel := PlasticFacetModel(type, params)
		facets.add(facetModel)
		return facetModel
	}
	
	This addFacetClone(Facet toClone) {
		facets.add(PlasticFacetModel(toClone))
		return this
	}

	** Extends the given type; be it a class or a mixin.
	** 
	** If 'type' is a class, it is set as the superclass, if it is a mixin, it is extended.
	** 
	** If this model is const, then the given type must be const also.
	** 
	** The type must be public.
	This extend(Type type) {
		// this is actually fine - const classes CAN extend non-const mixins 
//		if (isConst && !type.isConst)
//			throw PlasticErr(PlasticMsgs.constTypeCannotSubclassNonConstType(className, type))
		if (!isConst && type.isConst)
			throw PlasticErr("Non-const type ${className} can not subclass const type ${type.qname}")
		if (type.isInternal)
			throw PlasticErr("Super types must be 'public' or 'protected' scope - class ${className} : ${type.qname}")
		
		if (type.isClass) {
			if (superClass != Obj# && superClass != type)
				throw PlasticErr("Can not set Supertype to ${type.qname}, it is already set to ${superClass.qname}")
			superClass = type
		}

		if (type.isMixin) {
			// need to be clever about what mixin we add
			// see http://fantom.org/sidewalk/topic/2216
			if (mixins.any { it.fits(type) })
				return this
	
			mixins := this.mixins.exclude { type.fits(it) }
			mixins.add(type)
			
			this.mixins = mixins.unique			
		}
		
		return this	
	}

	@NoDoc @Deprecated { msg="Use extend() instead" }
	This extendClass(Type classType) {
		extend(classType)
	}

	@NoDoc @Deprecated { msg="Use extend() instead" }
	This extendMixin(Type mixinType) {
		extend(mixinType)
	}

	** Add a field.
	** 'getBody' and 'setBody' are code blocks to be used in the 'get' and 'set' accessors.
	PlasticFieldModel addField(Type fieldType, Str fieldName, Str? getBody := null, Str? setBody := null) {
		// synthetic fields may be non-const - how do we check if field is synthetic?
//		if (isConst && !fieldType.isConst)
//			throw PlasticErr(PlasticMsgs.constTypesMustHaveConstFields(className, fieldType, fieldName))

		fieldModel := PlasticFieldModel(false, PlasticVisibility.visPublic, isConst, fieldType, fieldName, getBody, setBody)
		fields.add(fieldModel)
		return fieldModel
	}

	** Override a field. 
	** The given field must exist in a super class / mixin.
	** 'getBody' and 'setBody' are code blocks to be used in the 'get' and 'set' accessors.
	PlasticFieldModel overrideField(Field field, Str? getBody := null, Str? setBody := null) {
		if (!extends.any { it.fits(field.parent) })
			throw PlasticErr("Field ${field.qname} does not belong to super type " + extends.map { it.qname }.join(", "))
		if (field.isPrivate || field.isInternal)
			throw PlasticErr("Field ${field.qname} must have 'public' or 'protected' scope")
		
		fieldModel := PlasticFieldModel(true, PlasticVisibility.visPublic, field.isConst, field.type, field.name, getBody, setBody)
		fields.add(fieldModel)
		return fieldModel
	}
	
	** Returns 'true' if this model has a field with the given name.
	Bool hasField(Str name) {
		fields.any { it.name == name }
	}

	** Add a method.
	** 'signature' does not include (brackets).
	** 'body' does not include {braces}
	PlasticMethodModel addMethod(Type returnType, Str methodName, Str signature, Str body) {
		methodModel := PlasticMethodModel(false, PlasticVisibility.visPublic, returnType, methodName, signature, body)
		methods.add(methodModel)
		return methodModel
	}

	** Override a method.
	** The given method must exist in a super class / mixin.
	** 'body' does not include {braces}
	PlasticMethodModel overrideMethod(Method method, Str body) {
		if (!extends.any { it.fits(method.parent) })
			throw PlasticErr(overrideMethodDoesNotBelongToSuperType(method, extends))
		if (method.isPrivate || method.isInternal)
			throw PlasticErr("Method ${method.qname} must have 'public' or 'protected' scope")
		if (!method.isVirtual)
			throw PlasticErr("Method ${method.qname} must be virtual (or abstract)")
		
		params := method.params.map |param->Str| {
			pSig := "${param.type.signature} ${param.name}"
			if (param.hasDefault) {
				def := guessDefault(method, param)
				if (def == null)
					throw PlasticErr("Can not determine a default parameter value for param '${param.name}' of : ${method.qname}")
				pSig += " := ${def}"
			}
			return pSig
		}
		
		methodModel := PlasticMethodModel(true, PlasticVisibility.visPublic, method.returns, method.name, params.join(", "), body)
		methods.add(methodModel)
		return methodModel
	}

	** Add a ctor.
	** 
	** 'signature' does not include (brackets).
	** 
	** 'body' does not include {braces}
	** 
	** 'superCtor' is the entire expression, 'super.make(in)'
	PlasticCtorModel addCtor(Str ctorName, Str signature, Str body, Str? superCtor := null) {
		ctorModel := PlasticCtorModel(PlasticVisibility.visPublic, ctorName, signature, body, superCtor)
		ctors.add(ctorModel)
		return ctorModel
	}
	
	** Override a ctor
	** The given ctor method must exist in a super class / mixin.
	** 'body' does not include {braces}
	PlasticCtorModel overrideCtor(Method ctor, Str body) {
		if (!extends.any { it.fits(ctor.parent) })
			throw PlasticErr(overrideMethodDoesNotBelongToSuperType(ctor, extends))
		if (ctor.isPrivate || ctor.isInternal)
			throw PlasticErr("Method ${ctor.qname} must have 'public' or 'protected' scope")
		
		params := ctor.params.map |param->Str| {
			pSig := "${param.type.signature} ${param.name}"
			if (param.hasDefault) {
				def := guessDefault(ctor, param)
				if (def == null)
					throw PlasticErr("Can not determine a default parameter value for param '${param.name}' of : ${ctor.qname}")
				pSig += " := ${def}"
			}
			return pSig
		}
		
		paramSig := params.join(", ")
		paramNom := ctor.params.map { it.name }.join(", ")
		
		ctorModel := PlasticCtorModel(PlasticVisibility.visPublic, ctor.name, paramSig, body, "super.${ctor.name}(${paramNom})")
		ctors.add(ctorModel)
		return ctorModel
	}
	
	** Converts the model into Fantom source code.
	** 
	** All types are generated with a standard serialisation ctor:
	**
	**   syntax: fantom
	**   new make(|This|? f := null) { f?.call(this) }
	Str toFantomCode() {
		typeCache := TypeCache()

		// add a useful default ctor if it doesn't exist
		if (superClass == Obj# && ctors.any { it.name == "make" }.not)
			addCtor("make", "|This|? f := null", "f?.call(this)")

		code := StrBuf()

		facets.each { code.add(it.toFantomCode) }
		
		constKeyword 	:= isConst ? "const " : ""
		extendsKeyword	:= extends.exclude { it == Obj#}.isEmpty ? "" : " : " + extends.unique.exclude { it == Obj#}.map { it.qname }.join(", ") 
		
		code.add("${constKeyword}class ${className}${extendsKeyword} {\n\n")
			fields	.each { code.add(it.toFantomCode(typeCache)) }
			ctors	.each { code.add(it.toFantomCode) }
			methods	.each { code.add(it.toFantomCode(typeCache)) }
		code.add("}\n")

		typeCache.addTo(usings)
		useStr := StrBuf()
		usings.unique.each { useStr.add(it.toFantomCode) }
		useStr.addChar('\n')

		code.insert(0, useStr.toStr)
		return code.toStr
	}
	
	internal Str? guessDefault(Method method, Param param) {
		
		if (method.isStatic || method.isCtor)
			try {
				// new in Fantom 1.0.68 !!!
				def := method.paramDef(param)
				if (def != null) {
					toCode := ReflectUtils.findMethod(param.type, "toCode", null, false, Str#)
					if (toCode != null)
						return toCode.callOn(def, null)
					if (def.typeof.hasFacet(Serializable#)) {
						sBuf := StrBuf()
						sBuf.clear.out.writeObj(def).close
						return sBuf.toStr
					}
				}
			} catch (Err e) { /* meh */ }
		
		// Special case for Bool checked
		if (param.type == Bool# && param.name.equalsIgnoreCase("checked"))
			return true.toStr
			
		try {
			// nullable values
			defVal := BeanBuilder.defVal(param.type)
			if (defVal == null)
				return "null"
			
			// types with a defVal and a toCode() method
			toCode := ReflectUtils.findMethod(param.type, "toCode", null, false, Str#)
			if (toCode != null)
				return toCode.callOn(defVal, null)
		} catch 
			return null
			
		// types with a default ctor 
		ctor := ReflectUtils.findCtors(param.type)
		if (ctor.size == 1)
			return "${param.type.qname}()"
		
		return null
	}
	
	private static Str overrideMethodDoesNotBelongToSuperType(Method method, Type[] superTypes) {
		"Method ${method.qname} does not belong to super types " + superTypes.map { it.qname }.join(", ")
	}
}
