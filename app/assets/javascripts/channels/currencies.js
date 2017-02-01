(function() {
  App.currencies = App.cable.subscriptions.create("CurrenciesChannel", {
    connected: function() {},
    disconnected: function() {},
    received: function(data) {
      curr = $('#' + data.code);
      if (data.update_failed){
        $('#usd').siblings().first().addClass('update-failed');
        $('#update-failed-notice').removeClass('hidden'); 
        //can't use show/hide because this content should be in the template and visible even without js
      }
      else{
        $('#usd').siblings().first().removeClass('update-failed');
        if ($('.update-failed').length < 2){
          $('#update-failed-notice').addClass('hidden');
          //can't use show/hide because this content should be in the template and visible even without js
        };
      };
      return $('#' + data.code).html(data.body);
    }
  });

}).call(this);
