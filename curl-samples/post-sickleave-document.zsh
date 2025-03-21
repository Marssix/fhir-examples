#!/bin/zsh
# Usage: ./post-sickleave-document.zsh $patient_id $encounter_id $practitioner_id

if [ $# -ne 3 ]; then
    echo "Usage: $0 <patient_id> <encounter_id> <practitioner_id>"
    exit 1
fi

patient_id=$1
encounter_id=$2
practitioner_id=$3

source ./get-access-token.zsh

# Post a new DocumentReference, SickLeave
sickleave_document_response=$(curl --location -s --request POST 'https://hdsfhircontexttest-contextchangefhirservice.fhir.azurehealthcareapis.com/DocumentReference' \
    --header 'Content-Type: application/json' \
    --header "Authorization: Bearer $access_token" \
    --data '{
        "resourceType": "DocumentReference",
        "status": "current",
        "type": {
            "coding": [
                {
                    "system": "urn:oid:1.2.246.537.6.12.2002.141",
                    "code": "SV6",
                    "display": "Lääkärintodistus A (SV6)"
                }
            ]
        },
        "subject": {
            "reference": "Patient/'$patient_id'"
        },
        "author": [
            {
                "reference": "Practitioner/'$practitioner_id'",
                "display": "Dr. Testaaja"
            }
        ],
        "date": "'$(date +%Y-%m-%d)'T00:00:00Z",
        "content": [
            {
                "attachment": {
                    "contentType": "application/pdf",
                    "url": "https://example.com/fhir/DocumentReference/sairausloma-'$(date +%Y)'-.pdf",
                    "title": "Lääkärintodistus A (SV6) - Sairausloma"
                }
            }
        ],
        "context": {
            "encounter": {
                "reference": "Encounter/'$encounter_id'"
            },
            "period": {
                "start": "'$(date +%Y-%m-%d)'",
                "end": "'$(date -v+30d +%Y-%m-%d)'"
            }
        },
        "category": [
            {
                "coding": [
                    {
                        "system": "http://hl7.org/fhir/ValueSet/doc-typecodes",
                        "code": "clinical-note",
                        "display": "Clinical Note"
                    }
                ]
            }
        ],
        "custodian": {
            "reference": "Organization/567",
            "display": "Yritys Oy"
        },
        "securityLabel": [
            {
                "coding": [
                    {
                        "system": "http://terminology.hl7.org/CodeSystem/v3-Confidentiality",
                        "code": "R",
                        "display": "Restricted"
                    }
                ]
            }
        ]
    }')

# Extract the DocumentReference ID
sickleave_document_id=$(echo "$sickleave_document_response" | jq -r '.id')

echo "$sickleave_document_id"