document.addEventListener("turbolinks:load", function () {
    $input = $('*[address_data_behavior="autocomplete"]')

    var options = {
        url: function(query) {
            return location.origin + "/hire/locations/search.json?letters=" + query;
        },
        getValue: "name",
    };

    $input.easyAutocomplete(options);
})