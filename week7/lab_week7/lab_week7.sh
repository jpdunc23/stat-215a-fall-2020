#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=3
#SBATCH --nodes=1

R CMD BATCH --no-save lab_week8a.R lab_week8a.out
