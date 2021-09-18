# To add a new cell, type '# %%'
# To add a new markdown cell, type '# %% [markdown]'
# %%
import numpy as np
import pandas as pd
import io
import os
import csv
from sklearn.tree import export_text
from sklearn.tree import export_graphviz
from six import StringIO 
from IPython.display import Image
import pydotplus


# %%
from sklearn.tree import DecisionTreeClassifier
import nbformat
from nbconvert import PythonExporter


# %%
from sklearn.model_selection import train_test_split
import json


# %%
from sklearn import metrics
from flask import Flask, jsonify

import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

cred = credentials.Certificate("we-don-t-byte---ass-firebase-adminsdk-kdbj6-ec500ebd6d.json")
firebase_admin.initialize_app(cred)
db = firestore.client()


# %%
#def recommendTofile():

provinceJson =  '{ "Limpopo" : 1,"Gauteng" : 2,"Free State" : 3,"Western Cape" : 4,"KZN" : 5,"North West" : 6,"Northern Cape" : 7,"Eastern Cape" : 8,"Mpumalanga" : 9}'
categoryJson =  '{"Books" : 1, "Shoes" : 2, "Clothing" : 3, "Tech" : 4, "Kitchen" : 5}'

# parse x:
loadProvinceJ = json.loads(provinceJson)
loadCategoryJ = json.loads(categoryJson)

print('collection')
products_ref = db.collection('Products')
Products_docs = products_ref.get()

print('collected')
#for prod_doc in Products_docs:

        #print(f'{prod_doc.id} => {prod_doc.to_dict()}')
        #print(prod_doc.exists('clicks'))
       # city_ref = db.collection(u'Products').document(prod_doc.id)

       # city_ref.set({u'id': prod_doc.id}, merge=True)
      #  noOfClicks = 1
        #if prod_doc.get('clicks'):
        #    noOfClicks = prod_doc.get('clicks')
            
        
        #category = prod_doc.get('category')
       # print(prod_doc.id)
        #print(loadCategoryJ[category])
        #print(prod_doc.get('clicks'))
        #print(prod_doc.get('category'))


users_ref = db.collection('Users')
users_docs = users_ref.list_documents()
# the result is a Python dictionary:
#print(loadCategoryJ["age"])

for doc in users_docs:
    print(doc.id)
    province = ''
    userDoc1 = users_ref.document(doc.id)
    userColl1 = userDoc1.collection('info')
    userColl2 = userDoc1.collection('Wishlist')
    colDocs1 = userColl1.get()
    s = False
    colDocs2 = userColl2.list_documents()
    #
    # ##
    # Wishlist
    ####
    #
    for colD_doc in colDocs2:
        print(colD_doc.id)
        pid = '0OeiOnaPTn1AiJWTUQ9i'
        s = pid in colDocs2

        print("ProductID in Wishlist")
    #
    #    Province
    #

    for colD_doc in colDocs1:
        print(colD_doc.get('province'))
        province = colD_doc.get('province')

    products_ref = db.collection('Products')
    Products_docs = products_ref.get()

    for prod_doc in Products_docs:

        #print(f'{prod_doc.id} => {prod_doc.to_dict()}')
        #print(str(prod_doc.exists('clicks')))
        noOfClicks = 1
        #
        #   Clicks
        #
        if prod_doc.get('clicks')>= 1:
            noOfClicks = prod_doc.get('clicks')
            
        #
        #
        #  Product
        #
        category = prod_doc.get('category')
        print(loadCategoryJ[category])
        #print(prod_doc.get('clicks'))
        #print(prod_doc.get('category'))
        break

col_names = ['Prod_ID', 'Prod_Cat', 'User_ID', 'User_Province', 'Event', 'Clicks', 'Wishlist', 'Recommend']

# %% [markdown]
# 

# %%
pima = pd.read_csv("../assets/DecisionTreeData/Train_Data.csv", header=None, names=col_names)
pima


# %%
#pimas.head()


# %%
feature_cols = ['Prod_Cat', 'User_Province', 'Clicks', 'Wishlist']


# %%
X = pima[feature_cols]


# %%
y = pima.Recommend


# %%
# Split dataset into training set and test set
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=1) # 70% training and 30% test


# %%
#Before Pruning
clf = DecisionTreeClassifier()

#pimas = pd.read_csv("..assets/DecisionTreeData/test_Data.csv", header=None, names=col_names)

#X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=1, random_state=1) # 100% Test Data(Totally Different from Training Data/Duplicates filtered out)

clf = clf.fit(X_train,y_train)

y_pred = clf.predict(X_test)

y_pred.tofile("../assets/DecisionTreeOutputs/recommendations.csv", sep = ',')

AccuracyBeforePruning = metrics.accuracy_score(y_test, y_pred)
print("-----------------------------------------------ACCURACY BEFORE PRUNING---------------------------------\n")

print(AccuracyBeforePruning)

print("\n-------------------------------------------------------------------------------------------------------\n")

r = export_text(clf, feature_names=feature_cols)

print(r)

dot_data = StringIO()

export_graphviz(clf, out_file=dot_data,  
                filled=True, rounded=True,
                special_characters=True,feature_names = feature_cols,class_names=['0','1'])
graph = pydotplus.graph_from_dot_data(dot_data.getvalue())  
graph.write_png('../assets/DecisionTreeOutputs/recommendations.png')
Image(graph.create_png())


# %%
#After pruning 
clf = DecisionTreeClassifier(criterion="entropy", max_depth=5) #Given a depth of 5 to make the tree less complicated(Avoid overfitting)

clf = clf.fit(X_train,y_train)

y_pred = clf.predict(X_test)

y_pred.tofile("../assets/DecisionTreeOutputs/recommendations(Pruned).csv", sep = ',')

AccuracyAfterPruning = metrics.accuracy_score(y_test, y_pred)

print("-----------------------------------------------ACCURACY AFTER PRUNING-------------------------------\n")
print(AccuracyAfterPruning)
print("\n-------------------------------------------------------------------------------------------------------\n")

r = export_text(clf, feature_names=feature_cols)

print(r)

dot_data = StringIO()

export_graphviz(clf, out_file=dot_data,  
                filled=True, rounded=True,
                special_characters=True,feature_names = feature_cols,class_names=['0','1'])
graph = pydotplus.graph_from_dot_data(dot_data.getvalue())  
graph.write_png('../assets/DecisionTreeOutputs/recommendations(Pruned).png')
Image(graph.create_png())


# %%



