#!/bin/bash -l
#SBATCH -p compute
#SBATCH -N 1
#SBATCH --ntasks-per-node=64
#SBATCH -t 23:00:00
#SBATCH -J screen
#SBATCH -A lt200358

module purge
module load intel/2023.1.0
module load libfabric/1.15.2.0

export OMP_NUM_THREADS=1
ulimit -s unlimited
cd $SLURM_SUBMIT_DIR

export PATH=/project/pv825005-mofmlp/src/qe_7.3_environ/bin/:$PATH

in="${1:-input}"

srun pw.x -nk 4 -in $in.in > $in-2.out

