# Install all used packages

pkgs <- c('dplyr', 'rvest', 'httr', 'RJSONIO', 'caret', 'data.table', 
          'ggplot2', 'ggthemes', 'plotly', 'mapsDK',
          'tidyr', 'stringr', 'jsonlite', 'knitr', 'rmarkdown', 'reshape2',
          'ggmap', 'devtools', 'RCurl', 'Rcpp', 'lubridate',
          'wordcloud', 'tm', 'RTextTools', 'quanteda', 'MASS',
          'randomForest', 'lift', 'gbm', 'XML')


ipak <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)) 
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
}
ipak(pkgs)


