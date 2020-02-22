#
#Author: Cristian Contrera
#Date: 19/12/2019
#Motivation: mucho tiempo al pedo
#

IOTHUB=$( az iot hub create --name "$1" \
                  --resource-group ccontrera \
                  --location eastus \
                  --sku F1 \
                  --partition-count 2 \
        )

                #   --partition-count 2 \ is for free tier
