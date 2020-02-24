<script>
  import List, {
    Group,
    Item,
    Graphic,
    Meta,
    Label,
    Separator,
    Subheader,
    Text,
    PrimaryText,
    SecondaryText
  } from "@smui/list";
  import { Cart } from "../stores/Cart.js";
  import { onDestroy } from "svelte";

  let selectionIndex = null;
  let selectionTwoLine = "Stephen Hawking";
  let cartData;

  const unsubscribe = Cart.subscribe(async store => {
    const { data } = store;
    cartData = data;
  });

  onDestroy(() => {
    unsubscribe();
  });
</script>

<style>
  :global(.demo-list) {
    max-width: 40%;
    margin-top: 2rem;
    margin-right: 10%;
    border: 1px solid rgba(0, 0, 0, 0.1);
  }

  .main-body {
    display: flex;
    align-items: flex-start;
    justify-content: center;
    height: 80%;
    width: 100%;
  }
</style>

<div class="main-body">
  <List
    class="demo-list p-16"
    twoLine
    avatarList
    singleSelection
    bind:selectedIndex={selectionIndex}>
    <div class="flex justify-center">
      <div
        class="p-4 bg-gray-300 text-gray-700 rounded inline-flex items-center">
        Data
      </div>
    </div>
    {#each cartData as item}
      <Item
        on:SMUI:action={() => ((selectionTwoLine = item._id), Cart.addDataItems($Cart.data.filter(d => d.Accession !== item.Accession)))}
        selected={selectionTwoLine === item._id}>
        <Graphic
          style="background-image:
          url(https://via.placeholder.com/40x40.png?text={item._id});" />
        <Text>
          <PrimaryText>{item.Accession}</PrimaryText>
          <SecondaryText>{item.Organism}</SecondaryText>
        </Text>
        <Meta class="material-icons">cancel</Meta>
      </Item>
    {/each}
  </List>

</div>
