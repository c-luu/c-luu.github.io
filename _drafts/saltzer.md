---
layout: post
title:  "Security Design Principles"
date:   
categories: [security]
tags: [summary]
---
# About
A summarization of section I.A.3 of the [Seltzer paper](http://web.mit.edu/Saltzer/www/publications/protection/Basic.html).

# Negative Requirements and Preventing Unauthorized Actions
In practice, building a system that prevents _all unauthorized_ acts is extremely difficult. The exception being _level-one_ systems, which are essentially completely unprotected systems. There's on-going research in systematically excluding security flaws from system implementations, but no general solution is available. It's inherently difficult to achieve because preventing __all__ unauthorized actions is a __negative requirement__.

# Principles in Absence of Methodical Techniques
Since there's no answer to systematically preventing unauthorized access, here are some design principles recommended to mitigate it.

## Fail-safe Defaults
> The default situation is lack of access, and the protection scheme identifies conditions under which access is permitted.

> A default of lack of permission is safer.

I.e., base access decisions on permissions rather than exclusion. It is better to ask why an object _should be_ accessible, rather than why they _shouldn't_ be. This is especially needed in large systems where it's difficult to manage access for every single resource. 

An instance where this principal of _requiring permission rather than exclusion_ is a system with a faulty access-exclusion mechanism that could fail by _allowing access_. 

## Complete Mediation
> All object accesses must be checked for authority.

This forces a system-wide view of access control, including system:

* Initialization
* Recovery
* Shutdown
* Maintenance

This principal implies:

* The method of identifying the _source_ of each request must be foolproof.
* Performance enhancements by remembering the result of a previous security check must be examined skeptically. If the authority changes, the remembered results could be stale.

## Open Design
Favor hiding and protecting a small set of keys and passwords over keeping the system security design a secret. By doing this, we _separate mechanism from protection keys_, allowing the mechanisms to be scrutinized and improved by the community.

## Separation of Privilege
> Where feasible, a protection mechanism requiring two keys to unlock it is more robust and flexible than one that allows access with just one key.

Once the mechanism is locked, no _single accident or breach_ can access the protected mechanism since the keys are separated among different entities.

This principle is already used effectively in physical systems, e.g.:

* Bank safe deposits, where there is a separate key into the vault, and another key to get into the deposit box.
* Defense systems, where two or more people need to give the correct command to fire a nuclear weapon.

## Least Privilege
> Each entity of the system should operate using the least set of privileges needed to complete the job.
In the military, this is known as [need-to-know basis.](https://en.wikipedia.org/wiki/Need_to_know)

This has practical benefits:

* Reduces potential interactions among privileged programs to the minimum for correct operation.
* Reduces unintentional, unwanted, or improper uses of privilege.
* Minimizes the number of programs to audit when someone asks how a privilege was misused.  
* Provides a rational of where to install firewalls should a mechanism provides one.

## Least Common Mechanism
> Avoid having multiple subjects sharing mechanisms to grant access to a resource. 

E.g., consider we share our application on the internet and there are two known subjects:

1. Valid users
2. Hackers

Our only mechanism for access is one- simply having the sight open and accessible to the Internet. Now sensitive info can be used by real users and attackers to gain application access.

If we have a different mechanism for each type of subject or class of subjects we have more access control flexibility and prevent security violations that'd occur if we only have one mechanism.

## Psychological Acceptability
To routinely apply the security mechanisms correctly, the interface must be simple to use. If the user's _mental image_ of the protection goals matches the required mechanisms, mistakes will be minimized. If the security mechanism is very difficult or awkward to have a _mental image_ or abstraction of, it's easier for the user to misuse the mechanism, leading to potential security violations or attacks.

# Imperfect Principles
## Work Factor
> Compare the cost of circumventing the mechanism with the resources of the potential attacker.

This _cost_ is known as the work factor, and can easily be calculated in some cases. For example, if our passwords can only be two alphabetic characters, that is `26^2` possible variations. An attacker with only a terminal and keyboard as resources has a _much higher work factor_, than an attacker with a computer capable of generating and automatically entering millions of passwords per second.

Some troubles with this principle causing unreliable or difficult cost estimates:

* Many protection mechanisms are __not__ conducive to work factor calculations.
* Defeating such systems systematically may be _logically impossible_. 
* Defeat is accomplished _indirectly_, such as waiting for hardware faults, or exploiting implementation errors.

## Compromise Recording
Some arguments say that _recording_ a potential attack could be as strong as the mechanism preventing the attack. E.g., some systems log the date and entity that last accessed a record. If such log was tamper-proof, it could provide valuable data on the potential attacker. The reason this is _imperfect_ is that it's difficult to guarantee discovery once the security has been broken, e.g. attacker can undo the log.

# References
* [Examples of these principles in use](http://www.informit.com/articles/article.aspx?p=30487&seqNum=2)
* [us-cert least common mechanism](https://www.us-cert.gov/bsi/articles/knowledge/principles/least-common-mechanism)