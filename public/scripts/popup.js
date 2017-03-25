document.addEventListener('DOMContentLoaded', function() {
  var popup_trigger = document.getElementById('popup_trigger');
  popup_trigger.addEventListener('click', function(e) {
    var popup = document.getElementById('popup');
    popup.style.opacity == '0' ? popup.style.opacity = '1' : popup.style.opacity = '0';
  });
});
