# Background

This thesis illustrates an approach of implementing a language server for the Nickel language which communicates with its clients, i.e. editors, over the open Language Server Protocol (in the following abbreviated as *LSP*).
The current chapter provides the background on the technological details of the project.
As the work presented aims to be transferable to other languages using the same methods, this chapter will provide the means to distinguish the nickel specific implementation details.

The primary technology built upon in this thesis is the language server protocol.
The first part of this chapter introduces the LSP, its rationale and improvements over classical approaches, technical capabilities and protocol details. 
The second part is dedicated to Nickel, elaborating on the context and use-cases of the language followed by an inspection of the technical features of Nickel.

## Language Server Protocol

The Language Server Protocol is a JSON-RPC based communication specification comprising an LSP client (i.e. editors) and server (also called language server for simplicity).
The LSP decouples the development of clients and servers, allowing developers to focus on either side.
The LSP defines several capabilities -- standardized functions which are remotely executed by the language server.
LSP Clients are often implemented as editor extensions facilitating abstraction libraries helping with the interaction with the protocol and editor interface.
Language Servers analyse source code sent by the client and may implement any number of 
capabilities relevant to the language.
Since the LSP is both language and editor independent, the same server implementation can serve all LSP compliant clients eliminating the need to redundantly recreate the same code intelligence for every editor.
  
Language servers are today's standard of integrating support for programming languages into code editors.
Initially developed by Microsoft for the use with their polyglot editor Visual Studio Code^[https://code.visualstudio.com/] before being released to the public in 2016 by Microsoft, RedHat and Codeenvy, the LSP decouples language analysis and provision of IDE-like features from the editor.
Developed under open source license on GitHub^[https://github.com/microsoft/language-server-protocol/], the protocol allows developers of editors and languages to work independently on the support for new languages.
If supported by both server and client, the LSP now supports more than 24 language features^[https://microsoft.github.io/language-server-protocol/specifications/specification-current/] including code completion, code navigation facilities, contextual information such as types or documentation, formatting, and more.

### JSON-RPC

the LSP uses JSON-RPC to communicate between a language server and a client.
JSON-RPC (v2) [@json-rpc] is a JSON based lightweight transport independent remote procedure call [@rpc] protocol. 

RPC is a paradigm that allows clients to virtually invoke a method at a connected process.
The caller sends a well-defined message to a connected process which executes a procedure associated with the request, taking into account any transmitted arguments.
Upon invoking a remote procedure, the client suspends the execution of its environment while it awaits an answer of the server, corresponding to a classical local procedure return.

JSON-RPC is a JSON based implementation of RPC.
The protocol specifies the format and meaning of the messages exchanged using the protocol, in particular *Request* and *Notification* and *Result* messages.
Since the protocol is based on JSON, is possible to be used through any text based communication channel which includes streams or network sockets.
In fact, JSON-RPC only specifies a message protocol, leaving the choice of the transport method to the application. 

All messages refer to a `method` and a set of `parameters`.
Servers are expected to perform the same procedure associated with the requested `method` at any time.
In return, clients have to follow the calling conventions for the requested method.
Typically, messages are synchronous, i.e., the client awaits a result associated to the method and its parameters before it continues its execution of the calling environment.
Hence, requests are marked with an `id` which is included in the result/error message necessarily sent by the server.
If the client does not require a response, it can omit the `id` field.
The message is then interpreted as a *notification*, which servers cannot respond to.

Part of the JSON-RPC specification is the ability for clients to batch requests and send a list of request or notification objects.
In this case, the server should respond with a list of results matching each request, yet is free to process requests concurrently.

### Commands and Notifications

The LSP builds on top of the JSON-RPC protocol described in the previous subsection.
It defines four sets of commands: 

The largest group are commands that are relevant in the scope of the currently opened document, e.g. autocompletion, refactoring, inline values and more.
In total the LSP defines 33 [@lsp] of such "Language Features".
Editors will notify the server about file changes and client side interaction, i.e., opening, closing and renaming files using "Document Synchronization" methods.
While most commands are defined in the document scope, i.e., a single actively edited file, the LSP allows clients to communicate changes to files in the opened project.
This so called workspace comprises on or more root folders managed by the editor and all files contained in them.
"Workspace Features" allow the server to intercept file creation, renaming or deletion to make changes to existing sources in other files.
Use cases of these features include updating import paths, changing class names and other automations that are not necessary local to a single file.
In addition, the LSP specifies so called "Window Features" which allow the server to control parts of the user interface of the connected editor.
For instance, servers may instruct clients to show notifications and progress bars or open files.


### Description of Key Methods

the authors of langserver.org [@langserver] identified six "key methods" of the LSP.
The methods represent a fundamental set of capabilities, specifically:


1. Code completion
   Suggest identifiers, methods or values at the cursor position.
2. Hover information
   Present additional information about an item under the cursor, i.e., types, contracts and documentation.
3. Jump to definition
   Find and jump to the definition of a local variable or identifier.
4. Find references
   List all usages of a defined variable.
5. Workspace/Document symbols
   List all variables in a workspace or document.
6. Diagnostics
   Analyze source code, i.e., parse and type check and notify the LSP Client if errors arise.

#### Code Completion

*RPC Method: [`textDocument/Completion`](https://microsoft.github.io/language-server-protocol/specifications/specification-current/#textDocument_completion)*

This feature allows users to request a suggested identifier of variables or methods, concrete values or larger templates of generated code to be inserted at the position of the cursor.
The completion can be invoked manually or upon entering language defined trigger characters, such as `.`, `::` or `->`.
The completion request contains the current cursor position, allowing the language server to resolve contextual information based on an internal representation of the document.
In the example ([@fig:lsp-capability-complete]) the completion feature suggests related identifiers for the incomplete function call "`pr`*`int`*".

![](examples/complete.png){#fig:lsp-capability-hover caption="Completion options resolved by the Python language server in Visual Studio Code"}


#### Hover

*RPC Method: [`textDocument/hover`](https://microsoft.github.io/language-server-protocol/specifications/specification-current/#textDocument_hover)*

Hover requests are issued by editors when the user rests their mouse cursor on text in an opened document or issues a designated command in editors without mouse support.
If the language server has indexed any information corresponding to the position, it can generate a report using plain text and code elements, which are then rendered by the editor.
Language servers typically use this to communicate type-signatures or documentation.
An example can be seen in [@fig:lsp-capability-hover].

![](examples/hover.png){#fig:lsp-capability-hover caption="Hover information displayed by the Python language server in Visual Studio Code"}


#### Jump to Definition

*RPC Method: [`textDocument/definition`](https://microsoft.github.io/language-server-protocol/specifications/specification-current/#textDocument_definition)*

The LSP allows users to navigate their code by the means of symbols by finding the definition of a requested symbol.
Symbols can be for instance variable names or function calls.
As seen in [@fig:lsp-capability-definition], editors can use the available information to enrich hover overlays with the hovered element's definition.

![](examples/definition.png){#fig:lsp-capability-hover caption="Hover information enriched with the definition. Python language server in Visual Studio Code"}


#### Find References

*RPC Method: [`textDocument/references`](https://microsoft.github.io/language-server-protocol/specifications/specification-current/#textDocument_references)*

Finding references is the inverse operation to the previously discussed *Jump to Definition* ([cf. @sec:jump-to-definition]).
For a given symbol definition, for example variable, function, function argument or record field the LSP provides all usages of the symbol allowing users to inspect or jump to the referencing code position.

![](examples/references.png){#fig:lsp-capability-hover caption="Listing of all references to the method "hello". Python language server in Visual Studio Code"}

#### Workspace/Document symbols

*RPC Method: [`workspace_symbol`](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#workspace_symbol) or [`textDocument_documentSymbol`](https://microsoft.github.io/language-server-protocol/specifications/specification-current/#textDocument_documentSymbol)*

The symbols capability is defined as both a "Language Feature" and "Workspace Feature" which mainly differ in the scope they represent.
The `textDocument/documentSymbol` command lists symbols solely found in the currently opened file, while the `workspace/symbol` takes into account all files in the opened set of folders.
The granularity of the listed items is determined by the server and possibly different for either scope.
For instance, document symbols could be as detailed as listing any kind of method or property found in the document, while workspace symbols take visibility rules into account which might expose public entities only.
Symbols are associated with a span of source code of the symbol itself and its context, for example a function name representing the function body. 
Moreover, the server can annotate the items with additional attributes such as symbol kinds, tags and even child-references (e.g. for the fields of a record or class).


#### Diagnostics

Diagnostics is the collective term for report statements about the analyzed language of varying severity.
This can be parsing or compilation or type-checking n errors, as well as errors and warnings issued by a linting tool.

Unlike the preceding features discussed here, diagnostics are a passive feature, since most often the information stems from external tools being invoked after source code changes.
File updates and diagnostics are therefore specified as notifications to avoid blocking the communication. 


### File Processing

Most language servers handling source code analysis in different ways.
The complexity of the language can be a main influence for the choice of the approach.
Distinctions appear in the way servers process *file indexes and changes* and how they respond to *requests*.

The LSP supports sending updates in form of diffs of atomic changes and complete transmission of changed files.
The former requires incremental parsing and analysis, which are challenging to implement but make processing files much faster upon changes.
An incremental approach makes use of an internal representation of the source code that allows efficient updates upon small changes to the source file.

Additionally, to facilitate the parsing, an incremental approach must be able to provide a parser with the right context to correctly parse a changed fragment of code.
In practice, most language servers process file changes by re-indexing the entire file, discarding the previous internal state entirely.
This is a more approachable method, as it poses less requirements to the architects of the language server.
Yet, it is far less performant.
Unlike incremental processing (which updates only the affected portion of its internal structure), the smallest changes, including adding or removing lines effect the _reprocessing of the entire file_.
While sufficient for small languages and codebases, non-incremental processing quickly becomes a performance bottleneck.

For code analysis LSP implementers have to decide between *lazy* or *greedy* approaches for processing files and answering requests.
Dominantly greedy implementations resolve most available information during the indexing of the file.
The server can then utilize this model to answer requests using mere lookups.
This stands in contrast to lazy approaches where only minimal local information is resolved during the indexing.
Requests invoke an ad-hoc resolution the results of which may be memoized for future requests.
Lazy resolution is more prevalent in conjunction with incremental indexing, since it further reduces the work associated with file changes.
This is essential in complex languages that would otherwise perform a great amount of redundant work.

## Text based Configuration


Configuration languages such as XML[@xml], JSON[@json], or YAML[@yaml] are textual representations of structural data used to configure parameters of a system or application.
The objective of such languages is to be machine readable, yet also intuitive enough for humans to write.

### Common Configuration Languages

#### JSON

According to the JSON specification [@json] the language was designed as a data-interchange format that is easy to read and write both for humans and machines.
Since it is a subset of the JavaScript language, its use is particularly straight forward and wide spread in JavaScript based environments such as web applications.
But due to its simplicity implementations are available and for all major languages,  motivating its use for configuration files.

#### YAML

YAML is another popular language, mainly used for configuration files.
According to its goals [@yaml-goals] it should be human readable and independent of the programming language making use of it.
It should be efficient to parse and easy to implement while being expressive and extensible.

YAML also features a very flexible syntax which allows for many alternative ways to declare semantically equivalent data.
For example boolean expressions can be written as any of the following values: 

> `y|Y|yes|Yes|YES|n|N|no|No|NO`
> `true|True|TRUE|false|False|FALSE`
> `on|On|ON|off|Off|OFF`

Since YAML facilitates indentation as a way to express objects or lists and does not require object keys (and even strings) to be quoted, it is considered easier to write than JSON at the expense of parser complexity.
Yet, YAML is compatible with JSON since as subset of its specification defines a JSON equivalent syntax that permits the use of `{..}` and `[..]` to describe objects and lists respectively. 
Applications of configuration languages are ubiquitous especially in the vicinity of software development. While XML and JSON are often used by package managers [@npm, @maven, @composer], YAML is a popular choice for complex configurations such as CI/CD pipelines [@travis, @ghaction, @gitlab-runner] or machine configurations in software defined networks such as Kubernetes and docker compose.

Such static formats are used due to some significant advantages compared to other formats.
Most strikingly, the textual representation allows inspection of a configuration without the need of a separate tool but a text editor and be version controlled using VCS software like Git.
For software configuration this is well understood as being preferable over databases or other binary formats. Linux service configurations (files in `/etc`) and MacOS `*.plist` files which can be serialized as XML or a JSON-like format, especially exemplify that claim.

Yet, despite these formats being simple to parse and widely supported [@json], their static nature rules out any dynamic content such as generated fields, functions and the possibility to factorize and reuse.
Moreover, content validation has to be developed separately, which led to the design of complementary schema specification languages like json-schema [@json-schema] or XSD [@xsd].

These qualities require an evaluated language.
In fact, some applications make heavy use of config files written in the native programming language which gives them access to language features and existing analysis tools.
Examples include JavaScript frameworks such as webpack [@webpack] or Vue [@vue] and python package management using `setuptools`[@setuptools].

Despite this, not all languages serve as a configuration language, e.g. compiled languages and some domains require language agnostic formats.
For particularly complex products, both language independence and advanced features are desirable.
Alternatively to generating configurations using high level languages, this demand is addressed by more domain specific languages.
Dhall [@dhall], Cue [@cue] or jsonnet [@jsonnet] are such domain specific languages (DSL), that offer varying support for string interpolation, (strict) typing, functions and validation.

### Infrastructure as Code

A prime example for the application of configuration languages are IaaS^[Infrastructure as a Service] products.
These solutions offer great flexibility with regard to resource provision (computing, storage, load balancing, etc.), network setup and scaling of (virtual) servers.
Although the primary interaction with those systems is imperative, maintaining entire applications' or company's environments manually comes with obvious drawbacks.

Changing and undoing changes to existing networks requires intricate knowledge about its topology which in turn has to be meticulously documented.
Undocumented modification pose a significant risk for *config drift* which is particularly difficult to undo imperatively.
Beyond that, interacting with a system through its imperative interfaces demands qualified skills of specialized engineers.

The concept of "Infrastructure as Code" (*IaC*) serves the DevOps principles.
IaC tools help to overcome the need for dedicated teams for *Dev*elopment and *Op*erations by allowing to declaratively specify the dependencies, topology and virtual resources.
Optimally, different environments for testing, staging and production can be derived from a common base and changes to configurations are atomic.
As an additional benefit, configuration code is subject to common software engineering tooling;
It can be statically analyzed, refactored and version controlled to ensure reproducibility.

As a notable instance, the Nix[@nix] ecosystem even goes as far as enabling declarative system and service configuration using NixOps[@nixops].

To get an idea of how this would look like, [@lst:nixops-rproxy] shows the configuration for a deployment of the Git based wiki server Gollum[@gollum] behind a nginx reverse proxy on the AWS network.
Although this example targets AWS, Nix itself is platform-agnostic and NixOps supports different backends through various plugins.
Configurations like this are abstractions over many manual steps and the Nix language employed in this example allows for even higher level turing-complete interaction with configurations.

```{.nix #lst:nixops-rproxy caption="Example NixOps deployment to AWS"}
{
  network.description = "Gollum server and reverse proxy";
  defaults = 
    { config, pkgs, ... }:
    {
      # Configuration of a specific deployment implementation
      # here: AWS EC2

      deployment.targetEnv = "ec2";
      deployment.ec2.accessKeyId = "AKIA...";
      deployment.ec2.keyPair = "...";
      deployment.ec2.privateKey = "...";
      deployment.ec2.securityGroups = pkgs.lib.mkDefault [ "default" ];
      deployment.ec2.region = pkgs.lib.mkDefault "eu-west-1";
      deployment.ec2.instanceType = pkgs.lib.mkDefault "t2.large";
    };
  gollum =
    { config, pkgs, ... }:
    {
      # Nix based setup of the gollum server

      services.gollum = {
        enable = true;
        port = 40273;
      };
      networking.firewall.allowedTCPPorts = [ config.services.gollum.port ];
    };

  reverseproxy =
    { config, pkgs, nodes, ... }:
    let
      gollumPort = nodes.gollum.config.services.gollum.port;
    in
    {
      # Nix based setup of a nginx reverse proxy

      services.nginx = {
        enable = true;
        virtualHosts."wiki.example.net".locations."/" = {
          proxyPass = "http://gollum:${toString gollumPort}";
        };
      };
      networking.firewall.allowedTCPPorts = [ 80 ];
      
      # Instance can override default deployment options 
      deployment.ec2.instanceType = "t1.medium";
    };
}
```

Similarly, tools like Terraform[@terraform], or Chef[@chef] use their own DSLs and integrate with most major cloud providers.
The popularity of these products^[https://trends.google.com/trends/explore?date=2012-01-01%202022-01-01&q=%2Fg%2F11g6bg27fp,CloudFormation], beyond all, highlights the importance of expressive configuration formats and their industry value.

Finally, descriptive data formats for cloud configurations allow mitigating security risks through static analysis.
Yet, as recently as spring 2020 and still more than a year later dossiers of Palo Alto Networks' security department Unit 42 [@pa2020H1, ps2021H2] show that a majority of public projects uses insecure configurations.
This suggests that techniques[@aws-cloud-formation-security-tests] to automatically check templates are not actively employed, and points out the importance of evaluated configuration languages which can implement passive approaches to security analysis.

### Nickel

The Nickel[@nickel] language is a configuration programming language (cf. [@sec:configuration-programming-languages]) with the aims of providing composable, verifiable and validatable configuration files.
The language draws inspiration from existing projects such as Cue [@cue], Dhall [@Dhall] and most importantly Nix [@nix].
Nickel implements a pure functional language with JSON-like data types and turing-complete lambda calculus.
However, Nickel sets itself apart from the existing projects by combining and advancing their strengths.
The language addresses concerns drawn from the experiences with Nix which employs a sophisticated modules system [@nixos-modules] to provide type-safe, composed (system) configuration files.
Nickel implements gradual type annotations, with runtime checked contracts to ensure even complex configurations remain correct.
Additionally, considering record merging on a language level facilitates modularization and composition of configurations.

#### Record Merging

Nickel considers record merging as a fundamental operation that combines two records (i.e. JSON objects).
Merging is a commutative operation between two records which takes the fields of both records and returns a new record that contains the fields of both operands (cf. [@lst:nickel-merging-simple])

```{.nickel #lst:nickel-merging-simple caption="Merging of two records without shared fields"}
{ enable = true } & { port = 40273 }
>>
{
  enable = true,
  port = 40273
}
```

If both operands contain a nested record referred to under the same name, the merging operation will be applied to these records recursively (cf. [@lst:nickel-merging-recursive]).

```{.nickel #lst:nickel-merging-recursive caption="Merging of two records without shared nested records"}
let enableGollum = {
  service = {
    gollum = {
      enable = true
    }
  } 
} in

let setGollumPort = {
  service = {
    gollum = {
      port = 40273
    }
  } 
} in 

enableGollum & setGollumPort

>> 
{
  service = {
    gollum = {
      enable = true,
      port = 40273
    }
  } 
} 
```

However, if both operands contain a field with the same name that is not a mergeable record, the operation fails since both fields have the same priority making it impossible for Nickel to chose one over the other (cf. [@lst:nickel-merging-failing-names])
Specifying one of the fields as a `default` value allows a single override (cf. [@lst:nickel-merging-default] ).
In future versions of Nickel ([@nickel-rfc-0001]) it will be possible to specify priorities in even greater detail and provide custom merge functions. 

```{.nickel #lst:nickel-merging-failing-names caption="Failing merge of two records with common field"}
{ port = 40273 } & { port = 8080 }

>>
error: non mergeable terms
  |
1 | { port = 40273 } & { port = 8080 }
  |          ^^^^^              ^^^^ with this expression
  |          |                   
  |          cannot merge this expression
```


```{.nickel #lst:nickel-merging-default caption="Succeeding merge of two records with default value for common field"}
{ port | default = 40273 } & { port = 8080 }

>>
{ port = 8080 }
```

#### Gradual typing

The typing approach followed by Nickel was introduce by Siek and Taha [@gradual-typing] as a combination of static and dynamic typing.
The choice between both type systems is traditionally debated since either approach imposes specific drawbacks.
Static typing lacks the flexibility given by fully dynamic systems yet allow to ensure greater correctness by enforcing value domains.
While dynamic typing is often used for prototyping, once an application or schema stabilizes, the ability to validate data schemas is usually preferred, often requiring the switch to a different statically typed language.
Gradual typing allows introducing statically checked types to a program while allowing other parts of the language to remain untyped and thus interpreted dynamically.


#### Contracts

In addition to a static type-system Nickel integrates a contract system akin what is described in [@cant-be-blamed].
First introduced by Findler and Felleisen, contracts allow the creation of runtime-checked subtypes.
Unlike types, contracts check an annotated value using arbitrary functions that either pass or *blame* the input.
Contracts act like assertions that are automatically checked when a value is used or passed to annotated functions.

For instance, a contract could be used to define TCP port numbers, like shown in [@lst:nickel-sample-contract].

```{.nickel #lst:nickel-sample-contract caption="Sample Contract ensuring that a value is a valid TCP port number"}
let Port | doc "A contract for a port number" =
  contracts.from_predicate (
    fun value =>
      builtins.is_num value &&
      value % 1 == 0 &&
      value >= 0 &&
      value <= 65535
  )
in 8080 | #Port
```

Going along gradual typing, contracts pose a convenient alternative to the `newtype` pattern.
Instead of requiring values to be wrapped or converted into custom types, contracts are self-contained.
As a further advantage, multiple contracts can be applied to the same value as well as integrated into other higher level contracts.
An example can be observed in [@lst:nickel-sample-advanced-contract]

```{.nickel #lst:nickel-sample-advanced-contract caption="More advaced use of contracts restricting values to an even smaller domain"}
let Port | doc "A contract for a port number" =
  contracts.from_predicate (
    fun value =>
      builtins.is_num value &&
      value % 1 == 0 &&
      value >= 0 &&
      value <= 65535
  )
in
let UnprivilegedPort = contracts.from_predicate (
  fun value =>
    (value | #Port) >= 1024  
  )
in
let Even = fun label value =>
  if value % 2 == 0 then value
  else
    let msg = "not an even value" in
    contracts.blame_with msg label
in

8001 | #UnprivilegedPort
     | #Even
```

Notice how contracts also enable detailed error messages (see [@lst:nickel-sample-error-advaced-contract]) using custom blame messages.
Nickel is able to point to the exact value violating a contract as well as the contract in question.

```{.text #lst:nickel-sample-error-advaced-contract caption="Example error message for failed contract"}
error: Blame error: contract broken by a value [not an even value].
    - :1:1
   |
 1 | #Even
   | ----- expected type
   |
    - repl-input-34:22:1
   |  
22 | - 8001 | #UnprivilegedPort
   |   ---- evaluated to this expression
23 | |      | #Even
   | -------------^ applied to this expression

note: 
    - repl-input-34:23:8
   |
23 |      | #Even
   |        ^^^^^ bound here
```



#### Nickel AST

Nickel's syntax tree is a single sum type, i.e., an enumeration of node types.
Each enumeration variant may refer to child nodes, representing a branch or hold terminal values in which case it is considered a leaf of the tree.
Additionally, tree nodes hold information about their position in the underlying code.

##### Basic Elements

The primitive values of the Nickel language are closely related to JSON.
On the leaf level, Nickel defines `Boolean`, `Number`, `String` and `Null`.
In addition to that the language implements native support for `Enum` values which are serialized as plain strings.
Each of these are terminal leafs in the syntax tree.

Completing JSON compatibility, `List` and `Record` constructs are present as well.
Records on a syntax level are HashMaps, uniquely associating an identifier with a sub-node.

These data types constitute a static subset of Nickel which allows writing JSON compatible expressions as shown in [@lst:nickel-static].

```{.nickel #lst:nickel-static caption="Example of a static Nickel expression"}
{
  list = [ 1, "string", null],
  "some key" = "value"
} 
```



Building on that Nickel also supports variables and functions.

##### Identifiers

The inclusion of Variables to the language, implies some sort of identifiers.
Such name bindings can be declared in multiple ways, e.g. `let` bindings, function arguments and records.
The usage of a name is always parsed as a single `Var` node wrapping the identifier.
Span information of identifiers is preserved by the parser and encoded in the `Ident` type. 

##### Variable Reference

```{.nickel #lst:nickel-let-binding caption="Let bindings and functions in nickel"}

// simple bindings
let name = <expr> in <expr>
let func = fun arg => <expr> in <expr>

// or with patterns
let name @ { field, with_default = 2 } = <expr> in <expr>
let func = fun arg @ { field, with_default = 2 } => 
  <expr> in 
  <expr>
```

Let bindings in their simplest form merely bind a name to a value expression and expose the name to the inner expression.
Hence, the `Let` node contains the binding and links to both implementation and scope subtrees.
The binding can be a simple name, a pattern or both by naming the pattern as shown in [@lst:nickel-let-binding].


```{.nickel #lst:nickel-args-function caption="Parsed representation of functions with multiple arguments"}
fun first second => first + second
// ...is parsed as
fun first =>
  fun second => first + second
```

Functions in Nickel are curried lambda expressions.
A function with multiple arguments gets broken down into nested single argument functions as seen in [@lst:nickel-args-function].
Function argument name binding therefore looks the same as in `let` bindings.


##### Meta Information

One key feature of Nickel is its gradual typing system [ref again?], which implies that values can be explicitly typed.
Complementing type information, it is possible to annotate values with contracts and additional metadata such as contracts, documentation, default values and merge priority using a special syntax as displayed in [@lst:nickel-meta].


```{.nickel #lst:nickel-meta caption="Example of a static Nickel expression"}
let Contract = { 
  foo | Num 
      | doc "I am foo",
  hello | Str
        | default = "world"
}
| doc "Just an example Contract"
in 
let value | #Contract = { foo = 9, }
in value == { foo = 9, hello = "world", } 

> true
```

Internally, the addition of annotations wraps the annotated term in a `MetaValue`, an additional tree node which describes its subtree. 
The expression shown in [@lst:nickel-meta-typed] translates to the AST in [@fig:nickel-meta-typed].

```{.nickel #lst:nickel-meta-typed caption="Example of a typed expression"}
let x: Num = 5 in x
```


```{.graphviz #fig:nickel-meta-typed caption="AST of typed expression" height=4.5cm}
strict digraph { 
  graph [fontname = "Fira Code"];
  node [fontname = "Fira Code"];
  edge [fontname = "Fira Code"];

  meta [label="MetaValue", color="green", shape="box"]
  let [label = "Let('x')"]
  num [label = "Num(5)"]
  var [label = "Var('x')"]

  meta -> let
  let -> num
  let -> var
}
```

##### Nested Record Access

Nickel supports both static and dynamic access to record fields.
If the field name is statically known, the access is said to be *static* accordingly.
Conversely, if the name requires evaluating a string from an expression the access is called *dynamic*.
An example is given in [@lst:nickel-static-dynamic]

```{.nickel #lst:nickel-static-dynamic caption="Examples for static and dynamic record access"}
let r = { foo = 1, "bar space" = 2} in
r.foo // static
r."bar space" // static
let field = "fo" ++ "o" in r."#{field}" // dynamic
```

The destruction of record fields is represented using a special set of AST nodes depending on whether the access is static or dynamic.
Static analysis does not evaluate dynamic fields and thus prevents the analysis of any deeper element starting with dynamic access.
Static access however can be used to resolve any intermediate reference.

Notably, Nickel represents static access chains in inverse order as unary operations which in turn puts the terminal `Var` node as a leaf in the tree.
[Figure @fig:nickel-static-access] shows the representation of the static access performed in [@lst:nickel-static-access] with the rest of the tree omitted.

```{.nickel #lst:nickel-static-access caption="Nickel static access"}
let x = {
  y = {
    z = 1,
  }
} in x.y.z
```


```{.graphviz #fig:nickel-static-access caption="AST of typed expression" height=6cm}
strict digraph { 
  graph [fontname = "Fira Code"];
  node [fontname = "Fira Code", margin=0.25];
  edge [fontname = "Fira Code"];

  rankdir="TD"

  let [label = "Let", color="grey"]
  rec [label = "omitted", color="grey", style="dashed", shape="box"]

  x [label = "Var('x')"]
  unop_x_y [label = ".y", shape = "triangle", margin=0.066]
  unop_y_z [label = ".z", shape = "triangle", margin=0.066]


  let -> rec
  let -> unop_y_z
  unop_y_z -> unop_x_y
  unop_x_y -> x
}
```



##### Record Shorthand

Nickel supports a shorthand syntax to efficiently define nested records similarly to how nested record fields are accessed.
As a comparison the example in [@lst:nickel-record-shorthand] uses the shorthand syntax which resolves to the semantically equivalent record defined in [@lst:nickel-record-no-shorthand]

```{.nickel #lst:nickel-record-shorthand caption="Nickel record defined using shorthand"}
{
  deeply.nested.record.field = true,
}
```

```{.nickel #lst:nickel-record-no-shorthand caption="Nickel record defined explicitly"}
{
  deeply = {
    nested = {
      record = { 
        field = true,
      }
    }
  }
}
```

Yet, on a syntax level Nickel generates a different representation.
