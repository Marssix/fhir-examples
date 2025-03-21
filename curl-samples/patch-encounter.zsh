#!/bin/zsh
# Usage: ./post-condition.zsh $encounter_id $patient_id $practitioner_id $condition_id

if [ $# -ne 4 ]; then
    echo "Usage: $0 <encounter_id> <patient_id> <practitioner_id> <condition_id>"
    exit 1
fi

encounter_id=$1
patient_id=$2
practitioner_id=$3
condition_id=$4

source ./get-access-token.zsh

# Patch the encounter with full details
encounter_response=$(curl --location -s --request PATCH 'https://hdsfhircontexttest-contextchangefhirservice.fhir.azurehealthcareapis.com/Encounter/'$encounter_id \
    --header 'Content-Type: application/json-patch+json' \
    --header "Authorization: Bearer $access_token" \
    --data '[
        {
            "op": "replace",
            "path": "/status",
            "value": "in-progress"
        },
        {
            "op": "replace",
            "path": "/identifier",
            "value": [{"value": "12345"}]
        },
        {
            "op": "replace",
            "path": "/subject",
            "value": {
                "reference": "Patient/'$patient_id'"
            }
        },
        {
            "op": "replace",
            "path": "/class",
            "value": {
                "system": "http://terminology.hl7.org/CodeSystem/v3-ActCode",
                "code": "IMP",
                "display": "inpatient encounter"
            }
        },
        {
            "op": "replace",
            "path": "/participant",
            "value": [{
                "type": [{
                    "coding": [{
                        "system": "http://terminology.hl7.org/CodeSystem/v3-ParticipationType",
                        "code": "ATND",
                        "display": "attender"
                    }]
                }],
                "individual": {
                    "reference": "Practitioner/'$practitioner_id'"
                }
            }]
        },
        {
            "op": "replace",
            "path": "/period",
            "value": {
                "start": "2024-06-10T10:00:00Z",
                "end": "2024-06-10T11:00:00Z"
            }
        },
        {
            "op": "replace",
            "path": "/reasonReference",
            "value": [{
                "reference": "Condition/'$condition_id'"
            }]
        }
    ]')

# Extract and display the encounter ID
encounter_id2=$(echo $encounter_response | grep -o '"id":"[^"]*"' | cut -d'"' -f4)
echo "$encounter_id2"
