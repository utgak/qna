$(document).on('turbolinks:load', function(){
    $(document).on('ajax:success', function(e) {
        $(`.${e.detail[0].class}`).find(`[data-id=${e.detail[0].id}]`).children(".voting-result").html(e.detail[0].result)
    })
        .on('ajax:error', function (e) {
            var errors = e.detail[0];

            $.each(errors, function(index, value) {
                $('.errors').append('<p>' + value + '</p>');
            })

        })
});
