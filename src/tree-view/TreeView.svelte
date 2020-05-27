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
  export let tree;
  let terms = [];
  $: {
    const metadataByCriteria = metadata.map(d => {
      if (Array.isArray(d[CRITERIA.key])) {
          return d[CRITERIA.key][CRITERIA.leaflet]
        } else {
          return d[CRITERIA.key];
        }
      })
    terms = [...new Set(metadataByCriteria)];
  }
  const newick = createNewick(tree);
  // const HARD_CODED_TREE = require(`../json/${virusName}.tree.js`);

  // if(virusName === 'SARS-CoV-2') {
  //   newick = createNewick(HARD_CODED_TREE); // to circumvent issue caused in Safari
  // } else {
  //     newick = createNewick(tree);
  // }

  function drawTree() {
    const selectedData = $Cart.data;
    const constructedTree = new Phylogram(selector, newick, {
      width: window.innerWidth * 0.5,
      height: window.innerHeight * 0.8,
      skipLabels: true,
      skipTicks: false,
      skipBranchLengthScaling: false
    }, d3.scale.ordinal().domain(terms).range(COLORS), metadata, CRITERIA, selectedData).build();
  }

  afterUpdate(() => {
    console.log("kicking afterUpdate!");
    drawTree();
  })
</script>

<div id="phylogram" bind:this={selector} />
