rm(list = ls())

setwd('C:/Users/T450s/Desktop/programming/git/sentiment_analysis-medium')
library(tidyverse)
library(aws.translate)
library(aws.comprehend)
library(ggpubr)
library(data.table)
library(ggcharts)
library(scales) 


# Setting up R w/AWS - key is stored locally and not updated to git
keyTable <- read.csv("path to file...", header = T) # 
AWS_ACCESS_KEY_ID <- as.character(keyTable$Access.key.ID)
AWS_SECRET_ACCESS_KEY <- as.character(keyTable$Secret.access.key)

Sys.setenv("AWS_ACCESS_KEY_ID" = AWS_ACCESS_KEY_ID,
           "AWS_SECRET_ACCESS_KEY" = AWS_SECRET_ACCESS_KEY,
           "AWS_DEFAULT_REGION" = "eu-west-1") 

## I will translate the text from hun to eng, since sentiment analysis doesn't work on hun text yet 

df <- read_csv('data/clean/articles_final2.csv') #articles 

for (string in seq_along(df$article_text)){
    article_text_eng[[string]] <- translate(df$article_text[[string]],
                                            from='hu', to = "en")
}

# I take out the the first element of the created list and assign some dummy values in case the result was NULL
first_elem <- c()

for(elem in article_text_eng){
    first_elem <- c(first_elem,elem[1])
}

for (elem in seq_along(first_elem)) {
    if (is.null(first_elem[[elem]])){
        first_elem[[elem]] <- 'NA'
    } 
}

#convert list to character vector so that I can append to the dataframe. Then writing out dataframe to disk
df$article_text_eng <- unlist(first_elem)
saveRDS(df,'data/clean/translated2.rds')
write_csv(df,path = 'data/clean/translated2.csv')

    
## Let's play with Amazon's sentiment analysis application 

sentiment_df <- data.frame()
for (i in seq_along(df$article_text_eng)){
    sentiment_row <- detect_sentiment(df$article_text_eng[i])
    sentiment_df <- rbind(sentiment_df,sentiment_row)
}

final_df <- cbind(df,sentiment_df)
final_df$Index <- NULL
write_csv(final_df,path='data/clean/sentiment_annalised2.csv') 

mean(final_df$n_characters)

# write_csv(final_df,path='data/clean/sentiment_analised_final.csv')

## Create some plots


summary <- final_df %>% 
    group_by(news_site,article) %>% 
    summarise(char_sum = sum(n_characters),
              pos = sum((n_characters*Positive)/sum(n_characters)),
              neg = sum((n_characters*Negative)/sum(n_characters)),
              mix = sum((n_characters*Mixed)/sum(n_characters)),
              neu = sum((n_characters*Neutral)/sum(n_characters))
    )

#charts from the perspective of articles


groupColors <- c('#696969','#228b22',"#ff8c00", "#0000ff",'#ff0000')

p1<- ggplot(summary,aes(x=char_sum,color = news_site, fill = news_site) )+
    geom_density(alpha=0.6, color = NA)+
#    geom_histogram( aes(y = ..density..) , alpha = 0.2, binwidth = 300, color = 'black', fill = NA) +
#    geom_density( aes(y = ..density..) , alpha = .2 , bw = 300, color = 'black', fill="#FF6666") +
#    geom_histogram( aes(y=..density..), alpha = 0.5, position = 'identity', binwidth = 300) +
#    geom_density( aes(y = ..density..) , alpha = .2 , bw = 300, color = 'black', fill="#FF6666")+
    scale_fill_manual(values=groupColors) +
    labs(x='Number of characters in each article',y='Density')+
    scale_color_manual(labels = c('24.hu','444.hu','Index.hu','Origo.hu','pestisracok.hu'))+
    guides(fill=guide_legend(title="News Site:"))


p2 <- ggplot(final_df,aes(x=n_characters,color = news_site, fill = news_site) )+
    geom_density(alpha=0.6, color = NA)+
    scale_fill_manual(values=groupColors) +
    labs(x='Number of characters in each paragraph',y='Density')+
    scale_color_manual(labels = c('24.hu','444.hu','Index.hu','Origo.hu','pestisracok.hu'))+
    guides(fill=guide_legend(title="News Site:"))
 

ggarrange(p1, p2, nrow = 1, common.legend = TRUE, legend = 'bottom')

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


long_summary %>% mutate(
    value = scales::percent(x = value,accuracy=0.01)
)

chart <- ggcharts::bar_chart(
    long_summary,
    variable,
    value,
    fill = news_site,
    facet = news_site, sort=T) +
    labs(y = NULL, x = NULL, fill = NULL) +
    scale_fill_manual(values=groupColors) +
    geom_label(aes(label=scales::percent(value,accuracy = 0.01)), color= 'black', fill='white',position = position_dodge(width = 1),
              vjust = 0.5, hjust =0.1) + scale_y_discrete(expand = expansion(c(0, 0.8)))
    

chart

#Let's see how this changes in time 
ts_groupColors <- c('#228b22','#ff0000',"#0000ff", '#696969')

##first, create new table for Index
index_ts <- summary[summary$news_site == 'Index',]
# order needs to be changed
index_ts <- index_ts[order(-index_ts$article),]
index_ts$article <- 1:length(index_ts$article)
index_ts$news_site <- NULL
index_ts$char_sum <- NULL
long_index = melt(index_ts, id.vars="article")

##second, origo
origo_ts <- summary[summary$news_site == 'Origo',]
origo_ts$news_site <- NULL
origo_ts$char_sum <- NULL
long_origo = melt(origo_ts, id.vars="article")

## third 24.hu
twentyfour_ts <- summary[summary$news_site == '24',]
twentyfour_ts$news_site <- NULL
twentyfour_ts$char_sum <- NULL
long_twentyfour = melt(twentyfour_ts, id.vars="article")

## fourth 444
fourfourfour_ts <- summary[summary$news_site == '444',]
# order needs to be changed
fourfourfour_ts <- fourfourfour_ts[order(-fourfourfour_ts$article),]
fourfourfour_ts$article <- 1:length(fourfourfour_ts$article)
fourfourfour_ts$news_site <- NULL
fourfourfour_ts$char_sum <- NULL
long_fourfourfour = melt(fourfourfour_ts, id.vars="article")

## lastly pestisracok
pestisracok_ts <- summary[summary$news_site == 'pestisracok',]
# order needs to be changed
pestisracok_ts <- pestisracok_ts[order(-pestisracok_ts$article),]
pestisracok_ts$article <- 1:length(pestisracok_ts$article)
pestisracok_ts$news_site <- NULL
pestisracok_ts$char_sum <- NULL
long_pestisracok = melt(pestisracok_ts, id.vars="article")

# plotting chronological
p11<- ggplot(long_twentyfour, aes(fill=variable, y=value, x=article)) + 
    geom_bar(position="stack", stat="identity")+
    scale_fill_manual(values=ts_groupColors) +
    labs(y='Percentage')+ 
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank(), axis.line = element_line(colour = "black"))+
    guides(fill=guide_legend(title="Sentiment: "))

p12<- ggplot(long_fourfourfour, aes(fill=variable, y=value, x=article)) + 
    geom_bar(position="stack", stat="identity")+
    scale_fill_manual(values=ts_groupColors) +
    labs(y='Percentage')+ 
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank(), axis.line = element_line(colour = "black"))+
    guides(fill=guide_legend(title="Sentiment: "))


p13<- ggplot(long_index, aes(fill=variable, y=value, x=article)) + 
    geom_bar(position="stack", stat="identity")+
    scale_fill_manual(values=ts_groupColors) +
    labs(y='Percentage')+ 
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank(), axis.line = element_line(colour = "black"))+
    guides(fill=guide_legend(title="Sentiment: "))

p14<- ggplot(long_origo, aes(fill=variable, y=value, x=article)) + 
    geom_bar(position="stack", stat="identity")+
    scale_fill_manual(values=ts_groupColors) +
    labs(y='Percentage')+ 
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank(), axis.line = element_line(colour = "black"))+
    guides(fill=guide_legend(title="Sentiment: "))

p15<- ggplot(long_pestisracok, aes(fill=variable, y=value, x=article)) + 
    geom_bar(position="stack", stat="identity")+
    scale_fill_manual(values=ts_groupColors) +
    labs(y='Percentage')+ 
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                panel.background = element_blank(), axis.line = element_line(colour = "black"))+
    guides(fill=guide_legend(title="Sentiment: "))


ggarrange(p11,p12,p13,p14, p15, 
          nrow = 2, 
          ncol = 3, 
          common.legend = TRUE, 
          legend = 'bottom', 
          labels = c('24','444','Index','Origo','PS'),
          font.label= (list(size = 12)),
          label.x = -0.015, label.y = 0.9)

