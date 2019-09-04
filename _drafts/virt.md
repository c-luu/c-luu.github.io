---
layout: post
title:  "Virtualization"
date:   2019-09-03 
categories: [systems]
tags: [summary, virtualization, theory]
---
# About
This post discusses virtualization in general.

# Key Terms

# Kinds of Virtualization
## Full
![hv]({{ site.url }}/assets/virt/hv.PNG)

In full virtualization, the guest VMs binaries are unchanged. They run as user-level processes which is a different privilege mode than if it was run bare-metal. Due to this, the guest VM isn't aware it is sitting on a hypervisor- so what happens if the guest issues a kernel-mode instruction?

### Trap and Emulate Strategy
Since the guest isn't aware of the hypervisor, it issues the kernel instruction as normal which generates a _trap_ into the hypervisor to emulate. Though this gives the benefit of not requiring binary modifications on the guest operating system, there's a draw-back.

Some privileged, or kernel, instructions may _fail silently_, i.e. from the guest OS perspective the instruction was handled as expected. To handle this case, the hypervisor must be cognizant of the set of silently failing instructions for each OS it supports and dynamically perform _binary translation_ to appropriately handle said instructions. 

## Para
![pv]({{ site.url }}/assets/virt/pv.PNG)

In para-virtualization, the guest VMs are _aware_ they are running on the hypervisor. This obviously requires binary modification of the guest OS. We are still running against said guest OS from the applications concern.

### How Much Modification?
Not much as documented by _Xen's proof of construction_: 2,995 and 4,620 lines of code were modified for Linux and XP which is 1.36% and 0.04% of the total code base respectively.

## Effort
In order to achieve virtualization, we'll need to virtualize:
* Memory hierarchy
* CPU
* Devices

Lastly, we'll need to add mechanisms handling data and control between guests and the hypervisor.

# Memory Virtualization
Nothing significant with a guest operating systems CPU, TLB, physically tagged cache is required in virtualization. Handling virtual memory is, however. 

> Virtual to physical address mapping is the key functionality in memory management subsystems.

Remember that each process is under the illusion that its (virtual) memory elements are _contiguous_, when in reality they may be sparse in physical memory due to paging.

## Guest To Hypervisor Translation
Each process in the guest VM has its own protection domain, and the guest VMs have distinct page tables they are aware of. 

### Guest Physical Memory Illusion
Let's say we have a Windows and Linux guest running on our hypervisor. The total physical memory that the Windows guest _thinks it has_ is $$[0, n]$$ and $$[0, m]$$ for the Linux guest.

Both the guests may think they have _contiguous_ memory blocks, e.g.:

$$R_1 = [0, q]$$ and $$R_2 = (q, n]$$ for Windows and $$R_1 = [0, l]$$ and $$R_2 = (l, m]$$ for Linux.


However these blocks may be mapped to _non-contiguous_ blocks on actual, physical machine memory.

### Shadow Page Tables (SPT) & Machine Page Numbers (MPN)
In a non-virtualized setting, the page table is the _broker_ when the process requests a translation from a virtual page number to a physical page number. 

Virtualized settings need __another level of indirection__ between the translation of the physical page number (PPN) and MPN: the SPT. 

The separation of concerns is:
* Guest PT translates VPN to PPN.
* Hypervisor SPT translates PPN to MPN.

![fullvirt-vpn-to-mpn]({{ site.url }}/assets/virt/fullvirt-vpn-to-mpn.PNG)

# Dynamically Increasing Memory
## Naive Approach
> Rob Peter to pay Paul!

## Coaxing Approach
### Ballooning

## Sharing Memory Across Guests
### Guest-oblivious Page Sharing
#### Successful Match

## Memory Allocation Policies

# References