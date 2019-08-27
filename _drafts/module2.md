---
layout: post
title:  "Design Principles for Secure Systems"
date:   
categories: [security]
tags: [summary]
---
# About
This post will summarize key security design principles. 

## Economics of Security
Discuss the graph capturing cost of defenders versus cost of attackers.

## User Acceptability
User or psychological acceptability design principle. Users are usually the weakest link when measuring system security.

## Economy of Mechanisms
### Complexity versus Security
![Complexity v. Security]({{ site.url }}/assets/module2/complexity-v-security.PNG)

Observe the two extreme systems, A and B. A is all features, minimal security, and B is all security while sacrificing most usability. We want to build a system closer to C in most cases.

### Heuristics 
There are a few design ideas for economy of mechanism, however they are not infallible:

* Open design- the more users see and vet your security architecture design, the more suggestions and patches can be made. However not in all cases, e.g. Heartbleed.
* Less code, less complexity- it's recommended that the TCB belongs to the hypervisor (~50 KLOC) versus the operating system (~50 MLOC).

## Least Privilege 