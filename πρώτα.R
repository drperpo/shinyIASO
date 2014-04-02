#https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet
#http://shiny.rstudio.com/tutorial/lesson7/
http://mages.github.io/googleVis_on_shiny/#1
http://lamages.blogspot.co.uk/2013/02/first-steps-of-using-googlevis-on-shiny.html
http://hernanresnizky.com/2013/08/02/dashboards-in-r-with-shiny-and-googlevis/
install_github('slidify', 'ramnathv')
install_github('slidifyLibraries', 'ramnathv')
library(slidify)
library(devtools)
author("mydeck")

publish('drperpo','slidifyDemo',host='github')
publish('slidifyDemo',host='dropbox')