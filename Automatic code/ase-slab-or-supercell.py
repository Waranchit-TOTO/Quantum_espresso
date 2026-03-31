from ase.io import read, write
from ase.build import surface
import sys

name = sys.argv[1]
unit = read(name)

Q = input('Need to build surface (yes/no)?: ')

if Q != 'no' :

    lay = input('Number of layers: ')
    vac = input('Vacuum size (Angstrom): ')
    unit = surface(unit, (1,1,0), layers = int(lay), vacuum = float(vac))

print('Making supercell: ')

x = input('X = ')
y = input('Y = ')
z = input('Z = ')

sup = unit.repeat(( int(x), int(y), int(z) ))

write('expanded'+name,  sup, vasp5=True)

print('Done')
