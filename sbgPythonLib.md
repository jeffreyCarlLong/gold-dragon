# SBG Python Library for API

These are notes from Anurag Sethi. The original format was a python notebook. 
I converted it to Markdown with [chronitis/ipyrmd](https://github.com/chronitis/ipyrmd).

## I. Installing the sevenbridges-python

The Seven Bridges python library for API access is available on github (https://github.com/sbg/sevenbridges-python) and can either be installed using pip or by downloading the source code. 

### Installing using pip

> pip install sevenbridges-python

### Installing using source code

> git clone git://github.com/sbg/sevenbridges-python.git

To embed it into your native python packages
> python setup.py install

## II. Import the library

Once you have installed the library, you need to import the modules everytime you invoke the API.

```{r eval=FALSE}
import sevenbridges as sbg
```

## III. Setting SBG Authentification

Multiple methods to set it up so that the SBG platform authorization is performed in the code. You can create a SBG config figure .sevenbridges/credentials in your home directory with the appropriate URL and authentification code. More information can be found on our github repository with API recipes and tutorials (https://github.com/sbg/okAPI/blob/master/Recipes/SBPLAT/Setup_API_environment.ipynb)

```{r eval=FALSE}
config_config_file = sbg.Config(profile='sbpla')
api = sbg.Api(config=config_config_file)
```

```{r eval=FALSE}
print(api.users.me())
```

## IV. List all projects I am a part off
Each project is an object with information about the project. A list-call for projects returns the following attributes:
* **id** Unique identifier for the project, generated based on Project Name
* **name** Name of project specified by the user, maybe non-unique
* **href** Address of the project.

```{r eval=FALSE}
my_projects = api.projects.query().all()

print(' List of project names:')
for project in my_projects:
    print('%s' % (project.name))
```

## VI. Creating a new project

Using the API to make a new project requires 2 fields and there is an additional optinal field:
* **billing_group** Billing group
* **name** Name of the project
* **description** (Optional) Project description 

```{r eval=FALSE}
new_project_name = 'APIs rock!'

billing_groups = api.billing_groups.query()  
print((billing_groups[0].name + \
       ' will be charged for computation and storage (if applicable) for your new project'))

my_new_project = api.projects.create(name = new_project_name, \
                                     billing_group = str(billing_groups[0].id), \
                                     description = "#This is to test how APIs work", \
                                     )

## (re)list all projects, and get your new project
my_project = [p for p in api.projects.query(limit=100).all() \
              if p.name == new_project_name][0]

print('Your new project %s has been created.' % (my_project.name))
if hasattr(my_project, 'description'): ## need to check if description has been entered
    print('Project description: %s \n' % (my_project.description))
```

## VII. Get the details and membership of a project

```{r eval=FALSE}
single_project = api.projects.get(id=my_project.id)

print(single_project.name)
if hasattr(single_project, 'description'):       
    ## Need to check if description has been entered, GUI created project have default text, 
    ##  but it is not in the metadata.
    print('Project description: %s \n' % (single_project.description))

project_members = single_project.get_members()

print('The selected project (%s) has %i members:' % \
      (single_project.name, len(project_members)))

for member in project_members:
    if member.permissions["admin"]:
        print('\t User %s is a project ADMIN' % (member.username))
    else:
        print('\t User %s is a project MEMBER with permissions of ' % (member.username), )
        if member.permissions["copy"]:
            print('Copy',) 
        if member.permissions["write"]:
            print('Write',) 
        if member.permissions["execute"]:
            print('Execute',) 
        if member.permissions["read"]:
            print('Read',)
        print('\n')
```

## VIII. Adding new members to a project

```{r eval=FALSE}
user_names =['anurag.sethi_demo']

## here we are assigning all users in the list the same permissions, this could also be a list
user_permissions = {'write': True,
                    'read': True,
                    'copy': True,
                    'execute': False,
                    'admin': False
                    }

for name in user_names:
    single_project.add_member(user = name, permissions = user_permissions)
```

## IX. Adding a public app to the project

```{r eval=FALSE}
#App you are looking for
a_name = "RNA-seq Alignment - STAR"

#Get all public apps
public_apps = list(api.apps.query(visibility='public', limit=100).all())
my_apps = api.apps.query(project=my_project)

#Find the app of choice
try:
    public_app = [app for app in public_apps if app.name == a_name][0]
except:
    print("App (%s) does not exist in public apps", (a_name))
    raise KeyboardInterrupt
```

```{r eval=FALSE}
duplicate_app = [a for a in my_apps.all() if a.name == public_app.name]
if duplicate_app:
    print('App already exists in second project, please try another app')
else:
    print('App (%s) does not exist in Project (%s); copying now' % \
          (a_name, my_project.name))
    
    new_app = public_app.copy(project = my_project.id)
        
    ## re-list apps in target project to verify the copy worked
    my_app_names = [a.name for a in \
                    api.apps.query(project = my_project.id, limit=100).all()]
    
    if a_name in my_app_names:
        print('Sucessfully copied one app!')
    else:
        print('Something went wrong...')
```

## X. Learn the inputs for the app

```{r eval=FALSE}
all_apps = list(api.apps.query(project = my_project.id, limit=100).all())
my_duplicated_app = [currApp for currApp in all_apps if currApp.name ==a_name][0]
idx = 1
for eachInput in  my_duplicated_app.raw["inputs"]:
    print("Input", idx, " with input label", eachInput["label"])
    idx += 1
```

## XI. Copying input files to the project

Many methods to get files into the projects:

### 1. Upload files (including batch uploads):

* Create a list of the files with whole paths <br>
```{r eval=FALSE}
file_list = ['/Users/anurag/APIdemo/file1.ext',
			 '/Users/anurag/APIdemo/file2.ext', 
			 '/Users/anurag/APIdemo/file3.ext']
```             

* Upload each file <br>
```{r eval=FALSE}
for f in file_list:<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;api.files.upload(project = my_project, path = f)
```

### 2. Copying from other projects:

*Find files in source project with certain filters based on metadata fields <br>
```{r eval=FALSE}
my_files = api.files.query(project=str(my_project[0].id), metadata = {"sample_name": file.metadata["sample_name"]} ) 
```

* Copy each file in target project<br>

```{r eval=FALSE}
for file in my_files:<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;new_file = file.copy(project=my_project)	
```

### 3. Copying from public files
Find the corresponding public files within the public data in SBPLA and copy each of them to the target project

```{r eval=FALSE}
file_names = ["Homo_sapiens.GRCh38.dna.primary_assembly.fa", \
  "G20479.HCC1143.2.converted.pe_1_1Mreads.fastq", \
  "G20479.HCC1143.2.converted.pe_2_1Mreads.fastq", \
  "Homo_sapiens.GRCh38.84.gtf"]
#Copying from public reference files
source_project_id = 'admin/sbg-public-data'  
source_files = list(api.files.query(limit = 100, project = source_project_id).all())
reqd_input_files = [currFile for currFile in source_files if currFile.name in file_names]
for currFile in reqd_input_files:
    print(currFile.name + "\t" + currFile.id)
    my_new_file = currFile.copy(project = my_project.id, name = currFile.name)
```

## XI. Creating and running a task 
This can also be a batch task as long as the criteria for batching each run are also provided.
  
To create a task in batch mode:
> task = api.tasks.create(task_name, project_id, app_id, batch_input=None, batch_by=None, inputs, description=None, run=False)

```{r eval=FALSE}
## Name of task
task_name = "Alignment with STAR through the API!" 

## Require  app, projects, and input files to start a job
inputs = {}
my_files = list(api.files.query(limit = 100, project = my_project.id).all())
for currFile in my_files:
    if currFile.name == "Homo_sapiens.GRCh38.84.gtf":
        inputs["sjdbGTFfile"] = []
        inputs["sjdbGTFfile"].append(currFile)
    elif currFile.name == "Homo_sapiens.GRCh38.dna.primary_assembly.fa":
        inputs["reference_or_index"] = currFile
    elif "fastq" in currFile.name:
        if "fastq" not in inputs:
            inputs["fastq"] = []
        inputs["fastq"].append(currFile)
    else:
        print("There are more files in this demo????")
        print(currFile.name)

print(my_project.id, my_duplicated_app.id, (inputs['fastq'][0]).name, (inputs['fastq'][1]).name, (inputs["sjdbGTFfile"][0]).name)
```

```{r eval=FALSE}
my_task = api.tasks.create(name=task_name, project=my_project.id, \
                        app=my_duplicated_app.id, inputs=inputs, run=True)
```

## XII. Print task status

```{r eval=FALSE}
details = my_task.get_execution_details()
print('Your task is in %s status' % (details.status))
```

## XIII. Check the status every couple of minutes

```{r eval=FALSE}
## [USER INPUT] Set loop time (seconds):
from time import sleep

loop_time = 120

print(details.status)
while details.status == "RUNNING":
    print('Checking whether task is completed.')
    details = my_task.get_execution_details()
    if details.status == 'COMPLETED':
        print('Task has completed sucessfully :)')
    elif details.status  == 'FAILED':  
        print('Task failed, can not continue')
        raise KeyboardInterrupt
    else:
        sleep(loop_time)

my_details = api.tasks.get(id = my_task.id)
print(my_details.outputs)
```
