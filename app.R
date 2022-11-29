# Shiny App

# load libraries
library(shiny)
library(shinyMobile)
library(magick)
library(tidyverse)
library(png) 

# standalone: https://github.com/electron/electron-quick-start
# f7Gallery()

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
        shadow = TRUE),
      
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
            
            uiOutput("start"),

            imageOutput("imgCut")
            
          )
        )
      )
    )
  ),
  server = function(input, output, session) {
    
 #----------------- Show original image ------------------------
    
    # show selected image   
    observeEvent(input[["up"]], {
    output$imgOrg <- renderImage({
      inFile <-  input[["up"]]

      width  <- session$clientData$output_plaatje_width
      height <- session$clientData$output_plaatje_height
      list(
        src = inFile$datapath,
        width = width,
        height = height
      )},
       deleteFile = FALSE
    )
    })
    
 #----------------- Cut original image  ------------------------

    # create start button, after image selection 
    observeEvent(input[["up"]], {
      output$start <- renderUI({
        f7Button(inputId = "start",
                 label = "Give me the results!",
                 size = "large")
      })
    })    
    
    
    #initiate values 
    tokens <- reactiveValues()
    
    
    # cut image in 36 peaces
    observeEvent(input[["start"]], {
      
      # get image
      inFile <- input[["up"]]
      rawImg <- image_read(inFile[["datapath"]])
      
      # describe dimension of image
      info <- image_info(rawImg)
      width <- info$width/6
      height <- info$height/6

      # define cuttings
      mat <- data.frame(index = 1:36,
                        cell = rep(1:6, each = 6),
                        row = rep(1:6, 6),
                        nam = paste(rep(1:6, each = 6), 
                                    rep(1:6, 6), sep = "_")) %>%
        mutate(width_end = cell * width,
               height_end = row * height,
               width_start = cell * width - width,
               height_start = row * height - height)
      
      #start cutting for each row in mat 
      for(i in 1:nrow(mat)){
        
        window <- paste0(round(width, 0), "x", round(height,0), "+",
                         round(mat$width_start[i],0), "+", round(mat$height_start[i],0))
        
        #  print(window)
        tokens[[paste0("A", i)]] <- image_crop(rawImg, window)
        
      }  
      
    })
    
    observeEvent(input[["start"]], {
      
      outfile <- tempfile(fileext = ".png")
      
      pic <- tokens[["A8"]]
      
      image_write(pic, path = outfile, format = "png")
 
      
      output$imgCut <- renderImage({
        
        width  <- session$clientData$output_plaatje_width
        height <- session$clientData$output_plaatje_height
        
        list(
          src = outfile,
          width = width,
          height = height,
          contentType = "image/png"
        )},
        deleteFile = FALSE
      )
    })
    
    
    
  }  

 )
