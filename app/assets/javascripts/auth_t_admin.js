var token = $('meta[name="auth_token_admin"]').attr('content');
var f_token = 'Token' + ' ' + token
$.ajaxSetup({
headers: { "Authorization": f_token }
});