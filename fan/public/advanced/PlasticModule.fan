
@NoDoc	// advanced use only
const class PlasticModule {
	
	Str:Obj defineModule() {
		[
			"services"	: [
				[
					"id"	: PlasticCompiler#.qname,
					"type"	: PlasticCompiler#,
					"scopes": ["root"]
				]
			]
		]
	}
	
}
