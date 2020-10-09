#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=5
#SBATCH --nodes=1

#SBATCH --mail-user=jpduncan@berkeley.edu
#SBATCH --mail-type=ALL

R CMD BATCH --no-save parallel_scf.R parallel_scf.out
