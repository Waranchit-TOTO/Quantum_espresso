from ase.build import bulk
from ase.visualize import view
from ase.io import write
from ase.data import reference_states, atomic_numbers

elements = [
    "Ag","Au","Cd","Co","Cr","Cu","Fe","Hf","Hg","Ir","La","Mn","Mo","Nb","Ni","Os",
    "Pd","Pt","Re","Rh","Ru","Sc","Ta","Tc","Ti","V","W","Y","Zn","Zr"
]

for i in elements:
    Z = atomic_numbers[i]
    ref = reference_states[Z]
    print(i, ref)
    # Check required keys
#    if 'a' in ref and 'symmetry' in ref:
    if ref['symmetry'] != 'cubic':
        atoms = bulk(i, crystalstructure=ref['symmetry'], a=ref['a'], covera=ref.get('c/a', None))
        # Write VASP (POSCAR) with element name in filename
        filename = fr'D:\++++NanoTech-Work\Project-pv825005\sensors\SnO2-sensor\6-TM-energy\vasp\{i}.vasp'
        #write(filename, atoms, direct=False, format='vasp')
        #print(f"Wrote {filename}")
        #print(ref)
        #view(atoms)  # Shows each structure one by one
    else:
        print(f"Skipping {i}: missing 'a' or 'symmetry' in reference state")

Mn = bulk('Mn', crystalstructure='bcc', a=3.47)
write(r'D:\++++NanoTech-Work\Project-pv825005\sensors\SnO2-sensor\6-TM-energy\vasp\Mn.vasp', Mn, direct=False, format='vasp')

print('completed')