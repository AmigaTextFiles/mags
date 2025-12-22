var ss_machine = "http://include.ebay.com/"; // machine these files are hosted on
var ss_path = "aw/pics/js/"; //  and path to the files
var thisPage = unescape(document.location).toLowerCase();
var thisHost = document.location.hostname.toLowerCase();
var lastPage = unescape(document.referrer).toLowerCase();
var pageName;
var ssAccounts = new Array();
var ssSmSample = 0;
var CookieDomain = ".ebay.com"; //set the domain to .ebay.com and then expand it to work with countries, stores, etc. if applicable
if (thisHost.indexOf(".ebay") > 0){
	CookieDomain = thisHost.substring(thisHost.indexOf(".ebay"));
}
var expires = new Date(); // set up a date object for expiration
var curyear = expires.getYear();
if (curyear < 1900) {
	curyear = curyear + 1900;
}
expires.setYear(curyear + 5);
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
function getOneOffs(){
	var ssSpecialPages = new Array() // make an array to hold more than one account name
	if(pageName && (thisHost.indexOf('.qa.')==-1)  && (thisHost.indexOf('.corp.')==-1)){
		//if(pageName.toLowerCase().indexOf('pagesyi')!=-1)ssSpecialPages[ssSpecialPages.length] = 'ebayspain';//add any new accounts below here (using Spain for testing)
	}
	if(ssSpecialPages.length > 0)return ssSpecialPages;
	else return false;
}
function getOrDropLuckyCookie(){
	var ss_y = ReadCookie("lucky7");
	if (ss_y.length < 1){
		if (thisHost.indexOf('.qa.') > 0)ss_y = 1;
		else{
			ss_y = Math.floor(Math.random()*1000000); // random number between 0-999999
		}		
		expires.setYear(curyear + 5);
		WriteCookie("lucky7",ss_y,CookieDomain,"/",expires);
	}
	var ss_x = ReadCookie("lucky7");
	if (ss_y == ss_x) return ss_x;
	else return '';
}
function ssDropRegCookie(){
	expires.setYear(curyear + 5);
	WriteCookie("reg","1",CookieDomain,"/",expires);
}
function determineAccounts(ss_x,oneOffs){
	if (oneOffs){
		for(i=0;i<oneOffs.length;i++){
			ssAccounts[ssAccounts.length]=oneOffs[i];
		}	
	}
	if ((ss_x.length != 0) && ((ss_x % 100) == 2)){
		ssAccounts[ssAccounts.length]='ebay1';
		//if (ReadCookie("reg") == "1")ssAccounts[ssAccounts.length]='ebayreg';
		//else ssAccounts[ssAccounts.length]='ebaynonreg';
	}
	//if ((ss_x.length != 0) && ((ss_x % 1000) == 2)){
		ssSmSample = 1; // we'll read this in ssGetCountry() and determine which country account to add
	//}
	var ss_qa = ReadCookie('ss_qa');
	if (ss_qa == 'Y')ssAccounts[ssAccounts.length]='ebayQualityAssurance';
	if (ssAccounts.length > 0)document.write('<SCRIPT SRC="' + ss_machine + ss_path + 'stats/ss_nest.js"></SCRIPT>')
}
if(ReadCookie("ebaysignin") == "in")ssDropRegCookie();//drop the reg cookie
determineAccounts(getOrDropLuckyCookie(),getOneOffs())
