var lastPage = document.referrer.toLowerCase();
var cbc;
var cobrandID;
var adflag;
var atag;
var las;




if (cobrandID == "1" || cobrandID == "2" || cobrandID == "4"){
adflag = 1;
}


function ad_tag(where){	
las = 1; 
	if ((cobrandID != "1") && (cobrandID != "2") && (cobrandID != "4")){ //if rtl, gmx, or aol do not display ad in the usual spot

		document.write("<SCRIPT SRC=\"http://include.ebay.com/aw/pics/de/js/cobrand/ads/ads_de.js\"></SCRIPT>");

		
	}

}

atag = 1; // is this file loaded?