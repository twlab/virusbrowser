import CATEGORIES from '../json/categories.json';
import {WANGFTP_URL_BASE, PUBLIC_FOLDER, IEDP_URL} from '../config';

export const saveDataOnWindow = function (FILES, virusName, FILESJSON, ALIGNMENTSJSON) {
  let tracks = [];
  tracks.push({type: 'refbed', name: `${virusName}_gene_annotation`, url: `${WANGFTP_URL_BASE}${PUBLIC_FOLDER}${virusName}/gene_annotation/${virusName}_refGenome_annotations.gff3.refbed.gz`}) // gene annotations

  FILES.forEach(file => {
    const FILE = FILESJSON.filter(f => f.name === file.Accession); // SNV
    const ALIGNMENT = ALIGNMENTSJSON.filter(f => f.name === file.Accession); // ALIGNMENT
    tracks.push({
      type: 'categorical',
      name: file.Accession + "_SNV",
      url: FILE[0].url,
      options: CATEGORIES
    }) // CATEGORICAL
    tracks.push({
      type: 'bed',
      name: file.Accession + "_alignment",
      url: ALIGNMENT[0].url
    }) // BED
  });
  tracks.push({type: 'bed', name: 'putative_immune_epitopes', url: IEDP_URL}) // immune epitopes
  tracks.push({type: 'bedGraph', name: `${virusName}_GC_content`, url: `${WANGFTP_URL_BASE}${PUBLIC_FOLDER}${virusName}/GC_content/${virusName}_CGpct.bedgraph.sort.gz`}) // GC content

  let tmpVar = {
    reference: virusName,
    tracks: tracks
  }

  localStorage.setItem('tracks', JSON.stringify(tracks));
  localStorage.setItem('reference', JSON.stringify(virusName));

  return tmpVar;

}
