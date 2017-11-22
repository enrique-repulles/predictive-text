1 Text Prediction Application
========================================================
author: Enrique Repullés.
date: 22-11-2017
autosize: true


- Application for coursera Data Science Capstone project.
- Purpose: to predict the next word in a sentence.


2 The application 
========================================================

Nowadays there are a lot of webs and social networks that work with text, and several input methods in all the devices. Therefore is of uttermost importance to improve the user agility when entering text. Our application does this trying to predicting the next word in a sentence.

A prototype of the application can be found here: 

[https://enrique-repulles.shinyapps.io/predict-text/]


**Usage:** insert the  sentence in the "Insert text" box and press the "predict" button. The prediction will be shown, and also a word-cloud of the possible candidates.

Souces can be found in [https://github.com/enrique-repulles/predictive-text]



3 Model construction
========================================================

For building the model, a corpora of texts was build from the following sources: 

[??]

Each file was scanned for tokens: single words, bigrams (pairs of consecutive words), trigrams and tetragrams. Some word cleaning is done: numbers and punctuation characters are removed.

Then the frecuency of each tokens is the calculated. These frecuencies are used later for the prediction phase.



4 Word prediction
========================================================

The prediction algorith works as follows: 

When the user //introduces// a sentence in the app, it is //separado// en words, and a then list of posible candidates is built based on the most frecuent //training tokens//  that are found  appear around the words. The list is //complementada// with the most frequent tokens and stop words.

One the candidates list is built, we look for the most promising, asigning a probability to each one. To obtain the probabilities, we //recuperamos// la frecuency of the full tetragram, trigram, bigram and single word, and //mezcla// all frequencies in a weighted sum. 

The candiate with the hgihter probability is offered to the user as most //prometedor// word.





5 Performance estimation
========================================================


For estimate the algorithm performance, the following method was used: 

The corpora was split into training and test set. The text in the training set was used to find the token frecuencies, and the resulting algorithm was //testeado// agains sentences from the test set. Then the number of //aciertos// was counted.


A compromise between acuracy and data size was done to allow the training set to //caber// in a mobil device. A final accuracy of 27% accuracy was obtained.

More information at [https://github.com/enrique-repulles/predictive-text]



TODO 
========================================================

Create a slide deck promoting your product. Write 5 slides using RStudio Presenter explaining your product and why it is awesome!
Questions to consider

How can you briefly explain how your predictive model works?
How can you succinctly quantitatively summarize the performance of your prediction algorithm?
How can you show the user how the product works?
