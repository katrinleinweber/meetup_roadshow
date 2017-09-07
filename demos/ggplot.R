library(tidyverse)
library(rwars)
library(forcats)
library(ggrepel)
library(ggthemes)

## What is the ratio of ships to vehicles in each movie?

trilogies <- c("Prequels: Episode I-III", "Originals: Episode IV-VI", "Sequels: Episode VII")
films <- rwars::get_all_films()$results
results <- tibble(
  title = map_chr(films, "title"),
  episode = map_dbl(films, "episode_id"),
  starships = map_dbl(films, ~length(.x$starships)),
  vehicles = map_dbl(films, ~length(.x$vehicles)),
  planets = map_dbl(films, ~length(.x$planets))
) %>% 
  mutate(ratio = starships / (vehicles + starships) * 100) %>% 
  mutate(Trilogy = trilogies[findInterval(episode, c(1,4,7))])

ggplot(results, aes(reorder(title, episode), ratio)) + 
  geom_bar(aes(fill = Trilogy), stat = "identity", size = 1) +
  labs(
    title = "The Rise of Hyperdrive",
    subtitle = "Percentage of Ships with Hyperdrive Capability"
  ) +
  scale_y_continuous(labels = function(x){paste(x,"%")}) +
  theme_fivethirtyeight() +
  scale_colour_fivethirtyeight() +
  theme(
    axis.text.x = element_text(angle = 35, vjust = 0.9, hjust = 0.9)
  )
  

  

  
