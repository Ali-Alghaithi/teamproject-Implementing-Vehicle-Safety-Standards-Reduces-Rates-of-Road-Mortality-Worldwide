library(ggplot2)
library(scales)
library(ggmap)
library(dplyr)

rmfDat <- read.csv("roadMortFact.csv")
rmfDat$AnnualRoadDeathsPer100kPeople <- as.numeric(rmfDat$AnnualRoadDeathsPer100kPeople)

map.dat <- map_data("world")
map.dat$region <- tolower(map.dat$region)
map.dat$region <- gsub(" ", "", map.dat$region)
map.dat$region <- gsub("-", "", map.dat$region)
map.dat$region <- gsub("'", "", map.dat$region)
map.dat$region <- gsub("c?te d'ivoire", "ivorycoast", map.dat$region)
map.dat$region <- gsub("uk", "unitedkingdom", map.dat$region)
map.dat$region <- gsub("usa", "unitedstates", map.dat$region)
map.dat$region <- gsub("czechrepublic", "czechia", map.dat$region)
map.dat$region <- gsub("republicofcongo", "republicofthecongo", map.dat$region)
map.dat$region <- gsub("swaziland", "eswatini", map.dat$region)
map.dat$region <- gsub("unitedkingdomraine", "ukraine", map.dat$region)
map.dat$region <- gsub("greenland", "denmark", map.dat$region)

shinyServer(function(input, output) {
  
  # setting the reactive environment 
  dataInput <- reactive({
    subset(rmfDat,
             factor==input$selectedFactor)
  })
  
  # PLotting the bar plots
  output$myPlot <- renderPlot({
    ggplot(top_n(dataInput(), n=40, value), aes(reorder(country,value),value))+ 
      geom_point(color="steelblue", size=4)+
      coord_flip() + theme_bw() + xlab(NULL) + ggtitle("Top 40 Countries") + theme(plot.title = element_text(hjust = 0.5))
    
  })
  
  output$myFactor <- renderPlot({ 
    sDat <- dataInput() %>% 
      arrange(-value)
    topCountry <- sDat$country[1]
    subDat <- subset(rmfDat,country==topCountry)
  })

  
  output$myMap <- renderPlot({ 
    combdat <- merge(map.dat, dataInput(), by.x=c('region'),
                     by.y=c('country'), all.x=TRUE)
    odat <- combdat[order(combdat$order),]
    ggplot(odat, aes(x=long, y=lat,group=group)) +
      geom_polygon(aes(fill=value), colour = alpha("white", 0.2)) + 
      theme_bw() + scale_fill_continuous(low="light blue", high="dark blue") +
      theme(
        legend.position = "none",
        text = element_blank(), 
        line = element_blank()) + ggtitle("Selected Factor")
  })
  
  # Plotting the road deaths map
  output$deathMap <- renderPlot({ 
    combdat <- merge(map.dat, rmfDat, by.x=c('region'),
                     by.y=c('country'), all.x=TRUE)
    odat <- combdat[order(combdat$order),]
    ggplot(odat, aes(x=long, y=lat,group=group)) +
      geom_polygon(aes(fill=AnnualRoadDeathsPer100kPeople), colour = alpha("white", 0.2)) + 
      theme_bw() + scale_fill_continuous(low="pink", high="dark red") + 
      theme(
        legend.position = "none",
        text = element_blank(), 
        line = element_blank()) + labs(title = "Annual Road Deaths per 100k People",
                                             x = NULL,
                                             y = NULL)
  })
  
})
