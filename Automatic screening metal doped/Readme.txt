Here is the exampe of automatic code for screening varying metal dope including the calculation of bulk metal species.

The code devided into two part with X and 0X index.
X-codes are:
    0-build vasp crystal unit cell by using ASE with "reference_states" database.
    1-python for template converting vasp to Quantum ESPRESSO input file (vc-relax).
    2-shell script looping for creating and submittng (running) jobs.
    Note: screening with respect to TM and TMpp file (check them first).

0X-code are:
    00-shell script for template varying metal dope to host structure.
    01-shell script for looping and submittng jobs.

The checking and pulling energy output (final relaxation step)
pull-E.sh, this code will check if it is final relaxation (relaxed) and show its total energy.

