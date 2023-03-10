function exchanged_amounts(data) {
    let html = ''

    data.forEach(function(item) {
        console.log(item.amount)
        html += `<p>${item.amount} ${item.currency}</p>`
    })

    return html
}

$(document).on('turbolinks:load', function () {
    $('*[money_data_behavior="exchange"]').each(function () {
        let field = $(this)
        let id = field.attr('id')

        field.on('input', function () {
            let amount = field.val()
            if(parseInt(amount) < 100)
                return

            let currency_id = $('#vacancy_currency_id option:selected').val()

            $.ajax({
                url: location.origin + "/exchange_rates",
                data: { exchange_rate: { currency_id: currency_id, amount: field.val()} },
                dataType: 'json',
                success: function (data) {
                    $("." + id + "_converted").html(exchanged_amounts(data))
                },
                error: function (data) {
                    console.log("Error:", data)
                },
            })
        })
    })
});