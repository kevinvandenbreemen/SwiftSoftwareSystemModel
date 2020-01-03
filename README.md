# SwiftSoftwareSystemModel

## Introduction

A reusable package for creating abstract models of software systems.  This system is written in Swift and primarily designed for helping understand the architecture of Swift programs.  However there is no reason it could not be used to analyze and diagram code in other languages.

For more specifics on how this package can be used please see also [SwiftCodeHelper](https://github.com/kevinvandenbreemen/SwiftCodeHelper).

## Architecture

![Architecture](doc/res/SwiftCodeHelper-SwiftSoftwareSystemModel.svg)

### Questions / Possible FAQ

#### Why do you neeed both a ClassProperty and a PropertyForDisplay?
This allows me to display fields of types that the developer didn't need to explicitly specify.  For example, it would be preferable to include a String field on a class as well as a field of a type that is defined in the codebase under analysis.