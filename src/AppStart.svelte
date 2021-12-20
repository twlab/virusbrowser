<script>
  import { onMount, afterUpdate, onDestroy } from 'svelte';
  import Tab, { Icon, Label } from '@smui/tab';
  import TabBar from '@smui/tab-bar';
  import Button from '@smui/button';
  import Drawer, {
    AppContent,
    Content,
    Header,
    Title,
    Subtitle,
    Scrim,
  } from '@smui/drawer';
  import List, { Item, Text, Graphic, Separator, Subheader } from '@smui/list';
  // import H6 from "@smui/common/H6.svelte";
  import LargeTreeContainer from './containers/LargeTreeContainer.svelte';
  import TreeView from './tree-view/CompressedTreeView.svelte';
  import DataTable from './components/DataTable.svelte';
  import { Cart } from './stores/Cart.js';
  import Dropdown from './UI/Dropdown.svelte';
  import CartIndicator from './UI/CartIndicator.svelte';
  import CartView from './containers/CartView.svelte';
  import HelpMenu from './UI/HelpMenu.svelte';
  import BrowserView from './components/BrowserView.svelte';
  // import SplashBanner from "./UI/SplashBanner.svelte";
  import LandingPage from './UI/LandingPage.svelte';
  import DataReactiveSearch from './components/DataReactiveSearch.svelte';

  let dataTableSelection = [];
  let ncov_tree_metadata = [];
  let clicked = 'nothing yet';
  let myDrawer;
  let myDrawerOpen = false;
  let active = 0;
  let FILESJSON = [];
  let TREEVIEW_METADATA = {};
  function setActive(value) {
    active = value;
    // myDrawerOpen = false;
  }
  const virusList = [
    'Ebola',
    'SARS',
    'MERS',
    'SARS-CoV-2',
    'Human papillomavirus',
  ];
  const virusNameList = ['ebola', 'sars', 'mers', 'ncov'];
  const GENOME_NAME_MAP = {
    ncov: 'SARS-CoV-2',
    mers: 'MERS',
    sars: 'SARS',
    ebola: 'Ebola',
  };
  let fullNames = {
    Ebola: {
      name: 'Ebola',
      id: 'ebola',
      desc: 'Ebola is a rare but deadly virus that causes fever, body aches, and diarrhea, and sometimes bleeding inside and outside the body. As the virus spreads through the body, it damages the immune system and organs. Ultimately, it causes levels of blood-clotting cells to drop. This leads to severe, uncontrollable bleeding.',
    },
    SARS: {
      name: 'SARS',
      id: 'sars',
      desc: 'Severe acute respiratory syndrome (SARS) is a viral respiratory illness caused by a coronavirus called SARS-associated coronavirus (SARS-CoV). SARS was first reported in Asia in February 2003. The illness spread to more than two dozen countries in North America, South America, Europe, and Asia before the SARS global outbreak of 2003 was contained.',
    },
    MERS: {
      name: 'MERS',
      id: 'mers',
      desc: 'Middle East Respiratory Syndrome (MERS) is viral respiratory illness that is new to humans. It was first reported in Saudi Arabia in 2012 and has since spread to several other countries, including the United States. Most people infected with MERS-CoV developed severe respiratory illness, including fever, cough, and shortness of breath. Many of them have died.',
    },
    'SARS-CoV-2': {
      name: 'SARS-CoV-2',
      id: 'ncov',
      desc: 'Since its debut in mid-December, 2019, the zoonotic SARS-CoV-2 has rapidly spread from its origin in Wuhan, China, to several countries across the globe, leading to a global health crisis. Research efforts have begun sequencing the 29 kb virus genome, allowing for comparisons between the novel virus and close relatives. The WashU Virus Genome Browser is home to the genomic sequences of 45 SARS-CoV-2 strains, as well as hundreds of related viruses, including severe acute respiratory syndrome coronavirus (SARS-CoV), Middle East respiratory syndrome coronavirus (MERS-CoV), and Ebola virus. In addition to included data tracks, the browser supports user-uploaded sequences, as well as two visualization platforms: a genomic track view and a phylogenetic tree view. Our hope is that the WashU Virus Genome Browser will serve as an efficient tool, aiding researchers in better understanding the disease.',
    },
    'Human papillomavirus': {
      name: 'Human papillomavirus',
      id: 'hpv16',
      desc: 'https://www.ncbi.nlm.nih.gov/nuccore/NC_001526.4',
    },
  };
  let DATA = {};
  let virusName = 'ncov';
  let virusFullName = 'SARS-CoV-2';
  let GENOMES_DICT;

  function handleReferenceSelect(evt) {
    virusFullName = evt.detail;
    virusName = fullNames[evt.detail].id;

    Cart.addDataItems([]); // reset cart
    keyedTabsActive = iconTabs[2];
  }

  const unsubscribe = Cart.subscribe(async (store) => {
    const { data } = store;
  });

  onDestroy(() => {
    unsubscribe();
  });

  function receiveMessage(evt) {
    console.log(evt.data);
    dataTableSelection = JSON.parse(evt.data);
    console.log(dataTableSelection);
    Cart.addDataItems(dataTableSelection);
  }

  async function getCovidMetadata() {
    const TREE_METADATA_URL = 'https://target.wustl.edu/treeview.json';

    const res = await fetch(TREE_METADATA_URL);
    const response = await res.json();

    if (res.ok) {
      return response;
    } else {
      throw new Error(response);
    }
  }

  onMount(async () => {
    window.addEventListener('message', receiveMessage, false); // listen to data selection from Data Table iframe
    TREEVIEW_METADATA = require('./json/treeview.metadata.json'); // /Users/dpuru/WashU-COVID-Research-Commons/ES-upload, node print_treeview_records.js --notest | jq . > treeview.metadata.json
    // ncov_tree_metadata = await getCovidMetadata();

    //     let FILESJSON_not_ncov = require("./json/pairwise.json");
    //     // const pairwise_ncov_res = await fetch('https://wangftp.wustl.edu/~cfan/public_viralBrowser/ncov/daily_updates/test/updated.json'); // TEST
    //     // const pairwise_ncov_res = await fetch('https://wangftp.wustl.edu/~cfan/datatable/latest/updated.json'); // TEST
    //     // const pairwise_ncov_json = await pairwise_ncov_res.json();
    //     // FILESJSON = [...FILESJSON_not_ncov, ...pairwise_ncov_json];
    //     FILESJSON = [...FILESJSON_not_ncov];

    //     await virusList.forEach(async reference => {
    //       let fileHandle;
    //       if (reference === 'SARS-CoV-2') {
    //         // const res = await fetch(`https://wangftp.wustl.edu/~cfan/public_viralBrowser/ncov/daily_updates/latest/metadata.json`);
    //         // const res = await fetch(`https://wangftp.wustl.edu/~cfan/public_viralBrowser/ncov/daily_updates/test/metadata.json`); // TEST
    //         // const res = await fetch(`https://wangftp.wustl.edu/~cfan/datatable/latest/metadata_v3.json`); // TEST
    // 		    // fileHandle = await res.json();
    //       } else {
    //         fileHandle = require(`./metadata/${fullNames[reference].id}_all_skinny.json`);
    //       }

    //       DATA[fullNames[reference].id] = fileHandle.map((d, i) => {
    //         const {
    //           accession,
    //           organism,
    //           isolate,
    //           mol_type,
    //           strain,
    //           db_xref,
    //           collection_date,
    //           country,
    //           host
    //         } = d;
    //         let tmp = { _id: i + 1 };
    //         tmp.Accession = accession;
    //         tmp.Organism = organism[0] || "";
    //         tmp.Molecule_Type = mol_type !== undefined ? mol_type[0] : "N/A";
    //         tmp.Strain = strain !== undefined ? strain[0] : "N/A";
    //         tmp.Isolate = isolate !== undefined ? isolate[0] : "N/A";
    //         tmp.Collection_Date =
    //           collection_date !== undefined ? collection_date[0] : "N/A";
    //         tmp.Country = country !== undefined ? country[0] : "N/A";
    //         tmp.db_xref = db_xref !== undefined ? db_xref[0] : "N/A";
    //         tmp.Host = host !== undefined ? host[0] : "N/A";
    //         /**
    // accession: "EPI_ISL_450699"
    // clade: "unassigned"
    // collection_date: (3) ["2020", "04", "29"]
    // database: "GISAID"
    // isolate: "hCoV-19/USA/CA-CZB-1195/2020"
    // location: (4) ["North America", "USA", "California", "San Francisco"]
    // snv: "C1059T, C3037T, C11916T, ..."
    // snv.all: (10) ["C241T", "C1059T", "C3037T", "C11916T", "C14408T", "C18998T", "A23403G", "G25563T", "G25947C", "G29540A"]
    // treeview: 0
    // */
    //         // const { accession, clade, collection_date, database, isolate, treeview,  } = d;
    //         // let tmp = { _id: accession };
    //         // tmp.Accession = accession;
    //         // tmp.Organism = reference || "";
    //         // tmp.Molecule_Type = "N/A";
    //         // tmp.Strain = reference || "N/A";
    //         // tmp.Isolate = isolate;
    //         // tmp.Collection_Date = Array.isArray(collection_date) ? collection_date.join('-') : "N/A";
    //         // tmp.Country = location[1] || "N/A";
    //         // tmp.db_xref = "N/A";
    //         // tmp.Host = "Homo sapiens";
    //         // return tmp;
    //       });
    //     })
  });

  const TRACKS = sessionStorage.getItem('tracks');
  if (TRACKS !== '') {
    let parsedTracks = JSON.parse(TRACKS) || [];
    Cart.addDataItems(
      parsedTracks.filter((d) => d.type === 'pairwise').map((d) => d.metadata)
    );
  }

  let referenceLS = sessionStorage.getItem('reference');
  let parsedReference;
  if (referenceLS !== undefined && referenceLS !== 'undefined') {
    parsedReference = JSON.parse(referenceLS);
  }
  if (parsedReference) {
    if (GENOME_NAME_MAP[parsedReference]) {
      // ncov
      virusName = parsedReference;
      console.log(parsedReference);
      virusFullName = GENOME_NAME_MAP[parsedReference];
    } else {
      virusFullName = parsedReference;
      virusName = fullNames[parsedReference].id;
    }
  }

  let iconTabs = [
    {
      k: 0,
      icon: '',
      label: '',
    },
    {
      k: 1,
      icon: 'leaf',
      label: 'Tree View',
    },
    {
      k: 2,
      icon: 'data',
      label: 'Data',
    },
    {
      k: 3,
      icon: 'shopping_cart',
      label: 'Cart',
    },
    {
      k: 4,
      icon: 'web',
      label: 'Browser View',
    },
  ];
  let keyedTabsActive = iconTabs[0];

  let helpMenuItems = [
    {
      k: 0,
      icon: 'slideshow',
      label: 'Video tutorials',
      url: 'https://www.youtube.com/channel/UCuIQetcmC5h1h_LXmhrlKrA',
    },
    {
      k: 1,
      icon: 'description',
      label: 'Documentation',
      url: 'https://virusgateway.readthedocs.io/en/latest/index.html',
    },
    {
      k: 2,
      icon: 'code',
      label: 'Github',
      url: 'https://github.com/debugpoint136/WashU-Virus-Genome-Browser',
    },
  ];
</script>

<div class="drawer-container">
  <Drawer bind:this={myDrawer} bind:open={myDrawerOpen}>
    <Content>
      <div class="w-full xl:flex xl:items-center lg:justify-center my-8">
        <a href="/"
          ><img
            src="/fresh/images/logos/virus-browser-logo.svg"
            alt=""
            width="112"
            height="28"
          /></a
        >
      </div>
      <label
        for="ref"
        class="ref w-full xl:flex xl:items-center lg:justify-center"
        >Choose a Virus Reference:</label
      >
      <div class="w-full xl:flex xl:items-start lg:justify-center h-64">
        <Dropdown
          on:reference-select={handleReferenceSelect}
          names={virusList}
        />
      </div>
      <List>
        <Item
          href="javascript:void(0)"
          on:click={() => setActive(4)}
          activated={active === 4}
        >
          <Graphic class="material-icons" aria-hidden="true">web</Graphic>
          <Text>Browser View</Text>
        </Item>
        {#if virusName !== 'hpv16'}
          <Item
            href="javascript:void(0)"
            on:click={() => setActive(1)}
            activated={active === 1}
          >
            <Graphic class="material-icons" aria-hidden="true">star</Graphic>
            <Text>Tree View</Text>
          </Item>
          <Item
            href="javascript:void(0)"
            on:click={() => setActive(2)}
            activated={active === 2}
          >
            <Graphic class="material-icons" aria-hidden="true">inbox</Graphic>
            <Text>Data Table</Text>
          </Item>

          <Separator nav />
          <Subheader>Resources</Subheader>
          {#each helpMenuItems as item}
            <Item href={item.url}>
              <Graphic class="material-icons" aria-hidden="true">
                bookmark
              </Graphic>
              <Text>{item.label}</Text>
            </Item>
          {/each}
        {/if}
      </List>
    </Content>
  </Drawer>
  <Scrim />
  <AppContent class="app-content">
    <!-- <Button on:click={() => myDrawerOpen = !myDrawerOpen}>Toggle Sidebar</Button> -->
    <main class="main-content">
      <div id="main-wrapper" class="mx-16">
        <div>
          {#if active === 0}
            <div style="height: 800px;">
              <!-- <SplashBanner
                on:start={() => setActive(2)}
                {virusName}
                {fullNames} /> -->
              <LandingPage on:start={() => setActive(4)} />
            </div>
          {:else if active === 1}
            <div style="height: 800px;" class="container">
              <TreeView
                virusName={virusFullName}
                METADATA={TREEVIEW_METADATA[virusFullName]}
              />
              <!-- {#if virusFullName === 'SARS-CoV-2'}
                <TreeView virusName={virusFullName} METADATA={TREEVIEW_METADATA[virusFullName]}/>
              {:else}
                <TreeView virusName={virusFullName}/>
              {/if}               -->
            </div>
          {:else if active === 2}
            <div style="height: 800px;">
              {#if virusFullName !== 'SARS-CoV-2'}
                <!-- <DataTable {virusName} DATA={DATA[virusName]} {FILESJSON}/> -->
              {:else}
                <div />
                <!-- <DataTable {virusName} DATA={DATA[virusName]} {FILESJSON}/> -->
              {/if}
            </div>
          {:else if active === 3}
            <div style="height: 100%;" class="container">
              <CartView />
            </div>
          {:else if active === 4}
            <div />
          {/if}
        </div>
        <div class="w-full xl:w-1/5 lg:items-start" />
      </div>
      <!-- <div style="height: 100%;" class:hidden={active !== 1}>
        <TreeView virusName={virusFullName} dataSelection={dataTableSelection} METADATA={TREEVIEW_METADATA[virusFullName]}/>
      </div> -->
      <div style="height: 100%;" class:hidden={active !== 2}>
        <!-- {#if virusFullName === 'SARS-CoV-2'} -->
        <DataReactiveSearch {virusFullName} />
        <!-- {/if} -->
      </div>
      <div style="height: 100%;" class:hidden={active !== 4}>
        <!-- <BrowserView {virusName} {active} {FILESJSON} dataSelection={dataTableSelection}/> -->
        <BrowserView {virusName} {active} />
      </div>
    </main>
  </AppContent>
</div>

<style>
  .drawer-container {
    position: relative;
    display: flex;
    height: 100%;
    max-width: 100%;
    /* border: 1px solid rgba(0, 0, 0, 0.1); */
    overflow: hidden;
    z-index: 0;
  }
  * :global(.mdc-drawer--modal, .mdc-drawer-scrim) {
    /* This is not needed for a page-wide modal. */
    position: absolute;
  }
  * :global(.app-content) {
    flex: auto;
    overflow: auto;
    position: relative;
    flex-grow: 1;
  }
  .main-content {
    overflow: auto;
    padding: 16px;
    height: 100%;
    box-sizing: border-box;
  }
  .ref {
    font-size: 1.2em;
    font-weight: bold;
    margin-bottom: 1em;
    margin-top: 0.5em;
  }
</style>
