#!/bin/zsh
# Usage: ./post-service-request.zsh $patient_id $encounter_id $practitioner_id

if [ $# -ne 2 ]; then
    echo "Usage: $0 <patient_id> <encounter_id> <practitioner_id>"
    exit 1
fi

patient_id=$1
encounter_id=$2
practitioner_id=$3

source ./get-access-token.zsh

# Post a new ServiceRequest
service_request_response=$(curl --location -s --request POST 'https://hdsfhircontexttest-contextchangefhirservice.fhir.azurehealthcareapis.com/ServiceRequest' \
    --header 'Content-Type: application/json' \
    --header "Authorization: Bearer $access_token" \
    --data '{
        "resourceType": "ServiceRequest",
        "meta": {
            "security": [
                {
                    "system": "urn:oid:1.2.246.537.5.40202.201901",
                    "code": "1"
                }
            ]
        },
        "status": "active",
        "intent": "order",
        "code": {
            "coding": [
                {
                    "system": "urn:oid:1.2.246.537.6.98",
                    "code": "6428",
                    "display": "S -Kolesteroli"
                },
                {
                    "system": "urn:oid:1.2.246.537.6.98",
                    "code": "6430",
                    "display": "S -Kolesteroli, high density lipoproteiinit"
                },
                {
                    "system": "urn:oid:1.2.246.537.6.98",
                    "code": "6432",
                    "display": "S -Kolesteroli, low density lipoproteiinit, analysoitu"
                },
                {
                    "system": "urn:oid:1.2.246.537.6.98",
                    "code": "6427",
                    "display": "S -Triglyseridit"
                },
                {
                    "system": "urn:oid:1.2.246.537.6.98",
                    "code": "1026",
                    "display": "S -Alaniiniaminotransferaasi"
                },
                {
                    "system": "urn:oid:1.2.246.537.6.98",
                    "code": "6354",
                    "display": "Pt-Glomerulussuodosnopeus, estimoitu, CKD-EPI-tutkimuksen kaava"
                },
                {
                    "system": "urn:oid:1.2.246.537.6.98",
                    "code": "1489",
                    "display": "S -Glutamyylitransferaasi"
                }
            ]
        },
        "category": [
            {
                "coding": [
                    {
                        "system": "urn:oid:1.2.246.537.6.605.2014",
                        "code": "1"
                    }
                ]
            }
        ],
        "subject": {
            "reference": "Patient/'$patient_id'"
        },
        "encounter": {
            "reference": "Encounter/'$encounter_id'"
        },
        "requester": {
            "reference": "Practitioner/'$practitioner_id'"
        },
        "authoredOn": "'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'"
    }')

# Extract the ServiceRequest ID
service_request_id=$(echo "$service_request_response" | jq -r '.id')

echo "$service_request_id"