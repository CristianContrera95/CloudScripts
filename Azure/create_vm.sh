#
#Author: Cristian Contrera
#Date: 19/12/2019
#Motivation: mucho tiempo al pedo
#

SSH_KEY_PUB="$( cat ~/.ssh/azure.pub )"

VM=$( az vm create --name "$1" \
             --resource-group MineSecurity_PiData \
             --image UbuntuLTS \
             --location eastus \
             --size Standard_B1ms \
             --admin-username anybody \
             --generate-ssh-keys \
     )

             #--ssh-key-value $SSH_KEY_PUB 
echo $VM

az vm open-port --port 80 --resource-group MineSecurity_PiData --name "$1"
