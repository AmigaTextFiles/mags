/****************************************************************************************************
** JS Cobrand (cobrand_top.js)
** Anna Baum for DE 3/2001: Tim Michaels (tmichaels) 11/16/00
** Description: Allows a single page to display cobranded elements based on current and previous
** URL and, in some cases, parameters passed by the ISAPI code.  Cobranded elements include headers
** and footers, promos, links, forms actions, and certain form attributes.  SSI vars are defined    
** in localdefs.  Available functions: ReadCookie(name); DeleteCookie (name,domain,path);
** WriteCookie(name,value,domain,path,expires,secure); cobrandLinks(); cobrandFormRedirect(chosen);
** cobrandForms(); searchAttribs(); writeRegCookie(); writeHeader(); writeHeaderNoATC(); writeFooter()
*****************************************************************************************************/
var machine = "http://include.ebay.com/"; // machine these files are hosted on
var path = "aw/pics/de/js/cobrand/"; //  and path to the files -- leave thse two blank for relative paths 
var cobrandID = "0"; // set site to IT
var thisPage = location.href.toLowerCase();
var lastPage = document.referrer.toLowerCase();
// the following code finds out what site we're on, and sets cobrandID for the current page
if ((thisPage.indexOf(".rtl.") > 0) || (lastPage.indexOf(".rtl.") > 0) || (thisPage.indexOf("ht=40") > 0) || (thisPage.indexOf("s_partnerid=40") > 0) || (thisPage.indexOf("co_partnerid=40") > 0)){
	cobrandID = "1";// rtl
}
else if ((thisPage.indexOf(".gmx.") > 0) || (lastPage.indexOf(".gmx.") > 0) || (thisPage.indexOf("ht=99") > 0) || (thisPage.indexOf("s_partnerid=99") > 0) || (thisPage.indexOf("co_partnerid=99") > 0)){
	cobrandID = "2";// gmx
}
else if ((thisPage.indexOf(".aol.") > 0) || (lastPage.indexOf(".aol.") > 0) || (thisPage.indexOf("ht=44") > 0) || (thisPage.indexOf("s_partnerid=44") > 0) || (thisPage.indexOf("co_partnerid=44") > 0)){
	cobrandID = "4";// aol
}

// cookie functions
function ReadCookie(name){
	var allCookie, cookieVal, length, start, end;
	cookieVal="";
	name=name+"=";
	allCookie=document.cookie;
	length=allCookie.length;
	if (length>0){
		start=allCookie.indexOf(name, 0);
		if (start!=-1){
			start+=name.length;
			end=allCookie.indexOf(";",start);
			if (end==-1) {
				end=length;
			}
			cookieVal=unescape(allCookie.substring(start,end));
		}
	}
	return(cookieVal);
}
function WriteCookie(name,value,domain,path,expires,secure){ 
	var CookieVal, CookError;
	CookieVal=CookError="";
	if (name){
		CookieVal=CookieVal+escape(name)+"=";
	}
	if (value){
		CookieVal=CookieVal+escape(value);
	}
	if (domain){
		CookieVal=CookieVal+"; domain="+domain;
	}
	if (path){
		CookieVal=CookieVal+"; path="+path;
	}
	if (expires){
		CookieVal=CookieVal+"; expires="+expires.toGMTString();
	}
	if (secure){
		CookieVal=CookieVal+"; secure="+secure;
	}
	else{
		CookError=CookError+"Write failure";
	}
	document.cookie=CookieVal;  // sets the cookie
}
function DeleteCookie (name,domain,path){
   var expireDate=new Date(1);
   if (ReadCookie(name)){
      WriteCookie(name, " ", domain, path, expireDate);
   }
}
if (cobrandID != "0"){
	document.write("<SCRIPT SRC=\"" + machine + path + "cobrand_functions.js\"></SCRIPT>");
}
function writeHeader(){ // writes the, um, header
		if (cobrandID == "1"){
			document.write("<SCRIPT SRC=\"" + machine + path + "headers/header.rtl.js\"></SCRIPT>");
		}
		else if (cobrandID == "2"){
			document.write("<SCRIPT SRC=\"" + machine + path + "headers/header.gmx.js\"></SCRIPT>");
		}
		else if (cobrandID == "4"){
			document.write("<SCRIPT SRC=\"http://ads.web.aol.com/file/adsWrapper.js\"></SCRIPT>");
			document.write("<SCRIPT SRC=\"" + machine + path + "headers/header.aol.js\"></SCRIPT>");
		}
}

function writeBrow(){
if (cobrandID != "0"){
	document.write("<SCRIPT SRC=\"" + machine + path + "headers/brow.js\"></SCRIPT>");
	}
}

function writeFooter(){ // writes the cobrand footer
	if (cobrandID == "1"){
		document.write("<SCRIPT SRC=\"" + machine + path + "footers/footers.rtl.js\"></SCRIPT>");
	}
	else if (cobrandID == "2"){
		document.write("<SCRIPT SRC=\"" + machine + path + "footers/footers.gmx.js\"></SCRIPT>");
	}
	else if (cobrandID == "4"){
		document.write("<SCRIPT SRC=\"" + machine + path + "footers/footers.aol.js\"></SCRIPT>");
		document.write("<SCRIPT SRC=\"http://ads.web.aol.com/file/adsEnd.js\"></SCRIPT>");
	}
}
var brow = 1;
var atc = 1;
var cbc = 1; // is this file loaded?

