<script>
  import { COLORS } from './scripts/colors';
  export let CRITERIA;
  export let metadata;
  let terms = [];
  $: {
      const metadataByCriteria = metadata.map(d => {
      if (Array.isArray(d[CRITERIA.key])) {
          return d[CRITERIA.key][CRITERIA.leaflet]
        } else {
          return d[CRITERIA.key];
        }
      })
      terms = [...new Set(metadataByCriteria)];
  }

  const monthName = {
    '01': 'January, 2020',
    '02': 'February, 2020',
    '03': 'March, 2020',
    '12': 'December, 2019',
    '04': 'April, 2020',
    '05': 'May, 2020'
  }

  function getValueFromJSON(key) {
    const index = terms.findIndex(d => d === key);
    return COLORS[index];
  }
</script>

<div>
{#if CRITERIA.id === 3}
   <p class="text-center">Month</p>
{:else if  CRITERIA.id === 2}
   <p>Country</p>
{:else}
   <p>Clade</p>
{/if}

{#each terms as item}
  <svg width="250" height="20">
    <g>
    <rect x="0" y="0" width="15" height="15" style="fill:{getValueFromJSON(item)};stroke-width:3;stroke:{getValueFromJSON(item)}" />
    {#if CRITERIA.id === 3}
      <text x="25" y="12" font-family="Verdana" font-size="12" fill="grey">{monthName[item] || item || 'N/A'}</text>
    {:else}
      <text x="25" y="12" font-family="Verdana" font-size="12" fill="grey">{item}</text>
    {/if}
    </g>
  </svg>
{/each}
</div>