# You get rounding errors that trip up acos when the arg
# is 1 + ϵ, This function catches those and rounds back down
# to 1
function ϵ_fix(x)

    if abs(x) > 1.0
        return 1.0
    else
        return x
    end
end

function nodiff(ϕ, b)

    modArg1 = (1/2π) * acos(
                            ϵ_fix(
                                  real((b + cos(2π*ϕ))/
                                      (sqrt(1 + b^2 + 2b * cos(ϕ*2π)))
                                      )
                                 )
                           )

    modArg2 = (1/2π) * acos(
                            ϵ_fix(
                                   -sqrt(Complex(
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

bs  = LinRange(1.0, 2.0, 2000);
# We're doing ϕ in two chunks (and putting small gap at ϕ=0.5) 
# because there's a discontinuity
# that we don't really want rendered as a vertical line.
ϕs1  = LinRange(0.0, 0.49999, 1000); 
fϕ1  = [nodiff(ϕ, b) for ϕ in ϕs1, b in bs];  

ϕs2  = LinRange(0.50001, 1.0, 1000); 
fϕ2  = [nodiff(ϕ, b) for ϕ in ϕs2, b in bs];  

fig = Figure(resolution = (1000, 1000));
ax = Axis3(fig[1, 1],
           height = 700,
           width = 700,
           xlabel = L"ϕ_i",
           ylabel = L"b",
           zlabel = "diff");


surface!(ax, ϕs1, bs, fϕ1);
surface!(ax, ϕs2, bs, fϕ2);

save("plots/test.png", fig)
