# Plot of map with b = 1/2
b_half_plot = Figure(fontsize = 16)
ax = Axis(b_half_plot[1, 1], xlabel = L"ϕ_{i}", ylabel = L"ϕ_{i+1}",
          xlabelsize = 24, ylabelsize = 24)

b = 0.5

left(x)  = acos((b + cos(2.0*π*x))/(sqrt(1 + b^2.0 + 2.0*b*cos(2.0*π*x))))/(2*π)
xs = 0.0:0.001:0.5 
ys = left.(xs)
lines!(ax, xs, ys, linewidth = 2, color = :black)

right(x) = 1 - acos((b + cos(2*π*x))/(sqrt(1 + b^2 + 2*b*cos(2*π*x))))/(2*π)
xs = 0.5:0.001:1.0
ys = right.(xs)
lines!(ax, xs, ys, linewidth = 2, color = :black)

xs = 0.0:0.001:1.0
ys = 0.0:0.001:1.0
lines!(ax, xs, ys, linewidth = 2, color = :black, linestyle = :dash)

save("plots/b_half_plot.png", b_half_plot)


# Plot of map with b = 1
b_one_plot = Figure(fontsize = 16)
ax = Axis(b_one_plot[1, 1], xlabel = L"ϕ_{i}", ylabel = L"ϕ_{i+1}",
          xlabelsize = 24, ylabelsize = 24)

b = 1.0

left(x)  = acos((b + cos(2.0*π*x))/(sqrt(1 + b^2.0 + 2.0*b*cos(2.0*π*x))))/(2*π)
xs = 0.0:0.001:0.5 
ys = left.(xs)
lines!(ax, xs, ys, linewidth = 2, color = :black)

right(x) = 1 - acos((b + cos(2*π*x))/(sqrt(1 + b^2 + 2*b*cos(2*π*x))))/(2*π)
xs = 0.5:0.001:1.0
ys = right.(xs)
lines!(ax, xs, ys, linewidth = 2, color = :black)

xs = 0.0:0.001:1.0
ys = 0.0:0.001:1.0
lines!(ax, xs, ys, linewidth = 2, color = :black, linestyle = :dash)
b_one_plot
save("plots/b_one_plot.png", b_one_plot)