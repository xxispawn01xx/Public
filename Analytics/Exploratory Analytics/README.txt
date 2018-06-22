This is an initial programmatic approach to predicting Gross Bookings based on largely categorical values (on a smaller dataset I was given)

I ingest and clean financial data, pulled using sql, from a data warehouse, into a csv. Finally I put this into a pandas df for filtering and sorting. 

I then fit my linear regressions and make gross bookings my dependent variable, writing it to an excel file for each product line by date elapsed

Finally using bokeh I generate interactive visual reports for each product regression (20 in total)