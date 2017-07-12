#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --mem=40G
#SBATCH --time=40:00:00
#SBATCH --output=run_CNVRepeat.sh.stdout
#SBATCH -p intel
#SBATCH --workdir=./


module load samtools
export PYTHONPATH=/rhome/cjinfeng/BigData/00.RD/CNVRepeat/env/lib/python2.7/site-packages


start=`date +%s`

CPU=$SLURM_NTASKS
if [ ! $CPU ]; then
   CPU=2
fi

N=$SLURM_ARRAY_TASK_ID
if [ ! $N ]; then
    N=1
fi

echo "CPU: $CPU"
echo "N: $N"

/rhome/cjinfeng/BigData/00.RD/CNVRepeat/env/bin/CNVRepeat --config config.json
#./env/bin/CNVRepeat --config example_Chr3_1X.config.json


end=`date +%s`
runtime=$((end-start))

echo "Start: $start"
echo "End: $end"
echo "Run time: $runtime"

echo "Done"
