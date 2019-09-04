---
layout: post
title:  "TCB & Untrustworthy Apps"
date:   2019-09-05 
categories: [security]
tags: [summary, hardware, tcb]
---
# About
A summary on required hard-ware support for a trusted-computing-base (TCB).

# Key Terms
1. Segmentation- Variable sized, logical units of an address space.
2. Pages- The result of splitting up a segment. Is fix-sized.
3. Logical address- E.g. virtual address. Consists of a segment number, page number, and page offset,
4. Descriptor tables (DT)- E.g. page tables? Where a Global DT (GDT) is maintained by the TCB and Local DT (LDT) is maintained by each user-process.
5. Data protection level (DPL)- Segment descriptor protection level.
6. Current data protection level (CPL)- DPL of the code segment being executed.
7. Requestor privilege level (RPL)- Specified in the segment selector data structure.

# Isolation
As noted in the TCB design principles summary, it is important that the TCB is _isolated_ from untrustworthy code. This can be achieved at a few levels in the system. 

## Hardware Implementation
Hardware can help us achieve the isolation goals of a TCB. For brevity, we'll assume we can _trust_ the hardware from a security perspective. At a high level, hardware provides us two isolation mechanisms:

1. Privilege modes (e.g. user versus kernel)
2. Privileged instructions

We will consider the address space is the __unit of protection__, or isolation. 

# Process Address Space
Our TCB exists in the kernel space and will be shared among each user-level process. 

![process]({{ site.url }}/assets/tcb-untrusty/process.png)

## Segment Tables
These _seem_ like page tables. Segment tables contain records that hold where a logical address is mapped to in main memory. Given a logical address and the following:

* Segment table base register (SGTBR)
* Segment table entry (STE) 
* STE size

We can calculate the physical address:

```c
size_t physical_addr = *(SGTBR + STE * sizeof(STE)) + displacement;
```

[TODO: Lots of page table and translation to revisit in M3L4, although the professor did mention the low level details is not important in office hours (verify this).](https://gatech.instructure.com/courses/73936/pages/topic-3-lecture-videos?module_item_id=379486)

# x86 Memory Protection Bits
Segments in the segment table have _protection_ bits. The _segment selector data structure_, which is used early in the address translation prodcess has the following properties:

* Index field
* TI (GDT or LDT)- a bit indicating which descriptor table to use.
* RPL- Indicates the protection level the _requestor_ wants to access the segment at.

We measure how _privileged_ a segment is with two bits, giving us a total of four privilege levels:

0. Highest (Kernel)
1. ...
2. ...
3. Lowest (User)

## Protection Check
We can determine whether an access is privileged enough by taking the max of the CPL and RPL, and checking if the result is at _least_ the DPL of the target. 

| CPL | RPL | DPL (target) | Note                                                                              |
|-----|-----|--------------|-----------------------------------------------------------------------------------|
| 3   | 3   |      3        | The max protection level is 3, so we can only access a target at level 3.         |
| 0   | 3   |     3         | Current DPL is 0 (kernel), requester only needs to access at 3 (user), so 3 wins. |

In the first example, `max(3, 3) <= 3`, so we can only perform the access if the target is at user level.

In the second example, we are currently at kernel level, but the request wants to access at user level. Since user level is larger in value than kernel, we choose this when determining if we can access the target DPL, i.e., this prevents __privilege escalation__, and increases protection and unintended privileged access,

# Conforming & Non-conforming Code
TODO: Need to revisit this, maybe from a separate paper.

The gist here is not all code accesses data, but may need to operate at DPL 0, an example is exception handling. This is considered _conforming_ code.

# Page Protection Levels
Pages _also_ have protection levels, luckily only tracked in one bit- privileged or non-privileged. 

> If your CPL is 3 (user mode), you can only access pages at protection level 1.

Armed with _segment_ and _page_ protection levels, we are now armed to protect ranges of addresses in hardware!

# M3L9

# References