# Infrastructure as code

A way of codifying the deployments you make in cloud infrastructure to make administering them more manageable.  The idea is to keep your infrastructure in a certain known state, which you commit to git.  When you want to change the state (because you have a new requirement), just like coding, you make the change in infrastructure code, and then you commit the new state into git.  That way, everyone should always know what infrastructure has actually be created, and what state it is in.  Of course this state does not take account of:

- data in a database 
- application versions deployed onto any web app.

So, for these exercises, we are going to use Bicep (which is a Microsoft native language for describing infrastructure state) to create the infrastructure.  you can find example of all kinds of different types of Azure infrastructure bicep files here: https://github.com/Azure/azure-quickstart-templates/tree/master/quickstarts


There are many videos on Youtube that can give you a crash course in Bicep.  Here's one or two


https://www.youtube.com/watch?v=VDCAJIGqHZU
https://www.youtube.com/watch?v=MP60ND7Upn4&list=PLlrxD0HtieHjzqIRjPoERUGj49rve3rCM


Ignore everything you hear about ARM templates.  These are older and more complex technologies which you don't need to know if you know how to use Bicep.

# Instructions for getting started and deploying infrastructure

- make sure Powershell is installed 
- make sure azure-cli is installed
- install Bicep
- login to Azure
- change to the Sandbox subscription
- run the powershell script: (./create.ps1 in a Powershell terminal)