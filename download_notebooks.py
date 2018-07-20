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

issue_no = input("What issue number are you creating?\n")
issue = "join-issue-" +issue_no
try:
    # os.makedirs(issue)
    path = os.getcwd() + "/" +issue
    os.chdir(path)
    num = int(input("How many notebooks are you uploading?\n"))
    for i in range(num):
     uid = input("Enter the notebook UID\n")
     download_notebook(uid)
except OSError as e:
    if e.errno != errno.EEXIST:
        raise

