library(dataRetrieval)
library(dplyr)

# (1) Extract the unique site IDs from quarterly snapshot
site_ids <- groundwater_qtr %>%
  distinct(site_no) %>%
  pull(site_no)

# (2) Download site metadata (includes lat/long) for those sites
site_info <- readNWISsite(site_ids) %>%
  # keep only the columns you need
  select(site_no,
         dec_lat_va,     # latitude
         dec_long_va)    # longitude

# (3) Left-join the lat/long back onto quarterly data
groundwater_loc <- groundwater_qtr %>%
  left_join(site_info, by = "site_no")

# (4) Check: do all rows now have a lat/long?
groundwater_loc %>%
  filter(is.na(dec_lat_va) | is.na(dec_long_va)) %>%
  distinct(site_no)   # should be zero sites
