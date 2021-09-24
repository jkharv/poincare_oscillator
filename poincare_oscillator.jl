using DynamicalSystems
using DataFrames
using CairoMakie

# Dynamic rule
function stim_map(x, p , n)
    x, y = x[1], x[2]
    k, τ, b = p[1], p[2], p[3]

    r = sqrt((x + b)^2 + y^2)

    x_new = ((x + b) * cos(2*π*τ) - y*sin(2*π*τ)) / ((1 - r)*exp(-k*τ) + r)
    y_new = (y*cos(2*π*τ) + (x + b)*sin(2*π*τ)) / ((1 - r)*exp(-k*τ) + r)

    # Convert back to polar coords to look at stuff.
    ϕ = atan2(y_new, x_new)

    return SVector(x_new, y_new, ϕ)
end

# atan2() but between 0 and 2π then normalized 0 to 1
function atan2(y, x)

    θ = atan(y, x)
    if(θ < 0)
        θ = θ + (2*π)    
    end
    θ = θ / (2*π)
    return(θ)
end

# Returns -1 for not periodic
function detect_period(ds::Dataset)::Integer

    _, _, ϕ = columns(ds)

    ϕ_zero = ϕ[1]
    period = -1

    for i in 2:1:length(ϕ)
        if ϕ[i] == ϕ_zero
            period = i - 1
            break
        end
    end

    return(period)
end

points = DataFrame(τ = Float64[], b = Float64[])
for τ in 0.49:0.001:1.0
    for b in 1.0:0.001:2.0

        state0 = [1.0, 0.0, 0.0] # x, y, ϕ
        parameters = [1000, τ, b] # k, τ, b
        stim_system = DiscreteDynamicalSystem(stim_map, state0, parameters)
        
        # Discard 500 from the begining as a transient. 
        t = trajectory(stim_system, 3021)[500:end] 
        push!(points, [τ, b])
    end
end

state0 = [1.0, 0.0, 0] # x, y, ϕ
parameters = [500, 0.5, 1.5] # k, τ, b
stim_system = DiscreteDynamicalSystem(stim_map, state0, parameters)

# Discard 500 from the begining as a transient. 
t = trajectory(stim_system, 10000)[500:end]

a, b, c = columns(t)

x = c
y = circshift(c, 1)

scatter(y[2:end-1], x[2:end-1])
detect_period(t)