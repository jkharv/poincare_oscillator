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

# Do the simulations for one frame of a periodicity chart.
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

# Do the simulations needed for one frame of a lyapunov chart
function make_frame_lyapunov(τ_start, τ_end, b_start, b_end, k, stepsize)
    
    ll = ReentrantLock()
    points = DataFrame(τ = Float64[], b = Float64[], λ = Float64[])
    for τ in τ_start:stepsize:τ_end
        Threads.@threads for b in b_start:stepsize:b_end

            state0 = [1.0, 0.1, 0.0] # x, y, ϕ
            parameters = [k, τ, b] # k, τ, b
            stim_system = DiscreteDynamicalSystem(stim_map, state0, parameters)

            λ = lyapunov(stim_system, 1000, Ttr = 500)

           lock(ll)
           try
                push!(points, [τ, b, λ])
           finally
                unlock(ll)
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

# Legend stuff I will need for all the other plots
elem_1 = [PolyElement(color = :orange)]
elem_2 = [PolyElement(color = :yellow)]
elem_3 = [PolyElement(color = :aquamarine)]
elem_4 = [PolyElement(color = :skyblue)]
elem_5 = [PolyElement(color = :fuchsia)]
elem_6 = [PolyElement(color = :red)]
elem_7 = [PolyElement(color = :goldenrod1)]
elem_8 = [PolyElement(color = :lightseagreen)]
elem_a = [PolyElement(color = :lightcyan3)]
symbols = [elem_1, elem_2, elem_3, elem_4, elem_5, 
           elem_6, elem_7, elem_8, elem_a]
labels =  ["Period-1", "Period-2", "Period-3", "Period-4", "Period-5",
           "Period-6", "Period-7", "Period-8", "Aperiodic"]

# Big plot
points = make_frame(0.0, 1.0, 0.0, 2.0, 50, 0.001)
transform!(points, :p => ByRow(categorize_period) => :colour)

big_plot = Figure()
ax = Axis(big_plot[1, 1], xlabel = "τ", ylabel = "b")
scatter!(ax, points[:,1], points[:,2], color = points[:,4], markersize = 0.75)
Legend(big_plot[1, 2], symbols, labels, patchsize = (35, 35), rowgap = 10)
save("plots/big_plot.png", big_plot)

# Big plot k 10
points = make_frame(0.01, 1.01, 0.0, 2.0, 10, 0.001)
transform!(points, :p => ByRow(categorize_period) => :colour)

big_plot = Figure()
ax = Axis(big_plot[1, 1], xlabel = "τ", ylabel = "b")
scatter!(ax, points[:,1], points[:,2], color = points[:,4], markersize = 0.75)
Legend(big_plot[1, 2], symbols, labels, patchsize = (35, 35), rowgap = 10)
save("plots/big_plot_k10.png", big_plot)

# Big plot k 1
points = make_frame(0.01, 1.01, 0.0, 2.0, 1, 0.001)
transform!(points, :p => ByRow(categorize_period) => :colour)

big_plot = Figure()
ax = Axis(big_plot[1, 1], xlabel = "τ", ylabel = "b")
scatter!(ax, points[:,1], points[:,2], color = points[:,4], markersize = 0.75)
Legend(big_plot[1, 2], symbols, labels, patchsize = (35, 35), rowgap = 10)
save("plots/big_plot_k1.png", big_plot)

# Big plot w/ line
big_plot_w_line = Figure()
ax = Axis(big_plot_w_line[1, 1], xlabel = "τ", ylabel = "b")
scatter!(ax, points[:,1], points[:,2], color = points[:,4], markersize = 0.75)
Legend(big_plot_w_line[1, 2], symbols, labels, patchsize = (35, 35), rowgap = 10)
# Left lower.
xs = 0:0.001:0.25 
ys = sin.(2*π*xs)
lines!(ax, xs, ys, linewidth = 2, color = :black)
# Right lower.
xs = 0.75:0.001:1 
ys = -sin.(2*π*xs)
lines!(ax, xs, ys, linewidth = 2, color = :black)
# Upper
upper(x) = sqrt(4 - 3*sin(2*π*x)^2)
xs = 0.25:0.001:0.75 
ys = upper.(xs)
lines!(ax, xs, ys, linewidth = 2, color = :black)

save("plots/big_plot_w_line.png", big_plot_w_line)

# Zoomed into upper left branch, interesting stuff here. 
points = make_frame(0.25, 0.45, 0.9, 1.25, 500, 0.0001)
transform!(points, :p => ByRow(categorize_period) => :colour)

zoom_plot = Figure()
ax = Axis(zoom_plot[1, 1], xlabel = "τ", ylabel = "b")
scatter!(ax, points[:,1], points[:,2], color = points[:,4], markersize = 0.75)
Legend(zoom_plot[1, 2], symbols, labels, patchsize = (35, 35), rowgap = 10)
save("plots/zoom_plot.png", zoom_plot)

# Zoomed into the region at (tau=0.25, b=1)
points = make_frame(0.24, 0.28, 0.99, 1.02, 500, 0.00001)
transform!(points, :p => ByRow(categorize_period) => :colour)

zoom_zoom_plot = Figure()
ax = Axis(zoom_zoom_plot[1, 1], xlabel = "τ", ylabel = "b")
scatter!(ax, points[:,1], points[:,2], color = points[:,4], markersize = 0.75)
Legend(zoom_zoom_plot[1, 2], symbols, labels, patchsize = (35, 35), rowgap = 10)
save("plots/zoom_zoom_plot.png", zoom_zoom_plot)

# Animated figure of chaning k value.
points = make_frame(0.0, 1.0, 0.0, 2.0, 50, 0.002)
transform!(points, :p => ByRow(categorize_period) => :colour)
   
τ = Observable(points[:,1])
b = Observable(points[:,2])
c = Observable(points[:,4])
klabel = Observable("K = 5")

scene = Figure()
ax = Axis(scene[1, 1], xlabel = "τ", ylabel = "b")
scatter!(ax, τ, b, color = c, markersize = 1.5)
Legend(scene[1, 2], symbols, labels, patchsize = (35, 35), rowgap = 10)
text!(klabel, position = (0.05, 1.75))
record(scene, "plots/vary_k.gif") do io
    
    for k = 50:-0.25:0

        points = make_frame(0.0, 1.0, 0.0, 2.0, k, 0.002)
        transform!(points, :p => ByRow(categorize_period) => :colour)
        
        τ[] = points[:,1]
        b[] = points[:,2]
        c[] = points[:,4]
        klabel[] = "K = " * string(k)

        recordframe!(io) # record a new frame
    end
end

# Animated figure of changing k value zoom in at the end.
points = make_frame(0.0, 1.0, 0.0, 2.0, 5, 0.002)
transform!(points, :p => ByRow(categorize_period) => :colour)
   
τ = Observable(points[:,1])
b = Observable(points[:,2])
c = Observable(points[:,4])
klabel = Observable("K = 5")

scene = Figure()
ax = Axis(scene[1, 1], xlabel = "τ", ylabel = "b")
scatter!(ax, τ, b, color = c, markersize = 1.5)
Legend(scene[1, 2], symbols, labels, patchsize = (35, 35), rowgap = 10)
text!(klabel, position = (0.05, 1.75))
record(scene, "plots/vary_small_k.gif") do io

    for k = 5:-0.005:0

        points = make_frame(0.0, 1.0, 0.0, 2.0, k, 0.002)
        transform!(points, :p => ByRow(categorize_period) => :colour)
        
        τ[] = points[:,1]
        b[] = points[:,2]
        c[] = points[:,4]
        klabel[] = "K = " * string(k)

        recordframe!(io) # record a new frame
    end
end

# Big lyapunov plot 
points = make_frame_lyapunov(0.0, 1.0, 0.0, 2.0, 50, 0.01)

big_plot_lyapunov = Figure()
ax = Axis(big_plot_lyapunov[1, 1], xlabel = "τ", ylabel = "b")
scatter!(ax, points[:,1], points[:,2], color = points[:,3], markersize = 10)
#Legend(big_plot[1, 2], symbols, labels, patchsize = (35, 35), rowgap = 10)
#save("plots/big_plot_lyapunov.png", big_plot_lyapunov)
big_plot_lyapunov