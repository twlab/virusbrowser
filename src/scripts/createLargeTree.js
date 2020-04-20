require('./phyloTreeMain');
import {COLORS} from './colors';
import { Cart } from '../stores/Cart';

export function createLargeTree(VIRUSNAME, CART_DATA, METADATA, MODE, INDENT, addDataToCart) {
  console.log(METADATA)
  const metadataList = makeMetadataTerms(METADATA);
  console.log(metadataList);
  let FILEPATH;
  if (VIRUSNAME === 'ncov') {
    // FILEPATH = 'https://wangftp.wustl.edu/~cfan/public_viralBrowser/ncov/daily_updates/latest/strain_updated.fa.tree'
    FILEPATH = 'https://wangftp.wustl.edu/~cfan/public_viralBrowser/ncov/daily_updates/test/strain_updated.fa.tree' // TEST
  } else {
    FILEPATH = `/data/${VIRUSNAME}_align.tree`;
  }
  var main_tree,
    guide_tree,
    parsed;

  // tooltip

  var div = d3
    .select("body")
    .append("div")
    .attr("class", "tooltip")
    .style("opacity", 0);

  d3.text(FILEPATH, function (error, newick) {

    const RIGHT_ALIGN_SWITCH = (INDENT === 'left')
      ? false
      : true;

    var tree = d3
      .layout
      .phylotree()
      // create a tree layout object
      .svg(d3.select("#tree_display"))
      .align_tips(RIGHT_ALIGN_SWITCH)
      .options({brush: false, zoom: true, "show-scale": RIGHT_ALIGN_SWITCH})
    // render to this SVG element

    var attribute_to_color = d3
      .scale
      .category10();
    var standard_label = tree.branch_name();

    tree.branch_name(function (node) {
      return standard_label(node) + "             ";
    });

    tree(d3.layout.newick_parser(newick));

    if (MODE === 'radial') {
      setTimeout(() => {
        tree
          .radial(!tree.radial())
          .placenodes()
          .update();
      }, 500);
    }

    if (MODE === 'linear' && INDENT === 'right') {

      var tree_attributes = {};

      /* the following loop just populates an object with key : value pairs like
        leaf_name -> [a,b,c], where a,b,c are random numbers in {0,1,2,3,4}
    */

      var maximum_length = 0;

      tree.traverse_and_compute(function (node) {
        if (d3.layout.phylotree.is_leafnode(node)) {
          tree_attributes[node.name] = fetchMetadataColors(node.name, METADATA, metadataList);
          maximum_length = maximum_length < node.name.length
            ? node.name.length
            : maximum_length;
        }
      });

      tree.style_nodes(function (element, node_data) {
        
        if (node_data.name in tree_attributes) { // see if the node has attributes
          var node_label = element.select("text");
          var font_size = parseFloat(node_label.style("font-size"));

          element.style("font-style", node_data['text-italic'] ? "italic" : "normal"); // dpuru
          element.style("fill", node_data['text-italic'] || CART_DATA.filter(d => d.Accession === node_data.name).length > 0 ? "#0150A0" : "grey"); // dpuru
          element.style("cursor", "pointer");
          var annotation = element
            .selectAll("rect")
            .data(tree_attributes[node_data.name]);
          annotation
            .enter()
            .append("rect");
          annotation
            .attr("width", font_size)
            .attr("height", font_size)
            .attr("y", -font_size / 2)
            .style("fill", function (d, i) {
              return d.color;
            })
            .on("mouseover", function (d) {
              div
                .transition()
                .duration(200)
                .style("opacity", .9);
              div
                .html(d.metadata)
                .style("left", (d3.event.pageX) + "px")
                .style("top", (d3.event.pageY - 28) + "px");
            })
            .on("mouseout", function (d) {
              div
                .transition()
                .duration(500)
                .style("opacity", 0);
            });

          var move_past_label = maximum_length * 0.75 * font_size;

          var x_shift = tree.shift_tip(node_data)[0] + move_past_label;
          annotation
            .attr("transform", null)
            .attr("x", function (d, i) {
              return x_shift + font_size * i;
            });
        }
      });
    }

    // =======================
    function my_node_style_text(node) {
      node['text-italic'] = !node['text-italic'];
      d3.layout.phylotree.trigger_refresh(tree);
    }
    
    function my_menu_title(node) {
      if (node['text-italic']) {
        return "Remove from Cart";
      }
      return "Add to Cart";
    }
    
    function my_style_nodes(element, node) {
      // console.log(element, node)
      element.style("font-style", node['text-italic'] ? "italic" : "normal");
      element.style("fill", node['text-italic'] ? "aquamarine" : "grey");
    }

    tree.get_nodes()
      .filter(d3.layout.phylotree.is_leafnode)
      .forEach(function(tree_node) {
      d3.layout.phylotree.add_custom_menu(tree_node, // add to this node
        my_menu_title, // display this text for the menu
        function() {
          my_node_style_text(tree_node);
          addDataToCart(tree_node);
        },
        // on-click callback include a reference to tree_node via transitive closure
        d3.layout.phylotree.is_leafnode // condition on when to display the menu
        // a function that takes node as an argument
      );
    });

    // =======================
    // parse the Newick into a d3 hierarchy object with additional fields
    // tree.style_nodes(my_style_nodes).layout();
    // tree.style_nodes(my_style_nodes);
    tree.layout();

    // TODO: export this function, provide a button to hide the node (query by name)
    // setTimeout(() => {   main_tree.modify_selection([_nodes[2]], "notshown",
    // true, true)                 .update_has_hidden_nodes() .update();
    // console.log('Hiding following nodes ' + __nodes.map(d => d.name).join(', '));
    //   } , 5000);
    //

  });
}

function makeMetadataTerms(list) {

  let allItems = [];
  list.forEach(item => {
    // console.log(item)
    // const {Organism, Molecule_Type, Isolate, country, year} = sanitizeMetadataItem(item);
    const {Organism, Molecule_Type, Isolate, Country, Collection_Date} = item;

    // allItems.push(Organism);
    // allItems.push(Molecule_Type);
    // allItems.push(Isolate);
    allItems.push(Country);
    allItems.push(Collection_Date);

  })

  return new Set(allItems);

}

function fetchMetadataColors(accession, METADATA, metadataTermsSet) {

  let metadataTerms = [...metadataTermsSet];

  let colorsResult = [];
  const element = METADATA.filter(d => d.Accession === accession)[0];
  if (!element) {
    console.log(accession)
  }
  // const {Organism, Molecule_Type, Isolate, country, year} = sanitizeMetadataItem(element);
  const {Organism, Molecule_Type, Isolate, Country, Collection_Date} = element;

  // colorsResult.push({
  //   color: COLORS[metadataTerms.indexOf(Organism)],
  //   metadata: Organism
  // });
  // colorsResult.push({
  //   color: COLORS[metadataTerms.indexOf(Molecule_Type)],
  //   metadata: Molecule_Type
  // });
  // colorsResult.push({
  //   color: COLORS[metadataTerms.indexOf(Isolate)],
  //   metadata: Isolate
  // });
  colorsResult.push({
    color: COLORS[metadataTerms.indexOf(Country)],
    metadata: Country
  });
  colorsResult.push({
    color: COLORS[metadataTerms.indexOf(Collection_Date)],
    metadata: Collection_Date
  });

  
  return colorsResult;

}

function sanitizeMetadataItem(item) {
  console.log(item)
  const {Organism, Molecule_Type, Isolate, Country, Collection_Date} = item;
  let splitStr = Collection_Date.split("-");
  let year = (splitStr.length !== 0)
    ? splitStr[splitStr.length - 1]
    : "N/A";
  let country = Country.split(":")[0];

  return {Organism, Molecule_Type, Isolate, country, year}
}

