<script>
  import { onMount, beforeUpdate } from 'svelte'; 
  // import Tree from "./Tree.svelte";
  import TreeView from "./TreeView.svelte";
  import TreeLegend from "./TreeLegend.svelte";
  // import ColorChoice from './ColorChoice.svelte';
  import Dropdown from "./Dropdown.svelte";
  // import "smelte/src/tailwind.css";
  import { COLORS } from './scripts/colors';
  // let METADATA_URL = 'https://wangftp.wustl.edu/~cfan/public_viralBrowser/ncov/daily_updates/test/metadata_v2.json';
  // let TREE_URL = 'https://wangftp.wustl.edu/~cfan/public_viralBrowser/ncov/daily_updates/test/strain_updated.fa.tree';
  // const WWW_DIR_TREE = 'https://wangftp.wustl.edu/~dpuru/viralGateway/';
  // const WWW_DIR_JSON = 'https://wangftp.wustl.edu/~cfan/viralBrowser/sme/datatable_json/';
  let CRITERIA = { id: 1, text: 'Clade', key: 'Clade' };
  // let CRITERIA = { id: 2, text: 'Location', key: 'Location' };
  export let METADATA = [];
  let TREE;
  let virusDisplayed;
  export let virusName;
  // export let treeMetadata = [];
  // let promise = Promise.all([getMetadata(), getTree()]);
  let promise = Promise.all([getTree()]);

  function handleCriteriaChange(event) {
    CRITERIA = event.detail;
    if (CRITERIA.id === 3 && virusName !== 'SARS-CoV-2') {
      CRITERIA.leaflet = 0;
    }
  }

  const isSafari = /^((?!chrome|android).)*safari/i.test(navigator.userAgent);


  // function metadataByCriteria() {
  //   // metadata should exist
  //   // criteria
  //   const metadataByCriteria = metadata.map(d => {
  //     if (Array.isArray(d[CRITERIA.key])) {
  //         return d[CRITERIA.key][1]
  //       } else {
  //         return d[CRITERIA.key];
  //       }
  //     })
  //   terms = [...new Set(metadataByCriteria)];
  // }

  async function getTree() {
    console.log('getting tree...');
    TREE = require(`../json/${virusName}.tree.js`);
    // console.log(TREE)
  }

  // async function getMetadata() {
  //   if (virusName === 'SARS-CoV-2') {
  //     return treeMetadata;
  //   }

  //   if (virusName !== 'SARS-CoV-2') {
  //     METADATA_URL = WWW_DIR_JSON + virusName + "_v2.json";
  //   } 
  //   // else {
  //   //     METADATA_URL = 'https://wangftp.wustl.edu/~cfan/public_viralBrowser/ncov/daily_updates/test/metadata_v2.json';
  //   // }
  //     const res = await fetch(METADATA_URL);
  //     const response = await res.json();

  //     if (res.ok) {
  //       return response;
  //     } else {
  //       throw new Error(response);
  //     }
  //   } 
	
  // async function getTree() {
  //   if (virusName !== 'SARS-CoV-2') {
  //     TREE_URL = WWW_DIR_TREE + "tree/" + virusName + ".tree";
  //   } else {
  //       TREE_URL = 'https://wangftp.wustl.edu/~cfan/public_viralBrowser/ncov/daily_updates/test/strain_updated.fa.tree';
  //   }
	// 	const res = await fetch(TREE_URL);
  //   const text = await res.text();

	// 	if (res.ok) {
	// 		return text;
	// 	} else {
	// 		throw new Error(text);
	// 	}
  // }

  beforeUpdate(async () => {
    if (virusName !== virusDisplayed) {
      CRITERIA = { id: 1, text: 'Clade', key: 'Clade' };
      virusDisplayed = virusName;
      console.log('and working here..');
      TREE = require(`../json/${virusName}.tree.js`)
      console.log(METADATA);
      // promise = Promise.all([getMetadata(), getTree()]);
      // const [metadata_response, tree_response] = await promise;
      // METADATA = metadata_response;
      // TREE = tree_response;
    }
  })
  
</script>

<style>
  main {
    text-align: center;
    padding: 1em;
    max-width: 240px;
    margin: 0 auto;
  }

  h1 {
    color: #495692;
    text-transform: uppercase;
    font-size: 2em;
    font-weight: 100;
  }

  @media (min-width: 640px) {
    main {
      max-width: none;
    }
  }
</style>

<div>
  <!-- <div class="h-screen top-0 sticky p-2 shadow bg-gray-200">
    <button
      class="p-1 border-2 border-transparent text-gray-400 rounded-full
      hover:text-white focus:outline-none focus:text-white focus:bg-gray-700"
      aria-label="Notifications">
      <svg
        class="h-6 w-6"
        stroke="currentColor"
        fill="none"
        viewBox="0 0 24 24">
        <path
          stroke-linecap="round"
          stroke-linejoin="round"
          stroke-width="2"
          d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0
          00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0
          .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" />
      </svg>
    </button>
  </div> -->
  <main>

    <h1>Tree View</h1>
    <!-- {#if isSafari}
      <p> Please use Chrome Browser for this feature.</p>
    {:else}
     -->

    {#await promise}
      <div>
      <p> Please wait .. loading metadata file...</p>
      <small>This will take a few seconds</small>
      </div>
    {:then result}
      <div class='mx-8'>
        <div class="flex justify-start">
          <Dropdown on:option-select={handleCriteriaChange} />
          <div id="tooltip" class="tooltip ml-8 p-4 text-start mr-48 w-128 h-32 rounded-md text-xs font-mono hidden" />
        </div>
        <div class="flex justify-between">
          <div class="w-3/4">
            <TreeView {virusName} {CRITERIA} metadata={METADATA} tree={TREE}/>
          </div>
          <div class="w-1/4">
            <TreeLegend {CRITERIA} metadata={METADATA}/>
          </div>
        </div>
      </div>
    {:catch error}
      <p style="color: red">{error.message}</p>
    {/await}
    <!-- {/if} -->
  </main>
</div>
