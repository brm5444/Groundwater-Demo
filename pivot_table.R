library(dplyr)
library(tidyr)

# 1) If needed, rename level column to something simple
#    (replace X_72019_00003 with whatever value‐column is called)
groundwater_loc <- groundwater_loc %>%
  rename(level = X_72019_00003)

# 2) Pivot to wide: id’s are site_no + lat/long, names come from lev_dt, values from level
groundwater_wide <- groundwater_loc %>%
  select(site_no, dec_lat_va, dec_long_va, lev_dt, level) %>%
  pivot_wider(
    id_cols     = c(site_no, dec_lat_va, dec_long_va),
    names_from  = lev_dt,
    values_from = level,
    names_prefix = "dt_"        # optional: makes column names like dt_2005-01-01
  )

# 3) Inspect
glimpse(groundwater_wide)
