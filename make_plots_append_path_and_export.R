# Load required packages
library(dplyr)
library(tidyr)
library(lubridate)
library(ggplot2)

# 1) Identify the “dt_…” date columns
date_cols <- grep("^dt_", names(groundwater_wide_clean), value = TRUE)

# 2) Pivot back to long format for plotting
gw_long <- groundwater_wide_clean %>%
  pivot_longer(
    cols      = all_of(date_cols),
    names_to  = "date",
    values_to = "level"
  ) %>%
  mutate(
    date = ymd(sub("^dt_", "", date))
  )

# 3) Make sure an 'images' folder exists in your working directory
if (!dir.exists("images")) {
  dir.create("images")
}

# 4) Loop over each site, create a time‐series plot + trend line, and save as PNG
for (site in unique(gw_long$site_no)) {
  df_site <- filter(gw_long, site_no == site)
  
  p <- ggplot(df_site, aes(x = date, y = level)) +
    geom_line() +
    geom_smooth(method = "lm", se = FALSE) +    # add linear trend line
    labs(
      title = paste("Groundwater Level – Site", site),
      x     = "Date",
      y     = "Depth"
    ) +
    theme_minimal()
  
  ggsave(
    filename = file.path("images", paste0(site, ".png")),
    plot     = p,
    width    = 6,
    height   = 4
  )
}


# 5) Add a column to groundwater_wide_clean with the image URL path
groundwater_wide_clean <- groundwater_wide_clean %>%
  mutate(
    image_html = paste0(
      '<img src="https://support.agconservation.psu.edu/groundwater/images/',
      site_no,
      '.png"/>'
    )
  )


# 6) Inspect the first few rows to confirm
groundwater_wide_clean %>%
  select(site_no, image_path) %>%
  slice_head(n = 5)

filename <- "pa_gw_data"

write.csv(groundwater_wide_clean, filename)