<script>
  import { createEventDispatcher } from "svelte";
  const dispatch = createEventDispatcher();
  export let virusName, fullNames;
  console.log(virusName);
  const GENOME_NAME_MAP = {
    ncov: "SARS-CoV-2",
    mers: "MERS",
    sars: "SARS",
    ebola: "Ebola"
  };
  console.log(fullNames[GENOME_NAME_MAP[virusName]]);

</script>

<!--Main-->
<div
  class="container pt-12 md:pt-24 px-6 mx-auto flex flex-wrap flex-col
  md:flex-row items-center block">

  <!--Left Col-->
  <div class="right-banner w-full xl:w-3/5 py-6 overflow-y-hidden text-xl">
    <h1
      class="my-4 text-3xl md:text-5xl text-purple-800 font-bold leading-tight
      text-center md:text-left slide-in-bottom-h1">
      {fullNames[GENOME_NAME_MAP[virusName]].name}
    </h1>
    <p
      class="leading-normal text-base md:text-2xl mb-8 text-center md:text-left
      slide-in-bottom-subtitle">
      {fullNames[GENOME_NAME_MAP[virusName]].desc}
    </p>
  </div>
  <div
    class="flex flex-col w-full xl:w-2/5 p-16 justify-center lg:items-start
    overflow-y-hidden">
    <div
      on:click={() => dispatch('start')}
      class="bg-gray-300 text-gray-700 font-semibold py-6 px-6 rounded flex
      justify-center items-center cursor-pointer">
      Browse Data =>
    </div>
  </div>
  <!--Right Col-->
</div>
