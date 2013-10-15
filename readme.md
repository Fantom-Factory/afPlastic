# afPlastic

*afPlastic is a support library and exists to aid the development of other Alien-Factory libraries and frameworks.
Though you are welcome to use it, you may find features are missing and the documentation incomplete!*

`afPlastic` is a [Fantom](http://fantom.org/) library for dynamically generating and compiling Fantom code.

`afPlastic` is the cornerstone of
[afIoc](http://repo.status302.com/doc/afIoc/#overview) proxied services and
[Embedded Fantom (efan)](http://repo.status302.com/doc/afEfan/#overview) templates.




## Quick Start

    model := PlasticClassModel("MyClass", true)
    model.addMethod(Str#, "greet", "Str name", """ "Hello \${name}!" """)

    model.toFantomCode // -->

    // const class MyClass {
    //   new make(|This|? f := null) {
    //     f?.call(this)
    //   }
    //
    //   sys::Str greet(Str name) {
    //      "Hello ${name}!"
    //   }
    // }
  
    myClass := PlasticCompiler().compileModel(model)
    myClass.make->greet("Mum") // --> Hello Mum!



## Documentation

Full API & fandocs are available on the [status302 repository](http://repo.status302.com/doc/afPlastic/#overview).



## Install

Download from [status302](http://repo.status302.com/browse/afPlastic).

Or install via fanr:

    $ fanr install -r http://repo.status302.com/fanr/ afPlastic

To use in a project, add a dependency in your `build.fan`:

    depends = ["sys 1.0", ..., "afPlastic 1.0+"]
