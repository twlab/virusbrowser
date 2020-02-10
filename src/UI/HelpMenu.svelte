<script>
  import { createEventDispatcher } from 'svelte';
  import { Icon, Label } from "@smui/tab";
  let selected = 0;
  export let items;

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

<div class="h-10 w-32">
  <div class="dropdown inline-block relative">
    <button
      class="bg-gray-300 text-gray-700 font-semibold py-2 px-4 rounded
      inline-flex items-center">
      <span class="mr-1"><Icon class="material-icons">help</Icon></span>
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
      {#each items as item}
        <li
          class="bg-gray-200 hover:bg-gray-400 py-2 px-4 block
          whitespace-no-wrap"
          on:click={updateSelected(item.k)}>
          <a href={item.url}>
            <Icon class="material-icons">{item.icon}</Icon>
            <Label>
              {item.label}
            </Label>
          </a>
        </li>
      {/each}
    </ul>
  </div>
</div>
