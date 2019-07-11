$(window).bind('scroll', function () {
    if ($(window).scrollTop() > 130) {
		document.getElementById('verticalGeneral').style.top = "0px";
    } else {
		document.getElementById('verticalGeneral').style.top = "200px";
	}
});