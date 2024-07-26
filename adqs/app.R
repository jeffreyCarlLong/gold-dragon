# Force Directed Knowledge Graph 
# brought to you by Jeffrey Long
# This app uses Javascript code to allow interactive display
# of force directed knowledge graphs in Shiny

# Copyright 2021 Jeffrey Long

# Permission is hereby granted to
# any person obtaining a copy of this software and
# associated documentation files (the "Software"), by
# copy, modify, merge, publish, distribute,
# copies of the Software,
# and to permit persons to whom the Software is
# furnished to do so, subject to the following
# conditions:

# The above copyright notice and this permission
# notice shall be included in all copies or
# substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY
# OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
# LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
# OR OTHER LIABILITY, WHETHER IN AN ACTION OF
# CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
# OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.

library(shiny)
library(data.table)
library(tidyverse)
# library(png)



#########################################
#########################################
#########################################
## UI DEFINITIONS
#########################################
#########################################
#########################################

ui <- fluidPage(
  #####################################
  # Data Democratization Title
  #####################################
  # https://github.com/rstudio/hex-stickers/blob/master/thumbs/shiny.png
  titlePanel(title=div(img(height = 100, width = 300, src = "http://www.rstudio.com/images/RStudio.2x.png", align="right"),
                       h1("ADQS Three Patient Subset Percent Change for Five Parameters"),
                       h2("by Jeffrey C. Long"),
                       h3("GSK Oncology Data Strategy")#,
                       # a(href = "www.rstudio.com", "RStudio"),
                       # code("This is a Shiny app."),
  ),
  windowTitle = "Shiny KG"),
  
  #########################################
  ## KNOWLEDGE GRAPH
  #########################################
  
  includeHTML("www/kg.html")
)


#########################################
#########################################
#########################################
## SERVER FUNCTIONS
#########################################
#########################################
#########################################

server <- function(input, output) {
  
  
  
}


#########################################
#########################################
#########################################
## CALL shinyApp
#########################################
#########################################
#########################################

shinyApp(ui = ui, server = server)
