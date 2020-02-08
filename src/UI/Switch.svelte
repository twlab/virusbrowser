<script>
  import { createEventDispatcher } from "svelte";
  import Switch from "@smui/switch";
  import FormField from "@smui/form-field";
  let selected = false;
  const dispatch = createEventDispatcher();

  $: {
    dispatch("mode-change", selected);
  }
</script>

<div class="flex py-16">
  <div class="px-2 mx2">
    <FormField>
      <span slot="label">Linear</span>
    </FormField>
  </div>
  <div class="px-2 mx2">
    <FormField>
      <Switch bind:checked={selected} />
      <span slot="label">Radial</span>
    </FormField>
  </div>
</div>
