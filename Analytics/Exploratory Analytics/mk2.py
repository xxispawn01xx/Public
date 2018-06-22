import os
import datetime
import pdb

from collections import OrderedDict

import numpy as np
import pandas as pd

import statsmodels.formula.api as smf

from bokeh.resources import CDN
from bokeh.embed import file_html
from bokeh.layouts import layout, column, row
from bokeh.plotting import figure
from bokeh.models import ColumnDataSource
from bokeh.models.widgets import Panel, Tabs

FILEPATH = "C:\Users\AliDesktop\Desktop\mk final\Original\Revenue Product Analyst Exercise.csv"
DATE_COLUMNS = ['Date']
NUMERIC_COLUMNS = ['Gross_Bookings', 'Fees']
TARGET_DATE = pd.to_datetime("05-01-2016")

MODEL_SUMMARY_DIR = 'model_summaries'
if not os.path.exists(MODEL_SUMMARY_DIR): os.mkdir(MODEL_SUMMARY_DIR) 
  
def main():
    ### clean up initial dataframe
    df = pd.read_csv(FILEPATH, dtype=str)
    df = clean_data(df)    
    write_excel(df, filename='raw_data', index_labels=['Product', 'Vendor_Name', 'Country', 'Date'])
    

    # filter df to only include the unique ['Product', 'Vendor_Name', 'Country'] that occur on the latest date (4/1/16)
    latest = df[df['Date']==df['Date'].max()].set_index(['Product', 'Vendor_Name', 'Country']).index.unique().values
    df = df.set_index(['Product', 'Vendor_Name', 'Country']).loc[latest, :].reset_index()
    write_excel(df, filename='raw_data_filtered', index_labels=['Product', 'Vendor_Name', 'Country', 'Date'])

    
    # aggregate categoricals to make datapoints contiguous on dates for each product
    df = df.groupby(['Product', 'Date'], as_index=False)['Gross_Bookings', 'Fees'].sum()
    df = clean_data(df)
    write_excel(df, filename='raw_data_agg', index_labels=['Product', 'Date'])
    
    
    # Fit model and make predictions
    df_final = []
    errors = {}
    formula_string = 'Gross_Bookings ~ Months_Elapsed + Month -1'   
    for product, df_group in df.groupby('Product'):        
        try:
            print product
            regression_input = df_group.dropna(subset=['Gross_Bookings'])
            lm_group = smf.ols(formula=formula_string, data=regression_input).fit()
            
            lm_summary_filepath = os.path.join(MODEL_SUMMARY_DIR, 'regression_{0}'.format(product))
            with open(lm_summary_filepath, 'wb') as fle:
                fle.write(formula_string + '\n\n' + str(lm_group.summary()))
                
            df_group = append_prediction_datapoint(df_group, TARGET_DATE)
            df_group['Model_Gross_Bookings'] = lm_group.predict(df_group).astype('float32')
            df_final.append(df_group)
        except:
            print "ERROR: {0}".format(product)
            errors[str(product)] = df_group 
            
    df_final = pd.concat(df_final, axis=0, ignore_index=True)    
    write_excel(df_final, filename='regression_model', index_labels=['Product', 'Date'])
    
    
    # generate visualizations
    report = Report(df_final, 'Gross_Bookings', 'Model_Gross_Bookings', ['Product'])
    html_report = report.generate()
    with open('visualization.html', 'w') as fle:
        fle.write(html_report)
        
        
def write_excel(df, filename='df', index_labels=None):    
    if index_labels: df = df.set_index(index_labels).sort_index()        
    writer = pd.ExcelWriter('{0}.xlsx'.format(filename))
    df.to_excel(writer)
    writer.save()
    
    
def append_prediction_datapoint(df, target_date):
    df_forecast = df[df['Date']==df['Date'].max()]
    df_forecast['Date'] = target_date  
    for num_col in NUMERIC_COLUMNS+['Percent_Gross_Bookings']:
        df_forecast[num_col] = np.nan
        
    df_model = pd.concat([df, df_forecast], axis=0, ignore_index=True)
    df_model = clean_data(df_model)
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
    df['Months_Elapsed'] = pd.to_numeric(df['Date'].dt.to_period('M') - df['Date'].dt.to_period('M').min())
    #if we include seasonality and trends in our analysis for change over time
    df['Month'] = df['Date'].dt.month 
    #pd to numeric getting month, datetime attributes, month        
    return df


class Report(object):
    def __init__(self, df_main, field, model_field, index_structure):
        self.df_main = df_main
        self.field = field
        self.model_field = model_field
        self.index_structure = index_structure
        
    def generate(self):
        panel1_tabs = [self._plotit(df1, group1) for group1, df1 in self.df_main.groupby(self.index_structure[0])]
        panel1_tabs = Tabs(tabs=panel1_tabs)    
        html_report = file_html(panel1_tabs, CDN, "Report")            
        return html_report
        
    def _plotit(self, df, group):
        data_source = ColumnDataSource(df) 
        p = figure(plot_height=300, plot_width=800, title='Actual vs Model: {0}'.format(self.field), x_axis_type='datetime', tools=['pan', 'xwheel_zoom', 'save', 'reset'], active_scroll='xwheel_zoom')
        p.circle(x='Date', y=self.field, size=6, color='blue', source=data_source)
        p.circle(x='Date', y=self.model_field, size=6, color='red', source=data_source)
        
        p_panel = Panel(child=p, title=group)
        return p_panel
        

if __name__=="__main__":    
    main()
                                           