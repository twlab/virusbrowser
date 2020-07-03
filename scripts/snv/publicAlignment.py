#!/usr/bin/env python
# coding: utf-8

# In[2]:


import sys
import os
import pandas as pd
from Bio import SeqIO
from Bio import AlignIO
import publicParseAlignment as pA
import argparse
import pair2markx3


# In[3]:


parser = argparse.ArgumentParser()


# In[5]:


#parser.add_argument('--script_dir', type=str, required = True, help=('the directory where all our scripts are stored'))


# In[7]:


#args = parser.parse_args(["--script_dir", "miao"])


# In[ ]:


#args.script_dir


# In[ ]:


parser.add_argument('--script_dir', type=str, required = True, help=('the directory where all our scripts are stored'))
parser.add_argument('--ref_fa', type=str, required = True,help=('fasta file containing reference sequence. All other sequences will be aligned to it. Should contain only one sequence'))
parser.add_argument('--strain_fa', type=str, required = True,help=('fasta file containing sequences of individual strains. Can contain multiple sequences. They will be aligned to ref_fa in a pair-wise manner separately'))
parser.add_argument('--tempt_dir', type=str, required = True,help=('tempt_dir to store intermediate files'))
parser.add_argument('--SNV_dir', type=str, required = True,help=('the directory to store generated SNV files'))
parser.add_argument('--aligner', type=str, required = True,help=('aligner to use. currently support "stretcher" for global alignment and "water" for local alignment'))
parser.add_argument('--email', type=str, default="local" ,help=('required by the embo aligners. if not specified, the program will call "stretcher from linux environment"'))


# In[ ]:


args = parser.parse_args()


# In[ ]:


def align_all(ref_fa, strain_fa, tempt_dir, bed_dir, script_dir, aligner, email):
    add = ""
    pseudo = False
    strain = SeqIO.parse(strain_fa, "fasta")
    for record in strain:
        faname = tempt_dir+"/"+record.id
        bedname = bed_dir+"/"+record.id+".bed"
        #catname = cat_dir+"/"+record.id+".cat"
        #print(bedname)
        #print(catname)
        os.system("mkdir -p "+tempt_dir)
        os.system("mkdir -p "+bed_dir)
        #os.system("mkdir -p "+cat_dir)
        with open(faname, "w") as fa:
            SeqIO.write(record, fa, "fasta")
        if email == "local":
            if aligner == "water":
                add = " -gapopen 10.0 -gapextend 0.5 -aformat pair"
            if aligner == "stretcher":
                add = " -aformat markx3"
                pseudo = True
            align_command = aligner+" -asequence "+ref_fa+" -bsequence "+faname+" -outfile "+faname+".aln.txt "+add
        else: 
            if aligner == "water":
                add = " --format pair"
            if aligner == "stretcher":
                add = " --format markx3"
                pseudo = True
            align_command = "python "+script_dir+"/"+"emboss_"+aligner+".py "+" --outfile "+faname+ add +" --email "+email+ " "+ref_fa+" "+faname
        print(align_command)
        #" -asequence "+ref_fa+" -bsequence "+faname+" -outfile "+faname+".aligned.txt -aformat markx3"
        os.system(align_command)
        # format_command = 'grep -v "#" '+faname+'.aln.txt > '+faname+'.aligned.fa'
        # print(format_command)
        # os.system(format_command)
        pair2markx3.pair2markx3(ref_fa = ref_fa, pair_file = faname+'.aln.txt', out_file = faname+'.aligned.fa', pseudo=pseudo)
        alignment = pA.align_to_bed_cat(faname+".aligned.fa", bedname, script_dir)


# In[ ]:


align_all(ref_fa=args.ref_fa, strain_fa=args.strain_fa, tempt_dir=args.tempt_dir, 
          bed_dir = args.SNV_dir, script_dir=args.script_dir, aligner=args.aligner, email=args.email )

