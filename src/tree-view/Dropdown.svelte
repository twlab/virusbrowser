<script>
	import { createEventDispatcher } from 'svelte';
	const dispatch = createEventDispatcher();
	let criteria = [
		// { id: 1, text: 'Clade', key: 'clade' },
		// { id: 2, text: 'Location', key: 'location', leaflet: 0 },
		// { id: 3, text: 'Collection Date', key: 'collection_date', leaflet: 1 }
		{ id: 1, text: 'Clade', key: 'Clade' },
		{ id: 2, text: 'Location', key: 'Country' },
		{ id: 3, text: 'Collection Date', key: 'Date' }
	];

	let selected;
</script>

	<select bind:value={selected} on:change="{() => dispatch('option-select', selected)}">
		{#each criteria as item}
			<option value={item}>
				{item.text}
			</option>
		{/each}
	</select>

<!-- <p>selected criteria {selected ? selected.id : '[waiting...]'}</p> -->