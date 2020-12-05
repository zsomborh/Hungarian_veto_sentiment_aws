rm(list = ls())

setwd('C:/Users/T450s/Desktop/programming/git/sentiment_analysis-medium')
library(tidyverse)
library(aws.translate)
library(aws.comprehend)
library(ggpubr)
library(data.table)
library(ggcharts)
library(scales) 


# Setting up R w/AWS 
keyTable <- read.csv("path to file", header = T) # 
AWS_ACCESS_KEY_ID <- as.character(keyTable$Access.key.ID)
AWS_SECRET_ACCESS_KEY <- as.character(keyTable$Secret.access.key)

Sys.setenv("AWS_ACCESS_KEY_ID" = AWS_ACCESS_KEY_ID,
           "AWS_SECRET_ACCESS_KEY" = AWS_SECRET_ACCESS_KEY,
           "AWS_DEFAULT_REGION" = "eu-west-1") 

## The below is commented out so that I don't accidentally run it twice. Translation costs money. 

# df <- read_csv('data/clean/articles_final.csv')
# article_text_eng <- c()
#
# mylist<- for (string in seq_along(df$article_text)){
#    article_text_eng[[string]] <- translate(df$article_text[[string]],from='hu', to = "en")
# }
#
# df$article_text_eng <- unlist(article_text_eng)
# saveRDS(df,'data/clean/translated.rds')
# write_csv(df,path = 'data/clean/translated.csv')



## Let's play with Amazon's sentiment analysis application - again commenting this out so that I don't run the codes by mistake

#sentiment_df <- data.frame()
#for (i in seq_along(df$article_text_eng)){
#    sentiment_row <- detect_sentiment(df$article_text_eng[i])
#    sentiment_df <- rbind(sentiment_df,sentiment_row)
#}


#final_df <- cbind(df,sentiment_df[1:553,])
#final_df$Index <- NULL
#write_csv(final_df,path='data/clean/sentiment_analised.csv')

## Create some plots


final_df<- read_csv('data/clean/sentiment_analised.csv')


summary <- final_df %>% 
    group_by(news_site,article) %>% 
    summarise(char_sum = sum(n_characters),
              pos = sum((n_characters*Positive)/sum(n_characters)),
              neg = sum((n_characters*Negative)/sum(n_characters)),
              mix = sum((n_characters*Mixed)/sum(n_characters)),
              neu = sum((n_characters*Neutral)/sum(n_characters))
    )

#charts from the perspective of articles


groupColors <- c("#ff8c00", "#0000ff")

p1<- ggplot(summary,aes(x=char_sum,color = news_site, fill = news_site) )+
    geom_density(alpha=0.6, color = NA)+
#    geom_histogram( aes(y = ..density..) , alpha = 0.2, binwidth = 300, color = 'black', fill = NA) +
#    geom_density( aes(y = ..density..) , alpha = .2 , bw = 300, color = 'black', fill="#FF6666") +
#    geom_histogram( aes(y=..density..), alpha = 0.5, position = 'identity', binwidth = 300) +
#    geom_density( aes(y = ..density..) , alpha = .2 , bw = 300, color = 'black', fill="#FF6666")+
    scale_fill_manual(values=groupColors) +
    labs(x='Number of articles in each paragraph',y='Density')


p2 <- ggplot(final_df,aes(x=n_characters,color = news_site, fill = news_site) )+
    geom_density(alpha=0.6, color = NA)+
    scale_fill_manual(values=groupColors) +
    labs(x='Number of characters in each paragraph',y='Density')

ggarrange(p1, p2, nrow = 1 )


# Bar chart for the two entities
summary2 <- final_df %>% 
    group_by(news_site) %>% 
    summarise(char_sum = sum(n_characters),
              pos = sum((n_characters*Positive)/sum(n_characters)),
              neg = sum((n_characters*Negative)/sum(n_characters)),
              mix = sum((n_characters*Mixed)/sum(n_characters)),
              neu = sum((n_characters*Neutral)/sum(n_characters))
    )

summary2$char_sum <- NULL

## Breakdown of sentiments
long_summary = melt(summary2, id.vars="news_site")

ggplot(data=long_summary, aes(x=variable, y=value, fill=news_site)) +
    geom_bar(stat="identity") + 
    facet_grid(.~variable, scale = 'free', space = 'free_x', switch= 'both') +
    scale_fill_manual(values=groupColors) 


chart <- ggcharts::bar_chart(
    long_summary,
    variable,
    value,
    fill = news_site,
    facet = news_site
) +
    labs(y = NULL, x = NULL, fill = NULL) +
    scale_fill_manual(values=groupColors) +
    geom_label(aes(label=scales::percent(round(value,4))), color= 'black', fill='white')

