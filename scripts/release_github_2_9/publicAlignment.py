#!/usr/bin/env python
# coding: utf-8

# In[48]:


import sys
import os
import pandas as pd
from Bio import SeqIO
from Bio import AlignIO
import publicParseAlignment as pA
from optparse import OptionParser


# In[ ]:


parser = OptionParser(add_help_option=False)


# In[ ]:


numOpts = len(sys.argv)


# In[ ]:


parser.add_option('--script_dir', type=str, help=('the directory where all our scripts are stored'))
parser.add_option('--ref_fa', type=str, help=('fasta file containing reference sequence. All other sequences will be aligned to it. Should contain only one sequence'))
parser.add_option('--strain_fa', type=str, help=('fasta file containing sequences of individual strains. Can contain multiple sequences. They will be aligned to ref_fa in a pair-wise manner separately'))
parser.add_option('--tempt_dir', type=str, help=('tempt_dir to store intermediate files'))
parser.add_option('--SNV_dir', type=str, help=('the directory to store generated bed files'))
parser.add_option('--aligner', type=str, help=('aligner to use. currently support "stretcher" for global alignment and "water" for local alignment'))
parser.add_option('--email', type=str, help=('required by the embo aligners. you will not receive junk from them'))


# In[ ]:


parser.add_option('-h', '--help', action='store_true', help='Show this help message and exit.')


# In[ ]:


(options, args) = parser.parse_args()


# In[14]:


def align_all(ref_fa, strain_fa, tempt_dir, bed_dir, script_dir, aligner, email):
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
        align_command = "python "+script_dir+"/"+"emboss_"+aligner+".py "+" --outfile "+faname+" "+" --format markx3 "+" --email "+email+ " "+ref_fa+" "+faname
        print(align_command)
        #" -asequence "+ref_fa+" -bsequence "+faname+" -outfile "+faname+".aligned.txt -aformat markx3"
        os.system(align_command)
        format_command = 'grep -v "#" '+faname+'.aln.txt > '+faname+'.aligned.fa'
        # print(format_command)
        os.system(format_command)
        alignment = pA.align_to_bed_cat(faname+".aligned.fa", bedname, script_dir)


# In[ ]:


def print_usage():
    print("""Batch pairwise sequence alignment using "stretcher" or "water". 
outputs "pairwise" format files that can be directly displayed on the wash u viral browser as SNV tracks.

[Required (for job submission)]
        --script_dir			the directory where all our scripts are stored
        --ref_fa				fasta file containing reference sequence. All other sequences will be aligned to it. Should contain only one sequence
        --strain_fa				fasta file containing sequences of individual strains. Can contain multiple sequences. They will be aligned to ref_fa in a pair-wise manner separately
        --tempt_dir				tempt_dir to store intermediate files
        --SNV_dir				the directory to store generated pairwise files
        --aligner				aligner to use. currently support "stretcher" for global alignment and "water" for local alignment
        --email 				required by the embo aligners. you will not receive junk from them
contact: changxu.fan@gmail.com for help""")


# In[ ]:


if numOpts < 2:
    print_usage()
    sys.exit()
elif options.help:
    print_usage()
    sys.exit()


# In[47]:


# align_all(ref_fa="sars_bat.fasta", strain_fa = "sars_BJ01.fasta", 
#           tempt_dir="test_fa", bed_dir="test_bed", cat_dir="test_cat" ,
#           aligner="stretcher", 
#           email = "changxu.fan@gmail.com")


# In[ ]:


align_all(ref_fa=options.ref_fa, strain_fa=options.strain_fa, tempt_dir=options.tempt_dir, 
          bed_dir = options.SNV_dir, script_dir=options.script_dir, aligner=options.aligner, email=options.email )

