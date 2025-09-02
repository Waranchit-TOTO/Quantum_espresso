#!/bin/bash

#!/bin/bash -l
#SBATCH -p compute
#SBATCH -N 2
#SBATCH --ntasks-per-node=128
#SBATCH -t 2-00:00:00
#SBATCH -J name
#SBATCH -A name-project

module purge
module load intel/2023.1.0
module load libfabric/1.15.2.0

export OMP_NUM_THREADS=1
ulimit -s unlimited
cd $SLURM_SUBMIT_DIR

export PATH=/project/project-name/src/qe_7.3_environ/bin/:$PATH

# Loop over U values from 1 to 8
for U in {1..8}; do
    DIR="U${U}"
    mkdir -p "$DIR"

    # Generate input file for SCF
    cat > "${DIR}/relax.in" <<EOF
&CONTROL
  calculation = 'vc-relax'
  etot_conv_thr =   1.00d-04
  forc_conv_thr =   1.00d-03
  outdir = './${DIR}/tmp'
  prefix = 'pbe'
  pseudo_dir = '../../../PPs'
  tprnfor = .true.
  verbosity = 'high'
/
&SYSTEM
  a    =  4.8002282801256513
  b    =  4.8002282801256513
  c    =  3.2345998723418408
  ibrav = 8
  nat = 6
  degauss =   1.000000000d-02
  ecutrho =   600
  ecutwfc =   60
  nosym = .false.
  nspin = 2
  ntyp = 2
  nbnd = 40
  occupations = 'smearing'
  smearing = 'gaussian'
  starting_magnetization(1) =   0.3
  starting_magnetization(2) =   0.2
  vdw_corr = 'dft-d3'
/
&ELECTRONS
  conv_thr =   1.00d-06
  electron_maxstep = 300
  mixing_beta =   0.4
/
&IONS
/
&CELL
   cell_dofree      = 'ibrav'
/
ATOMIC_SPECIES
Sn     118.710 Sn.pbesol-dn-kjpaw_psl.1.0.0.UPF
O      15.9994 O.pbesol-n-kjpaw_psl.1.0.0.UPF

HUBBARD ortho-atomic
U O-2p ${U}

K_POINTS automatic
9 9 13 0 0 0

ATOMIC_POSITIONS {angstrom}
Sn  0.0000000000000000  0.0000000000000000  0.0000000000000000
Sn  2.4001115180000001  2.4001115180000001  1.6173022855000001
O   0.9304844857000000  3.8697385502000001  1.6173022855000001
O   3.8697385502000001  0.9304844857000000  1.6173022855000001
O   3.3305960036000002  3.3305960036000002  0.0000000000000000
O   1.4696270323000000  1.4696270323000000  0.0000000000000000
EOF

    echo "Running Relax for U=${U}..."
    srun pw.x -nk 4  < "${DIR}/relax.in" > "${DIR}/relax.out"


done


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

