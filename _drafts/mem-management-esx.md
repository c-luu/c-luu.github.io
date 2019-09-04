---
layout: post
title:  "Memory Resource Management in VMware ESX"
date:   2019-09-03 
categories: [systems]
tags: [summary, virtualization, xen, esx]
---
# About
This summary discusses memory management in VMware's ESX server and aims to compare and contrast to its contemporary product: Workstation, and future product: Xen.

# Key Terms
1. Hypervisor- [A.k.a. virtual machine monitors](https://en.wikipedia.org/wiki/Hypervisor), an abstraction that creates and runs virtual machines. In this summary we use _monitors_ for brevity.
2. Over-commitment- Total _configured_ memory for the VMs has __exceeded__ actual machine memory.

## Background
Abstract and intro summary.

## Initial Contrast with Workstation
See page 1 highlight.

### Handling Nested System Calls
How do the two monitors handle system calls from a user process inside of the VM?

#### ESX
#### Workstation

# Memory Virtualization
## Contrasts with Xen

# Reclamation Mechanisms
## Page Replacement Issues
## Ballooning
#### Ballooning in Xen (thought experiment)
## Demand Paging
## Mechanism Trade-offs

# Sharing Memory
At least initially, just go over the concepts and _how they work_ in ESX. Hold off on implementation and performance graph analysis for now.

## Transparent Page Sharing
## Content Page Sharing

# Allocation Policies
## Parameters
## Dynamic Reallocation
### Metrics
Insert and discuss results.

# References
* [Memory Resource Management in VMware ESX Server](http://www.waldspurger.org/carl/papers/esx-mem-osdi02.pdf)