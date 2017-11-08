library("tm")
library("quanteda")
source("auxiliar_functions.R")

calculate.ngram.freq <- function(words, n, umbral ) 
{
  ngrams<-tokens_ngrams(words, n = n)
  ngrams<-removeFeatures(x=ngrams, features="EOS", valuetype="regex")
  ngrams.dfm<-dfm(ngrams)
  
  #word.dfm<-dfm_trim(ngrams.dfm, min_count=umbral, max_count=10)
  
  freq <- textstat_frequency(ngrams.dfm)
  ngrams.freq <-freq$frequency
  names(ngrams.freq) <- freq$feature
  
  #print(c(ngrams.freq,sum(freq$frequency),ngrams.freq/sum(freq$frequency)))
  
  ngrams.freq<-(ngrams.freq[(ngrams.freq/sum(freq$frequency))>umbral])
  ngrams.freq
}


train <- function(training.dir, w1, w2, w3, t1, t2, t3, t4)
{
  
  # Preparation
  # Read the list of offensive words 
  offensive.words<-readLines("raw_data/Terms-to-Block.csv")
  offensive.words<-offensive.words[5:length(offensive.words)]
  offensive.words<-gsub("[\"]","",offensive.words)
  offensive.words<-gsub("[,]","",offensive.words)  
  
  
  # Corpus for frequency information
  corpus.source<-DirSource(training.dir)
  tmcorpus1 <- tm::VCorpus(corpus.source, readerControl = list(reader=readPlain,language = "en"))
  tmcorpus1 <- tm_map(tmcorpus1, content_transformer(char_tolower))
  # tmcorpus <- tm_map(tmcorpus, removeWords, stopwords("english")) # quitar
  tmcorpus1 <- tm_map(tmcorpus1, removeWords, offensive.words)
  tmcorpus1 <- tm_map(tmcorpus1, removeNumbers)
  tmcorpus1 <- tm_map(tmcorpus1, mark.sentences)
  #tmcorpus <- tm_map(tmcorpus, removePunctuation)
  
  tmcorpus1 <- tm_map(tmcorpus1 ,stripWhitespace)
  frequency.corpus<-corpus(tmcorpus1)
  
  
  # Ngrams frequency
  words<-tokens(frequency.corpus, remove_punct = TRUE, remove_url = TRUE)
  
  
  # Organize result object 
  
 

  
  train.data<-list (
    word.freq=calculate.ngram.freq(words,1L,t1 ),
    bigram.freq=calculate.ngram.freq(words,2L,t2),
    trigram.freq=calculate.ngram.freq(words,3L,t3),
    tetragram.freq=calculate.ngram.freq(words,4L,t4),
    # most.frequent.words = names(most.frequent.words),
    # bigram.context = context.bigrams,
    stopwords =  tm::stopwords("english"),
    weights=c(w1,w2,w3, 1-w1-w2-w3)
  )
  
  
  
  train.data
}




predict.word <- function (query) 
{
  clean.query<-tolower(trimws(stripWhitespace(removePunctuation(removeNumbers(query)))))
  
  candidates<-candidates.probability(clean.query)
  
  # Remove repeated words
  
  
  list(
    candidates=candidates[order(candidates$prob,decreasing = TRUE)[1:10],], 
    word=candidates[which.max(candidates$prob),]$word
  )
  
  
}



find.candidates<-function (query)
{
  query.words<-unlist(strsplit (query," "))
  last_word <- lastn(query,1)
  candidate_pattern <- paste0(c("^","_"), last_word, "_", collapse = "|")
  candidate_index<-grep (names(train.data$bigram.freq),pattern = candidate_pattern)
  candidates<-unlist(sapply(X=names(train.data$bigram.freq)[candidate_index], FUN=function(x)lastn(x,1,"_")))
  
  #Remove candidates already in the sentence
  
  
  if (length(candidates)==0 & length(query.words)>1)
  { # look foor previous words
    candidates<-find.candidates(paste(query.words[1:(length(query.words)-1)],collapse = " "))
  }
  
  if (length(candidates)==0 & length(query.words)==1)
  {
    candidates<-train.data$stopwords
  }
  
  clean.candidates<-candidates[!(candidates %in% query.words)]
  
  
  if (length(clean.candidates)>0)
  {
    return(clean.candidates)
  }
  else 
  {
    return(candidates)
  }
  
  
}

candidates.probability <- function (query) {
  
  MAX_WORDS<-4
  
  
  # look for candidates
  
  candidates<-data.frame(word=find.candidates(query))
  candidates$full.sentence<-paste(query, candidates$word, sep = " ")
  
  candidates$words<-sapply(candidates$full.sentence, function (x) lastn (x,1))
  candidates$bigrams<-sapply(candidates$full.sentence, function (x) lastn (x,2))
  candidates$trigrams<-sapply(candidates$full.sentence, function (x) lastn (x,3))
  candidates$tetragrams<-sapply(candidates$full.sentence, function (x) lastn (x,4))
  
  #Calculate frecuencies for candidates
  
  candidates$word.freq<-train.data$word.freq[candidates$words]
  candidates$bigram.freq<-train.data$bigram.freq[candidates$bigrams]
  candidates$trigram.freq<-train.data$trigram.freq[candidates$trigrams]
  candidates$tetragram.freq<-train.data$tetragram.freq[candidates$tetragrams]
  
  candidates$word.freq[is.na(candidates$word.freq)]<-0
  candidates$bigram.freq[is.na(candidates$bigram.freq)]<-0
  candidates$trigram.freq[is.na(candidates$trigram.freq)]<-0
  candidates$tetragram.freq[is.na(candidates$tetragram.freq)]<-0
  candidates$word.prob<-(1+candidates$word.freq)/(1+sum(train.data$word.freq)) 
  candidates$bigram.prob<-(1+candidates$bigram.freq)/(1+sum(train.data$bigram.freq)) 
  candidates$trigram.prob<-(1+candidates$trigram.freq)/(1+sum(train.data$trigram.freq)) 
  candidates$tetragram.prob<-(1+candidates$tetragram.freq)/(1+sum(train.data$tetragram.freq)) 
  
  candidates$prob<-(
    train.data$weights[1]*candidates$word.prob + 
      train.data$weights[2]*candidates$bigram.prob +
      train.data$weights[3]*candidates$trigram.prob +
      train.data$weights[4]*candidates$tetragram.prob)/4
  return (candidates)
  
}




#remove sentences with length 1 
nwords<-function (x)
{
  words<-unlist(strsplit(x," "))
  length(words)
}

get.query<-function (x)
{
  words<-unlist(strsplit(x," "))
  paste(words[1:length(words)-1],collapse=" ")
}

get.correct.word<-function (x)
{
  words<-unlist(strsplit(x," "))
  words[length(words)]
}



execute.test <- function (evaluation.dir,test.size) {  

  corpus.source<-DirSource(evaluation.dir)
  tmcorpus1 <- tm::VCorpus(corpus.source, readerControl = list(reader=readPlain,language = "en"))
  validation.corpus<-corpus(tmcorpus1)
  sentences<-tokens(validation.corpus, remove_url = TRUE,  what = "sentence")
  
  sampled.sentences<-sample(unlist(sentences),size = test.size)
  sampled.sentences<-tolower(sampled.sentences)
  sampled.sentences<-removePunctuation(sampled.sentences)
  sampled.sentences<-removeNumbers(sampled.sentences)
  sampled.sentences<-stripWhitespace(removeNumbers(sampled.sentences))
  
  

  large.sentences<-(sapply(X=sampled.sentences, FUN=nwords) > 2)
  sampled.sentences<-sampled.sentences[large.sentences]
  
  
  result<-data.frame(sampled.sentences)
  result$sampled.sentences<-as.character(result$sampled.sentences)

  
  result$query<-sapply(X=result$sampled.sentences, FUN=get.query)
  result$correct.word<-sapply(X=result$sampled.sentences, FUN=get.correct.word)
  
  #Execute prediction
  
  result$prediction <-sapply(X=result$query,FUN=function(x) predict.word(x)$word)
  
  result
  
  
}