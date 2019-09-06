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
8. Copy on write (COW)- Writing to such shared page that is marked COW generates a fault that _generates a private copy._
9. Shares- Resource rights owned by resource consumers. Share collection is proportional to allowed resource consumption.
10. Performance isolation- Throttling performance (e.g., memory availability) on client VMs based on variables such as how much the client is paying to use the service for example.

## Initial Contrasts with Workstation
As mentioned earlier, ESX is a thin software abstraction designed to _multiplex_ resources among VMs. Its design is a stark contrast to the Workstation product that utilizes a [hosted VM architecture](https://en.wikipedia.org/wiki/Hypervisor#Classification) to harness the pre-existing OS for portable I/O device support. This hosted architecture employed by the Workstation monitor has significantly lower I/O performance. 

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

# Reclamation Mechanisms
## Page Replacement Issues
The benefits of _over-committing_ virtualization system configurations does come with a few meta-problems. ESX has to decide how to give and take memory from what VM to another. In a typical OS, this is already solved with paging.

In aggregate, these guests are actually paging out to their _illusions_ of physical memory, which crosses into the monitor boundary. A naive solution is to take the same paging logic and apply it at the monitor level as well, a.k.a. meta-level page replacement.

This isn't ideal since the monitor must guess which VM to target for paging, but also which pages are _least valuable_ within the VM to page. The guest OS is the entity that really knows which of its pages are least valuable.

## Ballooning
If ESX _reclaims_ memory from a guest VM, said guest should perform as if it had been initially _configured_ with less memory. Apparently this achieves predictable performance. 

> ESX uses ballooning to achieve predictable performance by coaxing the OS into cooperating with it when possible.

This requires a pseudo-device driver or kernel service that must be loaded into the guest OS at certain times. The guest cannot interact with the driver, only ESX may. When ESX wants more memory, it tells the driver to _inflate_ (the driver allocates _pinned physical pages_ within the VM). _Deflating_ is achieved by de-allocating previously-allocated pages. 

When inflating, the guest OS experiences increased memory pressure since the driver is allocating more pinned physical pages. This causes the guest OS to invoke native memory management algorithms. When memory is scarce, the VM has to reclaim space to satisfy the driver. The guest decides which pages to reclaim or pages out to virtual disk if necessary. The driver gives ESX each allocated, pinned PPNs, so that it can use it to reclaim its corresponding MPNs. 

More details of what goes into ballooning:
1. Driver causes PPN to balloon.
2. ESX annotates its `pmap` entry.
3. ESX de-allocates the associating MPN.
4. ESX handles subsequent faults due to accesses to the PPN _that was annotated in step two?_
5. At this point, the balloon has been _popped_, such that any interaction with the guest driver will reset its state.
6. The fault is handled by allocating a new MPN back to the PPN.

Otherwise, memory is abundant and it returns memory from its free list. 

### Implementation
1. Poll the server once per second in order to:
2. Obtain a target balloon size.
3. Allocation rates are adaptive to avoid stressing out the guest VM. 

Standard kernel interfaces are used to allocate physical pages, such as `get_free_page()` in Linux and `MmProbeAndLockPages()` in Windows.

Some down-sides of ballooning is having to install and uninstall it. Have the driver turned off during guest OS booting.

#### Ballooning in Xen (thought experiment)
TODO: Come back after reading the Xen paper to see how ballooning could be achieved there.

## Demand Paging
Ballooning is used to optimize for the most common case. When it can't be used, ESX falls back to demand paging. The ESX swap daemon receives swap targets for each VM and coordinates async page-outs to an ESX server swap area. Randomized page replacement is used, a choice based on an expectation that this fall-back will not occur often.

# Sharing Memory
What if the guest VMs run the same, or similar operating systems and processes? There is often such overlap, and ESX takes advantage of this so that server workloads running in VMs on a single machine are more memory efficient than if they were run on separate physical machines. This allows ESX to support higher levels of over-commitment.

## Transparent Page Sharing
It's common that VMs end up having identical pages of data, e.g. source code and read-only data. This redundant data could be consolidated to increase memory efficiency. If VMs x, y, and z have redundant _physical_ pages, ESX can map them to a _single_ machine page and mark it as COW. 

## Content Page Sharing
> By definition, all potentially shareable pages can be identified by their contents.

Other implementations of page sharing required modifying the guest OS- something ESX cannot do. ESX achieves this by scanning for potential sharing opportunities. Otherwise, a naive mechanism is needed to compare the content of _every page_ against _every other page_ in the system, which requires exponential time. ESX answers this with hashing.

### Hashing
We can avoid an exponential time page comparison with a hash table, where each entry might have a structure as such:

```c
struct cow_entry_t {
    size_t hash_val;
    char* contents;
}
```

The hash table will only hold contents from a COW page. With this structure, we can hash _some_ of a pages contents to form a key in the hash table. Upon successful look-up, do a full comparison of the contents to determine if it is a complete match or not. The heuristic being:

> If the hash_vals match, it's very likely their contents will as well.

On a miss, we could mark the page in question as COW, presuming there will be a future match. There's a downside to doing this on misses- at worst case, every hash table lookup could potentially mark these pages as COW which will incur overhead.

On a successful lookup and content comparison, we can reclaim the redundant page in question and use COW semantics to efficiently share the pages. Any _write_ attempts to this shared page generates a fault that creates a private page for the writer.

# Shares and Working Sets
While some systems tune memory allocation to improve some _aggregate_ measure, there is often a need to go for a less _fairness_-based approach. In some settings, some VMs should be prioritized over others due to pricing tiers, administrative groups, etc. ESX claims to incorporate this _VM penalization_ while not sacrificing isolation and memory performance. 

## Share-Based Allocation
ESX uses the _min-funding revocation replacement algorithm that selects a _victim_ VM, relinquishes its previously allocated space, and gives it to an in-demand client. The victim client is usually one with lower shares per allocated page.

> Shares-per-page ratio is like price; revocation allocates memory away from cheap clients to higher paying clients.

# Reclaiming Idle Memory
> The goals of performance isolation and efficient memory utilization often conflict.

If a client with more shares starts idling, it begins hoarding memory at the cost of lower-share clients that are active. ESX handles this problem by taxing the former client.

## Idle Memory Tax
The idea is to charge a client _more_ for idle pages it uses than for one it is actively using. This gives the desired dynamics:

> If memory is scarce, prefer to reclaim pages from clients not using their full allocations.

The tax rate is the maximum fraction of idle pages ESX can reclaim from a client. When a client starts using more of its allocated memory, its allocation will grow commensurate to its shares. See formula in section 5.2. 

### Measuring
ESX measures idle memory by using sampling techniques. For each VM, and given a sampling period defined in units of VM execution time:

1. Randomly select _n_ physical pages from the VM.
2. Track these pages by invalidating their mappings to their PPN.
3. Now, subsequent accesses from the guest OS will be intercepted by ESX, which increments touched page counter _t_. 
4. At the end of sampling, we now have $$t/n$$, estimating the fraction of actively accessed memory.

# Allocation Policies
ESX admins control VM memory allocation using three variables:

1. Minimum size
2. Maximum size
3. Memory shares

Minimum size is the _guaranteed_ minimum amount of memory allocated to a VM, even in over-committed configurations. Maximum size is the amount of _physical_ memory allotted to a guest OS running in the VM. Unless over-committed, VMs will be allotted their max size.

A VM with twice as many memory shares as another is _entitled_ to consume twice as much memory, assuming they're both using their allocated memory. This entitlement is subject to the configured minimum and maximum size.

## Admission Control Policy
This ensures the following categories are available before the VM powers on:
* Unreserved memory
* Server swap space

Minimum plus _overhead_ memory is guaranteed to the VM, where overhead constitutes `pmap` and shadow page table structures, and things like graphic buffers, to support virtualization.

Disk swap space is reserved for the remaining VM memory, calculated as maximum minus minimum memory. 

## Dynamic Reallocation
Sometimes ESX has to recompute memory allocations due to events such as:

* System-wide allocation parameters changed.
* VM allocation parameters changed.
* VMs entering or leaving the ecosystem.

Typically operating systems maintain a _minimum_ of free memory, e.g. 5%. If memory falls below, reclamation begins until a threshold of 7% is crossed.

ESX has four thresholds:

* High- Memory is sufficient, don't reclaim memory. 
* Soft- Balloon driver kicks in.
* Hard- Paging algorithm kicks in.
* Low- Continue paging until VMs that are _above_ their target allocations are blocked.

In order to reclaim memory, ESX computes target allocations for VMs to drive aggregate free space above the _high_ threshold. ESX uses a _laddering_ mechanism for crossing thresholds to prevent rapid state fluctuation. I.e., the threshold can promote or demote to the levels directly below or below it based on meeting the threshold criteria, no level jumping is allowed.

# I/O Page Remapping
High-end systems sometimes keep a separate I/O MMU to remap memory for data transfers. In such systems, when I/O involving _high memory_ crosses a threshold, say four gigabytes, it's copied into a temporary _bounce buffer_ in _low_ memory.

Virtualization exacerbates this because the _physical_ memory of a VM could be mapped to machine pages in _high_ memory. Since ESX uses translation indirection, it can remap the guest pages between low and high memory.

ESX will track _hot pages_ in high memory with a history of high I/O, such as network transmits. It can augment the PPN to MPN software cache to count each page copy. Once the count has crossed a threshold, ESX transparently remaps it to low memory.

# References
* [Memory Resource Management in VMware ESX Server](http://www.waldspurger.org/carl/papers/esx-mem-osdi02.pdf)