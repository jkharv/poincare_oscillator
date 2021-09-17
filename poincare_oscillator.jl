using DynamicalSystems

function stim_map(x, p , n)
    r, ϕ = x[1], x[2]
    k, τ = p[1], p[2]

    r_new = r / ((1 - r) * exp(-k * τ) + r)
    ϕ_new = mod(ϕ + τ, 1) 

    return SVector(r_new, ϕ_new)
end

state0 = [1.0, 0.0] # r, ϕ
parameters = [5.0, 1.5] # k, τ
stim_system = DiscreteDynamicalSystem(stim_map, state0, parameters)

trajectory(stim_system, 100)