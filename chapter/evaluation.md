# Evaluation

[Section @sec:implementation] described the implementation of the Nickel Language Server addressing the first research question stated in [@sec:research-questions].
Proving the viability of the result and answering the second research question demands an evaluation of different factors.

Earlier, the most important metrics of interest were identified as:

Usability
  ~ What is the real-world value of the language server?
  ~ Does it improve the experience of developers using Nickel?
    NLS offers several features, that are intended to help developers using the language.
    The evaluation should assess whether developers experience any help due to the use of the server.
  ~ Does NLS meet its users' expectations in terms of completeness and correctness and behavior?
    Being marketed as a Language Server, invokes certain expectations due to previous experience with other languages and language servers.
    Here, the evaluation should show whether NLS lives up to the expectations of its users.

Performance
  ~ What are the typical latencies of standard tasks?
    In this context *latency* refers to the time it takes from issuing an LSP command to return of the reply by the server.
    The JSON-RPC protocol used by the LSP is synchronous, i.e. requires the server to return results of commands in the order it received them.
    Since most commands are sent implicitly, a quick processing is imperative to avoid commands queuing up.
  ~ Can single performance bottlenecks be identified?
    Single commands with excessive runtimes can slow down the entire communication resulting in bad user experience.
    Identified issues can guide the future work on the server.
  ~ How does the performance of NLS scale for bigger projects?
    With increasing project sizes the work required to process files increases as well.
    The evaluation should allow estimates of the sustained performance in real-world scenarios.

Answering the questions above, this chapter consists of two main sections.
The first section [@sec:methods] introduces methods employed for the evaluation.
In particular, it details the survey ([@sec:qualitative]) which was conducted with the intent to gain qualitative opinions by users, as well as the tracing mechanism ([@sec:quantitative]) for factual quantitative insights.
[Section @sec:results] summarises the results of these methods.

## Methods

### Qualitative

### Quantitative

## Process

## Results

### Qualitative

### Quantitative

## Discussion

This section discusses the issues raised during the survey and uncovered through the performance tracing.
In the first part the individual findings are summarized and if possible grouped by their common cause.
The second part addresses each cause and connects it to the relevant architecture decisions, while explaining the reason for it and discussing possible alternatives.

### Discovered issues

During the qualitative evaluation several features did not meet the expectations of the users.
The survey also hinted performance issues that were solidified by the results of the quantitative analysis.

#### Diagnostics

First, participants criticized [@sec:diagnostics@res] the diagnostics feature for some unhelpful error messages and specifically for not taking into account Nickel's hallmark feature, Contracts [@sec:Contracts].
While Contracts are a central element of Nickel and relied upon to validate data, the language server does not actually warn about contract breaches.
Yet, while contracts and their application looks similar to types, contracts are a dynamic language element which are dynamically applied during evaluation.
Therefore it is not possible to determine whether a value conforms to a contract without evaluation of the contract.
NLS's is integrated with Nickel's type-checking mechanism which precedes evaluation and provides only a static representation of the source code.
In order to support diagnostics for contracts NLS would need to locally evaluate arbitrary code that makes up contracts.
However, contracts can not be evaluated entirely locally as they may transitively depend on other contracts.
This is particularly true for a file's output value.
Additionally, Contracts can implement any sort of complex computation including unbound recursion.
Due to these caveats, evaluating contracts as part of NLS's analysis implies the evaluation of the entire code which was considered a possibly significant impact to the performance.
As layed out above evaluating contracts locally is no option either.
It is not only challenging to collect the minimal context of the Contract, the context may in fact be the entire program.
An alternative option is to provide the ability to apply contracts manually using an LSP feature called "Code Lenses".
Code Lenses are displayed by editors as annotations allowing the user to manually execute an associated action.

<!-- TODO: Add nickels implementation detail of inlining contracts into the executed ast in background? -->

#### Cross File Navigation

In both cases `Jump-To-Definition` and `Find-References` surveyed users requested support for cross file navigation.
In particular, finding the definition of a record field of an imported record should navigate the editor to the respective file as symbolized in [@lst:imported-record-access].

```{.nickel #lst:imported-record-access caption="Minimal example of cross file referencing"}
// file_a.ncl

let b = import "./b.ncl" in b.field
                              |
                              +------+
                                     |
-----------------------------------  |
                                     |
// file_b.ncl                        |
                                     |
{                                    |
  field = "field value";             |
}  ^                                 |
   +---------------------------------+
```

The resolution of imported values is done at evaluation time, the AST therefore only contains nodes representing the concept of an import but no not reference elements of that file. 
NLS does ingest the the AST without resolving these imports manually.
The type checking module underlying NLS still recurses into imported files to check their formal correctness.
As a result it would be possible for a NLS to resolve these links as an additional step in the post processing by either inserting atificial linearization items [@sec:linearization] or merging both files linearization entirely.

#### Autocompletion

Another criticized element of NLS was the autocompletion feature.
In the survey, participants mentioned the lack of additional information and distinction of elements as well as NLS inability to provide completion for record fields.
In Nickel, record access is declared by a period.
An LSP client can to configured to ask for completions when such an access character is entered additionally to manual requests by the user.
The language server is then responsible to provide a list of completion candidates depending on the context, i.e. the position.
[Section #sec:completion] describes how NLS resolves this kind of request.
NLS just lists all identifiers of declarations that are in scope at the given position.
Notably, it does not take the preceding element into account as additional context.
To support completing records, the server must first be aware of separating tokens such as the period symbol, check whether the current position is part of a token that is preceded by a separator and finally resolve the parent element to a record.

#### Performance
