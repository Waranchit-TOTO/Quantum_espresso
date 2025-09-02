#!/bin/bash
# Usage: ./make-scf.sh relax.out U1 U > scf.in

relax="${1:-relax.out}"

DIR="${2:-U1}"

U="${3:-U}"

# --- Extract cell lengths a, b, c ---
read a b c < <(
awk '
/^CELL_PARAMETERS/ {
  s=1
  if (match($0,/\(alat *= *([-+0-9.eEdD]+)\)/,m)) { gsub(/[dD]/,"E",m[1]); s=m[1]*0.5291772109 }
  else if ($0 ~ /\(bohr\)/) s=0.5291772109
  else if ($0 ~ /\(angstrom\)/) s=1
  for(i=1;i<=3;i++){getline; for(j=1;j<=3;j++) v[i,j]=$j}
}
END {
  for(i=1;i<=3;i++){
    x=v[i,1]*s; y=v[i,2]*s; z=v[i,3]*s;
    a[i]=sqrt(x*x+y*y+z*z);
  }
  printf("%.9f %.9f %.9f",a[1],a[2],a[3])
}' "$relax"
)

# --- Extract final atomic positions ---
positions=$(tac "$relax" | awk '
  start { print } 
  /^ATOMIC_POSITIONS[[:space:]]*\(/ { print; exit } 
  /^End[[:space:]]+final[[:space:]]+coordinates/ { start = 1 }
' | tac | awk '!seen[$0]++')

# --- Print SCF input file ---
cat <<EOF
&CONTROL
  calculation = 'scf'
  etot_conv_thr =   1.00d-04
  forc_conv_thr =   1.00d-03
  outdir = './${DIR}/tmp'
  prefix = 'pbe'
  pseudo_dir = '../../../PPs'
  tprnfor = .true.
  verbosity = 'high'
/
&SYSTEM
  a    =  $a
  b    =  $b
  c    =  $c
  ibrav = 8
  nat = 6
  ecutrho =   600
  ecutwfc =   60
  nosym = .false.
  nspin = 2
  ntyp = 2
  nbnd = 40
  occupations = 'tetrahedra'  
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

$positions
EOF

