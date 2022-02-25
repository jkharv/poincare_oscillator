# poincare_oscillator

A replication of 

[L. Glass and J. Sun. “Periodic forcing of a limit-cycle oscillator: Fixed
points, Arnold tongues, and the global organization of bifurcations.” In:
Physical Review. E, Statistical Physics, Plasmas, Fluids, and Related Inter-
disciplinary Topics; (United States) 50:6 (Dec. 1994).](
https://journals.aps.org/pre/abstract/10.1103/PhysRevE.50.5077)

## Authors 

Jacob K. Harvey - [Github](https://github.com/jkharv),
[ORCID](https://orcid.org/0000-0003-3713-1824)

Lucas Philipp - [Github](https://github.com/lucasphilipp1),
[ORCID](https://orcid.org/0000-0001-6454-4275)

Kiri Stern - [Github](https://github.com/kiristern),
[ORCID](https://orcid.org/0000-0002-5720-2581)

## Running the code

Clone this repository to your own computer.

``` git clone https://github.com/jkharv/poincare_oscillator ```

`cd` into the directory and start a Julia REPL. This code is optimized for
multiple threads, using the `-t` argument you can start Julia with multiple
threads. Setting this to `auto` uses all available threads, otherwise set it to
any integer value of threads you wish to use.

``` julia -t auto ```

To install the dependencies enter the following line at the REPL.

``` ] instantiate ```

Then return from the package manager by hitting backspace.

Finally, run the code by sourcing the main script at the REPL.

``` include("src/poincare_oscillator.jl") ```







