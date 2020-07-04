<script>
  import { onMount } from "svelte";
  import { watchResize } from "svelte-watch-resize";
  let node;
  let loading = true;
  let leftWidth;
  import { drawTreeWidget } from "../scripts/d3treeViewWidget";
  function handleLeftResize(node) {
    leftWidth = node.clientWidth;
  }

  onMount(() => {
    drawTreeWidget(node);
  });
</script>

<style>
  .content {
    margin-left: 10%;
    display: flex;
    width: 100%;
    height: 100%;
    align-items: center;
    justify-content: center;
    font-size: 1em;
  }

  #svg-element {
    width: 100%;
    height: 100%;
  }
</style>

{#if loading}
  Please wait...
{/if}
<div
  class="content"
  bind:this={node}
  use:watchResize={handleLeftResize}>
  <label id="show-length">
    <input type="checkbox" />
    Show branch length
  </label>
  <svg id="svg-element" />
</div>
