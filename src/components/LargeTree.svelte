<script>
  import { onMount, beforeUpdate } from "svelte";
  import Switch from '../UI/Switch.svelte';
  import ButtonGroup from '../UI/ButtonGroup.svelte';
  export let virusName;
  import { createLargeTree } from "../scripts/createLargeTree";
  let mode = 'linear'; // mode
  let indent = 'right';
  export let metadata;

  function handleModeChange(event) {
    if (event.detail) {
      mode = 'radial'
    } else {
      mode = 'linear'
    }
    createLargeTree(virusName, metadata, mode, indent);
  }

  function handleIndentChange(event) {
    indent = event.detail;
    createLargeTree(virusName, metadata, mode, indent);
  }

  onMount(() => {
    createLargeTree(virusName, metadata, mode, indent);
  });

  beforeUpdate(() => {
    createLargeTree(virusName, metadata, mode, indent);
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
<ButtonGroup on:indent-change={handleIndentChange}/>
<Switch on:mode-change={handleModeChange}/>
<div><svg width="800" height="600" id="tree_display" /></div>
