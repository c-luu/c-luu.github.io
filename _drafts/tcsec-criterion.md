---
layout: post
title:  "TCSEC Criterion"
date:   2019-08-25 23:17:12 +0000
categories: [security]
tags: [summary]
---

# Draft Evolution
## Nibaldi
The [first draft](https://apps.dtic.mil/dtic/tr/fulltext/u2/a108832.pdf) consisted of a _strictly-ordered_ set of seven _requirement-subsuming_ evaluation classes. These classes ranged from _no protection_ to bleeding-edge attributes.

The seven levels are summarized:

0. No reason to have confidence that the system can protect info.
1. Attempted access control is recognized, but limited confidence is placed on whether the controls can successfully implement it.
2. Minimal requirements for the protection policy must be satisfied. Assurance is a function of system design and testing 
3. Confidence is derived from how well the protection-level components of the operating system (TCB) are constructed.
4. Formally verify the _design_ of the TCB implementation.
5. Formally verify the _implementation_ of the TCB.
6. Object code analysis and hardware support is strengthened. 

## the Chinese Menu Approach
The rigidness of this draft was initially challenged by the MITRE report. This report proposed for products to be evaluated against criteria selected by the product developers. These criteria would be drawn from policies, mechanisms, and assurance requirements perceived as _desirable_ for an application.

E.g. (TODO counter example explanation https://piazza.com/class/jyxewxioasc7bc?cid=42)
One of the strong arguments in favor of this approach was flexibility and the ability to _tailor a system to its envisioned use._

This flexibility implies performing comparative assessments, something procurement officers at the Department of Defense should not be principally concerned with, according to Roger Schell. This argument largely stopped the _Chinese Menu_ approach.

# Minima
To combat adding new intermediate evaluation classes, four _local minima_ were established:

1. Minimal protection
2. Discretionary protection
3. Mandatory protection
4. Verified protection

# Final Draft classes

1. Class D, Common practice- system fails to meet any security requirements.
2. Class C1, Discretionary security- system provides some mechanism providing individual user authentication. Provides [DAC](https://en.wikipedia.org/wiki/Discretionary_access_control) among users and data.
3. Class C2, Controlled access protection- requires individual accountability and security-event auditing features.
4. Class B1, Labeled security protection- provides [MAC](https://en.wikipedia.org/wiki/Mandatory_access_control).
5. Class B2, Structured protection- MAC is extended to all objects outside of the TCB.
6. Class B3, Security domains- TCB supports a defined security model.
7. Class A1, Verified design.
8. Class A2, Verified implementation.