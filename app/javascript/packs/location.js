document.addEventListener("turbolinks:load", function () {
    $input = $('*[address_data_behavior="autocomplete"]')

    var options = {
        url: function(query) {
            return location.origin + "/hire/locations/search.json?q=" + query;
        },
        getValue: "name",
    };
    console.log(options.url())

    $input.easyAutocomplete(options);
})