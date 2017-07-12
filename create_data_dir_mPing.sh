#chr=Chr3
#depth=3X
chr=$1
depth=$2
repeat=$3
folder=example_$repeat\_$chr\_$depth
mkdir $folder
cd $folder
ln -s /rhome/cjinfeng/BigData/00.RD/RelocaTE_i/ReadMapping/MSU7.$chr\.$repeat/MSU7.$chr\.$repeat\.rep1_reads/MSU7.$chr\.$repeat\.rep1_reads_$repeat\_$depth\_100_500.bam* ./
ln -s /rhome/cjinfeng/BigData/00.RD/RelocaTE_i/Simulation/MSU7.$chr\.$repeat/MSU7.$chr\.$repeat\.rep1_reads/MSU7.$chr\.$repeat\.rep1_reads_$repeat\_$depth\_100_500_*.fq.gz ./
ln -s /rhome/cjinfeng/BigData/00.RD/RelocaTE_i/Simulation/Reference/MSU7.$chr\.fa ./
grep "$chr" /rhome/cjinfeng/BigData/00.RD/CNVRepeat/example/MSU7.exon.gtf > MSU7.$chr\.exon.gtf
grep "$chr" /rhome/cjinfeng/BigData/00.RD/CNVRepeat/example/MSU7.exon.single_exon.bed > MSU7.$chr\.exon.single_exon.bed
cd ..

json="
{\n 
\t\"ref_fasta\":\"/rhome/cjinfeng/BigData/00.RD/CNVRepeat_eva/example_$repeat\_$chr\_$depth/MSU7.$chr\.fa\",\n
\t\"gtf\":\"\",\n
\t\"bam\":\"/rhome/cjinfeng/BigData/00.RD/CNVRepeat_eva/example_$repeat\_$chr\_$depth\/MSU7.$chr\.$repeat\.rep1_reads_$repeat\_$depth\_100_500.bam\",\n
\t\"fastq1\":\"/rhome/cjinfeng/BigData/00.RD/CNVRepeat_eva/example_$repeat\_$chr\_$depth\/MSU7.$chr\.$repeat\.rep1_reads_$repeat\_$depth\_100_500_1.fq.gz\",\n
\t\"fastq2\":\"/rhome/cjinfeng/BigData/00.RD/CNVRepeat_eva/example_$repeat\_$chr\_$depth\/MSU7.$chr\.$repeat\.rep1_reads_$repeat\_$depth\_100_500_2.fq.gz\",\n
\t\"bed\":\"/rhome/cjinfeng/BigData/00.RD/CNVRepeat_eva/example_$repeat\_$chr\_$depth\/MSU7.$chr\.exon.single_exon.bed\",\n
\t\"repeat\":\"/rhome/cjinfeng/BigData/00.RD/CNVRepeat_eva/example/mping.fa\",\n
\t\"output\":\"/rhome/cjinfeng/BigData/00.RD/CNVRepeat_eva/example_$repeat\_$chr\_$depth\/CNVRepeat_output\",\n
\t\"binaries\": {\n
\t\t\"bowtie2\": \"/opt/linux/centos/7.x/x86_64/pkgs/bowtie2/2.2.9/bin/bowtie2\",\n
\t\t\"bwa\": \"/opt/linux/centos/7.x/x86_64/pkgs/bwa/0.7.12/bin/bwa\",\n
\t\t\"samtools\": \"/opt/linux/centos/7.x/x86_64/pkgs/samtools/1.4.1/bin/samtools\",\n
\t\t\"bedtools\": \"/opt/linux/centos/7.x/x86_64/pkgs/bedtools/2.25.0/bin/bedtools\",\n
\t\t\"blastall\": \"/opt/linux/centos/7.x/x86_64/pkgs/ncbi-blast/2.2.26/bin/blastall\",\n
\t\t\"formatdb\": \"/opt/linux/centos/7.x/x86_64/pkgs/ncbi-blast/2.2.26/bin/formatdb\"\n
\t},\n
\t\"cluster_settings\": {\n
\t\t\"cluster_type\": \"multiprocessing\",\n
\t\t\"processes\": 24\n
\t}\n
}\n
"
echo -e $json | sed 's/\\//g' > $folder\.config.json
cat $folder\.config.json

shell="
#!/bin/bash\n
#SBATCH --nodes=1\n
#SBATCH --ntasks=24\n
#SBATCH --mem=40G\n
#SBATCH --time=40:00:00\n
#SBATCH --output=$folder\_CNVRepeat.sh.stdout\n
#SBATCH -p intel\n
#SBATCH --workdir=./\n
\n
start=\`date +%s\`\n
\n
module load samtools\n
export PYTHONPATH=/rhome/cjinfeng/BigData/00.RD/CNVRepeat/env/lib/python2.7/site-packages\n
\n
/rhome/cjinfeng/BigData/00.RD/CNVRepeat/env/bin/CNVRepeat --config $folder\.config.json\n
\n
end=\`date +%s\`\n
runtime=\$((end-start))\n

echo \"Start: \$start\"\n
echo \"End: \$end\"\n
echo \"Run time: \$runtime\"\n
\n
echo \"Done\"\n
"

echo -e $shell | sed 's/\\//g' | sed 's/^ //' > $folder\_CNVRepeat.sh
cat $folder\_CNVRepeat.sh

#sbatch $folder\_CNVRepeat.sh
