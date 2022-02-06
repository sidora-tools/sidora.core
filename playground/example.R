library(magrittr)

#### download and prepare the data from poseidon & pandora ####

con <- sidora.core::get_pandora_connection(".credentials")

pandora <- sidora.core::get_df_list(c("TAB_Site", "TAB_Individual", "TAB_Sample"), con) %>%
  sidora.core::join_pandora_tables() %>%
  dplyr::filter(!sample.Ethically_culturally_sensitive) %>%
  dplyr::select(individual.Full_Individual_Id, site.Latitude, site.Longitude) %>%
  dplyr::filter(!is.na(site.Latitude) & !is.na(site.Longitude)) %>%
  unique # necessary, because the input table is on sample level, but individuals are relevant here

poseidon <- poseidonR::read_janno("~/agora/published_data", validate = F) %>%
  dplyr::filter(Date_Type %in% c("C14", "contextual")) %>%
  dplyr::select(Poseidon_ID, Latitude, Longitude) %>%
  dplyr::filter(!is.na(Latitude) & !is.na(Longitude)) %>%
  tibble::as_tibble()

aadr <- readr::read_tsv("https://reichdata.hms.harvard.edu/pub/datasets/amh_repo/curated_releases/V50/V50.0/SHARE/public.dir/v50.0_1240K_public.anno") %>%
  dplyr::filter(`Full Date: One of two formats. (Format 1) 95.4% CI calibrated radiocarbon age (Conventional Radiocarbon Age BP, Lab number) e.g. 2624-2350 calBCE (3990±40 BP, Ua-35016). (Format 2) Archaeological context range, e.g. 2500-1700 BCE` != "present") %>%
  dplyr::select(`Version ID`, Lat., Long.) %>%
  dplyr::mutate(
    Lat. = as.numeric(Lat.),
    Long. = as.numeric(Long.)
  ) %>%
  dplyr::filter(!is.na(Lat.) & !is.na(Long.))

#### prepare spatial data objects ####

world_coastline <- rnaturalearth::ne_coastline(scale = "medium", returnclass = "sf")

world <- rnaturalearth::ne_countries(scale = "medium", returnclass = "sf")
world_6933 <- sf::st_transform(world, 6933)
world_grid_6933 <- sf::st_make_grid(
  world_6933,
  #cellsize = c(1000000,1000000),
  n = c(60,30),
  what = 'polygons',
  flat_topped = TRUE
) %>% sf::st_as_sf() %>%
  dplyr::mutate(
    area_id = seq_along(x)
  )
  
pandora_sf <- pandora %>% 
  sf::st_as_sf(coords = c('site.Longitude', 'site.Latitude'), crs = 4326) %>%
  sf::st_transform(6933)

poseidon_sf <- poseidon %>%
  sf::st_as_sf(coords = c('Longitude', 'Latitude'), crs = 4326) %>%
  sf::st_transform(6933)

aadr_sf <- aadr %>%
  sf::st_as_sf(coords = c('Long.', 'Lat.'), crs = 4326) %>%
  sf::st_transform(6933)

#### perform counting in spatial bins ####

world_with_count <- world_grid_6933 %>%
  dplyr::mutate(
    Pandora = sf::st_intersects(world_grid_6933, pandora_sf) %>% lengths(),
    Poseidon = sf::st_intersects(world_grid_6933, poseidon_sf) %>% lengths(),
    AADR = sf::st_intersects(world_grid_6933, aadr_sf) %>% lengths()
  ) %>%
  tidyr::pivot_longer(tidyselect::one_of("Pandora", "Poseidon", "AADR"), names_to = "database", values_to = "count") %>%
  dplyr::filter(count != 0)

world_max <- world_with_count %>%
  dplyr::group_by(area_id) %>%
  dplyr::summarise(
    max_id = which.max(count),
    database = ifelse(length(count) > 1 & length(which(count == max(count))) > 1, "2+ DBs equal", database[max_id]),
    distance = count[max_id] - ifelse(length(count[-max_id]) == 0, 0, max(count[-max_id]))
  )

#### plots ####

library(ggplot2)

single_map <- function(db, color, title) {
  current_world_count <- world_with_count %>% dplyr::filter(database == db & count != 0)
  ggplot() +
    geom_sf(
      data = current_world_count, 
      mapping = aes(fill = count), color = "black", size = 0.1
    ) +
    geom_sf(data = world_coastline, color = "black", cex = 0.2) +
    geom_sf_text(
      data = current_world_count, 
      mapping = aes(label = count), color = "black", size = 2
    ) +
    coord_sf(crs = "+proj=natearth") +
    #coord_sf(crs = 6933) +
    scale_fill_gradientn(
      colours = c("lightgrey", color),
      guide = "colorbar"
    ) +
    theme_minimal() +
    theme(
      legend.position = "bottom",
      legend.background = element_blank(),
      panel.grid.major = element_line(colour = "grey", size = 0.3)
    ) +
    guides(
      fill = guide_colorbar(title = title, barwidth = 20, barheight = 1.5)
    )
}

single_map("Pandora", "red", "Pandora individuals count")
single_map("Poseidon", "#3A77F1", "Poseidon individuals count")
single_map("AADR", "#00A44D", "AADR individuals count")

# difference map
ggplot() +
  geom_sf(
    data = world_max, 
    mapping = aes(fill = database, alpha = distance), color = "black", size = 0.1
  ) +
  geom_sf_text(
    data = world_max, 
    mapping = aes(label = distance), color = "black", size = 2
  ) +
  geom_sf(data = world_coastline, color = "black", cex = 0.2) +
  coord_sf(crs = "+proj=natearth") +
  scale_fill_manual(
    values = c("Pandora" = "red", "Poseidon" = "#3A77F1", "AADR" = "#00A44D", "2+ DBs equal" = "lightgrey")
  ) +
  scale_alpha_continuous(range = c(0.3, 1), ) +
  theme_minimal() +
  theme(
    legend.position = "bottom",
    legend.background = element_blank(),
    panel.grid.major = element_line(colour = "grey", size = 0.3)
  ) +
  guides(alpha = "none")
