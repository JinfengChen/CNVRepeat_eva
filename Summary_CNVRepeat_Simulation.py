#!/opt/Python/2.7.3/bin/python
import sys
from collections import defaultdict
import numpy as np
import re
import os
import argparse
import glob
from Bio import SeqIO
sys.path.append('/rhome/cjinfeng/BigData/software/ProgramPython/lib')
from utility import gff_parser, createdir

def usage():
    test="name"
    message='''
python Summary_CNVRepeat_Simulation.py --input ./
python Summary_CNVRepeat_Simulation.py --input ./ | sort -k1,1n -k2,2n > example_Chr34.summary.txt

    '''
    print message


def runjob(script, lines):
    cmd = 'perl /rhome/cjinfeng/BigData/software/bin/qsub-slurm.pl --maxjob 60 --lines 2 --interval 120 --task 1 --mem 15G --time 100:00:00 --convert no %s' %(lines, script)
    #print cmd 
    os.system(cmd)



def fasta_id(fastafile):
    fastaid = defaultdict(str)
    for record in SeqIO.parse(fastafile,"fasta"):
        fastaid[record.id] = 1
    return fastaid

#Repeat  Repeat_Coverage Single_Copy_Exon_Genome_Coverage        Repeat_Copy_Number
#mPing   152.89  9.01    16.96
def parse_csv(infile):
    data = defaultdict(lambda : float())
    with open (infile, 'r') as filehd:
        for line in filehd:
            line = line.rstrip()
            if len(line) > 2: 
                unit = re.split(r'\t',line)
                if not unit[0] == "Repeat":
                    data[unit[0]] = float(unit[3])
    summary = []
    for repeat in sorted(data.keys()):
        summary.append('{}\t{}'.format(repeat, data[repeat]))
    return '\t'.join(summary)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-i', '--input')
    parser.add_argument('-o', '--output')
    parser.add_argument('-v', dest='verbose', action='store_true')
    args = parser.parse_args()
    try:
        len(args.input) > 0
    except:
        usage()
        sys.exit(2)

    s = re.compile(r'example_Chr(\d+)_(\d+)X')
    dir_simulation = glob.glob('{}/example_Chr*_*X'.format(args.input))
    for d in dir_simulation:
        m = s.search(d)
        chrn = ''
        depth= ''
        if m:
            chrn  = m.groups(0)[0]
            depth = m.groups(0)[1]
        csv = 'example_Chr{}_{}X/CNVRepeat_output/results/EstimateRepeatCopyNumberStep/MSU7.Chr{}.repeat_cnv.csv'.format(chrn, depth, chrn)
        csv_sum = parse_csv(csv)
        print '{}\t{}\t{}\t{}'.format(chrn, depth, os.path.split(d)[1], csv_sum) 

if __name__ == '__main__':
    main()

