<script>
  import { onMount } from 'svelte';
  import LargeTree from '../components/LargeTree.svelte';
  export let virusName;
  export let DATA;

</script>

<LargeTree {virusName} metadata={DATA}/>