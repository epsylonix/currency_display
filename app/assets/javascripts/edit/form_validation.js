$(function () {
    options = { 
        errorClass: 'error',  
        successClass: 'success',
        trigger: 'change'
    };

    $("#currency-form").parsley(options).validate()

});