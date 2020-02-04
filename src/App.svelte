<script>
  import SplashBanner from "./UI/SplashBanner.svelte";
  import TreeComponent from "./components/TreeComponent.svelte";
  import CollapsibleTree from './components/CollapsibleTree.svelte';
  import Footer from "./UI/Footer.svelte";
  import Nav from "./UI/Nav.svelte";
  import LargeTreeContainer from "./containers/LargeTreeContainer.svelte";
  import DataTable from './components/DataTable.svelte';
</script>

<style>

</style>

<div
  class="pb-12 bg-right bg-cover"
  style="background-image:url('/images/bg.svg');">
  <!--Nav-->
  <Nav />
    <div class="h-screen">

    <div class="flex justify-between p-8">
       <a href="/metadata/ebola_all_skinny.json">Ebola</a>
       <a href="/metadata/Mers_all_skinny.json">Mers</a>
       <a href="/metadata/sars_all_skinny.json">Sars</a>
       <a href="/metadata/ncov_all_skinny.json">nCov</a>
    
    </div>

      <!-- <TreeComponent /> -->
      <!-- <LargeTreeContainer /> -->
      <!-- <CollapsibleTree/> -->
      <DataTable/>
    </div>
  <!-- <SplashBanner /> -->
  <!-- <Footer class="mt-14"/> -->

</div>
