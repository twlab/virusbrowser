<script>
  import { onMount, onDestroy, afterUpdate } from "svelte";
  import uuid from "uuid";
  // import LinearProgress from "../../ui/LinearProgress.svelte";
  import { Cart } from "../stores/Cart";
  import { generateDatahub } from '../scripts/generateDatahub';
  import fileDownload from 'js-file-download';
  let dataToRender;
  let loaded = false;
  let error = undefined;
  let sessionFile = undefined;
  let UUID;
  export let virusName;
  let dataFiles;
  const URLBASE = "https://wangftp.wustl.edu/~dpuru/viralGateway/";
  import CATEGORIES from '../json/categories.json';

  const unsubscribe = Cart.subscribe(async store => {
    const { data } = store;
		dataFiles = data;
  });
  
  onDestroy(() => {
		unsubscribe();
	});

  function handleSessionDownload() {
    // fileDownload(sessionFile, `${UUID}_region_sets.json`);
    let tmp = []
    dataFiles.forEach(file => {
      console.log(file);
    tmp.push(`
      new TrackModel({
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
        })
      `)

      console.log(tmp.join(','))
      });
  }

  onMount(() => {
    UUID = uuid.v4(); 
    sessionFile = generateDatahub(dataFiles, virusName, "NC_045512.2.fa");
  });

  afterUpdate(() => {
    UUID = uuid.v4(); 
    dataFiles.forEach(element => {
    console.log(`{
        "type": "categorical",
        "name": "${file.accession}",
        "url": "${URLBASE}/${virusName}/SNV/${file.accession}",
        "options": "${CATEGORIES}"
      }`)
      });
    // sessionFile = generateDatahub(dataFiles, virusName, "NC_045512.2.fa");
  });
</script>


<div>
  <!-- {#if sessionFile !== undefined} -->
    <div class="text-center block border border-blue-500 bg-blue-500 rounded py-2 px-4 hover:bg-blue-700 text-white" on:click={handleSessionDownload}> Download Datahub </div>
  <!-- {/if} -->
  <!-- {#if loaded}
    <div class="tooltip" id="genome-tooltip" />
    <hr />
  {:else if error !== undefined}
    <p>{error}</p>
  {:else} -->
    <!-- <LinearProgress /> -->
    
  <!-- {/if} -->
</div>

