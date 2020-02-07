<script>
  import { onMount, beforeUpdate } from "svelte";
  import Switch from '../UI/Switch.svelte';
  export let virusName;
  import { createLargeTree } from "../scripts/createLargeTree";
  let mode = 'linear'; // mode
  export let metadata;

  function handleModeChange(event) {
    if (event.detail) {
      mode = 'radial'
    } else {
      mode = 'linear'
    }
    createLargeTree(virusName, metadata, mode);
  }

  onMount(() => {
    createLargeTree(virusName, metadata, mode);
  });

  beforeUpdate(() => {
    createLargeTree(virusName, metadata, mode);
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
<Switch on:mode-change={handleModeChange}/>
<div><svg width="800" height="600" id="tree_display" /></div>
