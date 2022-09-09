elem_1 = [PolyElement(color = :red)]
elem_2 = [PolyElement(color = :orange)]
elem_3 = [PolyElement(color = :yellow)]
elem_4 = [PolyElement(color = :blue)]
elem_5 = [PolyElement(color = :green)]

symbols = [elem_1, elem_2, elem_3, elem_4, elem_5]

labels =  ["b=0.25", "b=0.5", "b=1", "b=1.25", "b=1.5"]
# Plot of map with b = 1/2
b_plot = Figure(fontsize = 16)
ax = Axis(b_plot[1, 1], xlabel = L"ϕ_{i}", ylabel = L"ϕ_{i+1}",
          xlabelsize = 24, ylabelsize = 24)

b = 0.25

left(x)  = acos((b + cos(2.0*π*x))/(sqrt(1 + b^2.0 + 2.0*b*cos(2.0*π*x))))/(2*π)
xs = 0.0:0.001:0.5 
ys = left.(xs)
lines!(ax, xs, ys, linewidth = 2, color = :red)

right(x) = 1 - acos((b + cos(2*π*x))/(sqrt(1 + b^2 + 2*b*cos(2*π*x))))/(2*π)
xs = 0.5:0.001:1.0
ys = right.(xs)
lines!(ax, xs, ys, linewidth = 2, color = :red)

b = 0.5

left(x)  = acos((b + cos(2.0*π*x))/(sqrt(1 + b^2.0 + 2.0*b*cos(2.0*π*x))))/(2*π)
xs = 0.0:0.001:0.5 
ys = left.(xs)
lines!(ax, xs, ys, linewidth = 2, color = :orange)

right(x) = 1 - acos((b + cos(2*π*x))/(sqrt(1 + b^2 + 2*b*cos(2*π*x))))/(2*π)
xs = 0.5:0.001:1.0
ys = right.(xs)
lines!(ax, xs, ys, linewidth = 2, color = :orange)

b = 1.0

left(x)  = acos((b + cos(2.0*π*x))/(sqrt(1 + b^2.0 + 2.0*b*cos(2.0*π*x))))/(2*π)
xs = 0.0:0.001:0.5 
ys = left.(xs)
lines!(ax, xs, ys, linewidth = 2, color = :yellow)

right(x) = 1 - acos((b + cos(2*π*x))/(sqrt(1 + b^2 + 2*b*cos(2*π*x))))/(2*π)
xs = 0.5:0.001:1.0
ys = right.(xs)
lines!(ax, xs, ys, linewidth = 2, color = :yellow)

b = 1.25

left(x)  = acos((b + cos(2.0*π*x))/(sqrt(1 + b^2.0 + 2.0*b*cos(2.0*π*x))))/(2*π)
xs = 0.0:0.001:0.5 
ys = left.(xs)
lines!(ax, xs, ys, linewidth = 2, color = :blue)

right(x) = 1 - acos((b + cos(2*π*x))/(sqrt(1 + b^2 + 2*b*cos(2*π*x))))/(2*π)
xs = 0.5:0.001:1.0
ys = right.(xs)
lines!(ax, xs, ys, linewidth = 2, color = :blue)

b = 1.5

left(x)  = acos((b + cos(2.0*π*x))/(sqrt(1 + b^2.0 + 2.0*b*cos(2.0*π*x))))/(2*π)
xs = 0.0:0.001:0.5 
ys = left.(xs)
lines!(ax, xs, ys, linewidth = 2, color = :green)

right(x) = 1 - acos((b + cos(2*π*x))/(sqrt(1 + b^2 + 2*b*cos(2*π*x))))/(2*π)
xs = 0.5:0.001:1.0
ys = right.(xs)
lines!(ax, xs, ys, linewidth = 2, color = :green)

xs = 0.0:0.001:1.0
ys = 0.0:0.001:1.0
lines!(ax, xs, ys, linewidth = 2, color = :black, linestyle = :dash)

Legend(b_plot[1, 2], symbols, labels, patchsize = (35, 35), rowgap = 10)

save("plots/b_plot.png", b_plot)

