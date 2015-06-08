Google prediction api is an ongoing project that sets up a handshake with Google Prediction API, returns
training model status, and quickly calls the API training methods for exploratory black box analysis on 
submitted datasets. 

Currently the returned queries from the training methods are printed out to the screen
for exploratory analysis and serves as the infastructure to better train some of the black box methods for greater accuracy,
while retaining the speed and convenience of machine learning on Google's cloud.

Things to work on in future releases: Putting results into PD arrays for analysis (ie splitting applying combining) as well
as calling scikit-learn models onto the outputted models above to see if there are certain biases within a prediction output 
(ie for the OCR example are certain letters inherently more difficult and require more attention to predict).