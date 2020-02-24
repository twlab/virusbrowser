<script>
  import { onDestroy, afterUpdate, onMount } from "svelte";
  import { Cart } from "../stores/Cart.js";
  import { saveDataOnWindow } from "../scripts/saveDataOnWindow";
  import { createDatahub } from "../scripts/createDatahub";
  import FILESJSON from "../json/pairwise.json";
  import axios from "axios";
  import uuid from "uuid";
  export let virusName;
  export let active; // 4 if tab is active
  let DATA;
  let uploaded = false;
  let error;
  let content;
  let DATAHUB_URL;
	let prevActive;
	let change_occured = false;

  const POST_DATAHUB_URL =
    "https://5dum6c4ytb.execute-api.us-east-1.amazonaws.com/dev/datahub";
  const BROWSER_URL =
    "http://eg-react.s3-website-us-east-1.amazonaws.com/browser";

  const GENOME_NAME_MAP = {
    ncov: "nCoV2019",
    mers: "MERS",
    sars: "SARS",
    ebola: "Ebola"
	};
	
	onMount(() => {
		content = `<iframe
																id="browser-embed"
																src="/browser"
																allowfullscreen>
															</iframe>`;
	})

  afterUpdate(() => {
    if (change_occured && active === 4) {
      const UUID = uuid.v4();
      let { tracks } = saveDataOnWindow($Cart.data, virusName, FILESJSON);
      // let generatedDatahub = createDatahub(content.tracks);
      const toPost = {
        _id: UUID,
        files: [],
        hub: { content: tracks },
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
            DATAHUB_URL = `/browser/?genome=${GENOME_NAME_MAP[virusName]}&hub=${POST_DATAHUB_URL}/${UUID}`;
            console.log("Created datahub:", DATAHUB_URL);

            content = `<iframe
																id="browser-embed"
																src="${DATAHUB_URL}"
																allowfullscreen>
															</iframe>`;
						const browserHandle = document.getElementById("browser-embed");
						console.log(browserHandle);
            if (browserHandle && active === 4 && DATA.length > 0) {
              browserHandle.contentDocument.location.reload(true);
            }
          }
        })
        .catch(err => {
          console.log(err);
          error = err;
				});
				change_occured = false;
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
    border-top: 1px solid #ccc;
    background-color: white;
    margin-top: 5vh;
  }

  :global(iframe) {
    width: 100%;
    height: calc(100vh - 3em);
    border: none;
    display: block;
    position: absolute;
    top: 1;
    left: 0;
  }
</style>

<div class="test">
  
  {#if uploaded && DATA.length > 0}
    <a href={DATAHUB_URL} target="_blank">View in new tab</a>
		<div class="iframe-container">
			{@html content}
		</div>
  {:else if error}
    <p>{error}</p>
  {:else if DATA.length > 0}
    <p>Generating datahub. Please wait...</p>
  {:else}
    <p>Add data in Data tab</p>
  {/if}
</div>
