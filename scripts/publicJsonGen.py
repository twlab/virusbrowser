#!/usr/bin/env python
# coding: utf-8

# In[4]:


import sys
import pandas as pd
import json
from optparse import OptionParser


# In[ ]:


def print_usage():
    print("""usage: python publicJsonGen.py <tsv> <json>

[Required]
        <tsv>				a tsv file with 4 columns: name, url, track_type, virus. one line per track
                                            the file should contain header. 
                                            order of the columns doesn't matter.
                                            virus means virus type, used for metadata.
        <json>				output json file that can be directly uploaded onto wash u virus browser as custom datahub
        
contact: changxu.fan@gmail.com for help""")


# In[5]:


def tsv_to_json(tsvfile, out_json):
    tsv = pd.read_csv(tsvfile, sep="\t")
    js = []
    for i in range(0, len(tsv["url"])):
        track = json_track(tsv["name"][i], tsv["url"][i], tsv["track_type"][i], tsv["virus"][i])
        js.append(track)
    viruses = ["nCoV", "SARS", "MERS", "Ebola"]
#     metadata = {
#         "type":"metadata",
#         "vocabulary": {"Virus Type": viruses},
#         "show": "Virus Type"
#     }
#     js.append(metadata)
    with  open (out_json, 'w+') as fp:
        json.dump(js, fp, indent=4)
    return(js)    


# In[3]:


def json_track(name, url, track_type, virus):
    if track_type == "categorical":
        track = {
            "type": "categorical",
            "name": name,
            "url": url,
            "options": {
                #"hiddenPixels": 0, 
                "category": {
                    "1": {"name": "A", "color": "#89C738"},
                    "2": {"name": "T", "color": "#9238C7"},
                    "3": {"name": "C", "color": "#E05144"},
                    "4": {"name": "G", "color": "#3899C7"},
                    "5": {"name": "N", "color": "#858585"},
                    "6": {"name": "deletion", "color": "#BC8F8F"},
                },
                "color": "#C7C3C3",
            },
            "metadata": {
                    "virus": virus,
                    }
        }
    else:
        track = {
            "type": track_type,
            "name": name,
            "url": url,
            "metadata": {
                    "virus": virus,
                    }
        }
    return track


# In[ ]:


numOpts = len(sys.argv)


# In[ ]:


if numOpts < 3:
    print_usage()
    sys.exit()


# In[ ]:


tsv_to_json(sys.argv[1], sys.argv[2])

