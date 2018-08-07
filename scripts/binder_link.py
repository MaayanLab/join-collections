#################################
###########binder_link.py########
#################################

#Author: Kevin Moses (kevin.moses@yale.edu)

#################################
#This script uses pandas to query titles selected for the JOIN 'issues' section.
#It then adds binder's unique filepath for the github repo and then inserts the binder url
#back into the database. 
#The notebooks should 
# 1. already have been in the database, and
# 2. Be in the github repo where its title corresponds to the notebook `title` in the database.
#################################

#python modules
import urllib.parse, urllib.request, json, os, errno, sqlalchemy
import pandas as pd
from sqlalchemy.sql import expression, functions
from sqlalchemy.orm import sessionmaker
from sqlalchemy.exc import IntegrityError
from sqlalchemy import MetaData, or_, and_, func, create_engine
import pymysql
pymysql.install_as_MySQLdb()

#change for each issue
issue_number = 2

#engine setup
engine = create_engine(os.environ['SQLALCHEMY_DATABASE_URI'])

#query
query = "SELECT n.id, n.title FROM notebook n WHERE n.collection_id_fk = %d;" %issue_number
issue_number = str(issue_number)
#read into dataframe
df = pd.read_sql_query(query, engine)
#convert titles to list
titles = df['title'].tolist()

new = list()
for t in titles:
    t = urllib.parse.quote(t)
    url = 'https://mybinder.org/v2/gh/maayanlab/join-collections/master?filepath=join-collection-' + issue_number + '%2F' + t + '.ipynb' 
    new.append(url)

#append to binder_url column
df['binder_url'] = new

count = len(df)

#Create csv, import using Sequel Pro or MySQLWorkbench 
df.to_csv('csv/to_database.csv')