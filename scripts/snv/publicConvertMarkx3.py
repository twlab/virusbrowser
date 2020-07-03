#!/usr/bin/env python
# coding: utf-8

# In[ ]:


import sys
import os
from Bio import AlignIO
import pandas as pd
import publicParseAlignment as pA


# In[ ]:


def print_usage():
    print("""usage: python publicConvertMarkx3.py <markx3> <out_pairwise> <script_dir>

[Required]
        <markx3>					pairwise alignment output in markx3 format. the first sequence should be the reference
                                            
                                            
        <out_pairwise>			output pairwise formatted file that can be displayed directly on wash u virus browser as SNV track
        
        <script_dir>				the directory where all our scripts are stored
        
contact: changxu.fan@gmail.com for help""")


# In[ ]:


numOpts = len(sys.argv)
if numOpts < 3:
    print_usage()
    sys.exit()


# In[ ]:


alignment_file = sys.argv[1]
format_command = 'grep -v "#" '+alignment_file+' > '+alignment_file+'.f'
os.system(format_command)


# In[ ]:


pA.align_to_bed_cat(alignment_file+'.f', sys.argv[2], sys.argv[3])

