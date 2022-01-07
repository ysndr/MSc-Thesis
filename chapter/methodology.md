# Method

This chapter contains a detailed guide through the various steps and components of the Nickel Language Server (NLS).
Being written in the same language (Rust[@rust]) as the Nickel interpreter allows NLS to integrate existing components for language analysis.
Complementary, NLS is tightly coupled to Nickel's Syntax definition.
Hence, in [@sec:nickel-ast] this chapter will first detail parts of the AST that are of particular interest for the LSP and require special handling.
Based on that [@sec:linearization] will introduce the main datastructure underlying all higher level LSP interactions and how the AST is transformed into this form.
Finally, in [@sec:lsp-server] the implementation of current LSP features is discussed on the basis of the previously reviewed compontents.

## Nickel AST


Nickel's Syntax tree is a single sum type, i.e. an enumeration of node types.
Each enumeration variant may refer to child nodes, representing a branch or hold terminal values in which case it is considered a leaf of the tree.
Additionally, nodes are parsed and represented, wrapped in another structure that encodes the span of the node and all its potential children.

### Basic Elements

The data types of the Nickel language are closely related to JSON.
On the leaf level, Nickel defines `Boolean`, `Number`, `String` and `Null`.
In addition to that the language implements native support for `Enum` values.
Each of these are terminal leafs in the syntax tree.

Completing JSON compatibility, `List` and `Record` constructs are present as well.
Records on a syntax level are HashMaps, uniquely associating an identifier with a sub-node.

These data types constitute a static subset of Nickel which allows writing JSON compatible expressions as shown in [@lst:nickel-static].

```{.nickel #lst:nickel-static caption="Example of a static Nickel expression"}
{
  list = [ 1, "string", null],
  "enum value" = `Value 
} 
```



Building on that Nickel also supports variables and functions which make up the majority of the AST stem.

### Meta Information

One key feature of Nickel is its gradual typing system [ref again?], which implies that values can be explicitly typed.
Complementing type information it is possible to annotate values with contracts and additional meta-data such as documentation, default values and merge priority a special syntax as displayed in [@lst:nickel-meta].


```{.nickel #lst:nickel-meta caption="Example of a static Nickel expression"}
let Contract = { 
         foo | Num 
             | doc "I am foo",
         hello | Str
               | default = "world"
       }
       | doc "Just an example Contract"
in 
let value | #Contract = { foo = 9 }
in value == { foo = 9, hello = "world"} 

> true
```

Internally, the addition of annotations wraps the annotated term in a `MetaValue` structure, that is creates an artificial tree node that describes its subtree. 
Concretely, the expression shown in [@lst:nickel-meta-typed] translates to the AST in [@fig:nickel-meta-typed].
The green `MetaValue` box is a virtual node generated during parsing and not present in the untyped equivalent.

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

<!-- 
\Begin{minipage}{.5\textwidth}
\centering

```{.graphviz #fig:nickel-ast-no-meta}
strict digraph { 
  let[label = "Let('x')"]
  num [label = "Num(5)"]
  var [label = "Var('x')"]

  let -> num
  let -> var
}
```
\captionof{figure}{AST of untyped code in Listing: \ref{lst:nickel-meta-untyped}}
\label{fig:nickel-meta-untyped}

\End{minipage}
\Begin{minipage}{0.5\textwidth}


```{.graphviz}
strict digraph { 
  meta [label="MetaValue", color="green", shape="box"]
  let[label = "Let('x')"]
  num [label = "Num(5)"]
  var [label = "Var('x')"]

  meta -> let
  let -> num
  let -> var
}
```

\captionof{figure}{AST of untyped code in Listing: \ref{lst:nickel-meta-typed}}
\label{fig:nickel-meta-typed}

\End{minipage}

 -->

### Nested Record Access

Nickel supports the referencing of variables which are represented as `Var` nodes that are resolved during runtime.
With records bound to a variable, a method to access elements inside that record is required.
The access of record members is represented using a special set of AST nodes depending on whether the member name requires an evaluation in which case resolution is deferred to the evaluation pass.
While the latter prevents static analysis of any deeper element by the LSP, `StaticAccess` can be used to resolve any intermediate reference.

Notably, Nickel represents static access chains in inverse order as unary operations which in turn puts the terminal `Var` node as a leaf in the tree.
[Figure @fig:nickel-static-access] shows the representation of the static access perfomed in [@lst:nickel-static-access] with the rest of the tree omitted.

```{.nickel #lst:nickel-static-access caption="Nickel static access"}
let x = {
  y = {
    z = 1;
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



### Record Shorthand

Nickel supports a shorthand syntax to efficiently define nested records similarly to how nested record fields are accessed.
As a comparison the example in [@lst:nickel-record-shorthand] uses the shorthand syntax which resolves to the semantically equivalent record defined in [@lst:nickel-record-no-shorthand]

```{.nickel #lst:nickel-record-shorthand caption="Nickel record using shorthand"}
{
  deeply.nested.record.field = true;
}
```

```{.nickel #lst:nickel-record-no-shorthand caption="Nickel record defined explicitly"}
{
  deeply = {
    nested = {
      record = { 
        field = true 
      }
    }
  }
}
```

Yet, on a syntax level different Nickel generates a different representation.




## Linearization

Being a domain specific language, the scope of analyzed Nickel files is expected to be small compared to other general purpose languages.
NLS therefore takes an *eager approach* to code analysis, resolving all information at once which is then stored in a linear data structure with efficient access to elements.
This data structure is referred to as *linearization*.
The term arises from the fact that the linearization is a transformation of the syntax tree into a linear structure which is presented in more detail in [@sec:transfer-from-ast].
The implementation distinguishes two separate states of the linearization.
During its construction, the linearization will be in a *building* state, and is eventually post-processed yielding a *completed* state.
The semantics of these states are defined in [@sec:states], while the post-processing is described separately in [@sec:post-processing].
Finally, [@sec:resolving-elements] explains how the linearization is accessed.

### States

At its core the linearization is an array of `LinearizationItem`s which are derived from AST nodes during the linearization process.

Closely related to nodes, `LinearizationItem`s maintain the position of their AST counterpart, as well as its type.
Unlike in the AST, metadata is directly associated with the element.
Further deviating from the AST representation, the type of the node and its kind are tracked separately.
The latter is used to distinguish between declarations of variables, records, record fields and variable usages as well as a wildcard kind for any other kind of structure, such as terminals control flow elements.

As mentioned in the introduction NLS distinguishes a linearization in construction from a finalized one.
Both states are set apart by the auxiliary data maintained about the linearization items, the ordering of the items themselves and the resolution of their concrete types.
Additionally, both states implement a different set of methods.
For the `Building` state the linearization implements several methods used during the transfer of the AST and post-processing routines that defines the state transition into the `Completed` state. 


### Transfer from AST

#### Retyping

### Post-Processing

### Resolving Elements

## LSP Server

### Diagnostics and Caching

### Capabilities

#### Hover

#### Completion

#### Jump to Definition

#### Show references
