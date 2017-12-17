app.controller("RolesController", ['$scope', '$http', function($scope, $http) {
    $scope.index = function() {
        $http.get('/roles.json').then(function (response) {
            $scope.roles = response.data;
        }, function(error) {
            console.log('Error: ' + error);
        });
    }
    
    $scope.submit = function() {
        $('.progress').show();
        $('#progress_bar').width("100%");
        setTimeout(function() {
            var data = {
                role: {
                    role: $scope.full_name ? $scope.full_name : ""
                }
            };
            $http.post('/roles', data).then(function (response) {
                var err = $(response.data).find("#error_explanation_list");
                if ($(err).length > 0) {
                    injectErrorDiv(err);
                } else {
                    var role_id = $(response.data).find("#role_id").val();
                    if (role_id) {
                        window.location.href = '/roles/' + role_id;
                    }
                }
            }, function(error) {
                console.log('Error: ' + error.data);
            });
            $('.progress').hide();
            $('#progress_bar').width("0%");
        }, 1000);
    }
}]);

function errorHeader(e) {
    err = e.length + ' error';
    if (e.length > 1) {
        err = err.concat('s');
    }
    return '<h2>' + err + ' prohibited this role from being saved:</h2>';
}

function addErrorListItems(e) {
    li = '';
    for (i = 0; i < e.length; ++i) {
        li = li.concat('<li>' + e[i] + '</li>');
    }
    return li;
}

function injectErrorDiv(obj) {
    errors = [];
    e = $('#error_explanation');
    $(obj).children().each(function(index, element) {
        errors.push($(element).text());
    });
    if (e.length > 0) {
        e.empty();
        div = $(errorHeader(errors) + '<ul id="error_explanation_list">' + addErrorListItems(errors) + '</ul>');
        e.append(div);
    } else {  
        div = $('<div id="error_explanation">' + errorHeader(errors) + '<ul id="error_explanation_list">' + addErrorListItems(errors) + '</ul></div>');
        $('form').prepend(div);
    }
}