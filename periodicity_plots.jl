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