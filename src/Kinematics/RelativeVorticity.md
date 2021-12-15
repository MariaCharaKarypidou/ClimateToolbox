# Relative Vorticity

In a way, wind is in a continuous dance mode around the globe. Nonetheless, it is also performing a local dance, spinning around itself, like the greek dance zeibekiko. In dynamic meteorology, this movement of the wind is described by a quantity termed as "relative vorticity". Briefly, relative vorticity is a measure of the spin that wind has! 

## First Thoughts


<img width="800" alt="portfolio_view" src="/src/Kinematics/img/ECMWF_RelVort_250hPa.png">

<img width="800" alt="portfolio_view" src="/src/Kinematics/img/ECMWF_RelVort_850hPa.png">
  
## Theory

## Code
This tutorial is based on the <a href="https://unidata.github.io/MetPy/latest/index.html#"> MetPy </a> Python library and exploits the <a href="https://unidata.github.io/MetPy/latest/api/generated/metpy.calc.vorticity.html?highlight=vorticity#metpy.calc.vorticity"> vorticity </a> function. \
Before using the <a href="https://unidata.github.io/MetPy/latest/api/generated/metpy.calc.vorticity.html?highlight=vorticity#metpy.calc.vorticity"> vorticity </a> function, let's take a look at the code. <a href="https://github.com/Unidata/MetPy"> MetPy's repository </a> is openly accesible in Github, making our lives easier. If we move to the source code of the <a href="https://github.com/Unidata/MetPy/blob/main/src/metpy/calc/kinematics.py"> Kinematics </a> funtions and look within lines 26-67, we will have a closer look of what happens within the function. 

As we see, the <a href="https://unidata.github.io/MetPy/latest/api/generated/metpy.calc.vorticity.html?highlight=vorticity#metpy.calc.vorticity"> vorticity </a> function requires the U and V wind components as input. In addition, some information about the dx and dy is required, referring to the grid spacing on the x and the y-axis.

```
def vorticity(u, v, *, dx=None, dy=None, x_dim=-1, y_dim=-2):
    r"""Calculate the vertical vorticity of the horizontal wind.

```
The key information is provided in lines 65-57, where we see that: 

![\Large x=\frac{-b\pm\sqrt{b^2-4ac}}{2a}](https://latex.codecogs.com/svg.latex?\Large&space;x=\frac{-b\pm\sqrt{b^2-4ac}}{2a}) 

![\Large \frac{\partial v}{\partial x} = \frac{\partial u}{\partial y}](https://latex.codecogs.com/svg.latex?\Large&space;\frac{\partial v}{\partial x} = \frac{\partial u}{\partial y}) 

```math
a^2+b^2=c^2
\frac{\partial v}{\partial x} = \frac{\partial u}{\partial y}
```


```
dudy = first_derivative(u, delta=dy, axis=y_dim)
dvdx = first_derivative(v, delta=dx, axis=x_dim)
return dvdx - dudy
```

```
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


