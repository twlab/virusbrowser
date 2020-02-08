<script>
  import SplashBanner from "./UI/SplashBanner.svelte";
  import Tab, { Icon, Label } from "@smui/tab";
  import TabBar from "@smui/tab-bar";
  import Button from "@smui/button";
  import { onMount, afterUpdate } from "svelte";
  import TreeComponent from "./components/TreeComponent.svelte";
  import CollapsibleTree from "./components/CollapsibleTree.svelte";
  import Footer from "./UI/Footer.svelte";
  import Nav from "./UI/Nav.svelte";
  import LargeTreeContainer from "./containers/LargeTreeContainer.svelte";
  import DataTable from "./components/DataTable.svelte";
  import { Cart } from "./stores/Cart.js";
  import Dropdown from "./UI/Dropdown.svelte";
  import CartIndicator from "./UI/CartIndicator.svelte";
  import CartView from './containers/CartView.svelte';

  const virusList = ["Ebola", "SARS", "MERS", "2019-nCoV"];
  const virusNameList = ["ebola", "sars", "mers", "ncov"];
  let DATA = {};
  let virusName = 'ncov';

  function handleReferenceSelect(event) {
    if (event.detail === '2019-nCoV') {
      virusName = 'ncov';
    } else {
      virusName = event.detail.toLowerCase();
    }
    console.log(virusName);
    Cart.addDataItems([]);
  }

  onMount(() => {
    virusNameList.forEach(reference => {
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

  let iconTabs = [
    {
      k: 0,
      icon: "",
      label: ""
    },
    {
      k: 1,
      icon: "green",
      label: "Tree View"
    },
    {
      k: 2,
      icon: "",
      label: "Data"
    },
    {
      k: 3,
      icon: "shopping_cart",
      label: "Cart"
    }
  ];
  let keyedTabsActive = iconTabs[0];
</script>

<style>

</style>

<!-- <div class="bg-right bg-cover" style="background-image:url('/images/bg.svg');"> -->
<div>
  <!-- <Nav/> -->
  <div class="w-full container mx-auto flex justify-between">
    <div class="w-full flex items-center justify-between">
      <a
        class="flex items-center text-indigo-400 no-underline hover:no-underline
        font-bold text-2xl lg:text-4xl"
        href="/">
        <svg
          class="h-8 fill-current text-indigo-600 pr-2"
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 20 20">
          <path
            d="M10 20a10 10 0 1 1 0-20 10 10 0 0 1 0 20zm-5.6-4.29a9.95 9.95 0 0
            1 11.2 0 8 8 0 1 0-11.2 0zm6.12-7.64l3.02-3.02 1.41 1.41-3.02 3.02a2
            2 0 1 1-1.41-1.41z" />
        </svg>
        WashU Virus Genome Browser
      </a>
    </div>

    <div class="flex flex-col m-2">
      <Dropdown on:reference-select={handleReferenceSelect} names={virusList} />
      <Label>Reference</Label>
    </div>

    <TabBar
      tabs={iconTabs}
      let:tab
      key={tab => tab.k}
      bind:active={keyedTabsActive}>
      <Tab
        {tab}
        stacked={true}
        indicatorSpanOnlyContent={true}
        tabIndicator$transition="fade">

        <Icon class="material-icons">{tab.icon}</Icon>
        <Label>
          {#if tab.k === 3}
            <CartIndicator />
          {:else}{tab.label}{/if}
        </Label>
      </Tab>
    </TabBar>
    <div class="w-1/5" />

  </div>
  <div id="main-wrapper" class="mx-16">
    <div>
      {#if keyedTabsActive.k === 0}
        <div style="height: 800px;">
          <SplashBanner on:start={() => keyedTabsActive = iconTabs[2]}/>
        </div>

      {:else if keyedTabsActive.k === 1}
        <div style="height: 800px;" class="container">
          <LargeTreeContainer {virusName} DATA={DATA[virusName]} />
        </div>

      {:else if keyedTabsActive.k === 2}
        <div style="height: 800px;">
          <DataTable {virusName} DATA={DATA[virusName]} />
        </div>
     
      {:else if keyedTabsActive.k === 3}
        <div style="height: 800px;" class="container">
          <CartView />
        </div>
      {/if}
    </div>
  </div>

  <!-- <TreeComponent /> -->
  <!-- <CollapsibleTree/> -->

  <!-- TEST -->
  <!-- <SplashBanner /> -->
  <!-- <Footer class="mt-14"/> -->

</div>
