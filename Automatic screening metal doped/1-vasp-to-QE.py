from ase.io import read

#### loop #####
system = read('./vasp/vaspname', format = 'vasp')


pseudopotentials={'Cl': 'Cl.pbe-n-kjpaw_psl.1.0.0.UPF',
'Sn' : 'Sn.pbe-dn-kjpaw_psl.1.0.0.UPF',
'N' : 'N.pbe-n-kjpaw_psl.1.0.0.UPF',
'O' : 'O.pbe-n-kjpaw_psl.1.0.0.UPF',
'O1' : 'O.pbe-n-kjpaw_psl.1.0.0.UPF',
'M' : 'Tpp'}

input_data = {
    'calculation'   : 'vc-relax',
    'verbosity'       : 'low',
    'restart_mode'    : 'from_scratch',
    'etot_conv_thr'   :  0.0001,
    'forc_conv_thr'   :  0.001,
    'nstep'           :  200,
    'tprnfor'         : True,
    'tstress'         : False,
    'outdir'          : './relax-M',
    'prefix'          : 'M',
    'pseudo_dir'      : '../../PPs',
    'nstep'          : 200,
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
    'mixing_beta' :   0.15,
    'startingpot'      : "atomic",
    'startingwfc'      : "atomic+random",
    'cell_dofree'      : 'ibrav'
}

system.write('QEname.in',format='espresso-in',input_data = input_data, pseudopotentials=pseudopotentials,kpts=(17, 17, 17))

