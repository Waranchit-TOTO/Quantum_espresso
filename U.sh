#!/bin/bash

#!/bin/bash -l
#SBATCH -p compute
#SBATCH -N 2
#SBATCH --ntasks-per-node=128
#SBATCH -t 23:00:00
#SBATCH -J O2p
#SBATCH -A pv825005

module purge
module load intel/2023.1.0
module load libfabric/1.15.2.0

export OMP_NUM_THREADS=1
ulimit -s unlimited
cd $SLURM_SUBMIT_DIR

export PATH=/project/pv825005-mofmlp/src/qe_7.3_environ/bin/:$PATH

# Loop over U values from 1 to 8
for U in {1..8}; do
    DIR="U${U}"

    bash make-scf.sh "${DIR}/relax.out" ${DIR} ${U} > ${DIR}/scf.in
    bash make-band.sh "${DIR}/relax.out" ${DIR} ${U} > ${DIR}/band.in

done

for U in {1..8}; do
    DIR="U${U}"

    echo "Running SCF for U=${U}..."
    srun pw.x -nk 4 -in "${DIR}/scf.in" > "${DIR}/scf.out"

    # Prepare DOS input
    cat > "${DIR}/dos.in" <<EOF
&DOS
  prefix = 'pbe'
  outdir = './${DIR}/tmp/'
  fildos = '${DIR}/dos${U}.dat'
  DeltaE = 0.05
/
EOF

    echo "Running DOS for U=${U}..."
    dos.x < "${DIR}/dos.in" > "${DIR}/dos.out"

    #Prepare PDOS input
    cat > "${DIR}/pdos.in" <<EOF
&PROJWFC
  prefix= 'pbe',
  outdir= './${DIR}/tmp/'
  filpdos= '${DIR}/pdos${U}.dat'
 DeltaE=0.05
/
EOF

    projwfc.x -in "${DIR}/pdos.in" > "${DIR}/pdos.out"
    
    cp bash.sh ${DIR}/
    cd ./${DIR}/
    bash bash.sh
    cd ../
    
    srun pw.x -nk 4 -in "${DIR}/band.in" > "${DIR}/band.out"

    #Prepare pp.Band input
    cat > "${DIR}/pp.band.in" <<EOF
&BANDS
  prefix = 'pbe'
  outdir = './${DIR}/tmp/'
  filband = '${DIR}/pbe_bands${U}.dat'
/
EOF
    bands.x -in "${DIR}/pp.band.in" > "${DIR}/pp.band.out"


done

echo "All U loops completed."

