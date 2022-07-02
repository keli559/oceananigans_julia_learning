# plot results
#
# load dataset
using Oceananigans
using OffsetArrays
#using CairoMakie
using GLMakie
using PlotlyJS
dataset = FieldDataset("/media/kenneth/DATA/Documents/cambridge_work/julia_code/langmuir/langmuir_turbulence_fields.jld2")
w = dataset.fields["w"];
b = dataset.fields["b"];
u = dataset.fields["u"];
times = w.times
timestep = 25
w_slice = w[:, :, :,timestep]
b_slice = b[:, :, :,timestep]
#u_slice = u[:, :, :,timestep]
xx, yy, zz = nodes(u)
x3d, y3d, z3d = mgrid(xx, yy, zz)

trace1 = PlotlyJS.volume(
   x=x3d[:], y=y3d[:], z=z3d[:],
    value=w_slice[:],
    isomin=-1.2e-2,
    isomax=-0.4e-2,
    opacity=0.3,
    surface_count=5,
    colorscale="Blues",
    colorbar=attr(;x=0.8, thickness=0.02, thicknessmode="fraction",
    len=0.6, lenmode="fraction",
    outlinewidth=0, title=attr(;text="Downwelling (m⋅s⁻¹)", side="right"))
 )
trace2 = PlotlyJS.volume(
   x=x3d[:], y=y3d[:], z=z3d[:],
    value=w_slice[:],
    isomax=1.2e-2,
    isomin=0.4e-2,
    opacity=0.3,
    colorscale="Reds",
    surface_count=5,
    colorbar=attr(;x=1.01, thickness=0.02, thicknessmode="fraction",
    len=0.6, lenmode="fraction",
    outlinewidth=0, title=attr(;text="Upwelling (m⋅s⁻¹)", side="right"))
 )
trace = PlotlyJS.volume(x=x3d[:], y=y3d[:], z=z3d[:], value = b_slice[:],
isomin= -6.5e-4, isomax = -6.45e-4, opacity=0.2, surface_count=1,
colorscale="Greys",
showscale=false,
    colorbar=attr(;x=1.0, thickness=0.02, thicknessmode="fraction",
    len=0.9, lenmode="fraction",
    outlinewidth=0)
)
#PlotlyJS.plot(plt, trace1)
layout = Layout(
scene= attr(
                    xaxis_title="x (m)",
                    yaxis_title="y (m)",
                    zaxis_title="z (m)",
                    ),
autosize=false, width=500, height=270,
                    margin=attr(l=0, r=20, b=0, t=30),
                    title=string("Langmuir turbulence at t=",
                    prettytime(times[timestep]))
                    )

p1 = PlotlyJS.plot([trace1, trace2, trace],
                    layout
                    )

# trace3 = PlotlyJS.volume(x=x3d[:], y=y3d[:], z=z3d[:],
#      value=u_slice[:],
#      isomin=0.0015,
#      isomax=0.005,
#      opacityscale=[[0, 1], [0.5, 0.2], [1, 0]],
#      opacity = 0.5,
#      surface_count=20,
#      colorscale="Blues",
#      reversescale=true
#   )
#layout = PlotlyJS.Layout(;autosize = true, xaxis = attr(title="x (m)", range=[0, 30]))
#PlotlyJS.plot(trace3, layout)
savefig(p1, "./lang_w_b_20220630v4.html")
savefig(p1, "./lang_w_b_20220630v4.png")
