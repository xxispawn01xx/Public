# Equivalent R models for Google API predictions can be found on my git, in many
#cases they were finer tuned, albeit at the expense of a programmer and looking at the data
# (time and money) compared to Google's Prediction Api. Would typically never put keys in a public
# directory. But this is a sample and limited account, and I want to show the handshake/authorization
    
    # OAuth handshake and creating Google Prediction API method caller

import httplib2
    #settings is an imported py doc that contains client id = '' and client_secret=''fields
    #for OAuth
import settings

client_id = settings.client_id
client_secret = settings.client_secret

from apiclient.discovery import build
from oauth2client.file import Storage
from oauth2client.client import OAuth2WebServerFlow 
from oauth2client.tools import run


scope = {'https://www.googleapis.com/auth/devstorage.full_control',
            'https://www.googleapis.com/auth/devstorage.read_only',
            'https://www.googleapis.com/auth/devstorage.read_write',
            'https://www.googleapis.com/auth/prediction'}
            
flow = OAuth2WebServerFlow(client_id, client_secret, scope)
            
storage = Storage("credentials.dat")
credentials = storage.get()
            
if credentials is None or credentials.invalid:
    credentials = run(flow, storage)
                
http = httplib2.Http()
http = credentials.authorize(http)

            
service = build('prediction', 'v1.6', http=http)

class TrainedModel(object):

    def __init__(self, project_id, model_name):
        self.p = project_id
        self.m = model_name
    
    #Train a Prediction API model
    def insert(self, storage_data_location=None, output_value=None, features=None):
        body= {
                "storageDataLocation": storage_data_location,
                "id": self.m,
                "trainingInstances": [
                            {"output": output_value,
                             "csvInstance": features
                             }
                           ]
             } 
        return service.trainedmodels().insert(project=self.p, body=body).execute()
        
    #Train a Prediction API model using a dataset
    def insert_dataset(self, training_data):
            body= {
                   "id": self.m,
                   "trainingInstances": training_data
                   }
            return service.trainedmodels().insert(project=self.p, body=body).execute()
            
    #Check training status of your model
    def get(self):
        return service.trainedmodels().get(project=self.p, id=self.m).execute()
    
    #Submit model id and request a prediction    
    def predict(self, features):
        body={
              "input": {
                "csvInstance": features
                }
            }
        return service.trainedmodels().predict(project=self.p, id=self.m, body=body).execute()
    
    #List available models    
    def list(self):
        return service.trainedmodels().list(project=self.p).execute()
    
    #Delete a trained model
    def delete(self):
        return service.trainedmodels().delete(project=self.p, id=self.m).execute()
     
    #Get analysis of the model and the data the model was trained on     
    def analyze(self):
        return service.trainedmodels().analyze(project=self.p, id=self.m).execute()
    
    #Add new data to a trained model    
    def update(self, output, features):
        body= {
               "output": output,
                "csvInstance":[
                features
                ]
              }
        return service.trainedmodels().update(project=self.p, id=self.m, body=body).execute()
        
class HostedModel(object):

    Hosted_model_id = 414649711441
    
    #Submit input and request an output against a hosted model
    def predict(self, model_name, csv_instances):
        body={
            "input":{
            "csvInstance": csv_instances
            }
        }
        return service.hostedmodels().predict()


##Callling all models  in projectID and predictions
all_models = TrainedModel("615292928655", "credit.csv").list()

####Print Model Names
    #Telling us which models are being trained or completed each time we refresh the script

def parseDictListDict(all_models):

    id_kind_list=[];

    # picking all the items list from the first dictionary
    itemsList = all_models['items'];

    # running a loop pver all the items, one at a time
    for item in itemsList: #item here is index number

        # pick out id from dictionary
        idVar = item['id'];

        # pick out kind from dictionary
        kindVar = item['kind'];

        # filling id and kind into a 2d array
        id_kind_list.append([idVar, kindVar]);
    return id_kind_list; #need return statement because all of these operations are 
    #happening in memory

def parseUserCreatedList(id_kind_list):

    # Getting out 1d array from 2d array
    for item in id_kind_list:

        #printing each index in 1d array
        print(item[0]+" "+item[1]+"\n");


#printing all_models and their statuses  	
id_kind_list = parseDictListDict(all_models);	
parseUserCreatedList(id_kind_list);
print("Models and training status")
print("\n"+"\n"+"\n")
		

###Now let's parse the prediction results
def parseDictListDict(prediction_results):

    pred_id_outputMulti=[];

    # picking all the items list from the first dictionary
    itemsList = prediction_results['outputMulti'];

    # running a loop pver all the items, one at a time
    for item in itemsList: #item here is index number

        # pick out id from dictionary
        labelVar = item['label'];

        # pick out kind from dictionary
        scoreVar = item['score'];

        # filling id and kind into a 2d array
        pred_id_outputMulti.append([labelVar, scoreVar]);
    return pred_id_outputMulti; #need return statement because all of these operations are 
    #happening in memory
    
def parseUserCreatedList(pred_id_outputMulti):
#        print(pred_id_outputMulti)
    # Getting out 1d array from 2d array
    for item in pred_id_outputMulti:

        #printing each index in 1d array
        print(item[0]+" "+item[1]+"\n");
    print("\n"+"\n"+"\n")
####Analysis
    #Note did not parse prediction dictionary output results in notebook like above, one can use
    #Spyder variable explorer to do cursory analysis before proceeding to tweek prediction
    # features for intended purposes, sorting, parsing results, boosting models, building ROC curves
    # etc

model = "credit.csv"
prediction_credit = TrainedModel("615292928655", model).predict(['unknown',12,'good','furniture/appliances',3059])
print(model+" "+"prediction scores")
id_kind_list = parseDictListDict(prediction_credit);	
parseUserCreatedList(id_kind_list);

#Does not do well with categorical variables and factor levels, using csvs with factors as strings 
# ie 0-200DM, 200-400DM, >400DM, unknown Deutsche Marks in ones bank account
# For a credit.csv file I had, from which I tried to determine whether a customer
#would default on a credit card payment or not. ALso seems to be less accurate on larger
# number of features and non-normally distributed IDV. Also seems overfit
# for decision tree classifiers. I have to remove a good number of features, as opposed to some of
#the more efficient packages on R that are oprimized for this, to get the same level of accuracy,
#thereby requiring more knowledge of the data you are sending to Google to blackbox.
#In fact the API method initially couldn't even find a classifier to use for the data and
#reported an accuracy of 0. It didn't work as well as other decision tree classifiers.

model = "concrete.csv"
prediction_concrete = TrainedModel("615292928655", model).predict([296,0,0,192,0,0,1085,765,7,14.2])
print(model+" "+"prediction scores")
id_kind_list = parseDictListDict(prediction_concrete);	
parseUserCreatedList(id_kind_list);
#Next I tried a concrete strength .csv that I had used an R ANN package on
# Given it did not have the above factors that limited the previous model, it worked
#much better, giving me an accuracy of .67 at determining the strength of cement
# from its eight featues. Unlike the above model as well, there were many more relevant 
# and numerical features that helped contribute to the accuracy of the model.

model = "letterdata.csv"
prediction_letterdata = TrainedModel("615292928655", model).predict([2,8,3,5])
print(model+" "+"prediction scores")
id_kind_list = parseDictListDict(prediction_letterdata);	
parseUserCreatedList(id_kind_list);

#Lastly I tried an SVM classifier for OCR of letter data from UCI's machine 
# learning repository. After vectorizing each variaton or 'glyph' for a letter
# different features such as horizontal and vertical positions, proportion of 
# black and white, and average horizontal and vertical positions of pixels
# are recorded for each letter of the alphabet to be OCR'd.

#The model had an accuracy of .76 and correctly predicted the letter 'X' from 4 of 16 features inputted. 
# Slightly less than the equivalent model in R of .83
# The reason for this, I can assume, given that Google's API predict is a blackbox method
# is the different krenels used to build the classifier in higher dimension space.
#I would assume much like I boosted the accuracy of my model in R, that the API
# initially chose to select a linear kernel. Much like I did in R, one can 
# increase the accuracy of results by using a Gaussian kernel.



####Conclusion:
#I learned Google's API is not well trained for certain machine learning tasks, but is robust, runs
# some of the more processor intensive tasks quicker on a distributed system. However great models
#still require strong knowledge of the statistical algorithms used, many of which are better
#optimized in R. Ultimately thoguh, you just have to know your data and how to train it.
# It seems Google's Prediction API is a good start, much like AWS was for distributed computing and elastic storage, 
#towards a #commercial and small business use of machine learning. It wants to democratize a 
#the future for machine learning in the cloud. 