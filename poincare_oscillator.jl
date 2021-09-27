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
    ϵ = 0.0001

    for i in 2:1:length(ϕ)
        if abs(ϕ[i] - ϕ_zero) < ϵ
            period = i - 1
            break
        end
    end

    return(period)
end

function make_frame(τ_start, τ_end, b_start, b_end, k, stepsize)
    
    l = ReentrantLock()
    points = DataFrame(τ = Float64[], b = Float64[], p = Float64[])
    for τ in τ_start:stepsize:τ_end
        Threads.@threads for b in b_start:stepsize:b_end

            state0 = [1.0, 0.0, 0.0] # x, y, ϕ
            parameters = [k, τ, b] # k, τ, b
            stim_system = DiscreteDynamicalSystem(stim_map, state0, parameters)
        
           # Discard 500 from the begining as a transient. 
           t = trajectory(stim_system, 800)[500:end]
           period = detect_period(t)
           lock(l)
           try
                push!(points, [τ, b, period])
           finally
                unlock(l)
           end
        end
    end
    return points
end

function categorize_period(p::AbstractFloat)

    if p == 1.0
        return(:orange)
    end
    if p == 2.0
        return(:yellow)
    end
    if p == 3.0
        return(:aquamarine)
    end
    if p == 4.0
        return(:skyblue)
    end
    if p == 5.0
        return(:fuchsia)
    end
    if p == 6.0
        return(:red)
    end
    if p == 7.0
        return(:goldenrod1)
    end
    if p == 8.0
        return(:lightseagreen)
    end
    if p == -1.0
        return(:lightcyan3)
    end
    if p > 8
        return(:lightcyan3)
    end
end

# Big plot
points = make_frame(0.0, 1.0, 0.0, 2.0, 50, 0.001)
transform!(points, :p => ByRow(categorize_period) => :colour)

big_plot = scatter(points[:,1], points[:,2], color = points[:,4], markersize = 0.75)
save("plots/big_plot.png", big_plot)

# Zoomed into upper left branch, interesting stuff here. 
points = make_frame(0.25, 0.45, 0.9, 1.25, 500, 0.0001)
transform!(points, :p => ByRow(categorize_period) => :colour)

zoom_plot = scatter(points[:,1], points[:,2], color = points[:,4], markersize = 0.75)
save("plots/zoom_plot.png", zoom_plot)

# Zoomed into the region at (tau=0.25, b=1)
points = make_frame(0.24, 0.28, 0.99, 1.02, 500, 0.00001)
transform!(points, :p => ByRow(categorize_period) => :colour)

zoom_zoom_plot = scatter(points[:,1], points[:,2], color = points[:,4], markersize = 0.75)
save("plots/zoom_zoom_plot.png", zoom_zoom_plot)

# Animated figure of chaning k value.
points = make_frame(0.0, 1.0, 0.0, 2.0, 50, 0.002)
transform!(points, :p => ByRow(categorize_period) => :colour)
   
τ = Observable(points[:,1])
b = Observable(points[:,2])
c = Observable(points[:,4])

scene = scatter(τ, b, color = c, markersize = 1.5)
record(scene, "plots/vary_k.gif") do io
    
    for k = 50:-0.25:0

        points = make_frame(0.0, 1.0, 0.0, 2.0, k, 0.002)
        transform!(points, :p => ByRow(categorize_period) => :colour)
        
        τ[] = points[:,1]
        b[] = points[:,2]
        c[] = points[:,4]

        recordframe!(io) # record a new frame
    end
end


# Animated figure of changing k value zoom in at the end.
points = make_frame(0.0, 1.0, 0.0, 2.0, 50, 0.002)
transform!(points, :p => ByRow(categorize_period) => :colour)
   
τ = Observable(points[:,1])
b = Observable(points[:,2])
c = Observable(points[:,4])

scene = scatter(τ, b, color = c, markersize = 1.5)
record(scene, "plots/vary_small_k.gif") do io
    
    for k = 5:-0.005:0

        points = make_frame(0.0, 1.0, 0.0, 2.0, k, 0.002)
        transform!(points, :p => ByRow(categorize_period) => :colour)
        
        τ[] = points[:,1]
        b[] = points[:,2]
        c[] = points[:,4]

        recordframe!(io) # record a new frame
    end
end