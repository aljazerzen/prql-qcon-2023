# PRQL - modern pipelined SQL replacement

## SQL as compilation target

<!--
Integrating a language into a database comes with a few downsides.

If you reuse some existing language (like SQL):
- you have to implement it with all of its quirks that people are already used to,
- you will certainly diviate from the language at some point,

If you create a new language:
- you have to design a language alogside an already complex system,
- it will lack a few features,
- people will have to learn it,

What about a database without a language at all? If the database is relational, you could just specify a list, say in JSON, of what tables to return.

But that will return all columns and also all rows! We need to add more info. And now you have created a language.
-->

Now I need to talk about the elephant in the room. How is this new language executed?
As I've said, it is meant to replace SQL, but this is only partially true.
PRQL is not meant to be integerated into databases and exposed as a database interface.
(well it could be, but that would not be the ideal scenario)
What I mean, is that it replaces the language that people use to express their data transformations.
This leaves the question: what would the ideal database interface be?
To answer that, we need to know why databases invent query languages in the first place.

### The task of a query lanuage

Imagine we had a database without a query language.
Well, you'd need some kind of interface, so imagine there is an API where you specify a table that you want to query.

That would be equivalent to issuing `SELECT * FROM albums` and then filter and join in your super fast Rust code.
That would be super slow, as it would transfer way too much data to the client, just to be thrown away later.

To be fair, we could also include the `WHERE` clause in our API, but that still doesn't solve all the problems.

A more extreme example is `SELECT COUNT(*) FROM albums WHERE title LIKE 'The %'`,
where we do some processing on our data and return a single number.

What you want is for this processing to happen as close to the data as possible.

This is the ideal scenario because:
- minimal data transfer: this is obvious, if we don't transfer data from the database to the client there is less things to do.
  and as the saying goes, best way to make a program faster is to do less.
- parallelism: your database might be enormous, spanned over multiple nodes.
  this is possible to achieve with general programming languages, but it is not easy.
- vectorization: some operations (eg. a sum of two columns) can be compiled to vectorized CPU instructions.
  this gives enormous performance boost (see DuckDB or Polars)

<!--
As people who worked with MapReduce know, this query is embarisingly simple to paralelize.
-->

So essentially, we are giving the database a program that we want executed and the database does that for you, before returning the data.

Which makes the database an execution platform or a compilation target.

Similarly as when:
- a Rust program compiles to a binary to be executed on a amd64 processor, for example, and
- a Java program compiles to byte code to be executed in JVM,
- -> we compile PRQL to SQL to be executed in a database.

### Leaky abstractions

We want the database interface to be transparent to the user.

Currently, this is not the case:
- our compiler is not perfect: sometimes it outputs invalid SQL,
- out compiler is not perfect: sometimes it outputs sub-optimal SQL,
- runtime errors report locations in SQL,

### A better database interface

When an SQL query is received by a database, it hits another compiler. It is parsed, desugared, resolved and compiled into a query plan - an object the database can then execute.

So when we started thinking about SQL as a compilation target, we saw a few things that could be improved, if we were replace the SQL with a more rigid query representation.

Because the interaction with the database happens at runtime, we would want to:
- minimize runtime query processing (to improve performance and simplify tooling),
- remove ambiguity,
- easy to extend,

substrait.io

## PRQL, the project

How to use it
How to contribute
