$(function () {
  var tz = jstz.determine();
  Cookies.set('timezone', tz.name(), { path: '/' });
});
