$( ".buttons .button span" ).hover(
  function() {
    $(this).siblings(".notice").toggle();
  }
);

// toggle visibility
jQuery.fn.visible = function() {
    return this.css('visibility', 'visible');
};

jQuery.fn.invisible = function() {
    return this.css('visibility', 'hidden');
};

jQuery.fn.visibilityToggle = function() {
    return this.css('visibility', function(i, visibility) {
        return (visibility == 'visible') ? 'hidden' : 'visible';
    });
};

!(function($) {
    var toggle = $.fn.toggle;
    $.fn.toggle = function() {
        var args = $.makeArray(arguments),
            lastArg = args.pop();

        if (lastArg == 'visibility') {
            return this.visibilityToggle();
        }

        return toggle.apply(this, arguments);
    };
})(jQuery);

// custom scrollbar
$(function() {
    window.dima = baron({
        root: '.wrapper_1',
        scroller: '.scroller',
        bar: '.scroller__bar',
        barOnCls: 'baron'
    }).fix({
        elements: '.header__title',
        outside: 'header__title_state_fixed',
        before: 'header__title_position_top',
        after: 'header__title_position_bottom',
        clickable: true
    }).pull({
        block: '.load',
        elements: [{
            self: '.load__value',
            property: 'width'
        }],
        limit: 115,
        onExpand: function() {
            $('.load').css('background', 'red');
        }
    });

    baron({
        scroller: '.wrapper_2 .scroller',
        bar: '.scroller__bar',
        barOnCls: 'baron'
    }).fix({
        elements: '.header__title',
        outside: 'header__title_state_fixed',
        before: 'header__title_position_top',
        after: 'header__title_position_bottom'
    }).baron({
        barOnCls: 'baron_h',
        bar: '.scroller__bar_h'
    });

// fancybox
    $('.fancybox').fancybox();

    $( ".header-updates" ).click(
        function() {
            $(".customscroll", this).visibilityToggle();
        }
    );

    $( ".edit-message" ).click(
        function() {
            $(".edit-message-menu", this).toggle();
        }
    );
});
