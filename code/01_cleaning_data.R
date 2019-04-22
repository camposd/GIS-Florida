library(rgdal)
library(here)
library(tidyverse)
library(maptools)


# Reading in Data ---------------------------------------------------------

rl.neighborhoods <- readOGR(here("data"),layer = "geo_export_1da20307-9d76-4424-a714-bc0f9e08e86c")
opd.crimes <- read_csv(here("data","OPD_Crimes.csv"))

# opd.crimes is a dataset provided by the Orlando Police Department of crimes and their
# types throughout the city. It's a fairly decent dataset of 180K observations
# orl.neighborhoods is a shapefile provided by the open data portal of the city of
# Orlando demarcating all the Orlando neighborhoods 

# Cleanign Data -----------------------------------------------------------

opd.crimes <- 
        opd.crimes %>% 
        rename_all(tolower)

orl.neighborhoods %>% 
     merge(opd.crimes, by = c("nbhdid", "orlando neighborhoods")) # this did not work because
# i used the wrong arguments for the key columns 

opd.neighborhoods <- unique(opd.crimes$`orlando neighborhoods`)

#works...maybe

opd.orl.df <- merge(opd.crimes, 
                    orl.neighborhoods, 
                    by.x = "orlando neighborhoods", 
                    by.y = "nbhdid")

# trying to aggregate a particular type of crime to each neighborhood and then
# merge that to the original shapefile and then maybe light will shine down upon me

assault.count <- opd.crimes %>% 
        group_by(`orlando neighborhoods`) %>% 
        filter(`case offense category` == "Assault") %>% 
        count() 

#merging the aggregated number of assults to our SPDF 
orl.assaults <- 
        merge(orl.neighborhoods, 
              assault.count, 
              by.x = "nbhdid", 
              by.y = "orlando neighborhoods")

assault.df <- 
        tidy(orl.assaults) %>% #converts the SPDF into a "tidy" dataframe
        mutate(id = as.numeric(id)) %>% 
        full_join(assault.count, by = c("id" = "orlando neighborhoods")) 



#rough visualization
ggplot(assault.df, aes(long,lat, group = group)) + 
        geom_polygon(aes(fill = n)) + 
        geom_path(color = "white") + 
        coord_equal()

class(assault.count$`orlando neighborhoods`)
