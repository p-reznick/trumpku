document.addEventListener('DOMContentLoaded', function() {
  var popupTrigger = document.getElementById('popup_trigger');
  var xOut = document.getElementById('x_out');
  var popupContainer = document.getElementById('popup_container');

  function closePopup() {
    popupContainer.style.display = 'none';
  }

  popupTrigger.addEventListener('click', function(e) {
    console.log('clicked');
    var display = popupContainer.style.display !== 'block';

    if (display !== 'block' || display === '') {
      popupContainer.style.display = 'block';
    } else {
      closePopup();
    }
  });

  document.addEventListener('keydown', function(e) {
    if (e.keyCode === 27) {
      closePopup();
    }
  });

  xOut.addEventListener('click', function() {
    closePopup();
  });

  popupContainer.addEventListener('click', function(e) {
    if (e.target.tagName === 'DIV') {
      popupContainer.style.display = 'none';
    }
  })
});
