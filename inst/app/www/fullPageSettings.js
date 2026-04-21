$( document ).ready(function() {

    // fullpage options
    new fullpage('#fullpage', {
        autoScrolling: true,
        navigation: true,
        slidesNavigation: true,

        normalScrollElements: '.scrollable-table, [id^="bs-select-"]'
    });
});

// Settings for the slidding plots
document.addEventListener('DOMContentLoaded', function() {

    const container = document.querySelector('.comparison-container');
    const slider = document.querySelector('.slider');
    const topPlot = document.querySelector('.top-plot');

    function move(e) {
        const rect = container.getBoundingClientRect();

        let x = e.clientX - rect.left;
        x = Math.max(0, Math.min(x, rect.width));

        const percent = (x / rect.width) * 100;

        // clip right side of top plot
        topPlot.style.clipPath = `inset(0 ${100 - percent}% 0 0)`;

        // move slider
        slider.style.left = percent + '%';
    }

    slider.addEventListener('mousedown', function() {

        function onMove(e) { move(e); }
        function onUp() {
            document.removeEventListener('mousemove', onMove);
            document.removeEventListener('mouseup', onUp);
        }

        document.addEventListener('mousemove', onMove);
        document.addEventListener('mouseup', onUp);
    });
});
