<script>
  import { createEventDispatcher } from "svelte";
  const dispatch = createEventDispatcher();
</script>
<div id="preloader">
      <div id="status"></div>
    </div>

    
    
    <section class="hero is-fullheight is-default is-bold">
  

<nav class="navbar is-fresh is-transparent no-shadow" role="navigation" aria-label="main navigation">
  <div class="container">
    <div class="navbar-brand">
      <!-- <a class="navbar-item" href="/">
        <img src="/fresh/images/logos/virus-browser-logo.svg" alt="" width="112" height="28">
      </a> -->

      <a role="button" class="navbar-burger" aria-label="menu" aria-expanded="false" data-target="navbar-menu" href="/">
        <span aria-hidden="true"></span>
        <span aria-hidden="true"></span>
        <span aria-hidden="true"></span>
      </a>
    </div>

      <div id="navbar-menu" class="navbar-menu is-static">

        <div class="navbar-end">
          <a href="/about" class="navbar-item is-secondary">
            About
          </a>
          <div class="navbar-item has-dropdown is-hoverable">
            <a class="navbar-link" href="/">
              Featured Datahubs
            </a>

            <div class="navbar-dropdown">
              <a href="https://epigenomegateway.wustl.edu/browser/?genome=hg38&hub=https://wangftp.wustl.edu/~jflynn/virus_genome_browser/Blanco_melo_et_al/blanco_melo_et_al.json" class="navbar-item">
                Human transcriptional responses to SARS-CoV-2
              </a>
              <!-- <a href="/" class="navbar-item">
                Dropdown item
              </a>
              <a href="/" class="navbar-item">
                Dropdown item
              </a> -->
            </div>
          </div>
        </div>
      </div>
  </div>
</nav>

  

<nav id="navbar-clone" class="navbar is-fresh is-transparent" role="navigation" aria-label="main navigation">
  <div class="container">
    <div class="navbar-brand">
      <!-- <a class="navbar-item" href="/">
        <img src="/images/logos/virus-browser-logo.svg" alt="" width="112" height="28">
      </a> -->

      <a role="button" class="navbar-burger" aria-label="menu" aria-expanded="false" data-target="cloned-navbar-menu" href="/">
        <span aria-hidden="true"></span>
        <span aria-hidden="true"></span>
        <span aria-hidden="true"></span>
      </a>
    </div>

    <div id="cloned-navbar-menu" class="navbar-menu is-fixed">

      <div class="navbar-end">
        <a href="/about" class="navbar-item is-secondary">
          About
        </a>
        <!-- <div class="navbar-item has-dropdown is-hoverable">
          <a class="navbar-link" href="/">
            Dropdown
          </a>

          <div class="navbar-dropdown">
            <a href="/" class="navbar-item">
              Dropdown item
            </a>
            <a href="/" class="navbar-item">
              Dropdown item
            </a>
            <a href="/" class="navbar-item">
              Dropdown item
            </a>
          </div>
        </div> -->
      </div>
    </div>
</div>
</nav>


<div class="hero-body">
  <div class="container">
    <div class="columns is-vcentered">
      <div class="column is-10 is-offset-1 landing-caption">
        <h1 class="title is-1 is-bold is-spaced">
          WashU Virus Genome Browser
        </h1>
        
        <h2 class="subtitle is-10">
          Explore the many ways to visualize viral sequencing data on our openly available platform.
        </h2>
        
        
          <div class="button cta rounded primary-btn raised" on:click={() => dispatch('start')}>
            Get started
          </div>
        
      </div>
      <!-- <div class="column is-6 is-offset-1">
        <figure class="image is-4by3">
                    <img class="pushed-image" src="/fresh/images/illustrations/mockups/app-mockup.png">
        </figure>
      </div> -->
    </div>
  </div>
</div>

<hr>
<div class="hero-body">
  <div class="container">
    <div class="columns is-vcentered">
      <div class="column is-4 is-offset-1 landing-caption">
        <h1 class="title is-1 is-bold is-spaced">
          Browser View
        </h1>
        
        <h2 class="subtitle is-5 is-muted">
          Compare -omics data across multiple SARS-CoV-2 strains or between SARS-CoV-2 and related viral sequences
        </h2>
        
        <!-- <p>
          <a class="button cta rounded primary-btn raised" href="#">
            Get started
          </a>
        </p> -->
      </div>
      <div class="column is-6 is-offset-1">
        <figure class="image is-4by3">
          <img src="/fresh/images/gifs/out.gif" alt="Description">
        </figure>
      </div>
    </div>
  </div>
</div>

<hr>
<div class="hero-body">
  <div class="container">
    <div class="columns is-vcentered">
      
      <div class="column is-6 is-offset-1">
        <figure class="image is-4by3">
          <img src="/fresh/images/gifs/2.gif" alt="Description">
        </figure>
      </div>
      <div class="column is-4 is-offset-1 landing-caption">
        <h1 class="title is-1 is-bold is-spaced">
          Datahub Therapeutic Utility
        </h1>
        
        <h2 class="subtitle is-5 is-muted">
          Identify predicted antigenic epitopes conserved across SARS-CoV-2 sequences and locate optimal primer locations
        </h2>
        
        <!-- <p>
          <a class="button cta rounded primary-btn raised" href="#">
            Get started
          </a>
        </p> -->
      </div>
    </div>
  </div>
</div>
<hr>
<div class="hero-body">
  <div class="container">
    <div class="columns is-vcentered">
      
      
      <div class="column is-4 is-offset-1 landing-caption">
        <h1 class="title is-1 is-bold is-spaced">
          Tree View
        </h1>
        
        <h2 class="subtitle is-5 is-muted">
          Visualize a strain of interest in the phylogenetic context of all available species strains
        </h2>
        
        <!-- <p>
          <a class="button cta rounded primary-btn raised" href="#">
            Get started
          </a>
        </p> -->
      </div>
      <div class="column is-6 is-offset-1">
        <figure class="image is-4by3">
          <img src="/fresh/images/gifs/3.gif" alt="Description">
        </figure>
      </div>
    </div>
  </div>
</div>
  
<div class="hero-foot mb-20">
  <div class="container">
    <div class="tabs is-centered">
      <ul>
      <p class="has-text-centered mb-10 section-feature-grey">
      <a class="button cta is-large rounded secondary-btn raised" href="https://www.youtube.com/watch?v=C-124zMbeto">
        Quick walkthrough
      </a>
    </p>
      </ul>
    </div>
  </div>
</div>
</section>
    
<!-- 
<section class="section section-feature-grey is-medium">
  <div class="container">
    <div class="columns">
      <div class="column is-10 is-offset-1">
        <div class="has-text-centered">
          <img class="pushed-image" src="/fresh/images/illustrations/mockups/app-mockup.png">
        </div>
      </div>
    </div>

    <div class="title-wrapper has-text-centered">
      <h2 class="title is-2">One platform</h2>
      <h3 class="subtitle is-5 is-muted">To rule them all</h3>
    </div>

    <p class="has-text-centered">
      <a class="button cta is-large rounded secondary-btn raised" href="https://www.youtube.com/watch?v=_Ewwwd3N0q0">
        Quick walkthrough
      </a>
    </p>
  </div>
</section> -->
    
<section class="section section-feature-grey is-medium">
  <div class="container">

  

    <div class="title-wrapper has-text-centered">
      <h2 class="title is-2 mt-10">Data Sources</h2>
      <!-- <h3 class="subtitle is-5 is-muted">with great responsibility</h3> -->
      <div class="divider is-centered"></div>
    </div>

    <div class="content-wrapper">
      <div class="columns">
        <div class="column is-one-third">
          <div class="feature-card is-bordered has-text-centered revealOnScroll delay-1" data-animation="fadeInLeft">
            <div class="card-title">
              <h4>NCBI Database</h4>
            </div>
            <div class="flex justify-center card-icon">
                <img src="/fresh/images/illustrations/icons/ncbi.png">
            </div>
            <div class="card-text">
                <p>Identify sequence deviation from the reference by colored bars</p>
            </div>
            <div class="card-action">
              <a href="https://www.ncbi.nlm.nih.gov/nuccore" class="button btn-align-md frost-btn raised">Learn more</a>
            </div>
          </div>
        </div>
        <div class="column is-one-third">
          <div class="feature-card is-bordered has-text-centered revealOnScroll delay-1" data-animation="fadeInLeft">
            <div class="card-title">
              <h4>Nextstrain Database</h4>
            </div>
            <div class="flex justify-center card-icon">
                <img src="/fresh/images/illustrations/icons/nextstrain.png">
            </div>
            <div class="card-text">
                <p>Completed genomes available to view in an interactive phylogenetic tree view</p>
            </div>
            <div class="card-action">
              <a href="http://data.Nextstrain.org/ncov.json" class="button btn-align-md frost-btn raised">Learn more</a>
            </div>
          </div>
        </div>
        <div class="column is-one-third">
          <div class="feature-card is-bordered has-text-centered revealOnScroll delay-1" data-animation="fadeInLeft">
            <div class="card-title">
              <h4>GISAID Database</h4>
            </div>
            <div class="flex justify-center card-icon">
                <img src="/fresh/images/illustrations/icons/gisaid.png">
            </div>
            <div class="card-text">
                <p>Continuously added to the browser in a SNV track format,</p>
            </div>
            <div class="card-action">
              <a href="https://www.gisaid.org" class="button btn-align-md frost-btn raised">Learn more</a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</section>
    

    
<!--     
<section class="section is-medium">
  <div class="container">
    <div class="columns">
      <div class="column is-centered-tablet-portrait">
        <h1 class="title section-title">You&#39;re here because you want the best</h1>
        <h3 class="subtitle is-5 is-muted">And we know it</h3>
        <div class="divider"></div>
      </div>
      <div class="column is-7 mt-60">
        <article class="media icon-box">
          <figure class="media-left">
            <p class="image">
              <img src="/fresh/images/illustrations/icons/laptop-globe.svg">
            </p>
          </figure>
          <div class="media-content mt-50">
            <div class="content">
              <p>
                <span class="icon-box-title">Browser view</span>

                <span class="icon-box-text">Compare -omics data across multiple SARS-CoV-2 strains or between SARS-CoV-2 and related viral sequences</span>
              </p>
            </div>
          </div>
        </article>
        <article class="media icon-box">
          <figure class="media-left">
            <p class="image">
              <img src="/fresh/images/illustrations/icons/doc-sync.svg">
            </p>
          </figure>
          <div class="media-content mt-50">
            <div class="content">
              <p>
                <span class="icon-box-title">Tree View</span>

                <span class="icon-box-text">Visualize a strain of interest in the phylogenetic context of all available species strains</span>
              </p>
            </div>
          </div>
        </article>
        <article class="media icon-box">
          <figure class="media-left">
            <p class="image">
              <img src="/fresh/images/illustrations/icons/mobile-feed.svg">
            </p>
          </figure>
          <div class="media-content mt-50">
            <div class="content">
              <p>
                <span class="icon-box-title">Datahub Therapeutic Utility</span>

                <span class="icon-box-text">Identify predicted antigenic epitopes conserved across SARS-CoV-2 sequences and locate optimal primer locations.</span>
              </p>
            </div>
          </div>
        </article>
      </div>
    </div>
  </div>
</section> -->
    

    
    
<!-- <section class="section section-feature-grey is-medium">
  <div class="container">
    <div class="columns">
      <div class="column is-10 is-offset-1">
        <div class="has-text-centered">
          <img class="pushed-image" src="/fresh/images/illustrations/mockups/app-mockup.png">
        </div>
      </div>
    </div>

    <div class="title-wrapper has-text-centered">
      <h2 class="title is-2">One platform</h2>
      <h3 class="subtitle is-5 is-muted">To rule them all</h3>
    </div>

    <p class="has-text-centered">
      <a class="button cta is-large rounded secondary-btn raised" href="https://www.youtube.com/watch?v=_Ewwwd3N0q0">
        Quick walkthrough
      </a>
    </p>
  </div>
</section> -->
    

    

    
    <!-- <section class="section section-light-grey is-medium">
  <div class="container">
    <div class="title-wrapper has-text-centered">
      <h2 class="title is-2 is-spaced">Drop us a line or two </h2>
      <h3 class="subtitle is-5 is-muted">We'd love to hear from you</h3>
      <div class="divider is-centered"></div>
    </div> 

    <div class="content-wrapper">
      <div class="columns">
        <div class="column is-6 is-offset-3">
          <form action="mailto:dpurushotham136@gmail.com" method="post" enctype="application/x-www-form-urlencoded">
            <div class="columns is-multiline">
              <div class="column is-6">
                <input class="input is-medium" type="text" placeholder="Enter your name">
              </div>
              <div class="column is-6">
                <input class="input is-medium" type="email" placeholder="Enter your email address">
              </div>
              <div class="column is-12">
                <textarea class="textarea" rows="10" placeholder="Write someting..."></textarea>
              </div>
              <div class="form-footer has-text-centered mt-10">
                <button class="button cta is-large primary-btn raised is-clear">Send Message</button>
              </div>
            </div>
          </form>
        </div>
      </div>
    </div> 
  </div>
</section>-->
    

    
    
<footer class="footer footer-dark">
  <div class="container">
    <div class="columns">
      <div class="column">
        <div class="footer-logo">
          <img src="/fresh/images/logos/virus-browser-logo.svg">
        </div>
        <ul class="link-list mt-5">
          
          <li class="button is-muted">
          
        <a href="http://wang.wustl.edu">
          The Wang Lab @ Washington University in St. Louis
        </a>
      </li>
      </ul>
      </div>
        <div class="column">
          <div class="footer-column">
            <div class="footer-header">
                <h3>Docs</h3>
            </div>
            <ul class="link-list">
              
                <li>
                <a href="/manuscript/WashU_Virus_Genome_Browser.pdf">
                  Manuscript
                </a>
              
              </li>
              <li>
                <a href="https://virusgateway.readthedocs.io/en/latest/index.html">
                  User guides
                </a>
              </li>
            </ul>
          </div>
        </div>
      <div class="column">
        <div class="footer-column">
          <div class="footer-header">
            <h3>Follow Us</h3>
            <nav class="level is-mobile">
              <div class="level-left">
                <a class="level-item" href="https://github.com/debugpoint136/WashU-Virus-Genome-Browser">
                  <span class="icon"><i class="fa fa-github"></i></span>
                </a>
                <a class="level-item" href="https://www.youtube.com/channel/UCuIQetcmC5h1h_LXmhrlKrA">
                  <span class="icon"><i class="fa fa-youtube"></i></span>
                </a>
                <!-- <a class="level-item" href="https://www.facebook.com/groups/346647445406639">
                  <span class="icon"><i class="fa fa-facebook"></i></span>
                </a> -->
                <a class="level-item" href="https://twitter.com/wuepgg">
                  <span class="icon"><i class="fa fa-twitter"></i></span>
                </a>
              </div>
            </nav>
          </div>
        </div>
      </div>
    </div>
  </div>
</footer>
    
    


    
    <div id="backtotop"><a href="#"></a></div>