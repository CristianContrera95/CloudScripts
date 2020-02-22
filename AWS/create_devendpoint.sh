#
#Author: Cristian Contrera
#Date: 19/12/2019
#Motivation: mucho tiempo al pedo
#


AWS_CRED=~/.ssh/aws.pub
AWS_CRED2=~/.ssh/aws_sabri.pub

SSH_KEY=~/.ssh/aws
# get aws cred and save into var
pub_key=$( cat "$AWS_CRED" )
pub_key2=$( cat "$AWS_CRED2" )

aws2 glue create-dev-endpoint \
    --endpoint-name "$1"\
    --role-arn "arn:aws:iam::022136153280:role/eu-west-1-cic-dev-dfi-glueRole"\
    --public-keys "$pub_key" "$pub_key2"\
    --security-group-ids "sg-809c0efa"\
    --subnet-id "subnet-3032096b"\
    --extra-python-libs-s3-path "s3://cic-dev-dfi-gluejobs/common.zip,s3://cic-dev-dfi-gluejobs/plugins.zip,s3://cic-dev-dfi-gluejobs/gluescripts.zip"\
    --extra-jars-s3-path "s3://cic-dev-dfi-gluejobs/mysql-connector-java-8.0.11.jar"
    #--worker-type "Standard"\ #4 vCPU, 16 GB of memory and a 50GB disk, and 2 executors per worker. 
    #--number-of-nodes 6 
    #--glue-version 0.9  #spark 2, python22


printf "\nEsperando...\n"
while [ 1 ]; do

    is_ready=$( aws2 glue get-dev-endpoint --endpoint-name "$1" | grep "READY" | wc -l  )
    if [ $(( $is_ready )) != 0 ];
    then
        una_varibale=$( aws2 glue get-dev-endpoint --endpoint-name "$1" )
        echo "$una_varibale"
        ip_addr=$( aws2 glue get-dev-endpoint --endpoint-name "$1" | grep PrivateAddress | grep -oE '\-((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\-){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])' | cut -c2-9999 | tr - . )
        ip_addr=$( echo $ip_addr  )
        last_ip=${ip_addr##*-}
        break;
    fi
    sleep 10;

done


printf "\n\nconetandose a la maquinita en $last_ip \n"
cd
ssh -i $SSH_KEY glue@$last_ip -t gluepyspark
