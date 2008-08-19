// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
jQuery(document).ready(function() {
	$("#quotes_container .quote").bind('click', function(e) {
		if (e.target.tagName == "DIV") {
			$(this).find(".quote_extended").toggle('blind');
		}
	});
});