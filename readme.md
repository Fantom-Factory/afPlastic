# Plastic v1.1.4
---

[![Written in: Fantom](http://img.shields.io/badge/written%20in-Fantom-lightgray.svg)](http://fantom-lang.org/)
[![pod: v1.1.4](http://img.shields.io/badge/pod-v1.1.4-yellow.svg)](http://eggbox.fantomfactory.org/pods/afPlastic)
[![Licence: ISC](http://img.shields.io/badge/licence-ISC-blue.svg)](https://choosealicense.com/licenses/isc/)

## Overview

*Plastic is a support library that aids Alien-Factory in the development of other libraries, frameworks and applications. Though you are welcome to use it, you may find features are missing and the documentation incomplete.*

Plastic is a library for dynamically generating and compiling Fantom code.

Plastic is the cornerstone of [IoC](http://eggbox.fantomfactory.org/pods/afIoc) proxied services and [Embedded Fantom (efan)](http://eggbox.fantomfactory.org/pods/afEfan) templates.

## Install

Install `Plastic` with the Fantom Pod Manager ( [FPM](http://eggbox.fantomfactory.org/pods/afFpm) ):

    C:\> fpm install afPlastic

Or install `Plastic` with [fanr](http://fantom.org/doc/docFanr/Tool.html#install):

    C:\> fanr install -r http://eggbox.fantomfactory.org/fanr/ afPlastic

To use in a [Fantom](http://fantom-lang.org/) project, add a dependency to `build.fan`:

    depends = ["sys 1.0", ..., "afPlastic 1.1"]

## Documentation

Full API & fandocs are available on the [Eggbox](http://eggbox.fantomfactory.org/pods/afPlastic/) - the Fantom Pod Repository.

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

