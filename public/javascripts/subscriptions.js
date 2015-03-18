$( function() {

  /* BlockUI Section */
  $.blockUI.defaults.message = "<img src='/images/loading2.gif' />";
  /* End BlockUI Section */

  /* Accordion Section */
  accordion_settings = {
    autoHeight  : false,
    navigation  : true,
    collapsible : true
  };
  $( "#accordion" ).accordion( accordion_settings );
  /* End Accordion Section */

  /* Lightbox Section */
  lightbox_settings = {
    width   : "700px",
    height  : "530px",
    inline  : true,
    href    : "#lightbox"
  };
  $( ".lightbox" ).colorbox( lightbox_settings );
  /* End Lightbox Section */

  /* NPI Search Section */
  $( "#npi-search-form" ).submit( function( e ){

    e.preventDefault();

    var form  = $( this );
    var gif   = $( this ).find( 'img.loading' );

    var successHandler = function( data, textStatus, jqXHR ) {
      if ( 'success' == textStatus ) {
        /* Check if data is a single JSON object or an array of JSON objects. */
        if ( $.isArray( data ) ){
          for ( i = 0; i < data.length; i++ ) {
            /* Do something with each record */
            /* Not yet implemented */
          }
        } else {
          data = $.parseJSON( data );
          fillPhysicianGroupForm( data );
          $( "a[href='#section1']" ).trigger( "click" );
        }
      }
    };

    var beforeSendHandler = function( jqXHR, settings ) {
      $( "#search-step" ).block();
    };

    var completeHandler   = function( jqXHR, textStatus ) {
      $( "#search-step" ).unblock();
    };

    var ajax_settings = getAjaxSettings( form, successHandler, beforeSendHandler, completeHandler );
    $.ajax( ajax_settings );

  } );
  /* End NPI Search Section */

  /* PhysicianGroup Form Section */
  $( "#new-physician-group-form" ).submit( function( e ){
    /* Do that bunch of stuff you've got to do */
    e.preventDefault();
    /* Not yet implemented. */
    /*
    var form = $( this );
    var successHandler = function( data, textStatus, jqXHR ) {
      if ( 'success' == textStatus ) {
      }
    };
    var beforeSendHanlder = function( jqXHR, settings ) {
    };
    var completeHandler   = function( jqXHR, textStatus ) {
    };
    var ajax_settings = getAjaxSettings( form );
    $.ajax( ajax_settings );
    */
  } );
  /* End PhysicianGroup Form Section */

} );

var getAjaxSettings = function( form, success, beforeSend, complete ) {
  var url         = form.attr( "action" );
  var data        = form.serialize();
  var dataType    = "JSON";
  var requestType = form.attr( "method" ).toUpperCase();
  var settings    = {
    url : url,
    beforeSend  : beforeSend,
    complete    : complete,
    success     : success,
    data        : data,
    dataType    : dataType,
    type        : requestType
  };
  return settings;
};

var fillPhysicianGroupForm = function( data ) {
  var name      = data.group.name;
  var address1  = data.business_info.address1;
  var address2  = data.business_info.address2;
  var city      = data.business_info.city;
  var state     = data.business_info.state;
  var zip       = data.business_info.zip;
  var phone     = data.business_info.phone;
  var fax       = data.business_info.fax;
  var providers = data.provider.length;
  if ( 0 == providers ) {
    providers = 1;
  }
  $( "input[name='physician_group[name]']" ).val( name );
  $( "input[name='physician_group[address]']" ).val( address1 );
  $( "input[name='physician_group[address2]']" ).val( address2 );
  $( "input[name='physician_group[city]']" ).val( city );
  $( "select[name='physician_group[state]']" ).val( state );
  $( "input[name='physician_group[zip]']" ).val( zip );
  $( "input[name='physician_group[phone]']" ).val( phone );
  $( "input[name='physician_group[fax]']" ).val( fax );
  $( "input[name='physician_group[providers]']" ).val( providers );
}
