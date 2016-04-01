library(rvest)
library(twitteR)

consumerKey='x'
consumerSecret='x'
accesstoken ='x'
tokensecret = 'x'

#establishing connection with Twitter api

setup_twitter_oauth(consumerKey,
                    consumerSecret,
                    accesstoken,
                    tokensecret)

setwd('D:/Analysis/tweet_bot')

#tweet_base_in_case_scraping_fails

quote_base <- data.frame(quote=c("Success is going from failure to failure without losing your enthusiasm",
                                 "The journey of a thousand miles begins with one step",
                                 "Dream big and dare to fail",
                                 "What you do speaks so loudly that I cannot hear what you say",
                                 "You must be the change you wish to see in the world",
                                 "Tough times never last, but tough people do",
                                 "Keep your face to the sunshine and you can never see the shadow",
                                 "Make each day your masterpiece",
                                 "The best dreams happen when you're awake",
                                 "Every moment is a fresh beginning",
                                 "Don't count the days, make the days count",
                                 "The difference between ordinary and extraordinary is that little extra",
                                 "You must not only aim right, but draw the bow with all your might"),
                         
                         
                         by=c("Winston Churchill",
                              "Lao Tzu",
                              "Norman Vaughan",
                              "Ralph Waldo",
                              "MK Gandhi",
                              "Dr. Robert Schuller",
                              "Helen Keller",
                              "John Wooden",
                              "Cherie Gilderbloom",
                              "T.S. Eliot",
                              "Muhammad Ali",
                              "Jimmy Johnson",
                              "Henry David Thoreau"))


#morning_tweet_from_forbes

if(strftime(Sys.time(),format = '%H:%m')<'13:00') {
  
  welcome <- read_html('http://www.forbes.com/forbes/welcome/')
  
  
  quote <- html_node(welcome,css='#content > div.content-container > div > div > p.body-content') %>% html_text(trim=TRUE)
  
  by <- html_node(welcome,css='#content > div.content-container > div > div > p.body-byline') %>% html_text(trim=TRUE)
  
  
  quote <- iconv(quote, "latin1", "ASCII", sub="")
  
  quote <- gsub("[^[:alnum:]///' ]", "", quote)
  
  write(paste(Sys.Date(),',',quote,',',by,sep = ''),'quote.log')
  
  
} else {
  
  #afternoon_tweet_from_brainyquotes
  
  qtd <- read_html('http://www.brainyquote.com/quotes_of_the_day.html')
  
  quote <- html_node(qtd,css='body > div.container.bqTopLevel > div.row.bq_left > div.col-sm-8.col-md-8 > div.m_panel.sticky_adzone > div:nth-child(2) > div:nth-child(3) > div.boxyPaddingBig.bqcpx > span > a ') %>% html_text(trim=TRUE)
  
  by <- html_node(qtd,css='body > div.container.bqTopLevel > div.row.bq_left > div.col-sm-8.col-md-8 > div.m_panel.sticky_adzone > div:nth-child(2) > div:nth-child(3) > div.boxyPaddingBig.bqcpx > div > a') %>% html_text(trim=TRUE)
  
  quote <- iconv(quote, "latin1", "ASCII", sub="")
  
  quote <- gsub("[^[:alnum:]///' ]", "", quote)
  
  write(paste(Sys.Date(),',',quote,',',by,sep = ''),'quote1.log')
  
  
}


#checking_twitter_char_limit

if(nchar(quote) > 140){
  
  x <- sample(1:13, 1, replace=F)
  
  quote <- quote_base$quote[x]
  by <- quote_base$by[x]
  
}

by_ws <- gsub(" ", "", by, fixed = TRUE)

new_tweet <- paste(quote,' - ',by,' ','#quote ','#',by_ws, sep = '')



if(nchar(new_tweet) > 140) {
  
  new_tweet <- paste(quote,' - ',by,' ','#quote ', sep = '')
  
  if(nchar(new_tweet) > 140){
    
    new_tweet <- paste(quote,' - ',by,sep = '')
    
  }
  
  if(nchar(new_tweet) > 140){
    
    new_tweet <- quote
    
  }
  
}

#lets_tweet_the_quote

tweet(new_tweet)

#writing_a_log

write(new_tweet,'tweet.log')
