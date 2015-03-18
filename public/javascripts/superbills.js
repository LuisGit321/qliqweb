$( document ).ready( function(){
    /* Accordion section */
    accordion_settings = {
        autoHeight  : false,
        collapsible : true
    };
    $( '.accordion' ).accordion( accordion_settings );
    /* End Accordion section */

    /* quickSearch section */
    $( 'input.superbill-search' ).each( function(){
        var ul_id = $( this ).parent().children( 'ul.cpt' ).attr( 'id' );
        var selector = 'ul#' + ul_id + ' li';
        $( this ).quicksearch( selector );
    } );
    /* EndquickSearch section */
} );
