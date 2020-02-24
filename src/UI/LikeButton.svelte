<script>
  import { onMount } from "svelte";
  import React from "react";
  import ReactDOM from "react-dom";
  const e = React.createElement;
  import Like from "./Like";

  let container;
  onMount(function() {
    ReactDOM.render(e(Like), container);
  });
</script>

<div bind:this={container} />
