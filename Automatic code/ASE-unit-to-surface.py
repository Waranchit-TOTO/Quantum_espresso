from ase.io import read, write
from ase.build import surface

# Read bulk rutile SnO2
bulk = read("SnO2-rutile.vasp")

# Build (110) surface slab
# layers = number of atomic layers along surface normal
slab = surface(bulk, (1, 1, 0), layers=6, vacuum=7.5)

# Optional: center slab in cell (recommended)
slab.center(axis=2)

slab_2x4 = slab.repeat((2, 4, 1))

# Write slab structure
write("raw_SnO2_110_slab.vasp", slab_2x4, vasp5=True)
print('110 done')
#############################################################

# Build (100) surface slab
# layers = number of atomic layers along surface normal
slab = surface(bulk, (1, 0, 0), layers=3, vacuum=7.5)

# Optional: center slab in cell (recommended)
slab.center(axis=2)

slab_3x4 = slab.repeat((3, 4, 1))

# Write slab structure
write("raw_SnO2_100_slab.vasp", slab_3x4, vasp5=True)
print('100 done')
#############################################################

# Build (101) surface slab
# layers = number of atomic layers along surface normal
slab = surface(bulk, (1, 0, 1), layers=6, vacuum=7.5)

# Optional: center slab in cell (recommended)
slab.center(axis=2)

slab_2x3 = slab.repeat((2, 3, 1))

# Write slab structure
write("raw_SnO2_101_slab.vasp", slab_2x3, vasp5=True)
print('101 done')
