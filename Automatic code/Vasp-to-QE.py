from ase.io import read
import sys 

#### loop #####
vaspname = sys.argv[1]
QEinput = sys.argv[2]
system = read(vaspname, format = 'vasp')


pseudopotentials={'Sn' : 'Sn.pbesol-dn-kjpaw_psl.1.0.0.UPF',
                  'O' : 'O.pbesol-n-kjpaw_psl.1.0.0.UPF', 
                  'N' : 'N.pbesol-n-kjpaw_psl.0.1.UPF'}

input_data = {
    'calculation'   : 'relax',
    'verbosity'       : 'low',
    'restart_mode'    : 'from_scratch',
    'etot_conv_thr'   :  0.0001,
    'forc_conv_thr'   :  0.001,
    'nstep'           :  200,
    'tprnfor'         : True,
    'tstress'         : False,
    'outdir'          : './relax-X',
    'prefix'          : 'X',
    'pseudo_dir'      : '../../PPs',
    'degauss' :   0.01,
    'ecutrho' :   600,
    'ecutwfc' :   60,    
    'occupations'               : "smearing",
    'smearing'                  : "gaussian",
    'nosym'  : True,
    'nspin'            : 2,
    'vdw_corr'         : 'dft-d3',
    'conv_thr' :   1e-06,
    'electron_maxstep' : 400,
    'mixing_beta' :   0.4,
    'startingpot'      : "atomic",
    'startingwfc'      : "atomic+random",
    'cell_dofree'      : 'all'
}

system.write(QEinput,format='espresso-in',input_data = input_data, pseudopotentials=pseudopotentials,kpts=(3, 3, 1))
