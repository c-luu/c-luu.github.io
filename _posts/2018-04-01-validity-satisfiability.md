---
layout: post
title:  "SATisfiability & Validity"
date:   2018-04-01 23:17:12 +0000
categories: [ai]
tags: [logic]
---

#### Determining Satisfiability and Validity

##### Truth Tables

Let's try the example above as a truth table- remember, $F:P \wedge Q \to P \vee \neg Q$. **Is it valid?** If it's valid, $\forall I, I \vDash F$!

| $P$  | $Q$  | $P \wedge Q$ | $\neg Q$ | $P \vee \neg Q$ | $F$  |
| ---- | ---- | ------------ | -------- | --------------- | ---- |
| 0    | 0    | 0            | 1        | 1               | 1    |
| 0    | 1    | 0            | 0        | 0               | 1    |
| 1    | 0    | 0            | 1        | 1               | 1    |
| 1    | 1    | 1            | 0        | 1               | 1    |

$\therefore$, since $F$ is valid under all interpretations of $P$ and $Q$, $F$ is valid!

#### Semantic Arguments

We can also approach validity checking with the _semantic argument method_. This is more complicated than using truth tables- it's introduced and emphasized because it's the only method of evaluating satisfiability and validity of FOL formulae.

The recipe for this method is as follows:

1. A proof based on semantic method begins by assuming that a given formula $F$ is **invalid**: hence, there's a **falsifying interpretation** $I$ s.t. $I \nvDash F$.
2. The proof proceeds by applying the semantic definitions of the logical connectives in the form of **proof rules**. Proof rules have one or more _premises_, or assumed facts, and one or more _deductions_.
3. Applying proof rule requires matching premises to facts already existing in the semantic argument and then forming deductions.

The proof rules are as follows:

- According to $\neg$ semantics, from $I \vDash \neg F$, deduce $I \nvDash F$:
  - $\dfrac{I \vDash \neg F}{I \nvDash F}$
- And from $I \nvDash \neg F$, deduce $I \vDash F$:
  - $\dfrac{I \nvDash F}{I \vDash F}$
- See page 11 for further proof rule derivations using this system, e.g. $\wedge, \vee, \to, \leftrightarrow$ semantics.

##### Example Proof by Contradiction

To prove $F : P \wedge Q \to P \vee \neg Q$ is valid, **assume** it's **invalid** and **derive a contradiction**. I.e., assume there's a *falsifying interpretation* $I$ of $F$ s.t. $I \nvDash F$:

1. $I \nvDash P \wedge Q \to P \vee \neg Q$, assumption.
2. $I \vDash P \wedge Q$, by 1. and semantics of $\to$.
3. $I \nvDash P \vee \neg Q$, by 1. and semantics of $\to$.
4. $I \vDash P$, by 2. and semantics of $\wedge$.
5. $I \vDash Q$, by 2. and semantics of $\wedge$.
6. $I \nvDash P$, by 3. and semantics of $\vee$.
7. $I \nvDash \neg Q$, by 3. and semantics of $\vee$.
8. $I \vDash Q$, by 7. and semantics of $\neg$.

Since 4. and 6. are contradictions, our assumption <u>must</u> be wrong! 

$\therefore$, $F$ is valid! Also, the proof could've stopped after finding the first contradiction.

##### Derived Rules

Derived rules make proof rules more concise rather than using the proof rules defined earlier. E.g., the derived rule of **modus ponens**:

$I \vDash F$

$\dfrac{I \vDash F \to G}{I \vDash G}$

I.e., from $I \vDash F$ and $I \vDash F \to G$, deduce $I \vDash G$. Let's simplify the proof of the validity of: $F:(P \to Q) \wedge (Q \to R) \to (P \to R)$.

1. $I \nvDash F$, assumption.
2. $I \vDash (P \to Q) \wedge (Q \to R)$, by 1. and $\to$ semantics.
3. $I \nvDash (P \to R)$, by 1. and $\to$ semantics.
4. $I \vDash P$, by 3. and $\to$ semantics.
5. $I \nvDash R$, by 3. and $\to$ semantics.
6. $I \vDash (P \to Q)$, by 2. and $\wedge$ semantics.
7. $I \vDash (Q \to R)$, by 2. and $\wedge$ semantics.
8. $I \vDash Q$, by 4., 6., and *modus ponens*.
9. $I \vDash R$, by 7., 8., and *modus ponens*.
10. $I \vDash \bot$, 5. and 9. contradict, therefore $F$ is validated. This proof only had one branch.
