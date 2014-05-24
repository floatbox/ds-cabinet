$( ".buttons .button span" ).hover(
  function() {
    $(this).siblings(".notice").toggle();
  }
);
