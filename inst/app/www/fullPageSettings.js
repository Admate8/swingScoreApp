$( document ).ready(function() {

    let isButtonClicked = false;

    // fullpage options
    new fullpage('#fullpage', {
    autoScrolling: true,
    navigation: true,

    slidesNavigation: true,
    scrollHorizontally: true,

    controlArrows: false,

    // Prevent the user from scrolling down when on the first page until the button is clicked
    afterLoad: function(origin, destination, direction) {

      // Check if the user is on the first page
      if (destination.index === 0 && !isButtonClicked) {
        // Prevent scrolling down
        fullpage_api.setAllowScrolling(false, 'down');
        fullpage_api.setKeyboardScrolling(false, 'down');
      } else {
        // Allow scrolling in all directions otherwise
        fullpage_api.setAllowScrolling(true);
        fullpage_api.setKeyboardScrolling(true);
      }
    }
  });

  $(document).on('click', '#triangle_btn', function() {
    isButtonClicked = false;

    // Allow scrolling in all directions after the button is clicked
    fullpage_api.setAllowScrolling(true);
    fullpage_api.setKeyboardScrolling(true);

    // Scroll down to the next slide
    fullpage_api.moveSectionDown();
  });

});

