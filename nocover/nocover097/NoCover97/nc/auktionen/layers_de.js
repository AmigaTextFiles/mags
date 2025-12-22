
var searchKW;
var sas;
var las;

if(document.layers){origWidth=innerWidth;origHeight=innerHeight;onresize=function(){if(innerWidth!=origWidth||innerHeight!=origHeight)location.reload()}}

if (sas){
searchKW = "kw=" + keyword;
	if (adflag){//layer
		if (cobrandID == "1"){//RTL
			document.write("<layer SRC=\"http://ad.de.doubleclick.net/adl/www.rtl.de/rtl_ebay;theme=rtl_ebay;pack=auktion;sz=468x60;ord=?\" visibility=\"hidden\" width=468 height=60 onload=\"moveToAbsolute(layer1.pageX,layer1.pageY);clip.width=468;clip.height=60;visibility=\'show\';\"></layer>");
		}
		else if (cobrandID == "2"){//GMX
			document.write("");
		}
		else if (cobrandID == "3"){//MSN
			document.write("<layer SRC=\"http://arc9.msn.com/ADSAdClient31.dll?GetAd?PG=DEMBAY?SC=LG?AN=1.0\" visibility=\"hidden\" width=468 height=60 onload=\"moveToAbsolute(layer2.pageX,layer2.pageY);clip.width=468;clip.height=60;visibility=\'show\';\"></layer>");
		}
		else if (cobrandID == "4"){//AOL
			document.write("<SCRIPT SRC=\"http://ads.web.aol.com/file/adsEnd.js\"></SCRIPT>");
		}
	}
	else{	//regular ebay ads layer
		var URL_1 = "<LAYER SRC=\"http://ad.doubleclick.net/adl/ebay.de.search/keywords;"+searchKW+";sz=468x60;ord="+randnum+"?\" width=468 height=60 visibility=\"hidden\" onLoad=\"moveToAbsolute(DE_search_layer.pageX,DE_search_layer.pageY);clip.width=468;clip.height=60; visibility='show';\"></LAYER>";
		document.write(URL_1);
	}
}


if (las){
	if (adflag){//layer
		if (cobrandID == "1"){//RTL
			document.write("<layer SRC=\"http://ad.de.doubleclick.net/adl/www.rtl.de/rtl_ebay;theme=rtl_ebay;pack=auktion;sz=468x60;ord=?\" visibility=\"hidden\" width=468 height=60 onload=\"moveToAbsolute(layer1.pageX,layer1.pageY);clip.width=468;clip.height=60;visibility=\'show\';\"></layer>");
		}
		else if (cobrandID == "2"){//GMX
			document.write("");
		}
		else if (cobrandID == "3"){//MSN
			document.write("<layer SRC=\"http://arc9.msn.com/ADSAdClient31.dll?GetAd?PG=DEMBAY?SC=LG?AN=1.0\" visibility=\"hidden\" width=468 height=60 onload=\"moveToAbsolute(layer2.pageX,layer2.pageY);clip.width=468;clip.height=60;visibility=\'show\';\"></layer>");
		}
		else if (cobrandID == "4"){//AOL
			document.write("<SCRIPT SRC=\"http://ads.web.aol.com/file/adsEnd.js\"></SCRIPT>");
		}
	}
	else{ //regular ebay ads layer	
		document.write("<LAYER SRC=\"http://ad.doubleclick.net/adl/ebay.de." + metaname + "/" + catname1 + catname2 + ";cat=" + catname3 + ";cat=" + catname4 + ";cat=" + catname5 + ";page=listing;sz=468x60;ord="+randnum+"?\" width=468 height=60 visibility=\"hidden\" onLoad=\"moveToAbsolute(DE_list_layer.pageX,DE_list_layer.pageY);clip.height=60;clip.width=468; visibility='show';\"></LAYER>");
	}
}