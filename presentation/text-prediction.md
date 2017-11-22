Text Prediction Application
========================================================
author: Enrique Repullés.
date: 22-11-2017
autosize: true


- Application for coursera Data Science Capstone project.
- Purpose: to predict the next word in a sentence.


The application 
========================================================  

Nowadays there are a lot of webs and social networks that work with text, and several input methods in all the devices. Therefore is of uttermost importance to improve the user's agility when entering text. Our application does this trying to predicting the next word in a sentence.
A prototype of the application can be found here: 

[enrique-repulles.shinyapps.io/predict-text/](https://enrique-repulles.shinyapps.io/predict-text/)


**Usage:** insert the  sentence in the "Insert text" box and press the "predict" button. The prediction will be shown, and also a word-cloud of the possible candidates.

Sources can be found in [github.com/enrique-repulles/predictive-text](https://github.com/enrique-repulles/predictive-text)



Model construction
========================================================

  For building the model, the raw material were some texts with excerpts from different sources:

- blogs
- newsletters
- twitteraccount

Each file was scanned for tokens: single words, bigrams (pairs of consecutive words), trigrams and tetragrams. Some word cleaning was done: numbers and punctuation characters were removed.

Then the frequency of each token was then calculated. These frequencies are used later for the prediction phase. 



Word prediction
========================================================

The prediction algorithm works as follows:

When the user enters a sentence in the app, it is parsed into words, and then the list of possible candidates is built, based on the most frequent training tokens that appear around the words. The list is supplemented with the most frequent tokens and stop words.

Once the candidates list is built, the application looks for the most promising, assigning a probability to each one. To obtain the probabilities, it retrieves the frequency of the  tetragram, trigram, bigram and single word, and mixes up  all frequencies in a weighted sum. 

The candidate with the highest probability is offered to the user as most promising word.



Performance estimation
========================================================


For estimating the algorithm performance, the following method was used: 

The corpora was split into training and test sets. The text in the training set was used to find the token frequencies, and the  app was run against sentences from the test set  and the number of successes was counted.

A compromise between accuracy and data size was done to allow the algorithm data to fit in small devices. A final accuracy of 27% accuracy was obtained.


More information at [github.com/enrique-repulles/predictive-text](https://github.com/enrique-repulles/predictive-text)


