library(tidyverse)
library(rwars)
library(forcats)
library(ggrepel)
library(ggthemes)

## What is the ratio of ships to vehicles in each movie?


films <- rwars::get_all_films()$results
results <- tibble(
  title = map_chr(films, "title"),
  episode = map_dbl(films, "episode_id"),
  starships = map_dbl(films, ~length(.x$starships)),
  vehicles = map_dbl(films, ~length(.x$vehicles)),
  planets = map_dbl(films, ~length(.x$planets))
) %>% 
  mutate(ratio = starships / (vehicles + starships) * 100) %>% 
  arrange(episode) %>% 
  mutate(Trilogy = c(rep("Prequels: Episode I-III", 3), rep("Originals: Epsiode IV-VI", 3), rep("Sequels: Episode VII", 1))) %>% 
  mutate(title = factor(title, levels = title))


ggplot(results, aes(title, ratio)) + 
  geom_line(group = 1) +
  geom_point(aes(color = Trilogy), stat = "identity", size = 4) +
  labs(
    title = "The Rise of Hyperdrive",
    subtitle = "Percentage of Ships with Hyperdrive Capability"
  ) +
  scale_y_continuous(labels = function(x){paste(x,"%")}) +
  theme_fivethirtyeight() +
  scale_colour_fivethirtyeight()
  

  

  
