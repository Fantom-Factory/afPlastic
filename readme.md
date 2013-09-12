# afPlastic

afPlastic is a [Fantom](http://fantom.org/) library for dynamically generating and compiling Fantom code.



## Quick Start

    model := PlasticClassModel("MyClass", true)
    model.addMethod(Str#, "greet", "Str name", """ "Hello \${name}!" """)

    myClass := PlasticCompiler().compileModel(model)
    myClass.make->greet("Mum") // --> Hello Mum!



## Documentation

Full API & fandocs are available on the [status302 repository](http://repo.status302.com/doc/afPlastic/#overview).



## Install

Download from [status302](http://repo.status302.com/browse/afPlastic).

Or install via fanr:

    $ fanr install -r http://repo.status302.com/fanr/ afPlastic

