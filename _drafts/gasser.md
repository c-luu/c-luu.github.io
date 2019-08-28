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

* Maybe we've added hooks to handle security checks, but such checks may introduce new possibilities of failures that the existing software can't handle. I.e., _new kind of failures_.
* A classic example of such failure is a mechanism that _knows_ a file exists but can't read it.

Gasser claims that the __keys__ to incorporating security hooks for future security enhancements are:

* Understanding computer security requirements in general.
* Include such requirements _as explicitly as possible_ as future security needs.
* Work out the details of how to handle such future requirements.

## Stunting System Security Evolution
_Evolving_ security requirements for a system could be impossible in some cases. For example, what if we have a system feature that allows anonymous, shared-access to a directory for temporary files. From a feature standpoint, it sounds reasonable and efficient use of resources, however it is also _fundamentally insecure_ since multiple users may read other users files in said directory.

# Economy of Mechanism
To achieve higher assurance in the architecture security, design the security-relevant modules such that _size and complexity_ is minimized.

Gasser says that even if we stuck to this design principal, there may be diminishing returns of adding new security mechanisms. I.e., if the effort, size, and or complexity required to implement the new security feature requires _as much_ mechanisms already in place, the assurance and reliability is likely to not be commensurate.

The goal to combat this is _economy of mechanism_, which is minimizing the variety security mechanisms. This forces security-relevant actions to be taken in a _few_ isolated sections.

## Feasibility
It largely depends on how flexible the system was designed. Historically, economy of mechanism is hard to attain due to how much security mechanisms _permeate_ the system. E.g., take the mechanism of _access of control_:

* DBMS worries about access at the row level.
* Message-handling systems worry about access at the message level.
* Document-processing worries about whole file access.

How would one isolate this mechanism when it's sprinkled throughout the system?

## Going Overboard
It's possible to take this principal to the extreme. For example, historically it made sense to store security attributes for files alongside other file attributes. If we instead _isolated_ these security attributes in a database, we'd potentially degrade security by adding on a synchronization mechanism.

# Least Privilege
> Subjects should have just enough privilege to do their jobs.

The idea is very familiar- the valet can use the car keys since they need to park the car, but the car washer does _not_ need the car keys since they only wash it.

Least privilege is used in computing, one example being kernel mode versus user mode. This example exhibits _coarse-grained_ privilege and suffers from an all-or-nothing state of possible privileges. Throwing in more privileges gives a more robust hierarchy of possible privileges to assign, but also requires more complex hardware or software support.

An example of least privilege used in software system goes as follows: a file back-up daemon may have _read_ privileges on the files, but it shouldn't need _write_ privileges on said files to perform its job successfully. 

# Friendliness
Gasser recommends we keep these goals in mind as well:
* Security shouldn't affect users obeying the rules.
* It should be easy for users to _give_ access.
* It should be easy for users to _restrict_ access.

# Open Design
> The safest assumption is that the penetrator knows everything.

_Secrecy of design_ is not a requirement for even the most highly secure systems. No system will ever be free of covert channels, whether the design is privatized or open. Disclosing the design of the system's security mechanism __can improve security__ because its internals are scrutinized by a much larger audience.