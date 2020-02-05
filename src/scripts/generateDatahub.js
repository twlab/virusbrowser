const URLBASE = "https://wangftp.wustl.edu/~dpuru/viralGateway/";
import CATEGORIES from '../json/categories.json';

export const generateDatahub = function(files, virusName, referencefasta) {

  let tmp = {};

  tmp.fastaUrl = `${URLBASE}/${virusName}/reference/${referencefasta}`;
  let tracks = files.forEach(file => {
    console.log(file)
      console.log(`{
        "type": "categorical",
        "name": "${file.accession}",
        "url": "${URLBASE}/${virusName}/SNV/${file.accession}",
        "options": ${CATEGORIES}"
      }`)
  })

  // console.log(tracks)

  return tracks;

}


/**
 * tmp.push(`
      {
        "type": "categorical",
        "name": "${file.Accession}",
        "url": "${URLBASE}/${virusName}/SNV/${file.Accession}.cat.gz",
        "options": {
            "category": {
              "1": { "name": "A", "color": "#89C738" },
              "2": { "name": "T", "color": "#9238C7" },
              "3": { "name": "C", "color": "#E05144" },
              "4": { "name": "G", "color": "#3899C7" },
              "5": { "name": "N", "color": "#858585" },
              "6": { "name": "Deletion", "color": "#462185" }
            }
          }
        }
      `)
 */


/**
 *  sars: {
        fullName: "SARS",
        fastaUrl: "https://wangftp.wustl.edu/~dpuru/viralGateway/ncov/reference/NC_045512.2.fa",
        tracks: [
            new TrackModel({type: "ruler", name: "Ruler"}),
            new TrackModel({
                "type": "categorical",
                "name": "sars_reference",
                "url": "https://wangftp.wustl.edu/~cfan/viralBrowser/genome_cat/sars_ref.cat.sort.gz",
                "options": {
                    "category": {
                        "1": {"name": "A", "color": "#89C738"},
                        "2": {"name": "T", "color": "#9238C7"},
                        "3": {"name": "C", "color": "#E05144"},
                        "4": {"name": "G", "color": "#3899C7"},
                        "5": {"name": "N", "color": "#858585"}
                    }
                }
            })
        ]
    }
 */