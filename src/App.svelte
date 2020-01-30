<script>
  import SplashBanner from "./UI/SplashBanner.svelte";
  import TreeComponent from "./components/TreeComponent.svelte";
  import Footer from "./UI/Footer.svelte";
  import Nav from "./UI/Nav.svelte";
</script>

<style>

</style>

<div
  class="pb-12 bg-right bg-cover"
  style="background-image:url('/images/bg.svg');">
  <!--Nav-->
  <Nav />
    <div class="h-screen">
      <TreeComponent />
    </div>
  <SplashBanner />
  <Footer class="mt-14"/>

</div>
