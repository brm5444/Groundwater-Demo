library(dplyr)

# 1) Identify date columns again
date_cols <- grep("^dt_", names(groundwater_wide_clean), value = TRUE)

# 2) Add an “avg_level” column as the mean of those date columns
groundwater_wide_clean <- groundwater_wide_clean %>%
  mutate(
    avg_level = rowMeans(across(all_of(date_cols)), na.rm = TRUE)
  )

# 3) Quick check
groundwater_wide_clean %>% 
  select(site_no, starts_with("dt_") %>% head(2), avg_level) %>%
  slice(1:5)


