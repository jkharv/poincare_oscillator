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
                                  real(
                                       -sqrt(Complex(
                                                    (b^2 - 1)/
                                                     3
                                                    )
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
        arg = modArg1 - modArg2 + 2
    end 
      
    return ϕ - mod(real(arg), 1)  
end

bs  = LinRange(0.0, 2.0, 1000);
# We're doing ϕ in two chunks because there's a discontinuity
# that we don't really want rendered as a vertical line.
ϕs1  = LinRange(0.0, 0.50, 1000); 
fϕ1  = [nodiff(ϕ, b) for ϕ in ϕs1, b in bs];  

ϕs2  = LinRange(0.500001, 1.0, 1000); 
fϕ2  = [nodiff(ϕ, b) for ϕ in ϕs2, b in bs];  

fig = surface(ϕs1, bs, fϕ1);
surface!(fig.axis, ϕs2, bs, fϕ2);

xlabel!(fig.axis.scene, L"ϕ_1")
ylabel!(fig.axis.scene, L"b")
zlabel!(fig.axis.scene, L"ϕ_1 - ϕ_{i+1}")

