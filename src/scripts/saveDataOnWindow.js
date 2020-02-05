import CATEGORIES from '../json/categories.json';

export const saveDataOnWindow = function (FILES, virusName, FILESJSON) {
  let tracks = [];
  FILES.forEach(file => {
    let FILE = FILESJSON.filter(f => f.name === file.Accession);
    tracks.push({type: 'categorical', name: file.Accession, url: FILE[0].url, options: CATEGORIES})
  });
  let tmpVar = {
    reference: virusName,
    tracks: tracks
  }

  localStorage.setItem('tracks', JSON.stringify(tracks));
  localStorage.setItem('reference', JSON.stringify(virusName));

  return tmpVar;
}