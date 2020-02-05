<script>
  import SplashBanner from "./UI/SplashBanner.svelte";
  import TreeComponent from "./components/TreeComponent.svelte";
  import CollapsibleTree from './components/CollapsibleTree.svelte';
  import Footer from "./UI/Footer.svelte";
  import Nav from "./UI/Nav.svelte";
  import LargeTreeContainer from "./containers/LargeTreeContainer.svelte";
  import DataTable from './components/DataTable.svelte';
  import DownloadDatahub from './components/DownloadDatahub.svelte';
  import { Cart } from "./stores/Cart.js";

  const virusList = ['Ebola', 'SARS', 'MERS', 'nCov'];
  let virusName = virusList[3].toLowerCase();
  function updateVirusName(item) {
    virusName = item.toLowerCase();
    Cart.addDataItems([]);
  }
</script>

<style>

</style>

<div
  class="pb-12 bg-right bg-cover"
  style="background-image:url('/images/bg.svg');">
  <!--Nav-->
  <Nav />
    <div class="h-screen">

    <div class="flex justify-center p-8">
      {#each virusList as item}
         <ul class="flex">
          <li class="flex-1 mr-2">
            <div on:click={() => updateVirusName(item)} class="text-center block border border-blue-500 bg-blue-500 rounded py-2 px-4 hover:bg-blue-700 text-white" class:active={item === virusName}>{item}</div>
          </li>
        </ul>
      {/each}
    </div>

      <!-- <TreeComponent /> -->
      <!-- <LargeTreeContainer /> -->
      <!-- <CollapsibleTree/> -->
      <!-- <DownloadDatahub {virusName}/> -->
      Selected : {virusName}
      <DataTable {virusName} /> 
      <!-- TEST -->
    </div> 
  <!-- <SplashBanner /> -->
  <!-- <Footer class="mt-14"/> -->

</div>
