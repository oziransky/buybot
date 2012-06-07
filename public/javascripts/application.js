// create the main and nav menus
$(document).ready(function() {
    $('#user_nav').ptMenu();
    $('#footer_nav').ptMenu();
});

// handle the flash messages
function notify(flash_message) {
    var flash_div = $(".flash")
    flash_div.html(flash_message);
    flash_div.fadeIn(400);
    setTimeout(function(){
            flash_div.fadeOut(2000,
                function(){
                    flash_div.html("");
                })
        },
        1400);
}

$(document).ready(function() {
    $(".flash").hide();
    var flash_message = $(".flash").html();
    if (flash_message != null) {
        flash_message = flash_message.trim();
        if (flash_message != "") {
            notify(flash_message);
        }
    }
});

function ajaxPlainGet(url) {
    ajaxGet(url, "");
}

function ajaxGet(url, data) {
    $.ajax({
        type: 'GET',
        url: url,
        data: data,
        dataType: 'html'
    });
}

