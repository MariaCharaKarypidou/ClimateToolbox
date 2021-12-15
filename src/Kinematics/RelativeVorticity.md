# Relative Vorticity

In a way, wind is in a continuous dance mode around the globe. Nonetheless, it is also performing a local dance, spinning around itself, like the greek dance zeibekiko. In dynamic meteorology, this movement of the wind is described by a quantity termed as "relative vorticity". Briefly, relative vorticity is a measure of the spin that wind has! 

## First Thoughts
 

<img src="./ECMWF_RelVort_250hPa.png">

<img src="./ECMWF_RelVort_850hPa.png">
  
## Theory

Theory is taken from the book <a href="https://www.amazon.com/Introduction-Dynamic-Meteorology-International-Geophysics/dp/0123848660"> "An Introduction to Dynamic Meteorology" </a> by James R. Holton and Gregory J. Hakim.\

According to them, "Vorticity, the microscopic measure of rotation in a fluid, is a vector field defined as the curl of velocity. The absolute vorticity <img src="https://render.githubusercontent.com/render/math?math=\large \omega_\alpha"> is the curl of the absolute velocity, whereas the relative vorticity <img src="https://render.githubusercontent.com/render/math?math=\large \omega"> is the curl of the relative velocity:

<img src="https://render.githubusercontent.com/render/math?math=\LARGE \omega_\alpha \equiv \nabla\times \U_\alpha">

which in Cartesian coordinates is analyzed to the following:

<img src="https://render.githubusercontent.com/render/math?math=\LARGE \omega = (\frac{\partial w}{\partial y} - \frac{\partial v}{\partial z}, \frac{\partial u}{\partial z} - \frac{\partial w}{\partial x}, \frac{\partial v}{\partial x} - \frac{\partial u}{\partial y})">

After performing scale analysis on the above equation, it appears that the horizontal components are negligible, and therefore only the vertical component is used, leading to the following equation for relative vorticity:

<img src="https://render.githubusercontent.com/render/math?math=\LARGE \zeta = \frac{\partial v}{\partial x} - \frac{\partial u}{\partial y}"> 



## Code
This tutorial is based on the <a href="https://unidata.github.io/MetPy/latest/index.html#"> MetPy </a> Python library and exploits the <a href="https://unidata.github.io/MetPy/latest/api/generated/metpy.calc.vorticity.html?highlight=vorticity#metpy.calc.vorticity"> vorticity </a> function. \
Before using the <a href="https://unidata.github.io/MetPy/latest/api/generated/metpy.calc.vorticity.html?highlight=vorticity#metpy.calc.vorticity"> vorticity </a> function, let's take a look at the code. <a href="https://github.com/Unidata/MetPy"> MetPy's repository </a> is openly accesible in Github, making our lives easier. If we move to the source code of the <a href="https://github.com/Unidata/MetPy/blob/main/src/metpy/calc/kinematics.py"> Kinematics </a> directory and look within lines 26-67, we will have a closer look of what happens within the function. 


```
def vorticity(u, v, *, dx=None, dy=None, x_dim=-1, y_dim=-2):
    r"""Calculate the vertical vorticity of the horizontal wind.

```
As we see, the <a href="https://unidata.github.io/MetPy/latest/api/generated/metpy.calc.vorticity.html?highlight=vorticity#metpy.calc.vorticity"> vorticity </a> function requires the U and V wind components as input. In addition, some information about the dx and dy is required, referring to the grid spacing on the Y and the x-axis.

```
dudy = first_derivative(u, delta=dy, axis=y_dim)
dvdx = first_derivative(v, delta=dx, axis=x_dim)
return dvdx - dudy
```

The key information is provided in lines 65-57. As we see, finite differences are calculated using the <a href="https://github.com/Unidata/MetPy/blob/9b01cbef28927a8fc70984807166b6f151f6990d/src/metpy/calc/tools.py#L952"> first_derivative </a> function. The <a href="https://github.com/Unidata/MetPy/blob/9b01cbef28927a8fc70984807166b6f151f6990d/src/metpy/calc/tools.py#L952"> first_derivative </a> function uses forward and backward differencing at the edges of the domain and central differences at every other part of the domain. We are reminded that in first order finite differencing, the following formulas are applied:

1. The one-sided (forward) difference: <img src="https://render.githubusercontent.com/render/math?math=\LARGE \frac{f(a \dotplus h)-f(a)}{h}">. 

2. The one-sided (backward) difference: <img src="https://render.githubusercontent.com/render/math?math=\LARGE \frac{f(a)-f(a-h)}{h}">. 

3. The central difference: <img src="https://render.githubusercontent.com/render/math?math=\LARGE \frac{f(a \dotplus h)-f(a-h)}{2h}">. 

The partial derivatives are then subtracted using the formula: <img src="https://render.githubusercontent.com/render/math?math=\LARGE \frac{\partial v}{\partial x} - \frac{\partial u}{\partial y}">. 


## Hands-on

```
# Not all packages and functions are necessary for this excercise, however, if you have those installed in your environment already, then you are ready to do pretty much everything in python (import data, analyze, plot etc.)
#
from matplotlib import pyplot
from matplotlib.cm import get_cmap
from __future__ import print_function
from netCDF4 import Dataset,num2date,date2num
from matplotlib.colors import from_levels_and_colors
from cartopy import crs
from cartopy.feature import NaturalEarthFeature, COLORS
from metpy.units import units
from datetime import datetime
from metpy.plots import StationPlot
#
import metpy.calc as mpcalc
import xarray as xr
import cartopy.crs as ccrs
import matplotlib
import numpy as np
import matplotlib.pyplot as plt
import cartopy.feature as cfeature
#
root_dir = '/users/pr007/mkaryp/vorticity/'
nc = Dataset(root_dir+'ERA5_daymean_monmean_merge_850.nc')
#
lon=nc.variables['longitude'][:]
lat=nc.variables['latitude'][:]
#
dx, dy = mpcalc.lat_lon_grid_deltas(lon, lat)
#
u = []
v = []
vort = []
#
for i in range(240):
    v.append(np.array(nc.variables['v'][i,:,:]))                    
    u.append(np.array(nc.variables['u'][i,:,:]))
    v[i] = units.Quantity(v[i], 'm/s')
    u[i] = units.Quantity(u[i], 'm/s')
    vort.append(np.array(mpcalc.vorticity(u[i], v[i], dx=dx, dy=dy)))
    #
    print(i)
#
np.shape(vort)
#
#
```
    
<footer>
<p style="float:left; width: 100%;">
Copyright © Maria Chara Karypidou, 2021
</p>
</footer>


