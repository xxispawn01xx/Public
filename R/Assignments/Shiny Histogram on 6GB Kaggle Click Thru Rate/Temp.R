# data<-read.csv("C:/Users/AliDesktop/Desktop/Magic Briefcase/School/1/2- Stat Programming/lecture/CTRRaw.csv", header=TRUE, sep=",")
# names1<-names(data)
# names1
# #"id", "click", "hour", "C1", "banner_pos", "site_id", "site_domain", "site_category","app_id", "app_domain", "app_category", "device_id", "device_ip", "device_model", "device_type", "device_conn_type", "C14", "C15", "C16", "C17", "C18", "C19", "C20", "C21")
# #'id', 'click', 'hour', 'C1', 'banner_pos', 'site_id', 'site_domain', 'site_category','app_id', 'app_domain', 'app_category', 'device_id', 'device_ip', 'device_model', 'device_type', 'device_conn_type', 'C14', 'C15', 'C16', 'C17', 'C18', 'C19', 'C20', 'C21')
# col_headings = c('id', 'click', 'hour', 'C1', 'banner_pos', 'site_id', 'site_domain', 'site_category','app_id', 'app_domain', 'app_category', 'device_id', 'device_ip', 'device_model', 'device_type', 'device_conn_type', 'C14', 'C15', 'C16', 'C17', 'C18', 'C19', 'C20', 'C21')
# names(data)<-col_headings

#actualdata<-read.csv("C:/Users/AliDesktop/Desktop/Bit Briefcase/Big Data/Kaggle/CTR/train.csv", nrow=1000)
# write.table(actualdata, file="actualdata.csv")
CTRRAW<-read.csv("C:/Users/AliDesktop/Desktop/Magic Briefcase/School/1/2- Stat Programming/lecture/CTRRAW.csv")