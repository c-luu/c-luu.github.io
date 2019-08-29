---
layout: post
title:  "Design Principles for Secure Systems"
date:   
categories: [security]
tags: [summary]
---
# About
This post will summarize key security design principles. 

# Economics of Security
How does one determine how much to spend on security? There's a few variables to consider to determine this:

* How much the defender values asset _x_.
* How much the attacker values asset _x_.
* How much the defender spends to protect _x_.
* How much the attacker spends to protect _x_.

# Operating Region
Given the variables above, the ideal operating region for the defender is such:

> The cost to defend asset _x_ is less than how much _x_ is worth and the cost to attack is greater than how much the attack values asset _x_.

I.e., security cost __must be__ commensurate with threat level __and__ asset level.

# User Acceptability
User or psychological acceptability design principle. Users are usually the weakest link when measuring system security.

# Economy of Mechanisms
## Complexity versus Security
![Complexity v. Security]({{ site.url }}/assets/module2/complexity-v-security.PNG)

Observe the two extreme systems, A and B. A is all features, minimal security, and B is all security while sacrificing most usability. We want to build a system closer to C in most cases.

### Heuristics 
There are a few design ideas for economy of mechanism, however they are not infallible:

* Open design- the more users see and vet your security architecture design, the more suggestions and patches can be made. However not in all cases, e.g. Heartbleed.
* Less code, less complexity- it's recommended that the TCB belongs to the hypervisor (~50 KLOC) versus the operating system (~50 MLOC).

# Least Privilege 
Prefer to __fail-safe__ by default rather than allow potentially insecure access.

# Defense in Depth
I.e., having multiple layers of security. This can be demonstrated with the following thought exercise, referencing the [reflections on trusting trust]() paper.

Lets say we're detecting potential compiler bugs or trojans. We'll accept the following assumptions as valid:

> Two distinct binaries compiling the _same source_ do not need to be binary equivalent, but should be functionally equivalent.

We have two compilers from different vendors, A and B. Assume a trojan was planted in A. There's corresponding executable for A and B as well.

1. Compile the source code of A with A's executable
2. Compile the source code of A with B's executable.
3. Repeat this process once more, which produces two more executables.
4. If these new executables don't match, we have a bug (or trojan) on our hands.

_Defense in depth_ principal emphasizes that _functionally equivalent_ programs should produce the same output.