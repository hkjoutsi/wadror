/*
$(document).ready(function () {
    $.getJSON('BREWERIES.json', function (BREWERIES) {
        oluet = BREWERIES
        $("#BREWERIES").html("oluita löytyi "+oluet.length);
    });
}); */

var BREWERIES = {};


BREWERIES.show = function(){
    $("#brewerytable tr:gt(0)").remove();

    var table = $("#brewerytable");

    $.each(BREWERIES.list, function (index, brewery) {
        table.append('<tr>'
            +'<td>'+brewery['name']+'</td>'
            +'<td>'+brewery['year']+'</td>'
            +'<td>'+ brewery['noOfBeers'] +'</td>' //no of beers 0 atm
            +'</tr>');
    });
};

BREWERIES.sort_breweries_by_name = function(){
    BREWERIES.list.sort( function(a,b){
        return a.name.toUpperCase().localeCompare(b.name.toUpperCase());
    });
};

BREWERIES.sort_by_year = function(){
    BREWERIES.list.sort( function(a,b){
        return a.year > b.year;
    });
};

BREWERIES.sort_by_no_of_beers = function(){
    BREWERIES.list.sort( function(a,b){
        return a.noOfBeers < b.noOfBeers;
    });
};

$(document).ready(function () {
    $("#breweryName").click(function (e) {
        BREWERIES.sort_breweries_by_name();
        BREWERIES.show();
        e.preventDefault();
    });

    $("#year").click(function (e) {
        BREWERIES.sort_by_year();
        BREWERIES.show();
        e.preventDefault();
    });

    $("#noOfBeers").click(function (e) {
        BREWERIES.sort_by_no_of_beers();
        BREWERIES.show();
        e.preventDefault();
    });

    if ( $("#brewerytable").length>0 ) {
      $.getJSON('brewerylist.json', function (breweries) {
        BREWERIES.list = breweries;
        //BREWERIES.sort_breweries_by_name;
        BREWERIES.show();
      });
    }

});