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

Inspired by the work of Leimeister in [@leimeister], a survey aims to provide practical insights into the experience of future users.
In order to get a clear picture of the users' needs and expectations independent of the experience, the survey consists of two parts -- a pre-evaluation and final survey.
The pre-evaluation introduced participants in brief to the concept of language servers and asked them to write down their understanding of several LSP features.
In total, six features were surveyed corresponding to the implementation as outlined in [@sec:capability].
The item for the "Hover" feature for instance reads as follows:

> Editors can show some additional information about code under the cursor.
> The selection, kind, and formatting of that information is left to the Language Server.
>
> What kind of information do you expect to see when hovering code? Does the position or kind of element matter? If so, how?

Items first introduce a feature on a high level followed by a request to the participant to describe their ideal implementation of the feature.

For the final survey interested participants at Tweag were invited to a workshop introducing Nickel.
As a preparation, they were asked to install the LSP.
The workshop allowed participants unfamiliar with the Nickel language to use the language and experience NLS.
Following the workshop, participants filled in a second survey which focused on particular experiences of every single feature.
This evaluation focused on three main aspects.
First, the general experience without weighing in expectations.
The goal was to assess the extent to which the user was able to use the feature, since all usability metrics as discussed in [#sec:evaluation] depend on the respective feature being available in the first place.
In the same category are the items surveying the perceived performance and stability on a linear scale hinting at possible usability issues.
The scales span from "Very slow response" to "Very quick response" and "Never Crashed" to "Always Crashed" respectively.
As a second aspect, the user was asked to explicitly reflect on their expectations, particularly, how satisfied their expectations were.
In the final part participants could describe their perceived shortcomings or questions or remarks.

### Quantitative

## Process

## Results

### Qualitative

### Quantitative
