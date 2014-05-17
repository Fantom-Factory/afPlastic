## Overview 

*`Plastic` is a support library that aids Alien-Factory in the development of other libraries, frameworks and applications. Though you are welcome to use it, you may find features are missing and the documentation incomplete.*

`Plastic` is a library for dynamically generating and compiling Fantom code.

`Plastic` is the cornerstone of [IoC](http://www.fantomfactory.org/pods/afIoc) proxied services and [Embedded Fantom (efan)](http://www.fantomfactory.org/pods/afEfan) templates.

## Install 

Install `Plastic` with the Fantom Repository Manager ( [fanr](http://fantom.org/doc/docFanr/Tool.html#install) ):

    C:\> fanr install -r http://repo.status302.com/fanr/ afPlastic

To use in a [Fantom](http://fantom.org/) project, add a dependency to `build.fan`:

    depends = ["sys 1.0", ..., "afPlastic 1.0+"]

## Quick Start 

```
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

myType := PlasticCompiler().compileModel(model)
myType.make->greet("Mum")

// --> Hello Mum!
```

