gmx grompp -c conf.gro -f prod.mdp -p topol.top -o prod.tpr
gmx mdrun -deffnm prod -bonded gpu -nb gpu -update gpu
