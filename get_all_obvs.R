library(dataRetrieval)
library(dplyr)
library(lubridate)

# --- a) Find all PA wells with DAILY groundwater‐level records (parameterCd = "72019") ---
dv_sites <- whatNWISdata(
  stateCd    = "PA",
  service    = "dv",
  parameterCd= "72019"
) %>% 
  distinct(site_no) %>% 
  pull()

# --- b) Download the DAILY values for those sites ---
dv_groundwater <- readNWISdv(
  siteNumbers = dv_sites,
  parameterCd = "72019",
  startDate   = "2005-01-01",
  endDate     = "2025-05-01"
)

# --- c) Rename & parse the date column (it comes in as “Date”) ---
dv_groundwater <- dv_groundwater %>%
  rename(lev_dt = Date) %>%
  mutate(lev_dt = ymd(lev_dt))

# --- d) Now filter to Jan 1, Apr 1, Jul 1, Oct 1 of each year ---
groundwater_qtr <- dv_groundwater %>%
  filter(
    month(lev_dt) %in% c(1, 4, 7, 10),
    day(  lev_dt) == 1
  )

# How many rows?
groundwater_qtr %>% tally()
