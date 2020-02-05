<script>
  import { createEventDispatcher } from 'svelte'
  let selected = "nCov";
  export let names;

  const dispatch = createEventDispatcher();
  function updateSelected(input) {
    selected = input
    dispatch('reference-select', selected);
  }
  
</script>

<style>
  .dropdown:hover .dropdown-menu {
    display: block;
  }
</style>

<div class="p-10">

  <div class="dropdown inline-block relative">
    <button
      class="bg-gray-300 text-gray-700 font-semibold py-2 px-4 rounded
      inline-flex items-center">
      <span class="mr-1">{selected}</span>
      <svg
        class="fill-current h-4 w-4"
        xmlns="http://www.w3.org/2000/svg"
        viewBox="0 0 20 20">
        <path
          d="M9.293 12.95l.707.707L15.657 8l-1.414-1.414L10 10.828 5.757 6.586
          4.343 8z" />
      </svg>
    </button>
    <ul class="dropdown-menu absolute hidden text-gray-700 pt-1">
      {#each names as item}
        <li
          class="bg-gray-200 hover:bg-gray-400 py-2 px-4 block
          whitespace-no-wrap"
          on:click={updateSelected(item)}>
          {item}
        </li>
      {/each}

    </ul>
  </div>

</div>
