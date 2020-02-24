export const createDatahub = function (input) {
    const { reference, tracks } = input;
    return tracks.filter(t => t.type === 'pairwise').map((item, index) => {
        
        const {
            Accession,
            Organism,
            Molecule_Type,
            Strain,
            Collection_Date,
            Country,
            Isolate,
            Host, 
            db_xref
        } = item.metadata;
        let metadata = {};
        // if (index < 5) {
        //     metadata.showOnHubLoad = true;
        // } else {
        //     metadata.showOnHubLoad = false;
        // }
        metadata.type = getDatahubType(item);
        metadata.url = getPipelineOutDir(item);
        metadata.name = `${Accession}`;
        metadata.metadata = {
            Assay,
            Dose,
            Exposure,
            Lab,
            Sex,
            Tissue
        }

        return  metadata;
    })
    
}