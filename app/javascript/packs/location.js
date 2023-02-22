document.addEventListener("turbolinks:load", function () {
    $input = $('*[address_data_behavior="autocomplete"]')

    var options = {
        url: function(query) {
            return location.origin + "/hire/locations/search.json?search_letters=" + query;
        },
        getValue: "name",
    };
    console.log(options.url())

    $input.easyAutocomplete(options);
})