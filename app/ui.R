#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(stringr)
library(dplyr)
library(leaflet)
library(sf)
library(shinythemes)
accidentes <- read.csv("www/accidentes_medellin.csv",header = TRUE,encoding='UTF-8')
accidentes$comuna <- str_replace_all(accidentes$comuna, "laureles-estadio","laureles estadio")
accidentes$fecha <- as.Date(accidentes$fecha) 


# Define UI for application that draws a histogram
shinyUI(
  navbarPage(
    collapsible = TRUE,
    theme = shinytheme("flatly"),
    title = "Medellin Crash",
  
                   
    tabPanel(title = "Mapa accidentes",
            icon = icon("map-pin"),
            
            #lateral derecho
            fluidPage(
              sidebarLayout(
                sidebarPanel(width = 4,
                  #fechas
                  dateRangeInput(
                  "fecha_mapa", 
                  label = "Ingrese la fecha:",
                  start = '2014-01-01',
                  end = '2018-12-31',
                  min = '2014-01-01',
                  max = '2018-12-31'),
                  #clase
                  selectInput(
                    "clase_mapa",
                    label = "Clase",
                    selected = "TODOS",
                    choices = c("TODOS",toupper(distinct(accidentes,clase)$clase))
                  ),
                  #comuna
                  selectInput(
                    "comuna_mapa",
                    label = "Comuna",
                    selected = "---",
                    choices = c("---",toupper(distinct(accidentes,comuna)$comuna))
                  ),
                  conditionalPanel("input.comuna_mapa != '---'",
                                   # Solo muestra el selector barrio si hay una comuna seleccionada
                                   uiOutput("select_barrio")
                  )
                 
                  
             ),
             mainPanel(width = 8,
               (leafletOutput("mapa"))
            ))
       
           )
    ),
  #prediccion
  tabPanel(title = "Predicciones",
           icon = icon("chart-bar"),
           fluidPage(
             titlePanel("Resultados modelos predictivos"),
             p("El modelo solo puede realizar predicciones entre el 2019 y el 2022"),
             fluidRow(
               #fechas
               column(4,
                 dateRangeInput(
                   "fecha_prediccion", 
                   label = "Ingrese la fecha:",
                   start = '2019-01-01',
                   end = '2022-12-31',
                   min = '2019-01-01',
                   max = '2022-12-31')
                 ),
               column(4,
                 #tipo
                 selectInput(
                   "tipo_prediccion",
                   label = "Nivel predicción",
                   selected = "---",
                   choices = c("---","Diario","Semanal","Mensual")
                 ))
             ),
             mainPanel(width = 12,
                       DT::dataTableOutput("prediccion")
             )
             
           )
           
   ),
  tabPanel(title = "Agrupación Barrios",
           icon = icon("code-branch"),
           fluidPage(
             h2("Agrupamiento de los barrios de Medellín"),
             includeHTML("www/grupos.html"),
             leafletOutput("cluster",height = 600)
             
             
           )
           ),
  tabPanel(title="Video",
           icon = icon("youtube"),
           fluidPage(
           HTML(paste0(
             '<iframe width="560" height="315" src="https://www.youtube.com/embed/VTM6SDmXuas" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>'
           ))
           )

  )
  
  
  
))
