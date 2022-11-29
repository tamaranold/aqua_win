# Shiny App

# load libraries
library(shiny)
library(shinyMobile)
library(magick)
library(tidyverse)
library(png) 

# standalone: https://github.com/electron/electron-quick-start
# f7Gallery()

# get modules


# color
#getF7Colors()
col_standard <- "teal"

# app
shinyApp(
  ui = f7Page(
    options = list(
      theme = "md",
      dark = TRUE,
      filled = TRUE,
      color = col_standard
    ),
    
    f7TabLayout(
      navbar = f7Navbar(
        title = "Aquawin",
        hairline = FALSE,
        shadow = TRUE
      ),
      
      f7Tabs(
        id = "tabs",
        swipeable = FALSE,
        animated = FALSE,
        
        #input image
        f7Tab(
          tabName = "Start",
          icon = f7Icon("camera_circle"),
          active = TRUE,
          
          f7Card(
            f7File(
              "up",
              label = "",
              multiple = FALSE,
              accept = "image/*",
              width = NULL,
              buttonLabel = "Take a picture!",
              placeholder = ""
            ),
            
            imageOutput("imgOrg"),
            imageOutput("imgRot")
            #startbutton
            #new tab - results
            
          )
        )
      )
    )
  ),
  server = function(input, output, session) {
    

    
    output$imgOrg <- renderImage({
      inFile = input[["up"]]
      print(inFile)
      if (!is.null(inFile))
      {
        list(src = inFile[["datapath"]])
        
          }
      else
      {
        
      }
    },  deleteFile = FALSE)
  
  
  outfile <- eventReactive(input[["up"]], {
    tempfile(fileext = ".png")
    })

    
  img <- eventReactive(input[["up"]], {
    inFile = input[["up"]]
    
    pic <- image_rotate(image_read(inFile[["datapath"]]), 180)
      
    image_write(pic, path = outfile(), format = "png")
    
  })
  
  observeEvent(img(),{
    output$imgRot <- renderImage({
                 
                 
                 list(src = outfile(),
                      contentType = "image/png")
                 
               },  deleteFile = FALSE)
               
               
               
                })
  }  
  
  
)
