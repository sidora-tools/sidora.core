library(magrittr)

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

world <- rnaturalearth::ne_countries(scale = "medium", returnclass = "sf")
world_6933 <- sf::st_transform(world, 6933)
world_grid_6933 <- sf::st_make_grid(
  world_6933,
  cellsize = c(400000,400000),
  what = 'polygons',
  flat_topped = TRUE
) %>% sf::st_as_sf()
  
pandora_sf <- pandora %>% 
  sf::st_as_sf(coords = c('site.Longitude', 'site.Latitude'), crs = 4326) %>%
  sf::st_transform(6933)

poseidon_sf <- poseidon %>%
  sf::st_as_sf(coords = c('Longitude', 'Latitude'), crs = 4326) %>%
  sf::st_transform(6933)

world_with_count <- world_grid_6933 %>%
  dplyr::mutate(
    pandora_count = sf::st_intersects(world_grid_6933, pandora_sf) %>% lengths(),
    poseidon_count = sf::st_intersects(world_grid_6933, poseidon_sf) %>% lengths(),
    difference = pandora_count - poseidon_count
  ) %>%
  dplyr::filter(pandora_count != 0 & poseidon_count != 0)

world_coastline <- rnaturalearth::ne_coastline(scale = "medium", returnclass = "sf")

library(ggplot2)
ggplot() +
  geom_sf(data = world_with_count, mapping = aes(fill = difference), color = NA) +
  geom_sf(data = world_coastline, color = "black", cex = 0.2) +
  coord_sf(crs = "+proj=robin +lon_0=0 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m no_defs") +
  scale_fill_gradientn(
    colours = c("blue","grey","red"), 
    values = scales::rescale(c(min(world_with_count$difference),0,max(world_with_count$difference))),
    guide = "colorbar", 
    limits = c(min(world_with_count$difference),max(world_with_count$difference)),
    breaks = c(-80, seq(0, 1400, 200))
  ) +
  theme_minimal() +
  theme(
    legend.position = "bottom",
    legend.background = element_blank()
  ) +
  guides(
    fill = guide_colorbar(title = "Difference (Pandora - Poseidon)", barwidth = 20, barheight = 1.5)
  )
