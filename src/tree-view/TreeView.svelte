<script>
  import { onMount, afterUpdate } from "svelte";
  import { createNewick } from "./scripts/createNewick";
  import Phylogram from "./scripts/phylogram-vanilla";
  import { COLORS } from './scripts/colors';
  import { Cart } from '../stores/Cart';
  // import Phylogram from "../scripts/phylogram";
  let selector;
  export let CRITERIA;
  export let metadata;
  export let virusName;
  let virusDisplayed;
  // let constructedTree;
  export let tree;
  let newick;
  let terms = [];
  $: {
    const metadataByCriteria = metadata.map(d => {
      /**
       * Accession: "EPI_ISL_420600"
        Clade: "20B"
        Continent: "South America"
        Country: "Argentina"
        Date: "2020-Mar"
        TreeView: "Yes"
      */
      if (Array.isArray(d[CRITERIA.key])) {
          return d[CRITERIA.key][CRITERIA.leaflet]
        } else {
          return d[CRITERIA.key];
        }
      })
    terms = [...new Set(metadataByCriteria)];
    newick = createNewick(tree);
  }
  // const newick = createNewick(tree);
  // console.log(newick);
  // const HARD_CODED_TREE = require(`../json/${virusName}.tree.js`);

  // if(virusName === 'SARS-CoV-2') {
  //   newick = createNewick(HARD_CODED_TREE); // to circumvent issue caused in Safari
  // } else {
  //     newick = createNewick(tree);
  // }


  function drawTree() {
    console.log('drawing...')
    const selectedData = $Cart.data;
    setTimeout(() => {
    let constructedTree = new Phylogram(selector, newick, {
        width: window.innerWidth * 0.5,
        height: window.innerHeight * 0.8,
        skipLabels: true,
        skipTicks: false,
        skipBranchLengthScaling: false
      }, d3.scale.ordinal().domain(terms).range(COLORS), metadata, CRITERIA, selectedData).build();
    }, 100)
  }

  afterUpdate(() => {
    console.log("kicking afterUpdate!");
    drawTree();
  })
</script>

<!-- <div>Displaying : {virusName}</div> -->
<div id="loader">Loading ...
  <img    alt="loading"
          class="center"
          width="24"
          height="24"
          src="https://i.pinimg.com/originals/3e/f0/e6/3ef0e69f3c889c1307330c36a501eb12.gif"
      />
</div>
<div id="phylogram" bind:this={selector} />


<style>
  .center {
  display: block;
  margin-left: auto;
  margin-right: auto;
}
</style>