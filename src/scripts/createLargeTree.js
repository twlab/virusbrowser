require('./phyloTreeMain');
export function createLargeTree(FILEPATH) {
  var main_tree,
    guide_tree,
    parsed;
  d3.text(FILEPATH, function (error, newick) {
    main_tree = d3.layout.phylotree()
      // create a tree layout object
      .svg(d3.select("#tree_display"))
    // render to this SVG element
    parsed = d3.layout.newick_parser(newick)
    // console.log(parsed);
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
  });
}

function is_leaf(node){ return node.name && node.name != 'root' && isNaN(parseFloat(node.name.slice(0, 1)));}
