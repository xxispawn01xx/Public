Cannot R Markdown as the datasets are too large. Shiny output in Jpeg.
Initial dataset is a 6gb Kaggle dataset from Avazu on ClickThruData for Online Ads.
Insight for $banner_pos in server.R
DotRaw.R pulls a 4,000 row sample out of my 6GB Kaggle click through rate dataset and writes it to CTRRAW.csv 750kb 
(so I don't have to go through 6GB every time) 
Temp.R loads CTRRAW.csv  (useful to reuse source) as variable CTRRAW 
Server. R sources Temp.
R's CTRRAW variable from which I call the $banner_pos column header for my Shiny histogram, or for that matter
any of the 24 variables available in the initial Kaggle Dataset