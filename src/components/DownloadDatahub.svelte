<script>
  import { onMount, onDestroy, afterUpdate } from "svelte";
  // import uuid from "uuid";
  // import LinearProgress from "../../ui/LinearProgress.svelte";
  import { Cart } from "../stores/Cart";
  // import { generateDatahub } from '../scripts/generateDatahub';
  import fileDownload from 'js-file-download';
  let dataToRender;
  let loaded = false;
  let error = undefined;
  let sessionFile = undefined;
  let UUID;
  let FILES = [];
  export let virusName;
  let dataFiles;
  const URLBASE = "https://wangftp.wustl.edu/~dpuru/viralGateway/";
  import CATEGORIES from '../json/categories.json';
  

  const unsubscribe = Cart.subscribe(async store => {
    const { data } = store;
    dataFiles = data;
    console.log(dataFiles);
  });
  
  onDestroy(() => {
		unsubscribe();
	});

  function handleSessionDownload() {
    // fileDownload(sessionFile, `${UUID}_region_sets.json`);
    let tmp = []
    dataFiles.forEach(file => {
      let FILE = FILES.filter(f => f.name === file.Accession);
      tmp.push({
        type: 'categorical',
        name: file.Accession,
        url: FILE[0].url,
        options: CATEGORIES
      })
    
      localStorage.setItem('tracks', JSON.stringify(tmp));
      localStorage.setItem('reference', JSON.stringify(virusName));
      });
  }

  onMount(async () => {
    let res = await fetch('https://wangftp.wustl.edu/~dpuru/database.json')
    FILES = await res.json();
    // console.log(FILES);
    // UUID = uuid.v4(); 
  });

</script>


<div class="w-1/4 flex justify-center">
  <!-- {#if sessionFile !== undefined} -->
    <div class="text-center block border border-grey-500 bg-blue-500 rounded py-2 px-4 hover:bg-blue-700 text-white" on:click={handleSessionDownload}> Update Datahub </div>
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


