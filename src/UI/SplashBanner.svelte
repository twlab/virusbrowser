<script>
  import { createEventDispatcher } from 'svelte';
  const dispatch = createEventDispatcher();
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
      The Wuhan Coronavirus 
    </h1>
    <p
      class="leading-normal text-base md:text-2xl mb-8 text-center md:text-left
      slide-in-bottom-subtitle">
      Since its debut in mid-December, 2019, the zoonotic Wuhan Coronavirus or 2019-nCoV has rapidly spread from its origin in Wuhan, China, to several countries across the globe, leading to a global health crisis. Research efforts have begun sequencing the 29 kb virus genome, allowing for comparisons between the novel virus and close relatives. The WashU Virus Genome Browser is home to the genomic sequences of 16 2019-nCoV strains, as well as hundreds of related viruses, including severe acute respiratory syndrome coronavirus (SARS-CoV), Middle East respiratory syndrome coronavirus (MERS-CoV), and Ebola virus. In addition to several included data tracks, the browser supports user-uploaded sequences, as well as two visualization platforms: a genomic track view and a phylogenetic tree view. Our hope is that the WashU Virus Genome Browser will serve as an efficient tool, aiding researchers in better understanding the disease.    </p>
  </div>
  <div class="flex flex-col w-full xl:w-2/5 p-16 justify-center lg:items-start 
    overflow-y-hidden">
    <div on:click={() => dispatch('start')} class="bg-gray-300 text-gray-700 font-semibold py-6 px-6 rounded flex justify-center items-center cursor-pointer">Browse Data</div>
  </div>
  <!--Right Col-->
</div>
