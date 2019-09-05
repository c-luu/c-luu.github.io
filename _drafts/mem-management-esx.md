---
layout: post
title:  "Memory Resource Management in VMware ESX"
date:   2019-09-05 
categories: [systems]
tags: [summary, virtualization, xen, esx]
---
# About
This summary discusses memory management in VMware's ESX server and aims to compare and contrast to its contemporary product: Workstation, and future product: Xen. ESX is a thin monitor that efficiently multiplexes hardware resources among VMs running _unmodified_, i.e. fully virtualized, concurrently. ESX mechanisms for implementing memory management policies will be discussed. 

## Big Ideas
* High-level resource management policies to compute a target memory allocation for each VM, based on specified parameters and system load.
* Low-level mechanisms to reclaim memory from VMs.
* A daemon that exploits opportunities to share identical pages among VMs, reducing overall system memory pressure.

# Key Terms
1. Hypervisor- [A.k.a. virtual machine monitors](https://en.wikipedia.org/wiki/Hypervisor), an abstraction that creates and runs virtual machines. In this summary we use _monitors_ for brevity.
2. Over-commitment- Total _configured_ memory for the VMs has __exceeded__ actual machine memory.
3. Ballooning- A technique that _reclaims_ pages in a VM that the host deems as _least valuable._
4. Idle memory tax- Better memory utilization while maintaining performance isolation guarantees.
5. Content-based page sharing & hot I/O page remapping- Exploits transparent page remapping to eliminate redundancy and reduce copy-overheads.
6. Physical address- Software abstraction to provide the _illusion of hardware memory_ to a VM.
7. Machine address- Actual hardware memory. __Remember: physical address is NOT the same as machine address, at least in this paper.__

## Initial Contrasts with Workstation
As mentioned earlier, ESX is a thin software abstraction designed to _multiplex_ resources among VMs. Its design is a stark contrast to the Workstation product that utilizes a [hosted VM architecture]() to harness the pre-existing OS for portable I/O device support. This hosted architecture employed by the Workstation monitor has significantly lower I/O performance. 

### Handling Nested System Calls
> How do the two monitors handle system calls from a user process inside of the VM?

Generally speaking, this performance hit is due to the extra level of interception required for address translation:

1. A guest VM attempts to read sectors from its virtual disk.
2. The Workstation monitor intercepts this attempt.
3. The monitor issues a `read()` system call to the underlying host OS to retrieve the data.

In contrast, the ESX monitor manages system hardware directly, bypassing interceptions.

# Memory Virtualization
Each guest OS, executing in a VM, expects a zero-based physical address as if it were running on real hardware. ESX provides this illusion to the guest by using an extra level of address translation. This illusion is called _virtualizating physical memory_. 

## Supporting Data Structures
### pmap (PPN -> MPN)
Each VM instruction to modify its page table or TLB is intercepted by ESX. ESX manages the `pmap` structure for each VM to translate _physical_ page numbers (PPN) to machine page numbers (MPN). 

### Shadow page tables (VPN -> MPN)
Similar to `pmap`, only it maintains _virtual_ to _machine_ page mappings, maintained by the processor and kept consistent with the physical to machine mappings of the `pmap`. 

A few benefits are realized with clever use of these data structures:
* Permits ordinary memory references to execute without additional overhead since the hardware TLB caches _direct virtual-to-machine_ address translations read from the shadow page table.
* ESX can remap a _physical_ page by changing its PPN to MPN mapping. 
* ESX can monitor or interpose on guest memory accesses.

## Contrasts with Xen
???

# Reclamation Mechanisms
## Page Replacement Issues
There's a lot of 'em. Page 3.

## Ballooning
If ESX _reclaims_ memory from a guest VM, said guest should perform as if it had been initially _configured_ with less memory. Apparently this achieves predictable performance. 

> ESX uses ballooning to achieve predictable performance by coaxing the OS into cooperating with it when possible.

This requires a pseudo-device driver or kernel service that must be loaded into the guest OS at certain times. The guest cannot interact with the driver, only ESX may. When ESX wants more memory, it tells the driver to _inflate_ (the driver allocates _pinned physical pages_ within the VM). _Deflating_ is achieved by deallocating previously-allocated pages. 

When inflating, the guest OS experiences increased memory pressure since the driver is allocating more pinned physical pages. This causes the guest OS to invoke native memory management algorithms.

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