start_demo = localStorage.getItem('start_demo');
user_welcome = localStorage.getItem('user_welcome');
roles_welcome = localStorage.getItem('roles_welcome');

if (!start_demo) {
    start_demo = 1;
}
if (!user_welcome) {
    user_welcome = 1;
}
if (!roles_welcome) {
    roles_welcome = 1;
}

//OnReady
$(function(){
    //Hide Coming Soon Div on home/root
    if (location.pathname == "/") {
        $('.main_content_div').hide();
    }
    
    //Show Welcome Modal - 1st Step
    if ((start_demo == 1) && (location.pathname == "/")) {
        $('#welcome_modal').modal({ backdrop: 'static', keyboard: false });
    }
    
    //Show Sign Up Info Modal - 4th Step
    if ((start_demo == 1) && (stringContains(location.pathname, REGISTER))) {
        $('#signup_info_modal').modal({ backdrop: 'static', keyboard: false });
        cancelInitDemo();
    }
    
    //Cancel Demo if user navigates to /login first
    if (stringContains(location.pathname, LOGIN)) {
        cancelInitDemo();
    }

    //Display User Welcome Message Modal - once
    //regex is for /users/id show view
    if ((location.pathname.match(/^\/users\/\d$/)) && (user_welcome == 1)) {
        $('#user_arrow_icon').show();
        $('#user_welcome_modal').modal({ backdrop: 'static', keyboard: false });
        cancelUserWelcomeDemo();
    }
    
    //Display Roles Welcome Message Modal - once
    //regex is for /roles index view
    if ((location.pathname.match(/^\/roles$/)) && (roles_welcome == 1)) {
        $('#roles_welcome_modal').modal({ backdrop: 'static', keyboard: false });
        cancelRolesWelcomeDemo();
    }
});


//Show Sign Up Info Modal - 3.5 Step
function startSignUpDemo() {
    if (start_demo) {
        window.location.href = window.location.origin.concat('/register');
    }
}

//Stop initial demo modals
function cancelInitDemo() {
    start_demo = 0;
    localStorage.setItem('start_demo', 0);
}

//Stop User Welcome modal
function cancelUserWelcomeDemo() {
    user_welcome = 0;
    localStorage.setItem('user_welcome', 0);
}

//Stop Roles Welcome modal
function cancelRolesWelcomeDemo() {
    roles_welcome = 0;
    localStorage.setItem('roles_welcome', 0);
}