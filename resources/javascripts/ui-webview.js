var template = null;

$(document).ready(function() {
	template = $("#testTemplate").html();

	$("#getDetails").click(function() {
		NativeJSBridge.call("nameAndLocation", {name: '', location: ''}, updateNameAndLocation);
	});
	
});

function updateNameAndLocation(json) {
	json = $.parseJSON(json);
	$("#nameAndLocation").html(_.template(template, json));  
}