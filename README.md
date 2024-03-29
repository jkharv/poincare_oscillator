# [Re] Periodic forcing of a limit-cycle oscillator: Fixed points, Arnold tongues, and the global organization of bifurcations

## 2022 Replication of Glass and Sun (1994)

This project is a Julia 1.8.0 replication of Glass and Sun (1994), a paper that
analyzed the global organization of phase locking zones of a periodically
stimulated non-linear limit-cycle oscillator at various relaxation rates. Full
reference to the original article:

> L. Glass and J. Sun. “Periodic forcing of a limit-cycle oscillator: Fixed
points, Arnold tongues, and the global organization of bifurcations.” In:
Physical Review. E, Statistical Physics, Plasmas, Fluids, and Related Inter-
disciplinary Topics; (United States) 50:6 (Dec. 1994).
https://journals.aps.org/pre/abstract/10.1103/PhysRevE.50.5077

Here we also include visual GIFs of the changing phase locking zones as a
function of changing relaxation rate to the limit cycle:

![vary_k](https://github.com/jkharv/poincare_oscillator/blob/main/plots/vary_k.gif?raw=true)

![vary_small_k](https://github.com/jkharv/poincare_oscillator/blob/main/plots/vary_small_k.gif?raw=true)

=======

## Authors 

Jacob K. Harvey - [Github](https://github.com/jkharv),
[ORCID](https://orcid.org/0000-0003-3713-1824)

Lucas Philipp - [Github](https://github.com/lucasphilipp1),
[ORCID](https://orcid.org/0000-0001-6454-4275)

Kiri Stern - [Github](https://github.com/kiristern),
[ORCID](https://orcid.org/0000-0002-5720-2581)

## Running the code

Clone this repository to your own computer.

```
git clone https://github.com/jkharv/poincare_oscillator
```

`cd` into the directory and start a Julia REPL. This code is optimized for
multiple threads, using the `-t` argument you can start Julia with multiple
threads. Setting this to `auto` uses all available threads, otherwise set it to
any integer value of threads you wish to use.

*N.B. This script takes about 25-30 minutes to run when using 16 threads.*

```
julia -t auto
```

To install the dependencies enter the package manager and enter the following
commands,

```
] activate . 
instantiate
```

Then return from the package manager by hitting backspace.

Finally, run the code by sourcing the main script at the REPL.

```
include("src/poincare_oscillator.jl")
```
