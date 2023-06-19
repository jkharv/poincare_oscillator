# This file contains code which is used to plot figures S2 and S3 in the supplementary
# material. These two figures are used to show the behaviour of two functions that come 
# out of the analytical derivations in our replication.

"""
    ϵ_fix(x)

`acos` gets tripped up when given a number larger than one. In some functions, we ran into
issues with rounding errors producing values of 1.0 + ϵ. This function simply rounds those
back down to avoid getting `DomainError`s being thrown by `acos`.

# Arguments

- `x::Float64`: Float value to be rounded down.
"""
function ϵ_fix(x)

    if abs(x) > 1.0
        return 1.0
    else
        return x
    end
end

"""
    △ϕsurface(ϕ, b, s)

Eqs. S17 and S18 from the supplementary materials of our replication.

# Arguments

- `ϕ::Float64`
- `b::Float64`
- `s::Float64`: Switches betwen eqs. S17 (s = -1.0) and S18 (s = s = +1.0) 
"""
function △ϕsurface(ϕ, b, s)

    modArg1 = (1/2π) * acos(
                            ϵ_fix(
                                  real((b + cos(2π*ϕ))/
                                      (sqrt(1 + b^2 + 2b * cos(ϕ*2π)))
                                      )
                                 )
                           )

    modArg2 = (1/2π) * acos(
                            ϵ_fix(
                                   s*sqrt(Complex(
                                                (b^2 - 1)/
                                                 3
                                                )
                                        )
                                 )
                           )

    # We're splitting it into two curves, cause there's 
    # actually a discontinuity which just renders as a
    # vertical surface otherwise.
    if (0 ≤ ϕ ≤ 1/2)
        arg = modArg1 + modArg2
    elseif (1/2 ≤ ϕ ≤ 1)
        arg = -modArg1 - modArg2 + 2
    end 
      
    return ϕ - mod(real(arg), 1)  
end

# Family of solutions to eq18 of this form =
# N - acos((-b^2 -2)/3b)/2π where N ∈ Z
"""
    ϕisoline(b)

There is a family of solutions to eq. S18 represented by N - isoline(b) where N ∈ Ζ.
This function (N = 0) is the black lines plotted in figures S2 and S3.
"""
function ϕisoline(b)

    acos((-b^2 -2)/3b)/2π
end

#
# Figure of eq. S17
#

bs = LinRange(1.0, 1.9999, 200);
# We're doing ϕ in two chunks (and putting small gap at ϕ=0.5) 
# because there's a discontinuity
# that we don't really want rendered as a vertical line.
ϕs1  = LinRange(0.0001, 0.49999, 100); 
fϕ1  = [△ϕsurface(ϕ, b, -1) for ϕ ∈ ϕs1, b in bs];  

# ϕ pt 2
ϕs2  = LinRange(0.50001, 1.0, 100); 
fϕ2  = [△ϕsurface(ϕ, b, -1) for ϕ ∈ ϕs2, b in bs];  

fϕisoline1 = [ϕisoline(b) for b ∈ bs];
fϕisoline2 = 1 .- fϕisoline1 

fig = Figure(resolution = (2000, 1700));
ax = Axis3(fig[1, 1],
           height = 1700,
           width = 1600,
           xlabel = L"ϕ_i",
           xlabelsize = 75,
           xlabeloffset = 110,
           xticklabelsize = 50,
           ylabel = L"b",
           ylabelsize = 75,
           ylabeloffset = 110,
           yticklabelsize = 50,
           zlabel = L"ϕ_{i+1} - ϕ_i",
           zlabelsize = 75,
           zlabeloffset = 110,
           zticklabelsize = 50,
           azimuth = 1.65π, 
           elevation = π/7);

    surface!(ax, ϕs1, bs, fϕ1);
    surface!(ax, ϕs2, bs, fϕ2);
    lines!(ax, fϕisoline1, bs,
           color = :black, linewidth = 5);
    lines!(ax, fϕisoline2, bs,
           color = :black, linewidth = 5);

save("plots/eqs17_fig.svg", fig)
save("plots/eqs17_fig.png", fig)
           
#
# Figure of eq. S18
#

fϕ1  = [△ϕsurface(ϕ, b, 1) for ϕ in ϕs1, b in bs];  
fϕ2  = [△ϕsurface(ϕ, b, 1) for ϕ in ϕs2, b in bs];  

fig = Figure(resolution = (2000, 1700));
ax = Axis3(fig[1, 1],
           height = 1700,
           width = 1600,
           xlabel = L"ϕ_i",
           xlabelsize = 75,
           xlabeloffset = 110,
           xticklabelsize = 50,
           ylabel = L"b",
           ylabelsize = 75,
           ylabeloffset = 110,
           yticklabelsize = 50,
           zlabel = L"ϕ_{i+1} - ϕ_i",
           zlabelsize = 75,
           zlabeloffset = 110,
           zticklabelsize = 50,
           azimuth = 1.65π, 
           elevation = π/7);

    surface!(ax, ϕs1, bs, fϕ1);
    surface!(ax, ϕs2, bs, fϕ2);
    lines!(ax, fϕisoline1, bs,
           color = :black, linewidth = 5);
    lines!(ax, fϕisoline2, bs,
           color = :black, linewidth = 5);

save("plots/eqs18_fig.svg", fig)
save("plots/eqs18_fig.png", fig)