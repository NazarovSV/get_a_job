document.addEventListener('turbolinks:load', function() {
    $(".filters select").on("change", function() {
        // let selectId = $(this).attr("id");
        // let value = $(this).val();

        let request = $('#request').val()
        let categoryId = $('.filters #category_id').val()
        let currencyId = $('.filters #currency_id').val()
        let cityId = $('.filters #city_id').val()
        let experienceId = $('.filters #experience_id').val()

        console.log(request)
        console.log(categoryId)
        console.log(currencyId)
        console.log(cityId)
        console.log(experienceId)

        $.ajax({
            url: location.origin + "/searches/",
            data: { request: request, currency_id: currencyId, category_id: categoryId, city_id: cityId, experience_id: experienceId },
            dataType: 'json',
            success: function (data) {
                console.log('Success')
            },
            error: function (data) {
                console.log("Error:", data)
            },
        })
    });
})