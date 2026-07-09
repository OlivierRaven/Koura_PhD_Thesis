# Koura livable habitat calculated from LERNZmp data 
# Explanation of this script------------------------------------------------
# 
# Clean and load packages ------------------------------------------------------
cat("\014"); rm(list = ls())#; dev.off()
#sapply(.packages(), unloadNamespace)

#Set working derectory
setwd("~/PhD/Data/Lakes/Lakes_waterquality")

# Define the list of packages
packages <- c("readxl","readr", "tidyverse", "dplyr", "ggplot2")

# Load packages if not already installed
lapply(packages, function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE))
    install.packages(pkg, dependencies = TRUE)
  library(pkg, character.only = TRUE)})

# Import the data --------------------------------------------------------------
# Import buoy data
Rotoiti_CTD_bouy <- list.files(path = "Data_raw/Bouy_rotoiti", pattern = "\\.csv$", full.names = TRUE)
Rotoiti_CTD_bouy <- bind_rows(lapply(Rotoiti_CTD_bouy, read.csv)) # make it into a DF
write.csv(Rotoiti_CTD_bouy, "Data_mod/Rotoiti_CTD_bouy.csv", row.names = FALSE)

Okaro_CTD_bouy <- list.files(path = "Data_raw/Okaro_bouy_profiles", pattern = "\\.csv$", full.names = TRUE)
Okaro_CTD_bouy <- bind_rows(lapply(Okaro_CTD_bouy, read.csv)) # make it into a DF
write.csv(Okaro_CTD_bouy, "Data_mod/Okaro_CTD_bouy.csv", row.names = FALSE)

Rotoiti_CTD_bouy <- read_csv("Data_mod/Rotoiti_CTD_bouy.csv")
Okaro_CTD_bouy <- read_csv("Data_mod/Okaro_CTD_bouy.csv")

water_quality_data <- read_csv("Data_mod/water_quality_data.csv")
hypsograph_data <- read_csv("Data_mod/hypsograph_data.csv")


# Analize the data -------------------------------------------------------------
# Filter for DO and Temp variables
DO_Tem_data <- water_quality_data %>%
  filter(var_aeme %in% c("CHM_oxy", "HYD_temp"))%>%
  mutate(lake_name = str_replace(lake_name, "\\s*\\(.*\\)", ""))

# Check unique Dates
unique(DO_Tem_data$Date)

# Plotting DO and Temp with ggplot
ggplot(DO_Tem_data, aes(value, depth_mid, col = Date)) +
  geom_line() +
  facet_wrap(var_aeme ~ lake_name, scales = "free") +
  scale_y_reverse()

# Simplify data frames
DO_Tem_data1 <- DO_Tem_data %>%
  select(Date, depth_mid, var_aeme, value, lake_name) %>%
  pivot_wider(names_from = var_aeme, values_from = value, names_prefix = "") %>%
  rename(Lake = lake_name, Depth = depth_mid, DO = CHM_oxy, Temp = HYD_temp) %>%
  select(Lake, Date, Depth, DO, Temp)

# Add Cast_ID for grouping
DO_Tem_data1 <- DO_Tem_data1 %>%
  group_by(Lake, Date) %>%
  mutate(Cast_ID = cur_group_id()) %>%
  ungroup()

# Count unique Cast_IDs by Lake
cast_counts <- DO_Tem_data1 %>%
  select(Lake, Cast_ID) %>% 
  distinct() %>%
  group_by(Lake) %>%
  summarise(Total_Casts = n(), .groups = "drop")

# Check sum of cast counts
sum(cast_counts$Total_Casts)


# Process Hypsograph Data 

# Clean hypsograph data and calculate area at depth
hypsograph_data1 <- hypsograph_data %>%
  filter(depth == floor(depth)) %>%
  mutate(depth = abs(depth), 
         Area_at_Depth = abs(area_ha - lag(area_ha, default = first(area_ha)))) %>%
  filter(!is.na(area_ha)) %>%
  arrange(lake_name, depth) %>%
  group_by(lake_name) %>%
  mutate(Area_at_Depth = if_else(depth == 0, 0, Area_at_Depth),  # Set Area_at_Depth to 0 when depth is 0
         Area_depth_0 = first(area_ha)) %>%  # Keep Area_depth_0 as the first area_ha, without changes
  ungroup() %>%
  select(Lake = lake_name, Depth = depth, Area = area_ha, Area_at_Depth, Area_depth_0, Total_area = total_area)%>%
  mutate(Lake = str_replace(Lake, "\\s*\\(.*\\)", ""))


# Combine DO/Temp and Hypsograph Data 

DO_Tem_area_data <- DO_Tem_data1 %>%
  left_join(hypsograph_data1, by = c("Lake" = "Lake", "Depth" = "Depth")) %>%
  filter(!is.na(Area))

# Add Date-related columns and Season information
DO_Tem_area_data <- DO_Tem_area_data %>%
  mutate(Date = as.Date(Date),
         Day = day(Date),
         Month = month(Date, label = TRUE, abbr = TRUE),
         Year = year(Date),
         Season = case_when(
           Month %in% c("Dec", "Jan", "Feb") ~ "Summer",
           Month %in% c("Mar", "Apr", "May") ~ "Autumn",
           Month %in% c("Jun", "Jul", "Aug") ~ "Winter",
           Month %in% c("Sep", "Oct", "Nov") ~ "Spring"
         ))

# Calculate Livable Habitat 

# Add column for Livable Habitat (DO >= 5 and Temp <= 21)
DO_Tem_area_data$Livable_Habitat <- with(DO_Tem_area_data, DO >= 5 & Temp <= 21)

# Example to filter and sum Area_at_Depth
example <- DO_Tem_area_data %>%
  filter(Cast_ID == 733)
sum(example$Area_at_Depth)

# Calculate livable habitat sum and area
livable_habitat_sum <- DO_Tem_area_data %>%
  filter(Livable_Habitat == FALSE) %>%
  group_by(Lake, Date) %>%
  summarise(Area_depth_0 = first(Area_depth_0), 
            Sum_Livable_Habitat_Area = Area_depth_0 - sum(Area_at_Depth, na.rm = TRUE), 
            .groups = "drop")

livable_habitat_sum <- livable_habitat_sum %>%
  left_join(DO_Tem_area_data %>% select(Lake, Date, Day, Month , Year, Season, Cast_ID  ), by = c("Lake", "Date"))

# Calculate livable habitat percentage
livable_habitat_sum <- livable_habitat_sum %>%
  mutate(Livable_Habitat_Percentage = (Sum_Livable_Habitat_Area / Area_depth_0) * 100)


# Plotting 

# Plot Livable Habitat Percentage over time with Seasons
ggplot(livable_habitat_sum, aes(Date, Livable_Habitat_Percentage, col = Season)) +
  geom_point() +
  facet_wrap(~Lake, scales = "free")




# Analize the Buoy data --------------------------------------------------------

head(Rotoiti_CTD_bouy)
head(Okaro_CTD_bouy)

Rotoiti_CTD_bouy$Lake <- "Rotoiti"
Okaro_CTD_bouy$Lake <- "Okaro"

# Combine the two datasets into one
CTD_bouy <- rbind(Rotoiti_CTD_bouy, Okaro_CTD_bouy)

# Filter and select relevant columns
Bouy_data <- CTD_bouy %>%
  select(c("Lake", "DateTime", "DptSns", "TmpWtr", "DOconc")) %>%
  rename(Depth = DptSns, Temp = TmpWtr, DO = DOconc) %>%
  distinct(Lake, DateTime, .keep_all = TRUE)%>%
  mutate(DateTime = as.POSIXct(DateTime, format = "%Y-%m-%d %H:%M:%S")) %>%  # Ensure DateTime is in POSIXct format
  drop_na(DateTime, Depth) %>% 
  mutate(Date = as.Date(DateTime),                      
         Time = format(DateTime, "%H:%M:%S"),   # Extract the time in HH:MM:SS format
         Year = year(DateTime),
         Month = month(DateTime, label = TRUE),          
         Day = day(DateTime),                             
         Season = case_when(                               
           Month %in% c("Dec", "Jan", "Feb") ~ "Summer",
           Month %in% c("Mar", "Apr", "May") ~ "Autumn",
           Month %in% c("Jun", "Jul", "Aug") ~ "Winter",
           Month %in% c("Sep", "Oct", "Nov") ~ "Spring",
           TRUE ~ NA_character_),
         Date_Time_Numeric = as.numeric(DateTime),
         Time_of_Day = case_when(                       # Add a column for time of day
           hour(DateTime) >= 6 & hour(DateTime) < 12 ~ "Morning",
           hour(DateTime) >= 12 & hour(DateTime) < 18 ~ "Afternoon",
           hour(DateTime) >= 18 & hour(DateTime) < 24 ~ "Evening",
           TRUE ~ "Night"))

summary(Bouy_data)

Bouy_data1 <- Bouy_data %>%
  arrange(Lake, Date, Time) %>%  # Ensure the data is ordered by Date and Time
  mutate(Depth = round(Depth),  # Round Depth to the nearest integer
    cast_id = cumsum(Depth < lag(Depth, default = first(Depth))) + 1) %>%  # Increment cast_id when Depth decreases
  mutate(cast_id = as.factor(cast_id)) %>%  # Convert cast_id to a factor
  group_by(Lake, Date) %>%
  mutate(num_casts = n_distinct(cast_id)) %>%  # Count the number of distinct casts per date
  ungroup() %>%
  group_by(Lake,Date, cast_id, Depth) %>%  # Group by Date, cast_id, and Depth to handle duplicates
  summarise(Temp = mean(Temp, na.rm = TRUE),    # Take mean of Temp for duplicate Depths
    DO = mean(DO, na.rm = TRUE),        # Take mean of DO for duplicate Depths
    across(-c(Temp, DO), first)  ) %>%         # Retain the first value of other columns
  ungroup() 

summary(Bouy_data1)

Bouy_data2<-Bouy_data1%>%
  left_join(hypsograph_data1, by = c("Lake" = "Lake", "Depth" = "Depth"))

summary(Bouy_data2)

# Add column for Livable Habitat (DO >= 5 and Temp <= 21)
Bouy_data2$Livable_Habitat <- with(Bouy_data2, DO >= 5 & Temp <= 21)

# Calculate livable habitat sum and area
Bouy_livable_habitat <- Bouy_data2 %>%
  filter(Livable_Habitat == FALSE) %>%  # Filter for non-livable habitat
  group_by(Lake, Date, cast_id) %>% 
  summarise(Area_depth_0 = first(Area_depth_0), Sum_Livable_Habitat_Area = Area_depth_0 - sum(Area_at_Depth, na.rm = TRUE),.groups = "drop") %>% 
  left_join(Bouy_data2 %>% 
      select(Lake, Date, Day, Month, Year, Season, Time_of_Day , cast_id), by = c("Lake", "Date", "cast_id")) %>% 
  mutate(Livable_Habitat_Percentage = (Sum_Livable_Habitat_Area / Area_depth_0) * 100)%>%
  distinct(Lake, Date,cast_id, .keep_all = TRUE)


# Plot Livable Habitat Percentage over time with Seasons
ggplot(Bouy_livable_habitat, aes(Date, Livable_Habitat_Percentage, col = Time_of_Day)) +
  geom_point() +
  facet_wrap(~Lake, scales = "free")


