clientSideValidations.validators.local["subscriber_email"] = function(element, options) {
    var data = {};
    data['case_sensitive'] = !!options.case_sensitive;
    if (options.id) {
        data['id'] = options.id;
    }

    if (options.scope) {
        data.scope = {}
        for (key in options.scope) {
            var scoped_element = jQuery('[name="' + element.attr('name').replace(/\[\w+]$/, '[' + key + ']' + '"]'));
            if (scoped_element[0] && scoped_element.val() != options.scope[key]) {
                data.scope[key] = scoped_element.val();
                scoped_element.unbind('change.' + element.id).bind('change.' + element.id, function() {
                    element.trigger('change');
                    element.trigger('focusout');
                });
            } else {
                data.scope[key] = options.scope[key];
            }
        }
    }

    var name = 'user[email]';
    data[name] = element.val();
    if (jQuery.ajax({
        url: '/validators/uniqueness.json',
        data: data,
        async: false
    }).status == 200) {
        return options.message;
    }
}

clientSideValidations.validators.local["credit_card_number"] = function(element, options) {
    if (($('#order_card_type').val() == 'american_express' && element.val().length != 15) || ( element.val().length != 16))
        return options.message;

}