rm(list = ls())

setwd('C:/Users/T450s/Desktop/programming/git/sentiment_analysis-medium')
library(tidyverse)
library(data.table)

article_unlist <- function(article_list) {
    i <<- i + 1 # we take i as a global variable - this is probably not the most elegant solution
    data_list = list()
    data_list[['article_text']] <- unlist(article_list)
    data_list[['paragraphs']] <- 1:length(unlist(article_list))
    data_list[['article']] <- rep(i,length(unlist(article_list)))
    return(data_list)
}

origo_articles <- readRDS(file= 'data/raw/origo_articles_list.rds')
i = 0 #specify i as it is going to be used in the article_unlist function
df_origo <- rbindlist(lapply(origo_articles, article_unlist))
df_origo$n_characters <- nchar(df_origo$article_text)
df_origo$news_site <- 'Origo'
ggplot(df_origo,aes(x=n_characters)) + geom_histogram() # none of the articles are close to 5k characters


index_articles <- readRDS(file= 'data/raw/index_articles_list.rds')
i = 0 #specify i as it is going to be used in the article_unlist function
df_index <- rbindlist(lapply(index_articles, article_unlist))
df_index$n_characters <- nchar(df_index$article_text)
df_index$news_site <- 'Index'
ggplot(df_index,aes(x=n_characters)) + geom_histogram() # none of the articles are close to 5k characters


fourfourfour_articles <- readRDS(file= 'data/raw/fourfourfour_articles_list.rds')
i = 0 #specify i as it is going to be used in the article_unlist function
df_fourfourfour <- rbindlist(lapply(fourfourfour_articles, article_unlist))
df_fourfourfour$n_characters <- nchar(df_fourfourfour$article_text)
df_fourfourfour$news_site <- '444'
ggplot(df_fourfourfour,aes(x=n_characters)) + geom_histogram() # none of the articles are close to 5k characters


twentyfour_articles <- readRDS(file= 'data/raw/twentyfour_articles_list.rds')
i = 0 #specify i as it is going to be used in the article_unlist function
df_twentyfour <- rbindlist(lapply(twentyfour_articles, article_unlist))
df_twentyfour$n_characters <- nchar(df_twentyfour$article_text)
df_twentyfour$news_site <- '24'
ggplot(df_twentyfour,aes(x=n_characters)) + geom_histogram()


pestisracok_articles <- readRDS(file= 'data/raw/pestisracok_articles_list.rds')
i = 0 #specify i as it is going to be used in the article_unlist function
df_pestisracok <- rbindlist(lapply(pestisracok_articles, article_unlist))
df_pestisracok$n_characters <- nchar(df_pestisracok$article_text)
df_pestisracok$news_site <- 'pestisracok'
ggplot(df_pestisracok,aes(x=n_characters)) + geom_histogram()


final_df<- rbind(df_index, df_origo, df_fourfourfour, df_twentyfour, df_pestisracok)

#write_csv(final_df, path ='data/clean/articles_final.csv' ) - updated final 2 file has more articles compared to v1
write_csv(final_df, path ='data/clean/articles_final2.csv' )