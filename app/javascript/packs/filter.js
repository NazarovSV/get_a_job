document.addEventListener('turbolinks:load', function() {
    $(".filters select").on("change", function() {

        let request = $('#request').val()
        let categoryId = $('.filters #category_id').val()
        let currencyId = $('.filters #currency_id').val()
        let cityId = $('.filters #city_id').val()
        let experienceId = $('.filters #experience_id').val()

        let filters = {}
        if (request.length > 0) {
            filters.request = request
        }
        if (categoryId.length > 0) {
            filters.category_id = categoryId
        }
        if (currencyId.length > 0) {
            filters.currency_id = currencyId
        }
        if (cityId.length > 0) {
            filters.city_id = cityId
        }
        if (experienceId.length > 0) {
            filters.experience_id = experienceId
        }

        $.ajax({
            url: location.origin + "/searches/",
            data: filters,
            success: function() {
                console.log('AJAX-запрос выполнен успешно!');
            },
            error: function() {
                console.log('Произошла ошибка при выполнении AJAX-запроса!');
            }
        })
    });
})