#!/usr/bin/env python

import html
import cgi
import cgitb; cgitb.enable()     # for troubleshooting

# print("Content-Type: text/html") # HTTP header to say HTML is following
# print()                          # blank line, end of headers

form = cgi.FieldStorage()
temperature = html.escape(form["temperature"].value);
humidity    = html.escape(form["humidity"].value);

# print(say, " ", to)
f = open("demonfile.html", "r+")

f = write("<p>Temperature : " + temperature + " Celsius </p>" +
     "<p>Humidity : " + humidity + " % </p>")

f.close()
#    http://localizer-train.000webhostapp.com/
#    MJ26e#6#fQ8x
