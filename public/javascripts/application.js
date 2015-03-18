function initialize_form() {
    $.FormCheck.Notifiers.create("custom_errors", {
      notify: function(attribute) {
        $('label.custom_error').remove();
        if (attribute) {
          var field = this.form.field(attribute);
          var div = field.element.parent("div");
          }
          else {
          var attributes = this.form.errors.attributes_with_errors();

          for (var i = 0; i < attributes.length; i++) {
            var field = this.form.field(attributes[i]);
            field.element.parent("div").append("<label class='custom_error'>" + this.form.errors.on(attributes[i])[0]  +"</label>");
          }
        }
      }
    });
}

  function show_link(option)
{
  if(option == 1)
    $('#physician_photo').show();
  else
    $('#hospital_photo').show();
}

  function hide_link(option)
{
  if(option == 1)
    $('#physician_photo').hide();
  else
    $('#hospital_photo').hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
    $("#staffs").append(content.replace(regexp, new_id));
}

var qliqWeb = {};
(function() {

})();
