# RStudio 2017 Meetup Roadshow

## Demos

These demos are designed to highlight the [tidyverse](http://tidyverse.org) and [RStudio Connect](https://rstudio.com/about/products/connect). 

If you want to see the end results, play with RStudio Connect, or if you just love Star Wars try http://roadshow.rstudio.com. 

The demos make use of [R Markdown](http://rmarkdown.rstudio.com) and [Shiny](http://shiny.rstudio.com) to empower R users to become data storytellers. The reports and applicatons are designed to allow end users to ask questions of the content instead of returning to the analyst for "what if" scenarios.

## Getting Started

The easiest way to get started is to clone the repository into a new RStudio project. Simply go to `New Project` -> `Version Control` and enter the repository URL (available above). If you're new to Git, you can also open the files and copy them directly.

The project includes packrat but does not use packrat by default. If you'd like to restore the package environment used to create the demos, run `packrat::on()` and `packrat::restore()` from within the project. 

**WARNING** Restoring the environment can take awhile since the project uses quite a few R packages.

## Feedback & Questions

If you attended one of RStudio's presentations we'd really appreciate if you'd take 5 minutes to fill out this [survey](http://roadshow.rstudio.com/survey).

For errors or questions on code please submit an issue to this repository. For questions on RStudio Connect please email sales@rstudio.com. 

## Data

These demos make use of the [Star Wars API](http://swapi.co/about) under the BSD license. Copyright Paul Halett 2017.

## Licensure

Use of http://roadshow.rstudio.com is subject to the following [Terms of Service](https://www.rstudio.com/about/connect-terms-of-use/). All demo material contained in this repository is distributed under the MIT license.
