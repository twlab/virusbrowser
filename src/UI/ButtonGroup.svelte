<script>
  import Button, {Group, GroupItem, Label, Icon} from '@smui/button';
  import { createEventDispatcher } from "svelte";
  let indent = 'right';
  const dispatch = createEventDispatcher();
  $: {
    dispatch("indent-change", indent);
  }

</script>

<Group variant="outlined">
  <Button  color="secondary" on:click={() => indent = 'left'} variant={indent === 'left' ? 'raised' : 'outlined'}><Icon class="material-icons">format_align_left</Icon></Button>
  <Button  color="secondary" on:click={() => indent = 'right'} variant={indent === 'right' ? 'raised' : 'outlined'}><Icon class="material-icons">format_align_right</Icon></Button>
</Group>



