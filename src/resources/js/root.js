/* create agent */
function newArt() {
	http = new XMLHttpRequest();
	/*Probably there is not an artifact with the referred name in a wks called 'temp', if so, its source will be opened*/
    http.open("POST", '/workspaces/temp/'+document.getElementById('createArtifact').value, false);
    http.send();
    window.open('/workspaces/temp/javafile/'+document.getElementById('createArtifact').value, 'mainframe');
}

/* create role: POST in "/{oename}/group/{groupname}" */
function newRole(org, gr) {
	/*
	TODO: The current method used window.open on the js, which is not showing the html to feedback the user after the post. Maybe a solution is changing it to a form using submit function
	var f = document.getElementById('TheForm');
	f.something.value = something;
	f.more.value = additional;
	f.other.value = misc;
	window.open('', 'TheWindow');
	f.submit();*/

	http = new XMLHttpRequest();
	var input = document.getElementById('orgGrRole').value;
	var lastDot = input.lastIndexOf('.');
	var firstPart = input.substring(0, lastDot);
	var role = input.substring(lastDot + 1);
	var firstDot = firstPart.indexOf('.');
	var org = firstPart.substring(0, firstDot);
	var group = firstPart.substring(firstDot + 1);

	console.log(org + "/" + group + "/" + role);

    http.open("POST", '/oe/' + org + '/group/'+ group, false);
    http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    var data = "role=" + encodeURIComponent(role);
    http.send(data);
    window.open('/oe/' + org + '/os', 'mainframe', 'location=yes,status=yes');
}

/* update navigation bar according to frames changes */
setInterval(function() {
	document.getElementById("nav-drawer").innerHTML = sessionStorage.getItem("menucontent");
}, 500);
