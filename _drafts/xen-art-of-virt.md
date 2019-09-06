---
layout: post
title:  "Xen and the Art of Virtualization"
date:   2019-09-06 
categories: [systems]
tags: [summary, virtualization, xen]
---
# About  
This summary discusses x86 virtualization in VMware's Xen, a resource-managed monitor that enables server consolidation, co-located hosting facilities, distributed web services, secure computing platforms, and application mobility.

# Key Terms
1. Hypervisor- [A.k.a. virtual machine monitors](https://en.wikipedia.org/wiki/Hypervisor), an abstraction that creates and runs virtual machines. In this summary we use _monitors_ for brevity.
2. _XenoLinux_- VMware's Linux port that is compatible with Xen?

# Background
There's a few challenges when partitioning a machine to support concurrently executing guest operating systems:

* VMs should be isolated from each other (trust-issues).
* It's desired to support multiple kinds of operating systems due to the benefits and popularity of multi-platform applications.
* The virtualization needed to achieve such partitioning should introduce little overhead.

Unlike their competitor, VMware's ESX for example, Xen requires a guest VM, e.g. XenoLinux, to sit between the monitor and guest operating systems. It exports an ABI identical to a non-virtualized Linux OS.

# Paravirtualization
A traditional monitor exposes a _virtual_ hardware interface that is _functionally identical_ to the underlying machine. Full virtualization provides the benefit of not having to modify the guest OS binaries, however there's a few drawbacks, if x86:

* Full virtualization support was never apart of x86 architecture design.
* Some instructions need to be intercepted by the monitor and handled. Without the sufficient privilege, they may fail silently instead of trapping correctly.
* _Efficiently_ virtualizing x86 is difficult.

E.g., the ESX server dynamically rewrites some of the hosted machine code to insert traps when monitor intervention is needed. Since all non-trapping privileged instructions must be caught and handled, this dynamic translation is applied to the entire guest. This results in high-cost, update-intensive operations such as creating a new application process.

Xen avoids the drawbacks of full virtualization by providing a monitor that is _similar_ to the underlying hardware- paravirtualization. 

# VM Interface
## Memory Management
## CPU
## Device I/O

# Cost of Porting OS to Xen
## Host Structure
Discuss figure 1.

## Controls and Management

# Detailed Design
Thought experiment 2 might be covered here.

# Control Transfer: Hypercalls and Events
# Data Transfer: I/O Rings
## Async Ring Transfer Structure
Discuss figure 2.

# Subsystem Virtualization
## CPU Scheduling
## Timers and timers
## Virtual Address Translation
Thought experiment 4 could be here.

## Physical Memory
## Network
Thought experiment 3 information could be here.

## Disk

# Building new Domains

# Performance
There's a good chunk of sections here we need to widdle down and see what is needed per the thought experiments and summary requirements.

# Virtualization Motivations
* Grouped physical servers may suffer from _under-utilization_, why not consolidate them as VMs on one server with little performance penalty?
* Consolidating many servers into one can simply and reduce management cost.

# References
* [Xen and the Art of Virtualization](https://www.cl.cam.ac.uk/research/srg/netos/papers/2003-xensosp.pdf)