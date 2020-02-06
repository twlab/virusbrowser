<script>
  import { createEventDispatcher } from 'svelte';
  const dispatch = createEventDispatcher();
</script>
<!--Main-->
<div
  class="container pt-24 md:pt-48 px-6 mx-auto flex flex-wrap flex-col
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
       or 2019-nCoV belongs to the Betacoronavirus, which is one of four genera of coronaviruses of the subfamily Orthocoronavirinae in the family Coronaviridae, of the order Nidovirales. These are enveloped, ssRNA positive-strand viruses of zoonotic origins. It is one of the largest RNA virus genomes varying from 27kb to 32kb in size, with this particular strain ringing in at 29,903 bps long. 
    </p>
  </div>
  <div class="flex flex-col w-full xl:w-3/5 p-16 justify-center lg:items-start
    overflow-y-hidden">
    <div on:click={() => dispatch('start')} class="bg-gray-300 text-gray-700 font-semibold py-6 px-6 rounded inline-flex items-center cursor-pointer">Browse Data</div>
  </div>
  <!--Right Col-->
</div>
