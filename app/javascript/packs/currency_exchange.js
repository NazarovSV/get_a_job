function exchanged_amounts(data) {
    let html = ''

    data.forEach(function(item) {
        console.log(item.amount)
        html += `<p>${item.amount} ${item.currency}</p>`
    })

    return html
}

function convertAmount(amount, id) {
    let currency_id = $('#vacancy_currency_id option:selected').val()

    $.ajax({
        url: location.origin + "/exchange_rates",
        data: { exchange_rate: { amount: parseInt(amount), currency_from_id: currency_id } },
        dataType: 'json',
        success: function (data) {
            $("." + id + "_converted").html(exchanged_amounts(data))
        },
        error: function (data) {
            console.log("Error:", data)
        },
    })
}

function showExchangedAmounts() {
    $('*[money_data_behavior="exchange"]').each(function () {
        let field = $(this)
        let id = field.attr('id')

        if (field.val().length > 0 && parseInt(field.val()) >= 100) {
            convertAmount(field.val(), id);
        }

        field.on('input', function () {
            let amount = field.val()
            if (parseInt(amount) < 100)
                return

            convertAmount(amount, id)
        })
    })
}

function convertCurrentAmount(oldValue) {
    $('#vacancy_currency_id').on('change', function () {
        let newValue = $(this).val();
        $('*[money_data_behavior="exchange"]').each(function () {
            let input = $(this)
            let amount = $(this).val()

            if (parseInt(amount) > 0) {
                $.ajax({
                    url: location.origin + "/exchange_rates/convert",
                    data: {
                        exchange_rate: {
                            amount: parseInt(amount),
                            currency_from_id: oldValue,
                            currency_to_id: newValue
                        }
                    },
                    dataType: 'json',
                    success: function (data) {
                        oldValue = newValue
                        input.val(data.amount)

                        convertAmount(data.amount, input.attr('id'))
                    },
                    error: function (data) {
                        oldValue = newValue
                        console.log("Error:", data)
                    },
                })
            }
        })
    });
}

$(document).on('turbolinks:load', function () {
    showExchangedAmounts()

    let oldValue = $('#vacancy_currency_id option:selected').val()
    convertCurrentAmount(oldValue);
});

