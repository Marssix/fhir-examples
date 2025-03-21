#!/bin/zsh
# Usage: ./post-medication-request.zsh $patient_id $encounter_id

if [ $# -ne 2 ]; then
    echo "Usage: $0 <patient_id> <encounter_id>"
    exit 1
fi

patient_id=$1
encounter_id=$2

source ./get-access-token.zsh

# Post a new MedicationRequest
medication_request_response=$(curl --location -s --request POST 'https://hdsfhircontexttest-contextchangefhirservice.fhir.azurehealthcareapis.com/MedicationRequest' \
    --header 'Content-Type: application/json' \
    --header "Authorization: Bearer $access_token" \
    --data '{
        "resourceType": "MedicationRequest",
        "meta": {
            "security": [
                {
                    "system": "urn:oid:1.2.246.537.5.40202.201901",
                    "code": "1"
                }
            ]
        },
        "extension": [
            {
                "url": "http://resepti.kanta.fi/StructureDefinition/extension/versionNumber",
                "valuePositiveInt": 1
            },
            {
                "url": "http://resepti.kanta.fi/StructureDefinition/extension/permanentMedication",
                "valueBoolean": true
            },
            {
                "url": "http://resepti.kanta.fi/StructureDefinition/extension/usage",
                "valueString": "Verenpainelääke."
            }
        ],
        "status": "active",
        "intent": "order",
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
        "medicationReference": {
            "reference": "Medication/medicationesim1"
        },
        "subject": {
            "reference": "Patient/'$patient_id'"
        },
        "encounter": {
            "reference": "Encounter/'$encounter_id'"
        },
        "authoredOn": "'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'",
        "dosageInstruction": [
            {
                "text": "1 tabletti 2 kertaa päivässä",
                "timing": {
                    "repeat": {
                        "frequency": 2,
                        "period": 1,
                        "periodUnit": "d"
                    }
                },
                "asNeededBoolean": false,
                "doseAndRate": [
                    {
                        "doseQuantity": {
                            "value": 1,
                            "unit": "tabletti",
                            "system": "urn:oid:1.2.246.537.6.138.202001",
                            "code": "18"
                        }
                    }
                ]
            }
        ],
        "dispenseRequest": {
            "validityPeriod": {
                "end": "'$(date -v+1y -u +"%Y-%m-%dT%H:%M:%SZ")'"
            },
            "numberOfRepeatsAllowed": 3,
            "dispenseInterval": {
                "value": 30,
                "unit": "d"
            }
        },
        "substitution": {
            "allowedBoolean": true
        }
    }')

# Extract the MedicationRequest ID
medication_request_id=$(echo "$medication_request_response" | jq -r '.id')

echo "$medication_request_id"