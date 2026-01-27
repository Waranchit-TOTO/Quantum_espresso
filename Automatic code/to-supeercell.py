from ase.io import read, write
import sys

name = sys.argv[1]

# Edit the file type byy manual in '.xyz'#

model = read(name + '.xyz')

model_repeat = model.repeat((1,3,1))

write('expanded' + name + '.xyz', model_repeat)
print('done')
