---
layout: post
title:  "Principles of a Security Architecture"
date:   
categories: [security]
tags: [summary]
---
# About
A summarization of chapter five of the [Gasser book]().

# Defining Initial Security Architecture
__Security architecure__ should be synthesized from security requirements. A _good_ architecture is one that abstractly describes the relationship between key elements of the system in a way that satisfies the security requirements. It is also distinct from the functional specs of the system and recommended to be a _design overview_.

Good security architecture is not all technical, an important feature is establishing development standards to adhere to the policies set in place by the architecture.

A high-level security architecture should be in place as early as possible in the software project. An example draft can be high level and _evolve_ over time. The following points could make up a draft for starters:

* System security policies.
* How much assurance is desired.
* How said security requirements impact the development process.

# Evolving Security Requirements
It's ideal to have the security architecture specified early on, but how do we anticipate or prepare for future security requirements? For one, _don't be overly specific about anticipating security enhancements_ (sic). E.g.:

* Maybe we've added hooks to handle security checks, but such checks may introduce new possibilities of failures that the existing software can't handle.