using DynamicalSystems
using DataFrames

# Dynamic rule
function stim_map(x, p , n)
    r, ϕ = x[1], x[2]
    k, τ, b = p[1], p[2], p[3]

    r_per = sqrt(r^2 + b^2 + 2*b*r*cos(2*π*ϕ))
    ϕ_per = acos((r*cos(2*π*ϕ) + b) / r_per) / 2*π

    r_new = r_per / ((1 - r_per) * exp(-k * τ) + r_per)
    ϕ_new = mod(ϕ_per + τ, 1) 
    
    Δ = ϕ_per + τ - ϕ_new

    return SVector(r_new, ϕ_new, Δ)
end

# See Langfield et al 2017. eq (4)
function rotation_number(ds::Dataset)::AbstractFloat

    _, _, c = columns(ds)

    μ = c[1]
    μ_max = μ
    N = length(c)

    for i in 2:N
        
        μ = (c[i] + i * μ)/(i + 1) # Running average

        if μ > μ_max
            μ_max = μ   #lim sup
        end
    end
    return(μ_max)
end

points = DataFrame(τ = AbstractFloat[], b = AbstractFloat[], ρ = AbstractFloat[])
for τ in 0.50:0.001:1.0
    for b in 2.0:0.001:2.0

        state0 = [1.0, 0.0, 0.0] # r, ϕ, Δ
        parameters = [1000, τ, b] # k, τ, b
        stim_system = DiscreteDynamicalSystem(stim_map, state0, parameters)
        
        # Discard 500 from the begining as a transient. 
        t = trajectory(stim_system, 2500)[500:end] 
        ρ = rotation_number(t)
        push!(points, [τ, b, ρ])
    end
end