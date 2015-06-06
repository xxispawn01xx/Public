import sys;



def parseDictListDict(all_models):

    id_kind_list=[];

    # picking all the items list from the first dictionary
    itemsList = all_models['items'];

    # running a loop pver all the items, one at a time
    for item in items:

        # pick out id from dictionary
        idVar = item['id'];

        # pick out kind from dictionary
        kindVar = item['kind'];

        # filling id and kind into a 2d array
        id_kind_list.append([idVar, kindVar]);
    return id_kind_list;

def parseUserCreatedList(id_kind_list):

    # Getting out 1d array from 2d array
    for item in id_kind_list:

        #printing each index in 1d array
        print(item[0]+" "+item[1]+"\n");


# FOR TESTING PURPOSES
#items=[]
#items.append({'id': 'CTR', 'kind': 'prediction#training'});
#items.append({'id': 'CTR1', 'kind': 'prediction#training1'});
#items.append({'id': 'CTR2', 'kind': 'prediction#training2'});
#items.append({'id': 'CTR3', 'kind': 'prediction#training3'});
#items.append({'id': 'CTR4', 'kind': 'prediction#training4'});
#items.append({'id': 'CTR5', 'kind': 'prediction#training5'});
#items.append({'id': 'CTR6', 'kind': 'prediction#training6'});
#items.append({'id': 'CTR7', 'kind': 'prediction#training7'});
#
#all_models={};
#all_models['items'] = items;
#all_models['kind'] = 'prediction#list';
#all_models['selfLink'] = 'http://sad';

# ACTUAL FUNCTION CALL
id_kind_list=parseDictListDict(all_models);

# SIMPLY PRINTING WHATEVER I PARSED
all_models_printed= parseUserCreatedList(id_kind_list);
