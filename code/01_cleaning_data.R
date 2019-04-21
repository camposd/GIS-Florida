library(rgdal)
library(here)
library(tidyverse)


# Reading in Data ---------------------------------------------------------

rl.neighborhoods <- readOGR(here("data"),layer = "geo_export_1da20307-9d76-4424-a714-bc0f9e08e86c")
opd.crimes <- read_csv(here("data","OPD_Crimes.csv"))


# Cleanign Data -----------------------------------------------------------

opd.crimes <- 
        opd.crimes %>% 
        rename_all(tolower)
