<script>
  import { onMount, beforeUpdate } from "svelte";
  import Switch from '../UI/Switch.svelte';
  import { Cart } from '../stores/Cart';
  import ButtonGroup from '../UI/ButtonGroup.svelte';
  export let virusName;
  let virusDisplayed;
  import { createLargeTree } from "../scripts/createLargeTree";
  let mode = 'linear'; // mode
  let indent = 'right';
  export let metadata;


function addDataToCart(input) {
  let found = $Cart.data.filter(d => d.Accession === input.name);
  if (found.length > 0) {
    Cart.addDataItems($Cart.data.filter(d => d.Accession !== input.name));
  } else {
    let tmp = metadata.filter(d => d.Accession === input.name)
    Cart.addDataItems([...new Set([...$Cart.data, tmp[0]])]);
  }
  // const tracksWindow = saveDataOnWindow($Cart.data, virusName, FILESJSON, ALIGNMENTSJSON);
  // window.TRACKS = tracksWindow;
}

  function handleModeChange(event) {
    if (event.detail) {
      mode = 'radial'
    } else {
      mode = 'linear'
    }
    createLargeTree(virusName, metadata, mode, indent, addDataToCart);
  }

  function handleIndentChange(event) {
    indent = event.detail;
    createLargeTree(virusName, metadata, mode, indent, addDataToCart);
  }

  onMount(() => {
    createLargeTree(virusName, metadata, mode, indent, addDataToCart);
  });

  beforeUpdate(() => {
    if (virusName !== virusDisplayed) {
      virusDisplayed = virusName;
      createLargeTree(virusName, metadata, mode, indent, addDataToCart);
    }
  })
</script>

<style>
  :global(#guide) {
    position: fixed;
    top: 25px;
    right: 25px;
    border-style: solid;
    border-color: red;
    border-width: 1px;
    background: white;
  }
  :global(#guide path.branch) {
    stroke: #ddd;
  }
  :global(#guide path.branch:hover) {
    stroke-width: 2px;
  }

  /* #tree_display {
    width: 800px;
  } */

</style>

<!-- <div>
  <svg width="300" height="600" id="tree_guide" />
</div> -->
<div class="flex">
  <ButtonGroup on:indent-change={handleIndentChange}/>
  <Switch on:mode-change={handleModeChange}/>
</div>
<div><svg width="800" height="600" id="tree_display" /></div>
