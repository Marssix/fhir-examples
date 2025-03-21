#!/bin/zsh
# Usage: ./post-condition.zsh <patient_id> <encounter_id>

if [ $# -ne 2 ]; then
    echo "Usage: $0 <patient_id> <encounter_id>"
    exit 1
fi

patient_id=$1
encounter_id=$2

source ./get-access-token.zsh

# Create a condition for the patient
condition_response=$(curl -s --location 'https://hdsfhircontexttest-contextchangefhirservice.fhir.azurehealthcareapis.com/Condition' \
    --header 'Content-Type: application/json' \
    --header "Authorization: Bearer $access_token" \
    --data '{
    "resourceType": "Condition",
    "clinicalStatus": {
        "coding": [{
            "system": "http://terminology.hl7.org/CodeSystem/condition-clinical",
            "code": "active",
            "display": "Active"
        }]
    },
    "verificationStatus": {
        "coding": [{
            "system": "http://terminology.hl7.org/CodeSystem/condition-ver-status",
            "code": "confirmed",
            "display": "Confirmed"
        }]
    },
    "category": [{
        "coding": [{
            "system": "http://terminology.hl7.org/CodeSystem/condition-category",
            "code": "encounter-diagnosis",
            "display": "Encounter Diagnosis"
        }]
    }],
    "code": {
        "coding": [{
            "system": "http://hl7.org/fhir/sid/icd-10",
            "code": "J03.0",
            "display": "Streptokokkiangiina"
        }]
    },
    "subject": {
        "reference": "Patient/'$patient_id'"
    },
    "encounter": {
        "reference": "Encounter/'$encounter_id'"
    }
}')

# Extract and display the condition ID
condition_id=$(echo $condition_response | grep -o '"id":"[^"]*"' | cut -d'"' -f4)
echo "$condition_id"

