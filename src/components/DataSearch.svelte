<script>
  import { onMount } from 'svelte';

	onMount(() => {
		setTimeout(() => {
			document.getElementById("my-component").style.display = "block";
		}, 3000)
	})
</script>

