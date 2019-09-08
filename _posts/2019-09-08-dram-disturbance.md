---
layout: post
title:  "DRAM Disturbance Errors and RowHammers"
date:   2019-09-08 
categories: [security]
tags: [summary, hardware, tcb, dram]
---
# About
A summary on required [DRAM disturbance errors and how bits are flipped in memory without accessing them](https://users.ece.cmu.edu/~yoonguk/papers/kim-isca14.pdf) and [Project Zero exploits of such errors](https://googleprojectzero.blogspot.com/2015/03/exploiting-dram-rowhammer-bug-to-gain.html). 

Memory isolation is key in the TCB.

> Memory access in one location shouldn't have unintended side effects on data stored in other addresses. 

This isolation is harder to achieve as DRAM technology scales down. It's proved that reading from the same address in DRAM can corrupt nearby data. This _disturbance error_ is caused by _charge leakage_ from repeatedly toggling DRAM word-lines. 

The DRAM goal of scaling down has an advantage of reducing _cost-per-bit_ of memory. This sacrifices memory reliabilities due to:

1. The smaller the cell, the less charge it can hold, making it more vulnerable to data loss.
2. Close cell proximity causes undesired interaction.
3. Higher variation in process technology increases _outlier cells_ that are very susceptible to cross-talk, making the previous points worse.

These factors contribute to _disturbance_- different cells interacting with each other's operations. Once this disturbance breaks the cells _noise margin_, its malfunction is called a _disturbance error_.

# The Word-line
> The root cause of DRAM disturbance errors are due to voltage fluctuations on an internal wire called the word-line.

A DRAM is a 2-d cell array, and each _row_ has a _word-line_. 

![rows]({{ site.url }}/assets/dram-disturbance/rows.png)

Accessing a cell in a row requires _activating_ its word-line by raising its voltage. Multiple row accesses causes the word-line to toggle repeatedly, which causes voltage fluctuation, causing the disturbance error on neighboring rows. 

![cell]({{ site.url }}/assets/dram-disturbance/cell.png)

Each cell is an intersection of the vertical _bit-line_ and horizontal _word-line_, connecting all cells in the grid. 

# Inducing Disturbance
## A
This snippet generates a DRAM read on __every__ data access. It queues up multiple DRAM read requests.
```
code1a:
    // read from DRAM @ address X into general purpose register
    mov (X), %eax
    // read from DRAM @ address Y into cache register
    mov (Y), %ebx
    // Evict data from cache
    cflush (X)
    cflush (Y)
    // Ensure data is fully flushed 
    mfence
    // Loop
    jmp code1a
```

The key observation is that _X_ and _Y_ are chosen such that they map to the same _bank_ but different _rows_ within the bank. This code forces the memory controller to open and close repeatedly, for millions of iterations. This causes unintended _bit-flips_, or writes, when no write was issued- this proves the cause of the disturbance error.  

## B
```
code1b:
    mov (X), %eax
    cflush (X)
    mfence
    jmp code1b
```

This does not cause the disturbance error, since all reads target __the same row in DRAM__. The memory controller _minimizes_ DRAM commands by opening and closing rows __just once__. 

> DRAM disturbance errors are caused by repeated toggling of a row, NOT by column reads- which is exactly why code B doesn't induce errors.

# Bad News
Such disturbance errors violate two memory invariants:

1. Read access should __not__ modify data at __any__ address.
2. Write access should modify data __only at the address being written to.__

Violating such invariants, such as inducing disturbance errors, opens up avenues for error injections, system crashes, and hijacking. 

## Privilege Escalation Exploit
The Project Zero team from Google exploited disturbance errors to cause bit-flips in page tables. This enabled a user-level process to gain read and write access to all physical memory, something the team argues could have been discovered sooner had vendors been more explicit about this _unreliability_ bug.

Their kernel-privilege exploit by row-hammering to induce a bit-flip in a page table entry (PTE). This causes the PTE to point to a physical page _containing a page table of the attacking user-level process_. The attacking process now has access to one of its own page tables, hence all of physical memory.   

### Ensuring High-Probability of Attack
1. Row-hammer induced bit-flipping tends to be repeatable. With this property, we know which bit location will be fruitful for exploiting.
2. As a PTE's PPN changes, there's a high probability it'll point to a page table of the attacking process. To trigger such changes, they _spray_ most of physical memory with page tables. Spraying can be done by calling `mmap` on the same file repeatedly. This is __fast__, 3 gigabytes of memory full of page tables takes about 3 seconds!

### Exploit Steps
1. `mmap` a large block of shared-memory segments in `/dev/shm` repeatedly.
2. Search block for victim addresses by row-hammering random address pairs. Or, treat `/proc/self/pagemap` as a cache of victim physical addresses from a previous run.
3. If victim address was bit-flipped with no benefit for the exploit, skip that address set.
4. Otherwise, `munmap` all but the aggressor/ victim pages and begin the exploit attempt. 

## Terrifying News
Could this exploit be done in normal memory accesses? The Project Zero thinks so, _if_ all cache levels generate misses to allow for the row-hammer bit flipping. 

> If possible, it's a serious problem, because now JavaScript code can generate bit flips on the open web, perhaps via JavaScript typed arrays.

# Solutions
1. Make better chips- regardless of improved process technology, the goal is still for smaller cells, which makes disturbance errors possible again.
2. Correct errors- too expensive, especially for consumers.
3. Refresh all rows frequently- causes performance degradation and energy-efficiency, however the paper discusses implementation that could make it worth it.
4. Retire cells (manufacturer)- victim cells to replace could take days.
5. Retire cells (consumer)- end-user has to pay cost of finding such victim cells.
6. Find "hot" rows and refresh neighbors- heuristic approach to identify frequently opened rows and refresh only their neighbors. Intuitive, but introduces hashing, which introduces hash collisions.
7. PARA- the _proposed_ solution. When a row is toggled, one of its neighbor rows is also opened with low probability, i.e. refreshed. The main advantage is that it is _stateless_ and doesn't need expensive hardware counters. PARA has small performance impact for _strong_ reliability and low design complexity from its stateless nature.

# References
* [Row hammer exploit source code](https://github.com/google/rowhammer-test)