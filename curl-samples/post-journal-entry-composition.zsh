#!/bin/zsh
# Usage: ./post-journal-entry-composition.zsh $patient_id $encounter_id $practitioner_id $document_reference_id

if [ $# -ne 4 ]; then
    echo "Usage: $0 <patient_id> <encounter_id> <practitioner_id> <document_reference_id>"
    exit 1
fi

patient_id=$1
encounter_id=$2
practitioner_id=$3
document_reference_id=$4

source ./get-access-token.zsh

current_date=$(date +%Y-%m-%d)
current_datetime="${current_date}T$(date +%H:%M:%S)+02:00"

# Post a new Bundle with Encounter, Composition, Condition, and DocumentReference
response=$(curl --location -s --request POST 'https://hdsfhircontexttest-contextchangefhirservice.fhir.azurehealthcareapis.com/Composition' \
    --header 'Content-Type: application/json' \
    --header "Authorization: Bearer $access_token" \
    --data '{
    "resourceType": "Composition",
    "status": "final",
    "title": "Potilaskäynnin kirjaus",
    "type": {
        "coding": [{
            "system": "urn:oid:1.2.246.537.6.12.2002.119",
            "code": "11506-3",
            "display": "Käyntikirjaus"
        }]
    },
    "subject": { "reference": "Patient/'$patient_id'" },
    "date": "'$current_datetime'",
    "author": [{ "reference": "Practitioner/'$practitioner_id'" }],
    "encounter": { "reference": "Encounter/'$encounter_id'" },
    "section": [{
        "title": "Käyntirivi",
        "text": {
            "status": "generated",
            "div": "<div><b>Päivämäärä:</b> '$current_date'<br><b>Paikka:</b> Terveyskeskus Helsinki<br><b>Kirjaaja:</b> Tohtori Kirjaaja<br><b>Kirjaajan titteli:</b> Yleislääkäri</div>"
        }
    }, {
        "title": "Esitiedot",
        "text": {
            "status": "generated",
            "div": "<div>Potilas valittelee olevansa kipiä</div>"
        }
    }, {
        "title": "Nykytila",
        "text": {
            "status": "generated",
            "div": "<div>Sanoo Aaa, kurkku punottaa</div>"
        }
    }, {
        "title": "Diagnoosi",
        "entry": [{ "reference": "Condition/condition-1" }]
    }, {
        "title": "Suunnitelma",
        "text": {
            "status": "generated",
            "div": "<div>Loppuviikko saikkua. Buranaa tarvittaessa.</div>"
        }
    }, {
        "title": "Original Document",
        "entry": [{ "reference": "DocumentReference/'$document_reference_id'" }]
    }]
}')

# Extract the Bundle ID and echo it
bundle_id=$(echo "$response" | jq -r '.id')
echo "$bundle_id"
