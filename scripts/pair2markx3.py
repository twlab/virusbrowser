#!/usr/bin/env python
# coding: utf-8

# In[94]:


from Bio.SeqRecord import SeqRecord
from Bio.Seq import Seq
from Bio import SeqIO
from Bio import AlignIO
import os
import sys
import subprocess
from subprocess import PIPE


# In[ ]:


import argparse


# In[ ]:


parser = argparse.ArgumentParser()


# In[ ]:


parser.add_argument('--ref_fa', type=str, required = True, help=('fasta file of the reference sequence'))
parser.add_argument('--pair_file', type=str, required = True, help=('alignment results in pair format'))
parser.add_argument('--out_file', type=str, required = True, help=('output markx3 file'))
parser.add_argument('--pseudo', action = "store_true" ,help=('just rename the file to out_file if file is already in markx3'))


# In[117]:


def pair2markx3(ref_fa, pair_file, out_file, pseudo):
    if pseudo == True:
        format_command = 'grep -v "#" '+pair_file+' > '+out_file
        print(format_command)
        os.system(format_command)
        return 
    ref = SeqIO.read(ref_fa, "fasta")
    aligned = AlignIO.read(pair_file, "emboss")
    ref_align = aligned[0]
    strain_align = aligned[1]
    pos1 = subprocess.run('grep -v "#" '+pair_file+' | grep '+ref.id+' |  awk \'BEGIN{OFS = " "; ORS = " "} {print $2, $NF}\'', 
                      stdout=PIPE, shell=True, encoding = "UTF-8")
    left = int(pos1.stdout.split()[0])
    right = int(pos1.stdout.split()[-1])
    ref_seq = []
    strain_seq = []
    for i in range(0, left-1):
        ref_seq.append(ref.seq[i])
        strain_seq.append("-")
    for i in strain_align.seq:
        strain_seq.append(i)
    for i in ref_align.seq:
        ref_seq.append(i)
    for i in range(right, len(ref.seq)):
        ref_seq.append(ref.seq[i])
        strain_seq.append("-")
    ref_cvtd = SeqRecord(Seq("".join(ref_seq)), id=ref_align.id,name="", description = "")
    strain_cvtd = SeqRecord(Seq("".join(strain_seq)), id=strain_align.id,name="", description = "")
    SeqIO.write([ref_cvtd,strain_cvtd], out_file, "fasta")
    return left, right, len(ref.seq)


# In[118]:


#pair2markx3("/bar/cfan/viralBrowser/test/mini_ref.fa", "/bar/cfan/viralBrowser/test/mini_water.fa", "/bar/cfan/viralBrowser/test/test_write.fa")


# In[ ]:


def main():
    args = parser.parse_args()
    pair2markx3(ref_fa = args.ref_fa, pair_file = args.pair_file, out_file = args.out_file, pseudo = args.pseudo)
    


# In[ ]:


if __name__ == "__main__":
    main()

