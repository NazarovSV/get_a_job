
function search() {
    return new Promise((resolve, reject) => {
        let request = $('#request').val()
        let employmentId = $('.filters #employment_id').val()
        let currencyId = $('.filters #currency_id').val()
        let cityId = $('.filters #city_id').val()
        let experienceId = $('.filters #experience_id').val()
        let salary_min = $('.filters #salary_min').val()
        let salary_max = $('.filters #salary_max').val()
        let specializationId = $('.filters #specialization_id').val()

        let filters = {
            request: request,
            employment_id: employmentId,
            currency_id: currencyId,
            city_id: cityId,
            experience_id: experienceId,
            specialization_id: specializationId
        };

        if (!isNaN(salary_min)) {
            filters.salary_min = salary_min
        }

        if (!isNaN(salary_max)) {
            filters.salary_max = salary_max
        }

        Object.keys(filters).forEach(key => {
            if (filters[key].length === 0) {
                delete filters[key];
            }
        });

        // Создаем строку запроса из фильтров
        let queryString = Object.keys(filters)
            .map(key => encodeURIComponent(key) + '=' + encodeURIComponent(filters[key]))
            .join('&');

        console.log(filters);
        // Добавляем новое состояние и изменяем URL без перезагрузки страницы
        window.history.pushState(filters, "", "/searches?" + queryString);
        $.ajax({
            url: location.origin + "/searches.js",
            data: filters,
            success: function () {
                console.log('AJAX-запрос выполнен успешно!');
                resolve();
            },
            error: function () {
                console.log('Произошла ошибка при выполнении AJAX-запроса!');
                reject();
            }
        })
    })
}

document.addEventListener('turbolinks:load', function () {
    $(".filters select").on("change", function () {
        search()
    });

    $('*[money_data_behavior="filter"]').each(function () {
        let field = $(this)
        let id = field.attr('id')

        field.on("keypress", function (e) {
            if (e.key == "Enter")  // the enter key code
            {
                console.log('enter')
                search()
            }
        }
        )
    })
})
