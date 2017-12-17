//Establish reused vars
window.location.origin = (!window.location.origin) ? (window.location.protocol + "//" + window.location.hostname) : (window.location.origin);
LOGIN = 'login';
LOGOUT = 'logout';
REGISTER = 'register';

//Initialize angular.js app
var app = angular.module("BasicApp", []);


$(document).on('click', '#login_button', function(event) {
    auth = $(this).text().trim();
    var destination_url = window.location.origin;
    destination_url = (auth.toLowerCase() == LOGIN) ? destination_url.concat('/login') : destination_url.concat('/logout');
    window.location.href = destination_url;
});

$(document).on('click', '#register_button', function(event) {
    var destination_url = window.location.origin.concat('/register');
    window.location.href = destination_url;
});

$(document).on('click', '#save_profile_id', function(event) {
    var destination_url = window.location.origin.concat("/save_profile_image_id?image=");
    var image_id = "";
    $('.profile_image_checkboxes').each(function(i, obj) {
        if($(obj).is(':checked')) {
            image_id = $(obj).val();
        }
    });
    if (image_id != "") {
        destination_url = destination_url.concat(image_id);
        window.location.href = destination_url;
    } else {
        alert('You must select an image first.');   
    }
});

$(document).on('click', 'tr[data-href]', function(event) {
    window.location.href = document.URL.concat('/' + $(this).data('href'));
});

function stringContains(string, match) {
    return (string.toLowerCase().indexOf(match.toLowerCase()) >= 0) ? true : false;
}