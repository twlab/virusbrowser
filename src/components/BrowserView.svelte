<script>
  import { onDestroy, afterUpdate, onMount } from "svelte";
	import { Cart } from "../stores/Cart.js";
	import Button, { Label } from "@smui/button";
  import { saveDataOnWindow } from "../scripts/saveDataOnWindow";
  import { createDatahubCustom } from "../scripts/createDatahubCustom";
  import { createDatahub } from "../scripts/createDatahub";
  // import FILESJSON from "../json/pairwise.json";
  import axios from "axios";
  import uuid from "uuid";
  export let virusName;
  export let active; // 4 if tab is active
  export let FILESJSON;
  export let dataSelection = [];
  let DATA;
  let uploaded = true;
  let error;
  let content;
  let DATAHUB_URL;
	let prevActive;
  let change_occured = false;
  let DATA_FOR_DATAHUB = [];

  const POST_DATAHUB_URL =
    "https://5dum6c4ytb.execute-api.us-east-1.amazonaws.com/dev/datahub";
  const BROWSER_URL =
    "https://eg-react.s3-website-us-east-1.amazonaws.com/browser";

  const GENOME_NAME_MAP = {
    ncov: "SARS-CoV-2",
    mers: "MERS",
    sars: "SARS",
    ebola: "Ebola"
	};
	
	onMount(() => {
    // console.log(JSON.parse(sessionStorage.getItem('eg-react-session')));
    console.log(dataSelection);
		content = `<iframe
																id="browser-embed"
																src="https://epigenomegateway.wustl.edu/browser"
																allowfullscreen>
                              </iframe>`;
  })
  
  afterUpdate(() => {
    if (change_occured && active === 4) {
      let generatedDatahub;
      if (virusName === 'ncov') {
        console.log(dataSelection)
        generatedDatahub = createDatahubCustom(dataSelection, GENOME_NAME_MAP[virusName]); //SARS-CoV-2 only
      } else {
        generatedDatahub = saveDataOnWindow(DATA_FOR_DATAHUB, GENOME_NAME_MAP[virusName], FILESJSON);
      }
      change_occured = false;
      uploaded = false;
      const UUID = uuid.v4();
      // let { tracks } = saveDataOnWindow($Cart.data, virusName, FILESJSON);
      // console.log($Cart.data);
      console.log(DATA_FOR_DATAHUB);
      // let generatedDatahub = saveDataOnWindow($Cart.data, GENOME_NAME_MAP[virusName], FILESJSON);
      // generatedDatahub = saveDataOnWindow(DATA_FOR_DATAHUB, GENOME_NAME_MAP[virusName], FILESJSON);
      console.log(generatedDatahub);
      console.log(UUID);
      // let generatedDatahub = createDatahub(content.tracks);
      // if (DATA.length > 0) {
      const toPost = {
        _id: UUID,
        files: [],
        hub: { content: generatedDatahub },
        comments: "TEST",
        compositegraphdata: {},
        registered: Date(),
        username: "dpuru"
      };
      console.log("Posting request to mongo API...");
      axios
        .post(POST_DATAHUB_URL, toPost)
        .then(res => {
          let resBody = JSON.parse(res.data.body);
          if (resBody.hasOwnProperty("id")) {
            uploaded = true;
            // DATAHUB_URL = `/browser/?genome=${GENOME_NAME_MAP[virusName]}&hub=${POST_DATAHUB_URL}/${UUID}&virusBrowserMode=1`;
            DATAHUB_URL = `https://epigenomegateway.wustl.edu/browser/?genome=${GENOME_NAME_MAP[virusName]}&hubSessionStorage=${POST_DATAHUB_URL}/${UUID}&virusBrowserMode=1`;
            // DATAHUB_URL = `https://epigenomegateway.wustl.edu/browser`;
            console.log("Created datahub:", DATAHUB_URL);

            content = `<iframe
																id="browser-embed"
																src="${DATAHUB_URL}"
																allowfullscreen>
															</iframe>`;
						const browserHandle = document.getElementById("browser-embed");
            if (browserHandle && active === 4 && DATA.length > 0) {
              browserHandle.contentDocument.location.reload(true);
            }
          }
        })
        .catch(err => {
          console.log(err);
          error = err;
        });
      // }
		}
		// prevActive = active;
  });

  const unsubscribe = Cart.subscribe(async store => {
    const { data } = store;
		DATA = data;
		change_occured = true;
    // const browserHandle = document.getElementById("browser-embed");
    // if (browserHandle && active === 4 && DATA.length > 0) {
    //   browserHandle.contentDocument.location.reload(true);
    // }
  });

  onDestroy(() => {
    unsubscribe();
  });
</script>

<style>
  .iframe-container {
    /* border-top: 1px solid #ccc; */
    background-color: white;
    margin-top: -5vh;
  }

  :global(iframe) {
    width: 100%;
    height: calc(100vh);
    border: none;
    display: block;
    position: absolute;
    top: 0;
    left: 0;
  }
</style>

<div class="test">
  
  {#if uploaded}
		<div class="float-right mt-4">
    <a href={DATAHUB_URL} target="_blank"><Button><Label>View in new tab</Label></Button></a>
		</div>
		<div class="iframe-container">
			{@html content}
		</div>
  {:else if error}
    <p>{error}</p>
  {:else }
    <p>Generating datahub. Please wait...</p>
  <!-- {:else}
    <p>Add data in Data tab</p> -->
  {/if}
</div>
