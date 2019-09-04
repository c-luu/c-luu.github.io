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
4. Descriptor tables (DT)- E.g. page tables? Where a Global DT (GDT) is maintained by the TCB and Local DT (LDT) is maintained by each process.


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

[left off here](https://gatech.instructure.com/courses/73936/pages/topic-3-lecture-videos?module_item_id=379486)

# References