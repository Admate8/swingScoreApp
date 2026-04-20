$( document ).ready(function() {

    // fullpage options
    new fullpage('#fullpage', {
    autoScrolling: true,
    navigation: true,
    slidesNavigation: true,

    normalScrollElements: '.scrollable-table, [id^="bs-select-"]'
    });
});


