
# Red Hat Summit 2025
# Lab 1153
# Script to retrieve the CIDR of the Ripper app from ACS
#
# mthirion@redhat.com
#
# -------------------
#
# arguments : 
#    $SCRIPT ACS_CENTRAL_URL ACS_PASSWORD
#
#  ACS_CENTRAL_URL ; i.e. https://central-stackrox.apps.cluster-f2gxq.f2gxq.sandbox4732.opentlc.com
#  ACS_PASSWORD (assuming 'admin' as username
#
# ===========================================


#echo "curl -k -u admin:$ACS_PSWD $ACS_CENTRAL/v1/clusters | jq '.clusters[] | select (.name == "production").id'"
CLUSTER=$(curl -s -k -u admin:$ACS_PSWD $ACS_CENTRAL/v1/clusters | jq '.clusters[] | select (.name == "production").id' )
CLUSTER=$(echo $CLUSTER | tr -d '"')
#echo $CLUSTER

while [[ -z $DEPLOYMENT ]]
do
	#echo "curl -k -u admin:$ACS_PSWD $ACS_CENTRAL/v1/networkgraph/cluster/$CLUSTER | jq -c 'first(.nodes[].entity | select (.deployment.name == "quarkus-template")| select (.deployment.namespace == "customers-user1") ).id'"
	DEPLOYMENT=$(curl -s -k -u admin:$ACS_PSWD $ACS_CENTRAL/v1/networkgraph/cluster/$CLUSTER | jq -c 'first(.nodes[].entity | select (.deployment.name == "quarkus-template") | select (.deployment.namespace == "customers-user1") ).id' ) 
	DEPLOYMENT=$(echo $DEPLOYMENT | tr -d '"')
	#echo $DEPLOYMENT
	if [[ -z $DEPLOYMENT ]]
	then
		sleep 10
	fi
done

while [[ -z $CIDR ]]
do
	#echo "curl -k -u admin:$ACS_PSWD $ACS_CENTRAL/v1/networkgraph/cluster/$CLUSTER/externalentities/flows/$DEPLOYMENT | jq '.flows[].props.dstEntity.externalSource.cidr' "
	CIDR=$(curl -s -k -u admin:$ACS_PSWD $ACS_CENTRAL/v1/networkgraph/cluster/$CLUSTER/externalentities/flows/$DEPLOYMENT | jq '.flows[].props.dstEntity.externalSource.cidr' ) 
	CIDR=$(echo $CIDR | tr -d '"')
	#echo $CIDR
	if [[ -z $CIDR ]]
	then
		sleep 10
	fi
done
echo $CIDR
