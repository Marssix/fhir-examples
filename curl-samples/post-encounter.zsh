#!/bin/zsh
# Usage: ./post-encounter.zsh <patient_id> <practitioner_id>

if [ $# -ne 2 ]; then
    echo "Usage: $0 <patient_id> <practitioner_id>"
    exit 1
fi

patient_id=$1
practitioner_id=$2

source ./get-access-token.zsh

# Create an encounter for the patient
encounter_response=$(curl -s --location 'https://hdsfhircontexttest-contextchangefhirservice.fhir.azurehealthcareapis.com/Encounter' \
    --header 'Content-Type: application/json' \
    --header "Authorization: Bearer $access_token" \
    --data '{
    "resourceType": "Encounter",
    "status": "in-progress",
    "identifier": [{"value": "12345"}],
    "subject": {
        "reference": "Patient/'$patient_id'"
    },
    "class": {
        "system": "http://terminology.hl7.org/CodeSystem/v3-ActCode",
        "code": "IMP",
        "display": "inpatient encounter"
    },
    "participant": [{
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
    }],
    "period": {
        "start": "2024-06-10T10:00:00Z",
        "end": "2024-06-10T11:00:00Z"
    },
    "reasonReference": [{
        "reference": "Condition/0489312"
    }]
}')

# Extract and display the encounter ID
encounter_id=$(echo $encounter_response | grep -o '"id":"[^"]*"' | cut -d'"' -f4)
echo "$encounter_id"

