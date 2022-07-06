using GLMakie
# plot results
#
# load dataset
using Oceananigans
using OffsetArrays
#using CairoMakie
using PlotlyJS

fig = Figure(resolution=(500, 600))
ax = LScene(fig[1, 1], show_axis=false)
#
#
#----------------------------
# 1. Load the dataset
#----------------------------
#
dataset = FieldDataset("/media/kenneth/DATA/Documents/cambridge_work/julia_code/langmuir/langmuir_turbulence_fields.jld2")
w = dataset.fields["w"];
b = dataset.fields["b"];
times = w.times
timestep = 20
w_slice = w[:, :, :,timestep]
b_slice = b[:, :, :,timestep]
x, y, z = nodes(w)
#
#
#----------------------------
# 2. Set the slider bar 
#----------------------------
#
sgrid = SliderGrid(
    fig[2, 1],
    (label = "yz plane - x axis", range = 1:length(x)),
    (label = "xz plane - y axis", range = 1:length(y)),
    (label = "xy plane - z axis", range = 1:length(z)),
)
sl_yz, sl_xz, sl_xy = sgrid.sliders
#
# set the initial condition of a bar
set_close_to!(sl_yz, 0.5length(x)) # 0.5 means the bar is set initially to the middle range.
set_close_to!(sl_xz, 0.5length(y))
set_close_to!(sl_xy, 0.5length(z))
#
#
#----------------------------
# 3. Set the Toggles (Switches) 
#----------------------------
#
lo = sgrid.layout
nc = ncols(lo)
#
# the line below gives the initial value of the switches
#
toggles = [Toggle(lo[i, nc + 1], active = true) for i ∈ 1:3]
#
#----------------------------
# 4. Plot the volume slice plot
#----------------------------
#
#### the function to plot ###########
vol = w_slice
plt = volumeslices!(ax, x, y, z, vol, colormap=:bluesreds)
#####################################
#
#----------------------------
# 5. Link the toggles/sliders to the plot
#           (w/ listener functions)
#----------------------------
#
# Sliders: set listeners 
on(sl_xz.value) do v; plt[:update_xz][](v) end
on(sl_xy.value) do v; plt[:update_xy][](v) end
on(sl_yz.value) do v; plt[:update_yz][](v) end
#
#
# Toggles: set listeners
# # add toggles to show/hide heatmaps
hmaps = [plt[Symbol(:heatmap_, s)][] for s ∈ (:yz, :xz, :xy)]
#
map(zip(hmaps, toggles)) do (h, t)
     connect!(h.visible, t.active)
end
#
# #cam3d!(ax.scene, projectiontype=Makie.Orthographic)
# #
#fig
# #
save("./volume_slice_lang_w_07022022.png", fig)
