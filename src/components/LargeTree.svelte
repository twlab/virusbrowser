<script>
  import { onMount, beforeUpdate } from "svelte";
  export let virusName;
  import { createLargeTree } from "../scripts/createLargeTree";

  onMount(() => {
    createLargeTree(`/data/${virusName}_align.tree`);
  });

  beforeUpdate(() => {
    createLargeTree(`/data/${virusName}_align.tree`);
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

</style>

<!-- <div>
  <svg width="300" height="600" id="tree_guide" />
</div> -->
<div><svg width="300" height="600" id="tree_display" /></div>
