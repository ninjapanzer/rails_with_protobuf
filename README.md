# README

## What are we looking at here?

The purpose of this repo is to explore and refine a few ideas around the use of Protobuf, Rails-Api, and a stateless security context.

As this is a focus on the Protobuf we are leaning heavily on enums to constrain our common types. These enforce a simple contract of a symbol, string, or integer representation.
The value of the enum is by default a integer and can be infered to a symbol using the `#lookup` method and we can convert back to the object from string with `#resolve`.

## What is the problem we are trying to solve?

We what to show how to include protobuf in a project and make it work with zeitwerk as well as promote the use of their generated classes as shared objects.
We don't need to allow the objects to cross domain borders. The provide a manner of typesafety when serialized which allows us to enforce a level of type safety on our contracts.
Types aside these contracts are easy to devolope complicated and nested structures without much boilerplate. While populating nested objects can be verbose we can use these contracts to
define the objects we need to meet our contracts and share them for public consumption.

While this is a simple project with a lot of enums it shows how a contract can both be used within the application as a security context under `current_user` within secured.rb as well as a response contract from the controllers.

It could of course also be the parser for an request contract when accepting json data.

Techniques like this allow us to move to IPC style communication via GRPC which encapsulates local-sockets.

## How does this live with sorbet

Well in some cases this is a different concern than that which sorbet tries to solve. Instead of trying to be verbose about types we are instead trying to eliminate shapeless data transport and relying as often as possible on value objects. Since its easy to define and describe a protobuf it easily creates a value object when needed. These can be namespaced and because they have a constrained syntax it should be easier for engineers and product to collaborate on these with ease.

Sorbet on the other hand wishes for us to infer our internal types and supports local runtime checking. It is extremely powerful but adds a lot of noise to the code. One of the things we don't often struggle with in ruby is making sure the right type inference is met. But we do suffer from the inability to express the shape of our contracts when we use hashes. Sorbet provides a medium weight data object to enhance structs for creating simple types.

If we wanted to infer sorbet types we could add an extension to the protoc compiler to assign types to the generated files. We could also generate RBIs for our proto classes to mirror the types created by protobuf messages.

If you wanna use sorbet with this project you can run `make init` and `make compile-rbi`
