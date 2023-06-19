# This file includes the code used for simulating the system. The function make_frame
# is what is used in the periodicity_plots files to generate the datapoints to plot the 
# periodicity plots.

"""
    stim_map(x, p , n)

This is the definition of the discrete map that we will be simulating using
DynamicalSystems. It's a cartesian coordinate version of the system studied by Glass and
Sun. The polar coordinate version suffered from numerical issues. The polar system suffers
greatly from round-off errors when ``r_i ≈ 1, b ≈ 1,`` and ``ϕ_i ≈ 0.5`` The format of
this function is dictated by DynamicalSystems systems and is not super useful on it's own.

# Arguments

- `x::Vector{Float64}`: The state of the map.
- `p::Vector{Float64}`: Parameters for the map.
- `n::Integer`: The iteration number. 

"""
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

"""
    atan2(y, x)

For our numerical work, we needed a tan function that is aware of what quadrant the point
is in. It also rescales the angles to be between 0 and 1, just for consistency with how
Glass & Sun dealt with it in their paper. 
"""
function atan2(y, x)

    θ = atan(y, x)
    if(θ < 0)
        θ = θ + (2*π)    
    end
    θ = θ / (2*π)
    return(θ)
end

"""
    detect_period(ds::Dataset)::Integer

This loops through a trajectory and checks for equality between the first point and any
other point in the trajectory with an ϵ of 0.0001. 

If a matching point is foind at position i, we assume this shows an i - 1 periodicity. If
we find no reapet point, we assume the trajectory is aperiodic. (In reality probably
extremely long period but each of those long period regions should occupy such a small
area of the phase space we wouldn't be able to resolve it in our figures anyway.)

# Arguments

- `ds::Dataset`: The trajectory output by DynamicalSystems.jl
"""
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

"""
    make_frame(τ_start, τ_end, b_start, b_end, k, stepsize)

Given a range of parameter values this function returns a list of points in the τ - b
phase space and the resultant period of the trajectory at that point. This list is used by
our plotting code to produce periodicity maps of the poincarre oscillator system.


# Arguments

-`τ_start ::Float64`: Starting value for τ
-`τ_end::Float65`: Ending value for τ
-`b_start::Float64`: Starting value for b
-`b_end::Float65`: Ending value for b
-`k::Float65`: Value for k 
-`stepsize`: Stepsize to use between starting and ending values of the parameters
"""
function make_frame(τ_start, τ_end, b_start, b_end, k, stepsize)
    
    # Prevent race condition on data frame access.
    l = ReentrantLock()
    points = DataFrame(τ = Float64[], b = Float64[], p = Int[])

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

"""
    categorize_period(p::Int)

This converts between a periodicity number and the colour we use to represent this on the
figures. Any period greater than 8 get lumped into the (apparently) "aperiodic" group.
This is just because there are only so many colours and you could barely even make out
these regions on the plots.

This only actually gets used in the periodicity_plots.jl file.

# Arguments

- `p::Int`: Periodicity
"""
function categorize_period(p::Int)

    if p == 1
        return(:orange)
    end
    if p == 2
        return(:yellow)
    end
    if p == 3
        return(:aquamarine)
    end
    if p == 4
        return(:skyblue)
    end
    if p == 5
        return(:fuchsia)
    end
    if p == 6
        return(:red)
    end
    if p == 7
        return(:goldenrod1)
    end
    if p == 8
        return(:lightseagreen)
    end
    if p == -1
        return(:lightcyan3)
    end
    if p > 8
        return(:lightcyan3)
    end
end