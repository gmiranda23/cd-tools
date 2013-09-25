cd-tools
========

cd tools!

are the bestest - seriously

this is a non-Gerrit fork of adamhjk's cd-tools experiment that assumes use of single cookbook repos.  it requires a git pull-request code review model to replace gerrit functionality.

------
jenkins
------

OK - the recipes will get you set up, but there are manual steps.

# Step 1
  /path/to/cmd example

# Add the Jenkins user to the Non-Interactive Users group

Manipulate the default permissions.

Admin->Project->All-Projects->Access

  refs/*
    + Read -> Non-Interactive Users
    + Push -> Administrators -> Force Push Checked
    + Create References -> Administrators
  refs/heads/*
    + Push -> Administrators -> Force Push Checked
    + Label Verified -> Non-Interactive Users (-1/+1)
    + Label Code Reviewed -> Non-Interactive Users (-1/+1)
    + Submit -> Registered Users

# More steps TBD


# Test Flow for Cookbooks

- Check Jobs
  - Syntax
  - Foodcritic
  - Test-kitchen
- Gate Jobs
  - Bump Patch Level
  - Upload cookbook
  - Pin to Dev Environment
  - Converge Dev Environment
- Promotion
  - Dev->Integration
  - Integration->Staging
  - Staging->Production
  - Production->A
  - A->B

# Create the first check job

# Gate Tests

