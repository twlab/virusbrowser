#!/usr/bin/env python
# coding: utf-8

# In[2]:


import sys
import os
from Bio import AlignIO
import pandas as pd


# In[ ]:


def parse_mark3x (alignment): 
    t = []
    for i in alignment:
        t.append(i.upper())
    alignment = t
    j = 0
    i = 0
    mismatch = [""]
    insertion = [""]
    deletion = [""]
    for i in range(0, len(alignment[0])):
        if alignment[0][i] == "-" and alignment[1][i] == "-":
            continue 
        if alignment[0][i] != "-":
            if alignment[1][i] == "-":
                deletion[j]=deletion[j]+alignment[0][i]
            else:
                if alignment[0][i] != alignment[1][i]:
                    mismatch[j] = alignment[1][i]
            j = j+1
            mismatch.append("")
            insertion.append("")
            deletion.append("")
        else: 
            insertion[j] = insertion[j]+alignment[1][i]

    alignDF = pd.DataFrame({
        "mismatch": [x.upper() for x in mismatch],
        "insertion": [x.upper() for x in insertion],
        "deletion": [x.upper() for x in deletion]
    })
    return alignDF


# In[ ]:


def align_to_bed_cat(alignment_file, out_bed, script_dir):
    alignment = AlignIO.read(alignment_file, "fasta")
    ref = alignment[0].id
    parse = parse_mark3x(alignment)
    parse.to_csv(alignment_file+".tsv",sep = "\t", header=True, index=False)
    bedcmd = script_dir+"/convert_tsv_to_bed_and_cat.sh "+alignment_file+".tsv "+out_bed+" placeHolder "+ref
    os.system(bedcmd)


# In[ ]:


# def align_to_bed_cat(alignment_file, out_bed, script_dir):
#     format_command = 'grep -v "#" '+alignment_file+' > '+alignment_file+'.f'
#     os.system(format_command)
#     alignment = AlignIO.read(alignment_file+".f", "fasta")
#     ref = alignment[0].id
#     parse = parse_mark3x(alignment)
#     parse.to_csv(alignment_file+".tsv",sep = "\t", header=True, index=False)
#     bedcmd = script_dir+"/convert_tsv_to_bed_and_cat.sh "+alignment_file+".tsv "+out_bed+" placeHolder "+ref
#     os.system(bedcmd)


# In[ ]:


#align_to_bed_cat(sys.argv[1], sys.argv[2], sys.argv[3])

