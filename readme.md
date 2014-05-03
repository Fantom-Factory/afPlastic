# Plastic

*`Plastic` is a support library that aids Alien-Factory in the development of libraries, frameworks and applications.
Though you are welcome to use it, you may find features are missing and the documentation incomplete.*

`Plastic` is a [Fantom](http://fantom.org/) library for dynamically generating and compiling Fantom code.

`Plastic` is the cornerstone of
[IoC](http://repo.status302.com/doc/afIoc/#overview) proxied services and
[Embedded Fantom (efan)](http://repo.status302.com/doc/afEfan/#overview) templates.


## Install

Install `Plastic` with the Fantom Respository Manager ( [fanr](http://fantom.org/doc/docFanr/Tool.html#install) ):

    $ fanr install -r http://repo.status302.com/fanr/ afPlastic

To use in a [Fantom](http://fantom.org/) project, add a dependency to `build.fan`:

    depends = ["sys 1.0", ..., "afPlastic 1.0+"]



## Documentation

Full API & fandocs are available on the [status302 repository](http://repo.status302.com/doc/afPlastic/#overview).



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
