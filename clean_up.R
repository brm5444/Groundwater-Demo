library(dplyr)

# 1) Identify which columns are the date columns:
date_cols <- grep("^dt_", names(groundwater_wide), value = TRUE)

# 2) Compute the minimum non-NA count (75% of all date cols):
min_obs <- ceiling(length(date_cols) * 0.75)

# 3) Filter rows by counting non-NAs across those columns:
groundwater_wide_clean <- groundwater_wide %>%
  filter(
    rowSums(!is.na(select(., all_of(date_cols)))) >= min_obs
  )

# 4) (Optional) Check how many sites remain
nrow(groundwater_wide_clean)


