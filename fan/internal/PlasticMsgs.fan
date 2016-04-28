
internal const class PlasticMsgs {
	
	// ---- Err Messages --------------------------------------------------------------------------

	static Str nonConstTypeCannotSubclassConstType(Str typeName, Type superType) {
		"Non-const type ${typeName} can not subclass const type ${superType.qname}"
	}

	static Str constTypeCannotSubclassNonConstType(Str typeName, Type superType) {
		"Const type ${typeName} can not subclass non-const type ${superType.qname}"
	}

	static Str superTypesMustBePublic(Str typeName, Type superType) {
		"Super types must be 'public' or 'protected' scope - class ${typeName} : ${superType.qname}"
	}

	static Str overrideMethodDoesNotBelongToSuperType(Method method, Type[] superTypes) {
		"Method ${method.qname} does not belong to super types " + superTypes.map { it.qname }.join(", ")
	}

	static Str overrideMethodHasWrongScope(Method method) {
		"Method ${method.qname} must have 'public' or 'protected' scope"
	}

	static Str overrideMethodsMustBeVirtual(Method method) {
		"Method ${method.qname} must be virtual (or abstract)"
	}

	static Str overrideFieldDoesNotBelongToSuperType(Field field, Type[] superTypes) {
		"Field ${field.qname} does not belong to super type " + superTypes.map { it.qname }.join(", ")
	}

	static Str overrideFieldHasWrongScope(Field field) {
		"Field ${field.qname} must have 'public' or 'protected' scope"
	}

	static Str overrideMethodsCanNotHaveDefaultValues(Method method, Param param) {
		"Can not determine a default parameter value for param '${param.name}' of : ${method.qname}"
	}

	static Str usingStrMustNotStartWithUsing(Str usingStr) {
		"UsingStr '${usingStr} must not start with 'using'"
	}
}
