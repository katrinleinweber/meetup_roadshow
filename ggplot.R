library(tidyverse)
library(rwars)
library(ggrepel)
library(ggthemes)

## What is the ratio of ships to vehicles in each movie?
## Does this depend on the number of planets?

films <- rwars::get_all_films()$results
results <- tibble(
  title = map_chr(films, "title"),
  episode = map_dbl(films, "episode_id"),
starships = map_dbl(films, ~length(.x$starships)),
  vehicles = map_dbl(films, ~length(.x$vehicles)),
  planets = map_dbl(films, ~length(.x$planets))
)

results <- results %>% 
  mutate(ratio = starships / (vehicles + starships) * 100,
         total = vehicles + starships,
         label = paste0(title, "\n", vehicles," vehicles / ", starships, " starships")) %>% 
  arrange(episode) %>% 
  mutate(trilogy = c(rep("prequel", 3), rep("original", 3), rep("sequel", 1)))

lab = tibble(
  planets = rep(0,3),
  label = c("Episode I-II", "Episode IV-VI", "Episode VII"),
  ratio = c(58, 78, 105)
  #color = c("#f4d142", "#418ff4", "#42bc46")
)


p <- ggplot(results, aes(x = planets, y = ratio)) + 
#  geom_density2d(data = results %>% filter(episode < 7), aes(color = trilogy), 
#                 alpha = 0.5, contour = TRUE) + 
  geom_point(aes(size = total),color = "darkgrey") +
  geom_text_repel(aes(label = title, color = trilogy),
                   nudge_y = 6 , family = "Droid Sans",
                   color =c(rep("#ffe81f",3), rep("#418ff4",3), "#42bc46")) +
  labs(
    title = "The Rise of Hyperdrive",
    y = "Ships with Hyperdrive",
    x = "Number of Planets",
    size = "Number of Unique Ships"
  ) +
  scale_y_continuous(labels = function(x){paste(x,"%")}) +
  scale_x_continuous(limits = c(-2, max(results$planets +1))) +
  scale_fill_continuous(guide = FALSE) +
  geom_text(data = lab, aes(label = label), family = "Droid Sans", fontface = "bold",
             color = c("#f4d142", "#418ff4", "#42bc46")) +
  scale_color_manual(values  = c("#418ff4", "#ffe81f", "#42bc46"), guide = FALSE) +
  theme(
    text = element_text(family = "Dejavu Serif", face = "bold", color = "white"),
    plot.background = element_rect(fill = "black"),
    legend.background = element_rect(fill = "black"),
    panel.background = element_rect(fill = "black"),
    axis.text = element_text(color = "white"),
    legend.key = element_rect(fill = "black", size = 0),
    panel.grid.major = element_line(color = "darkgrey")
  )
  
p

  

  
