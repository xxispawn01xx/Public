# -*- coding: utf-8 -*-
"""
Created on Tue Nov 29 17:59:16 2016

@author: AliDesktop
"""
import sys
import os
os.chdir('C:\\Users\AliDesktop\Desktop')
import nltk.data
import codecs
from nltk.corpus import stopwords
from nltk.tokenize import sent_tokenize
#from textblob.classifiers import NaiveBayesClassifier
default_stopwords = set(nltk.corpus.stopwords.words('english'))

#Change to test file directory here
fp = codecs.open("C:\\Users\AliDesktop\Desktop\sore_throat_control_raw.txt", 'r', 'latin-1')
tokenizer = nltk.data.load('tokenizers/punkt/english.pickle')
#r=fp.read() legacy
all_stopwords = default_stopwords

#quick cleaning of data that doesn't include stemming or lemmatizing
words = nltk.word_tokenize(fp.read())
words = [word for word in words if len(word) > 1]
words = [word for word in words if not word.isnumeric()]
words = [word.lower() for word in words]
words = [word for word in words if word not in all_stopwords]


from textblob import TextBlob
#plot distribution of 50 most frequent words, to see where we should focus
# our features
fdist = nltk.FreqDist(words)

print "most common word frequencies/exploratory analysis and variable introductory profiling"
for word, frequency in fdist.most_common(50):
    print(u'{};{}'.format(word, frequency))
fp.seek(0) #read puts to last line, this brings it to first

#comment this two line block to see freq output
sentences = nltk.sent_tokenize(fp.read())
sentences = [sentence for sentence in sentences if sentence not in all_stopwords]


#train_data = sentences[:75]
#test_data = sentences[75:]
    
#self care           The patient is going to take care of the sore throat themselves #tea;11
#other               We didn't understand the response
#doctor              They would call or see the doctor #doctor;19
#urgent care         They would go to the urgent care clinic (IEHP)  #urgent;22
#nurse               They would call the nurse advice line (offered by IEHP) #nurse;61
#don't know          They are not sure what they should #know;21
#emergency           They would go to an ER to have it checked #emergency;11
    

#I would call first to see if maybe o had some meds to help soothe the throat
#I would use clot aseptic spray
#I would fix some hot tea""", 'self care'),
#         ('I would take a hot bath to open up my airways then drink hot throat coating tea', 'self care'),
#         ('I don't know to much about the benefits', 'don't know') ]
#         ("""don't know
#Call hot line""", 'don't know') ]


from textblob.classifiers import NaiveBayesClassifier
from textblob.classifiers import PositiveNaiveBayesClassifier
from textblob import TextBlob

train = [('Call nurses hot line if not better in morning ', 'nurse'),
         ('I would call a nurse, or if I needed to I would go to urgent care', 'nurse'),
         ('Id wait till the morning to call', 'other'),
         ('I would go to the emergency room', 'emergency'),
         ("sore throat and I couldn't take the pain I will go to the emergency room", 'emergency'),
         ("I wouldcontact my doctor", 'doctor'),
         ("It depends on how bad my throat feels.", 'self care'),
         ('I would take a hot bath to open up my airways then drink hot throat coating tea', 'self care')
         ]

#if you have the time to label 'bin' what you think a text belongs in
# ie a secretary put the ER text into the doctor bin. The Classifier correctly identifies this
# and hence goes from 100% accuracy for the first two texts, to 2/3 for the third text
test = [
  ('Going to the Emergency room', 'emergency'), #true positive
  ('Id wait till the morning to call', 'other'), #true positive
  ('Going to the Emergency room', 'doctor') #false negative
]

print str('testing set the last one is incorrectly classified') 
print  test 

#unlabeled, let the algorithm sort it out
#test_unlabeled = [
#  ('Going to the Emergency room', 'doctor'),
#  ('Call in the morning', 'other')
#]

# feature extraction for unlabeled data
#def feature_extraction_unlabeled(unlabeled_tokenized_sentences):
#    test_unlabeled = []
#    for i in unlabeled_tokenized_sentences[i]:
#        test_unlabeled = test_unlabeled.extend(unlabeled_tokenized_sentences[i])+','
#    

cl = NaiveBayesClassifier(train)
#cl_unlabeled = PositiveNaiveBayesClassifier(train, test_unlabeled)

# Compute accuracy

accuracy = cl.accuracy(test)
print("Accuracy: {0}".format(accuracy))

#accuracy for unlabaled data
#accuracy_unlabeled = cl.accuracy(test_unlabeled)
#print("Accuracy: {0}".format(accuracy_unlabeled))

#larger sample, more time and consistency to better index and classify training set. Maybe even making a decision
# tree to better split the text input, ie if a text asks whether to go to nurse or emergeny care
#Alternative approaches include decision trees, different classifier, more programatic approaches to classification.
# For example having a decision tree decide whether to split on 'nurse' or 'don't know' category