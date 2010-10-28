/*
* grid.js  Copyright Robbie Straw, 2010. All Rights Reserved.
* This code implements some necessary functions to save gridstate, load gridstate, and periodically update gridstate
* None of this code would work if it weren't for the awesome drag.js library and jQuery framework! :-)!
* This code shares the license embodying the entirety of the qRPSd project.
* The latest licensing information can be found at http://github.com/drbawb/qrpsd
* This code relies on:
*  - jQuery (1.4.2)
*  - "Drag and Drop Table Content" library @ http://www.redips.net/javascript/drag-and-drop-table-content/
* ======================
* Robbie Straw
* drbob@soggymilk.com
* OR
* webtravesty@gmail.com
*
*
* For use on qRPSd - [this comment block] updated 2010/10/26
*/

var t; //Placeholder for a timeout
var testObj;
function blank() { //[relies on jQuery - clears a table with the exception of it's top/left edge]
  $('.drag').qtip('destroy');
  $('#table2 tr:nth-child(n+2) td:nth-child(n+2)').each(function(index, Row) {
	$(this).empty();
  });
  
}
function save(object, target) { //Saves the grid and returns a string
	/* var content = REDIPS.drag.save_content(2); */
        target = target.split("_");
        target[0] = object;
        content = target.join("_");
	return content;
}



function load(size,table,query) {
	blank('table1', '27');
        query = JSON.parse(query);
        if (query.length > 0) {
            len = query.length;
            for ( i=0; i < len; i++ ) { //Go over each tokenid/locale pair
                    token = query[i];
                    id = token.id; //token id is 0 part.
                    pic = ROOT_PATH + 'images/tokens/' + token.image; //Image URL is the first part
                    row = token.tblrow; //Row is part 2
                    col = token.tblcol; //Col is part 3
                    $('#n_'+row+'_'+col).append("<div class='drag' id='"+id+"'><img src='"+pic+"' alt='"+pic+"' /></div>");
                    $('.drag#' + id ).qtip({
                       content: '<strong>Turn Order</strong>:'+ token.turn_order +'<br /> <strong>HP</strong>:' + token.hp + '!',
                       style: {
                              name: 'dark' // Inherit from preset style
                       }
                    });
                    /*
                    old_content = document.getElementById('n_'+row+'_'+col).innerHTML
                    document.getElementById('n_'+row+'_'+col).innerHTML=old_content + "<div class='drag' id='"+id+"'><img src='"+pic+"' alt='"+pic+"' /></div>";
                    */
            }
            REDIPS.drag.init()
        }
}



REDIPS.drag.myhandler_clicked = function () {
  var obj = REDIPS.drag.obj;
  //$(".drag#"+obj.id).qtip('destroy');
  clearTimeout(t);
}

REDIPS.drag.myhandler_notmoved = function () {
  t = setTimeout("repeatRefreshGrid()", 5000);
}

REDIPS.drag.myhandler_dropped = function () {
  var obj = REDIPS.drag.obj; // reference to the dragged OBJect
  var mea = REDIPS.drag.marked_exception;	// reference to the Marked Exception Array
  var tcn = REDIPS.drag.target_cell; // reference to the Target cell Class Name
  var msg; // message text
  // if the DIV element was placed on allowed cell, then make it a unmovable
  // { secretsauce: save(obj.id, tcn.id) },
  $.ajax({
    type: "POST",
    url: ROOT_PATH + "grids/" + GRID_ID + "/tokens/" + obj.id + ".json",
    dataType: 'json',
    data: { _method: 'PUT', token: {tblrow: tcn.id.split("_")[1], tblcol: tcn.id.split("_")[2]} }
  });
  t = setTimeout("repeatRefreshGrid()", 5000);
}
REDIPS.drag.myhandler_deleted = function () {
  var dobj = REDIPS.drag.obj; //ref to deleted object? (poke to inspect)
  var dmea = REDIPS.drag.marked_exception; //reff to marked exc array
  var dtcn = REDIPS.drag.target_cell.className; // ref to target cell cass name
  var dsrc = REDIPS.drag.source_cell
  $.ajax({
    type: "POST",
    url: ROOT_PATH + "tokens/" + dobj.id + ".js",
    data: { _method: 'DELETE', cell: dsrc.id }
  });
  
  t = setTimeout("repeatRefreshGrid()", 5000);
}

  function repeatRefreshGrid() {
    $.ajax({
      url: ROOT_PATH + 'grids/' + GRID_ID + '.js',
      dataType: "text",
      success: function(data) {
        reloadGrid(data);
      }
    });
    t = setTimeout("repeatRefreshGrid()", 5000);
  }
  
  function reloadGrid(data) {
    blank();
    load('26', 'table2', data);
    REDIPS.drag.init();
  }

$(document).ready(function() {
  repeatRefreshGrid();
});
