import matplotlib.pyplot as plt 
import numpy as np 
import sys 

nbnd = 25
nkpt = 682
col = int(sys.argv[1])

data = np.loadtxt('pbesol.projbands')
kaxis = data[:,1]
eigen = data[:,4]
weight = data[:,col]

#plt.scatter(kaxis,eigen,c=weight, s=weight*10,cmap='inferno') 

print(data.shape)
data = data.reshape(nkpt, nbnd, -1)
print(data.shape)

for inbnd in range(nbnd):
    print(data[:, inbnd])
    plt.plot(data[:, inbnd, 1], data[:, inbnd, 2], c='black')
    plt.scatter(data[:, inbnd, 1], 
                data[:, inbnd, 2], 
                c=data[:,inbnd, col],
                s=10*data[:,inbnd, col],
                vmin=0, vmax=0.5)


plt.show()
