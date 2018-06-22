import os
import datetime
import pdb

from collections import OrderedDict

import numpy as np
import pandas as pd

import statsmodels.formula.api as smf

import matplotlib.pyplot as plt
import matplotlib as mp
mp.style.use('ggplot')

FILEPATH = "C:\Users\AliDesktop\Desktop\ORiginal\Revenue Product Analyst Exercise\Revenue Product Analyst Exercise.csv"
DATE_COLUMNS = ['Date']
NUMERIC_COLUMNS = ['Gross_Bookings', 'Fees']
TARGET_DATE = pd.to_datetime("05-01-2016")
  
def main():
    ### clean up initial dataframe
    df = pd.read_csv(FILEPATH, dtype=str)
    df = clean_data(df)

    #save larger files or avoid data cleaning by saving into pickle file. Also helps if I modify df
    #df.to_pickle('df.pkl')
    #df2 = pd.read_pickle('df.pkl')  
       
    ### Test Modeling
    formula_string = 'Gross_Bookings ~ Month + C(Vendor_Name) + C(Country) + C(Product)'
    lm = smf.ols(formula=formula_string, data=df).fit()
    with open('regression_results_{0}.txt'.format('grossbookings'), 'wb') as fle:
        fle.write(formula_string + '\n\n')
        fle.write(str(lm.summary()))
    
    ### Execute pipelines
    #df_model = model_pipeline(df)             
    
    ### combine original df and forecasting df for excel export 
    #df_model = pd.concat([df, df_model], axis=0, ignore_index=True)
    #df_model = df_model.set_index(['Vendor_Name', 'Country', 'Product', 'Date']).sort_index()       
        
    #writer = pd.ExcelWriter('regression_model.xlsx')
    #df_model.to_excel(writer)
    #writer.save() 

    
def model_pipeline(df):
    ### create forecasting df for the target date 
    df_model = create_forecasting_df(df, TARGET_DATE)
    
    ### model gross bookings
    response1 = 'Gross_Bookings'
    predictors1 = ['Month']
    categorical1 = ['Vendor_Name', 'Country', 'Product']    
    lm_bookings = get_regression_model(df, response1, predictors1, categorical=categorical1)
            
    ### model fees
    response2 = 'Fees'
    predictors2 = ['Month']
    categorical2 = ['Vendor_Name', 'Country', 'Product']
    lm_fees = get_regression_model(df, response2, predictors2, categorical=categorical2)
       
    ### predict gross bookings and fees and compute % expenses from gross bookings
    df_model[response1] = lm_bookings.predict(df_model).astype('float32')
    df_model[response2] = lm_fees.predict(df_model).astype('float32')
    df_model['Percent_Gross_Bookings'] = df_model['Fees'] / df_model['Gross_Bookings']
    return df_model
    
    
def get_regression_model(df, response, predictors, categorical=None, intercept=True):
    formula_string = response + ' ~ ' + ' + '.join(predictors) 
    if categorical:
        formula_string = formula_string + ' + ' + ' + '.join(['C(%s)' % predictor for predictor in categorical])  
    if not intercept:
        formula_string = formula_string + ' -1 '
    
    lm = smf.ols(formula=formula_string, data=df).fit() #calling smf arguments
    #ie : smf.ols('Lottery ~ Literacy + np.log(Pop1831)', data=dat).fit()
    
    with open('regression_results_{0}.txt'.format(response), 'wb') as fle:
        fle.write(formula_string + '\n\n')
        fle.write(str(lm.summary()))
    return lm

 
def create_forecasting_df(df, target_date):
    df_model = df[df['Date']==df['Date'].max()] #
    df_model['Date'] = target_date  
    for num_col in NUMERIC_COLUMNS+['Percent_Gross_Bookings']: #
        df_model[num_col] = np.nan  
    df_model = pd.concat([df, df_model], axis=0, ignore_index=True) #
    df_model = clean_data(df_model)
    df_model = df_model.loc[df_model['Date']==target_date, :]
    return df_model
    
    
def clean_data(df):          
    df.columns = [col.strip().replace(' ', '_') for col in df.columns.tolist()] 
    #strip leading and trailing spaces, replace spaces with underscores
    #to make machine readable
    df = df.applymap(lambda x: x.strip() if isinstance(x, basestring) else x)    
    
    for date_col in DATE_COLUMNS:
        df[date_col] = pd.to_datetime(df[date_col]) 
        #pd.to_datetime(column/single series OR a single scalar value)
   
    for numeric_col in NUMERIC_COLUMNS:
        df[numeric_col] = pd.to_numeric(df[numeric_col], errors='coerce', downcast='float')

    # df.sort_values('Fees') doens't modify original df but df = df.sort_values('Fees')

    df['Percent_Gross_Bookings'] = df['Fees'] / df['Gross_Bookings']
    
    df['Months_Elapsed'] = pd.to_numeric(df['Date'].dt.to_period('M') - df['Date'].dt.to_period('M').min(), downcast='float')
    #if we include seasonality and trends in our analysis for change over time
    df['Month'] = df['Date'].dt.month 
    #pd to numeric getting month, datetime attributes, month        
    return df



if __name__=="__main__":    
    main()
    
#in pandas 'object' refers to string in dtype
x:list[]
for i in x:
    if 20/2 10/2 8/2 i/2:

                                              
        
#validation, r^2, cross validatoin, and error terms