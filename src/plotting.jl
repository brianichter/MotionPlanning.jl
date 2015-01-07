rectangle_corners(lo, hi) = ([lo[1],hi[1],hi[1],lo[1],lo[1]], [lo[2],lo[2],hi[2],hi[2],lo[2]])

function plot_rectangle(r; kwargs...)
    plt.fill(rectangle_corners(r[:,1], r[:,2])...,
             edgecolor="black", zorder=0; kwargs...)
end

function plot_circle(c, r; xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf, kwargs...)
    plt.fill(clamp(c[1] + r*cos(linspace(0, 2pi, 40)), xmin, xmax),
             clamp(c[2] + r*sin(linspace(0, 2pi, 40)), ymin, ymax),
             edgecolor="black", zorder=0; kwargs...)
end

function plot_ellipse(c, a, b, t; xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf, kwargs...)
    XY = [a*cos(linspace(0, 2pi, 40)) b*sin(linspace(0, 2pi, 40))]*[cos(t) sin(t); -sin(t) cos(t)]
    plt.fill(clamp(c[1] + XY[:,1], xmin, xmax),
             clamp(c[2] + XY[:,2], ymin, ymax),
             edgecolor="black", zorder=0; kwargs...)
end

function plot_ellipse(c, Sigma; xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf, kwargs...)
    XY = [cos(linspace(0, 2pi, 40)) sin(linspace(0, 2pi, 40))]*chol(Sigma)
    plt.fill(clamp(c[1] + XY[:,1], xmin, xmax),
             clamp(c[2] + XY[:,2], ymin, ymax),
             edgecolor="black", zorder=0; kwargs...)
end

function plot_bounds(lo = zeros(2), hi = ones(2))
    plt.plot(rectangle_corners(lo, hi)..., color="black", linewidth=1.0, linestyle="-")
    axis("equal")
end

function plot_graph(V::Matrix, F; kwargs...)  # learn how to just pass kwargs
    scatter(V[1,:], V[2,:], zorder=1; kwargs...)
    X = vcat([V[1,idx_list] for idx_list in findn(triu(F))]..., fill(nothing, 1, sum(triu(F))))[:]
    Y = vcat([V[2,idx_list] for idx_list in findn(triu(F))]..., fill(nothing, 1, sum(triu(F))))[:]
    plt.plot(X, Y, linewidth=.5, linestyle="-", zorder=1; kwargs...)
end
plot_graph{T}(V::Vector{Vector{T}}, F; kwargs...) = plot_graph(hcat(V...), F; kwargs...)

function plot_tree(V::Matrix, A; kwargs...)
    scatter(V[1,:], V[2,:], zorder=1; kwargs...)
    X = vcat(V[1,find(A)], V[1,A[find(A)]], fill(nothing, 1, countnz(A)))[:]
    Y = vcat(V[2,find(A)], V[2,A[find(A)]], fill(nothing, 1, countnz(A)))[:]
    plt.plot(X, Y, linewidth=.5, linestyle="-", zorder=1; kwargs...)
end
plot_tree{T}(V::Vector{Vector{T}}, A; kwargs...) = plot_tree(hcat(V...), A; kwargs...)

function plot_path(V::Matrix, idx_list = 1:size(V,2); kwargs...)
    plt.plot(V[1,idx_list]', V[2,idx_list]', linewidth=1.0, linestyle="-", zorder=2; kwargs...)
end
plot_path{T}(V::Vector{Vector{T}}, idx_list = 1:length(V); kwargs...) = plot_path(hcat(V...), idx_list; kwargs...)

function plot_problem_setup(P::ProblemSetup)
    plot_bounds(P.SS.lo, P.SS.hi)
    plot_obstacles(P.obs)
    plot_goal(P.goal)
end