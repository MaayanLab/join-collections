###########################################
###########biojupies_download.py###########
###########################################

#Author: Denis Torre (Denis.torre@mssm.edu), small edits: Kevin moses

#################################
# This script creates a subdirectory for a new issue of JOIN and inserts BioJupies notebooks
# from their nbviewer URL.
#################################

import urllib.parse, urllib.request, json, os, errno


def download_notebook(notebook_uid):

	# If exists
	if notebook_uid:

		# Get Notebook Data URl
		notebook_data_url = 'http://amp.pharm.mssm.edu/biojupies/api/notebook/'+notebook_uid

		# Get Notebook Data
		with urllib.request.urlopen(notebook_data_url) as response:
			notebook_data = json.loads(response.read())
			
		# Get Notebook URL
		notebook_url = urllib.parse.quote(notebook_data['notebook_url'], safe=':/')
		print(notebook_url)

		# Get data
		os.system('wget '+notebook_url)

		# Jupyter Trust

#specify issue number
issue_no = input("What issue number are you creating?\n")
issue = "join-issue-" +issue_no

try:
    #create subdirectory
	os.makedirs(issue)
	#get path
	path = os.getcwd() + "/" +issue
    #cd into subdirectory
	os.chdir(path)
    #input # of notebooks
	num = int(input("How many notebooks are you uploading?\n"))
    #download notebooks
	for i in range(num):
		uid = input("Enter the notebook UID\n")
		download_notebook(uid)
#error message
except OSError as e:
    if e.errno != errno.EEXIST:
        raise

