# plot results
#
# load dataset
using Oceananigans
using OffsetArrays
#using CairoMakie
using GLMakie
using PlotlyJS
dataset = FieldDataset("/media/kenneth/DATA/Documents/cambridge_work/julia_code/langmuir/langmuir_turbulence_fields.jld2")
u = dataset.fields["u"];
times = u.times
#timestep = 25
xx, yy, zz = nodes(u)
Nx = length(xx)
Ny = length(yy)
Nz = length(zz)
x3d, y3d, z3d = mgrid(xx, yy, zz)

n = Observable(1)
u_title = @lift string("u= 17cm/s isosurface at t = ", prettytime(times[$n]))
uₙ = @lift u[1:Nx, 1:Ny, 1:Nz, $n]
#
fig = Figure(resolution = (560, 500))
ax = Axis3(fig[1, 1],aspect=:data, elevation=π/4.0-π/6.0,
azimuth=π/3.0, protrusions=(50, 0, 20, 10), viewmode=:fitzoom,
            xlabel = "x (m)",
            ylabel = "y (m)",
			zlabel = "z (m)", title=u_title)
volume!(xx, yy, zz, uₙ, algorithm = :iso,
	isovalue =0.0017,isorange = 0.0003,
	colormap = cgrad(:Oranges)
)

frames = 1:length(times)
record(fig, "./u_n_20220628.mp4", frames, framerate=8) do i
     msg = string("Plotting frame ", i, " of ", frames[end])
	 print(msg * " \r")
     n[] = i
end
