# Infrastructure as code

A way of codifying the deployments you make in cloud infrastructure to make administering them more manageable.  The idea is to keep your infrastructure in a certain known state, which you commit to git.  When you want to change the state (because you have a new requirement), just like coding, you make the change in infrastructure code, and then you commit the new state into git.  That way, everyone should always know what infrastructure has actually be created, and what state it is in.  Of course this state does not take account of:

- data in a database 
- application versions deployed onto any web app.

So, for these exercises, we are going to use Bicep (which is a Microsoft native language for describing infrastructure state) to create the infrastructure.  you can find example of all kinds of different types of Azure infrastructure bicep files here: https://github.com/Azure/azure-quickstart-templates/tree/master/quickstarts


There are many videos on Youtube that can give you a crash course in Bicep.  Here's one or two


https://www.youtube.com/watch?v=VDCAJIGqHZU
https://www.youtube.com/watch?v=MP60ND7Upn4&list=PLlrxD0HtieHjzqIRjPoERUGj49rve3rCM


Ignore everything you hear about ARM templates.  These are older and more complex technologies which you don't need to know if you know how to use Bicep.

# Getting started

- make sure Powershell is installed (https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7.4)
- make sure azure-cli is installed (https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/install)
- install Bicep (it may have been installed by the azure-cli.  Check by running `az bicep version`)
- If you are using VS Code, install the bicep extension. If you open this repo and open one of the bicep files, you will be prompted to install the extension anyway.
- login to Azure `az login` in a terminal
- change to the Sandbox subscription `az account set -s 'Sandbox'`
- amend the bicep files, and then run the powershell script: (./create.ps1 in a Powershell terminal) in a terminal. Make sure you are in the right directory

You can of course use this example to create private versions of the same infrastructure that is connected to a VNet.  There are a few examples online.  For example on the mysql side, you can see this here:

https://learn.microsoft.com/en-us/azure/mysql/flexible-server/quickstart-create-bicep?tabs=azure-cli 

# Folders

Folders have been created to help structure the code for the infrastructure as follows
- environments - this is to be used for code that will be created for live infrastructure (for the African clients or development team where required).  There's a readme file in this folder, which specifies what the folders in the environments folder are used for.
- samples - to be used in learning examples or snippets of code that help with learning. Please keep this area tidy.  Everything should be put into its separate folder so that the area is well organized.
- pipelines.  In future, we'll need pipelines to help with orchestrating the creation of infrastructure.  This is where the pipelines will be stored.