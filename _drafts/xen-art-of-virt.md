---
layout: post
title:  "Xen and the Art of Virtualization"
date:   2019-09-03 
categories: [systems]
tags: [summary, virtualization, xen]
---
# About
This summary discusses virtualization in VMware's Xen, a resource-managed monitor that enables server consolidation, co-located hosting facilities, distributed web services, secure computing platforms, and application mobility.

# Key Terms
1. Hypervisor- [A.k.a. virtual machine monitors](https://en.wikipedia.org/wiki/Hypervisor), an abstraction that creates and runs virtual machines. In this summary we use _monitors_ for brevity.
2. _XenoLinux_- VMware's Linux port that is compatible with Xen?

## Background
Abstract and intro summary.

# Approach & Overview
## Paravirtualization
Discuss chart.

## VM Interface
### Memory Management
### CPU
### Device I/O

## Cost of Porting OS to Xen
### Host Structure
Discuss figure 1.

### Controls and Management

# Detailed Design
Thought experiment 2 might be covered here.

## Control Transfer: Hypercalls and Events
## Data Transfer: I/O Rings
### Async Ring Transfer Structure
Discuss figure 2.

## Subsystem Virtualization
### CPU Scheduling
### Timers and timers
### Virtual Address Translation
Thought experiment 4 could be here.

### Physical Memory
### Network
Thought experiment 3 information could be here.

### Disk

## Building new Domains

# Performance
There's a good chunk of sections here we need to widdle down and see what is needed per the thought experiments and summary requirements.

# Virtualization Motivations
* Grouped physical servers may suffer from _under-utilization_, why not consolidate them as VMs on one server with little performance penalty?
* Consolidating many servers into one can simply and reduce management cost.

# References
* [Xen and the Art of Virtualization](https://www.cl.cam.ac.uk/research/srg/netos/papers/2003-xensosp.pdf)