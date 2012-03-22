$(document).ready(function() {
    //When you click on a link with class of poplight and the href starts with a #
    $('#directregister').click(function() {
        var popID = $(this).attr('rel');
        var popWidth = 200;
        //Fade in the Popup and add close button
        $('#' + popID).fadeIn().css({ 'width': Number( popWidth ) }).prepend('<a href="#" class="close"><img src="images/close_pop.png" class="btn_close" title="Close Window" alt="Close" /></a>');

        //Define margin for center alignment (vertical   horizontal) - we add 80px to the height/width to accomodate for the padding  and border width defined in the css
        var popMargTop = ($('#' + popID).height() + 80) / 2;
        var popMargLeft = ($('#' + popID).width() + 80) / 2;

        //Apply Margin to Popup
        $('#' + popID).css({
            'margin-top' : -popMargTop,
            'margin-left' : -popMargLeft
        });

        //Fade in Background
        $('body').append('<div id="fade"></div>'); //Add the fade layer to bottom of the body tag.
        $('#fade').css({'filter' : 'alpha(opacity=80)'}).fadeIn(); //Fade in the fade layer - .css({'filter' : 'alpha(opacity=80)'}) is used to fix the IE Bug on fading transparencies

        return false;
    });

    // Close the register popup form
    $('a.close, #fade').live('click', function() {
        $('#fade , .register_block').fadeOut(function() {
            $('#fade, a.close').remove();  //fade them both out
        });
        return false;
    });

    $.fn.serializeForm = function() {
        var values = {}
        $("form input, form select, form textarea").each( function(){
            values[this.name] = $(this).val();
        });

        return values;
    }

    $(function(){
        $("form#ajax_signup").submit(function(e){
            e.preventDefault(); // This prevents the form from submitting normally
            var user_info = $(this).serializeForm();
            console.log("About to post to /users: " + JSON.stringify(user_info));
            $.ajax({
                type: "POST",
                url: "/users",
                data: user_info,
                success: function(json){
                    console.log("The Devise Response: " + JSON.stringify(json));
                    // Close the register popup form
                    $('#fade, .register_block').fadeOut(function() {
                        $('#fade, a.close').remove();  //fade them both out
                    });
                },
                dataType: "json"
            });
        });
    });

    $(function(){
        $("#directlogin_submit").click(function(){
            var email = $("#directlogin_username").val();
            var password = $("#directlogin_password").val();
            var user_info = {remote: true, commit: "Sign in", utf8: "✓",
                user: {remember_me: 1, password: password, email: email}};
            console.log("About to post to /users/sign_in: " + JSON.stringify(user_info));
            $.ajax({
                type: "POST",
                url: "/users/sign_in",
                data: user_info,
                success: function(json){
                    console.log("The Devise Response: " + JSON.stringify(json));
                    $('#user_nav').load('/');
                },
                dataType: "json"
            });
        });
    });

    $(function() {
        $("#direct_auction").click(function(){
            var user_info = {remote: true, commit: "Start Auction", utf8: "✓",
                product_id: 1, store_ids: [1, 2, 3]};
            console.log("About to post to /auctions: " + JSON.stringify(user_info));
            $.ajax({
                type: "POST",
                url: "/auctions",
                data: user_info,
                success: function(json){
                    console.log("The Server Response: " + JSON.stringify(json));
                },
                dataType: "json"
            });
        });
    });
});
