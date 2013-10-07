
** A class to ensure future versions of afPlastic will be backwards compatible with afIoc. 
@NoDoc
class IocClassModel {
	
	private PlasticClassModel model
	
	new make(Str className, Bool isConst) {
		model = PlasticClassModel(className, isConst)
	}

	Str className() {
		model.className
	}
	
	This extendMixin(Type mixinType) {
		model.extendMixin(mixinType)
		return this
	}
	
	This addField(Type fieldType, Str fieldName, Str? getBody := null, Str? setBody := null) {
		model.addField(fieldType, fieldName, getBody, setBody)
		return this
	}

	This overrideField(Field field, Str? getBody := null, Str? setBody := null) {
		model.overrideField(field, getBody, setBody)
		return this
	}
	
	This overrideMethod(Method method, Str body) {
		model.overrideMethod(method, body)
		return this
	}
	
	Str toFantomCode() {
		model.toFantomCode
	}
}
