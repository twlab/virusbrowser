require('./phyloTreeMain');
export function createLargeTree(FILEPATH, MODE) {
  var main_tree,
    guide_tree,
    parsed;
  d3.text(FILEPATH, function (error, newick) {

    
    main_tree = d3.layout.phylotree()
      // create a tree layout object
      .svg(d3.select("#tree_display"))
      // .align_tips (true)
      .options({
        brush: false,
        zoom: true,
        "show-scale": false
      })
    // render to this SVG element

    var attribute_to_color = d3.scale.category10();
    var standard_label = main_tree.branch_name();
    
    main_tree.branch_name (function (node) {
      return standard_label(node) + "             ";
    });
    

    parsed = d3.layout.newick_parser(newick)
    // console.log(parsed);


    //==================/
   

    var tree_attributes = {};
    
    /* the following loop just populates an object with key : value pairs like 
        leaf_name -> [a,b,c], where a,b,c are random numbers in {0,1,2,3,4}
    */
    
    var maximum_length = 0;
    
    // main_tree.traverse_and_compute (function (node) {
    //   if (d3.layout.phylotree.is_leafnode (node)) {
    //     tree_attributes[node.name] = [0,0,0].map (function () {return Math.floor(Math.random() * 5);});
    //     maximum_length = maximum_length < node.name.length ? node.name.length : maximum_length;
    //   }
    // });
    
    
    //  main_tree.style_nodes(function (element, node_data) {       
    //     if (node_data.name in tree_attributes) {   // see if the node has attributes
    //       var node_label = element.select("text");
    //       var font_size  = parseFloat (node_label.style ("font-size"));
          
              
          
    //       var annotation = element.selectAll ("rect").data (tree_attributes[node_data.name]);
    //       annotation.enter().append ("rect");
    //       annotation.attr ("width", font_size)
    //         .attr ("height", font_size)
    //         .attr ("y", -font_size/2).style ("fill", function(d, i) {
    //           return attribute_to_color (d);
    //          });
          
    //       var move_past_label = maximum_length * 0.75 * font_size;
          
    //       var x_shift = main_tree.shift_tip (node_data)[0] + move_past_label;
    //       annotation.attr ("transform", null).attr ("x", function (d, i) { return  x_shift + font_size * i;});
                
    //     }
    // });
    //==================/
    let parsedLayout = main_tree(parsed)
    // parse the Newick into a d3 hierarchy object with additional fields
      .layout();
    // console.log(parsedLayout);
    // let nodes = main_tree.get_nodes();
    // console.log(nodes.filter(is_leaf));

    
    // let _nodes = main_tree.get_nodes().filter(n => parseFloat(n.attribute) < 0.001);
    // console.log(_nodes);
    // dpuru

    // var _hide = function(n) { 
    //   if (!main_tree.is_leafnode(n)) {
    //       n.children.forEach(_hide);
    //   }
    //   n.hidden = true;
    //   n.collapsed = true;
    // };
    // _nodes.forEach(_hide);

    let _nodes = main_tree.get_nodes().filter(d => d.depth === 1);
    console.log(_nodes);
    console.log(_nodes.length);
    // 

    let __nodes = main_tree.select_all_descendants(_nodes[2], true, true).filter(is_leaf);
    console.log(__nodes);


     // TODO: export this function, provide a button to hide the node (query by name)
    // setTimeout(() => {
    //   main_tree.modify_selection([_nodes[2]], "notshown", true, true)
    //                 .update_has_hidden_nodes()
    //                 .update();
    //   console.log('Hiding following nodes ' + __nodes.map(d => d.name).join(', '));
    //   }
    // , 5000);
    // 
    if (MODE === 'radial') {
      setTimeout(() => {
            main_tree.radial (!main_tree.radial ()).placenodes().update ();
        }, 500);
    }
  });
}

function is_leaf(node){ return node.name && node.name != 'root' && isNaN(parseFloat(node.name.slice(0, 1)));}
