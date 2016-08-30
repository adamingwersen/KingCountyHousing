pkgs <- c('data.table',
          'ggplot2',
          'ggthemes',
          'plotly',
          'stringr',
          'tidyr',
          'dplyr',
          'choroplethr',
          'choroplethrMaps',
          'ggmaps')
lapply(pkgs, require, character.only = TRUE)

dir <- '~/Documents/Data/Kaggle/Housesalesprediction/kc_house_data.csv'
houses.dt <- fread(dir)

## Initial Inspection

houses.dt$grade <- as.factor(houses.dt$grade)
houses.dt$condition <- as.factor(houses.dt$condition)
p = ggplot(data = houses.dt, aes(x = sqft_living, y = price))
p = p + geom_point(colour = grade) + theme_economist() + labs(title = 'Price ~ Size', x= 'Square-footage', y = 'Sell Price')
p = p + scale_color_economist() + theme(plot.title=element_text(hjust=0.5))
plot(p)

lm <- lm(price ~ sqft_basement, data = houses.dt)
plot(lm)
lm


## Data cleaning

houses.dt$date <- gsub('T\\d{6}', '', houses.dt$date,)
houses.dt$date <- as.Date(houses.dt$date, "%Y%m%d")

p = ggplot(data = houses.dt, aes(x = date, y = price, group = condition, colour = condition))
p = p + geom_point(aes(alpha = 0.1)) + theme_economist() + scale_color_fivethirtyeight()
p = p  + theme(plot.title=element_text(hjust=0.5)) + labs(title = 'Price ~ Size', x= 'Date', y = 'Sell Price')
plot(p)

summary(houses.dt$condition)

is.data.table(houses.dt)
houses.dt[, lapply(.SD, sum), by = date]

ibrary(dplyr)

sumhouses.dt <- houses.dt %>%
  group_by(date && grade) %>%
  summarise(avg.price = mean(price))

g = ggplot(data = sumhouses.dt, aes(x = date, y = avg.price))
g = g + geom_line() + theme_fivethirtyeight() + scale_color_tableau()
g = g + theme(plot.title=element_text(hjust=0.5)) + labs(title = 'Average Sales Prices', x = 'Date', y = 'Avg. Daily Sell Price')
plot(g)

counties <- map_data('county')
washington <- subset(counties, region == "washington")
king <- subset(washington, subregion == "kings")
kingsCounty <- merge(washington, houses.dt, by=c("lat","long"))
washington <- subset(states, region %in% c("california", "oregon", "washington"))






