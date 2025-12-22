var cobrandID;
if (cobrandID == "1"){    //if the site is rtl cobranded, then do this
// create random IVW-number
  	rand  = (""+Math.random());
  	len  = rand.length;
  	append = rand.substr(len-10,10);
 	var IVW="http://rtl.ivwbox.de/cgi-bin/ivw/CP/;/net/auktion";
	document.write("<IMG SRC=\""+IVW+"?r="+escape(document.referrer)+"\" WIDTH=\"1\" HEIGHT=\"1\">");
 	document.write("<img src=\"http://www.rtl.de/ivw-bin/CP/net/auktion?"+append+"\" width=1 height=1>");
}

if (cobrandID == "2"){    //if the site is gmx cobranded, then do this
// create random IVW-number
  	jetzt = new Date();
	timestamp = Date.parse(jetzt);
	//document.write('<img src=\"http://213.165.64.33/www/auktion_ebay/0?' + timestamp + '\" width=\"1\" height=\"1\">');
document.write('<img src=\"http://www.gmx.net/cgi-bin/ivw/CP/CGI?ts=' + timestamp + '\" width=\"1\" height=\"1\">');
	document.write('<img src=\"http://gmx.ivwbox.de/cgi-bin/ivw/CP/CGI;' + timestamp + '?r=\" width=\"1\" height=\"1\">');
}

