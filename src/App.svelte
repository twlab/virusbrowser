<script>
  import SplashBanner from "./UI/SplashBanner.svelte";  
  import { onMount, afterUpdate } from "svelte";
  import TreeComponent from "./components/TreeComponent.svelte";
  import CollapsibleTree from "./components/CollapsibleTree.svelte";
  import Footer from "./UI/Footer.svelte";
  import Nav from "./UI/Nav.svelte";
  import LargeTreeContainer from "./containers/LargeTreeContainer.svelte";
  import DataTable from "./components/DataTable.svelte";
  // import DownloadDatahub from './components/DownloadDatahub.svelte';
  import { Cart } from "./stores/Cart.js";
  import Dropdown from './UI/Dropdown.svelte';

  const virusList = ["Ebola", "SARS", "MERS", "nCov"];
  let DATA = {};
  let virusName = virusList[3].toLowerCase();

  function handleReferenceSelect(event) {
    virusName = event.detail.toLowerCase();
    Cart.addDataItems([]);
  }

  onMount(() => {
    virusList.forEach(ref => {
      let reference = ref.toLowerCase();
      let fileHandle = require(`./metadata/${reference}_all_skinny.json`);
      DATA[reference] = fileHandle.map((d, i) => {
        const {
          accession,
          organism,
          isolate,
          mol_type,
          strain,
          db_xref,
          collection_date,
          country,
          host
        } = d;
        let tmp = { _id: i + 1 };
        tmp.Accession = accession;
        tmp.Organism = organism[0] || "";
        tmp.Molecule_Type = mol_type !== undefined ? mol_type[0] : "N/A";
        tmp.Strain = strain !== undefined ? strain[0] : "N/A";
        tmp.Isolate = isolate !== undefined ? isolate[0] : "N/A";
        tmp.Collection_Date =
          collection_date !== undefined ? collection_date[0] : "N/A";
        tmp.Country = country !== undefined ? country[0] : "N/A";
        tmp.db_xref = db_xref !== undefined ? db_xref[0] : "N/A";
        tmp.Host = host !== undefined ? host[0] : "N/A";
        return tmp;
      });
    });
  });
</script>

<style>

</style>

<div
  class="pb-12 bg-right bg-cover"
  style="background-image:url('/images/bg.svg');">
  <!--Nav-->
  <Nav />
  <div class="h-screen">
    <Dropdown on:reference-select={handleReferenceSelect} names={virusList}/>

    <!-- <TreeComponent /> -->
    <!-- <LargeTreeContainer /> -->
    <!-- <CollapsibleTree/> -->
    <!-- <DownloadDatahub {virusName}/> -->
    <DataTable {virusName} DATA={DATA[virusName]} />
    <!-- TEST -->
  </div>
  <!-- <SplashBanner /> -->
  <!-- <Footer class="mt-14"/> -->

</div>
