$('#navbar-affix').affix({
    offset: {
        top: function () {
            /* Chrome refresh fix */
            var sel = $(".navbar-logo")[0];
            sel.style.display='none';
            sel.offsetHeight; // no need to store this anywhere, the reference is enough
            sel.style.display='inline';
            /*****/
            return 150;
        }
    }
});