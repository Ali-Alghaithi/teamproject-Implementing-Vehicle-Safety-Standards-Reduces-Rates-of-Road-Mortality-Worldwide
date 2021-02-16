rmfDat <- read.csv("roadMortFact.csv")
myFactor <- as.character(unique(rmfDat$factor))

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  ###################### first row starts here
  fluidRow(
    column(12,
           # Application title takes all 12 column spaces
           titlePanel("Factors in road deaths")
    )),
  
  ###################### 2nd row starts here. 2 columns 
  fluidRow(
    column(5,
           wellPanel(
             selectInput("selectedFactor", 
                         label = "Choose a factor to display",
                         choices = myFactor, 
                         selected = myFactor[1]),
             
             "This projects explores factors related to road deaths worldwide..."
           )
    ),
    column(6, 
           plotOutput("deathMap",height = "300px", width="550px")
    )      
  ),
  
  ###################### 3rd row starts here. 2 columns
  fluidRow(
    column(5, 
           plotOutput("myPlot",height = "900px",width="350px")
    ),
    column(6, 
           plotOutput("myMap",height = "300px", width="550px")
    )  
  )
  

))