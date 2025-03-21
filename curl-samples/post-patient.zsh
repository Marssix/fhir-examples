#!/bin/zsh
source ./get-access-token.zsh

# Arrays of Finnish names
first_names=(
    "Mikko" "Matti" "Juhani" "Pekka" "Antti" 
    "Maria" "Liisa" "Anna" "Helena" "Kaarina"
)
last_names=(
    "Virtanen" "Korhonen" "Mäkinen" "Nieminen" "Mäkelä" 
    "Hämäläinen" "Laine" "Heikkinen" "Koskinen" "Järvinen"
)

# Function to generate random name
generate_name() {
    first=${first_names[$((RANDOM % ${#first_names[@]} + 1))]}
    middle=${first_names[$((RANDOM % ${#first_names[@]} + 1))]}
    last=${last_names[$((RANDOM % ${#last_names[@]} + 1))]}
    echo "$first" "$middle" "$last"
}

# Function to generate random Finnish SSN
generate_ssn() {
    # Generate random date between 1940-2020
    year=$(( RANDOM % 81 + 40 ))
    month=$(printf "%02d" $(( RANDOM % 12 + 1 )))
    day=$(printf "%02d" $(( RANDOM % 28 + 1 )))  # Using 28 to be safe with all months
    
    # Century marker (A=1900s, B=2000s, ...)
    if [[ $year -lt 50 ]]; then
        century_mark="A"
    else
        century_mark="-"
    fi
    
    # Individual number (002-899)
    individual=$(printf "%03d" $(( RANDOM % 898 + 2 )))
    
    # Base part of SSN
    base="${day}${month}${year}${century_mark}${individual}"
    
    # Control characters lookup
    control_chars="0123456789ABCDEFHJKLMNPRSTUVWXY"
    remainder=$(( $(echo "$base" | sed 's/[A-Z-]//g') % 31 ))
    control_char=${control_chars:$remainder:1}
    
    echo "${base}${control_char}"
}

# Generate random SSN
SSN=$(generate_ssn)

# Generate random names
read first middle last <<< $(generate_name)

# Create a new patient and store response
response=$(curl -s --location 'https://hdsfhircontexttest-contextchangefhirservice.fhir.azurehealthcareapis.com/Patient' \
    --header 'Content-Type: application/json' \
    --header "Authorization: Bearer $access_token" \
    --data-raw '{
    "resourceType": "Patient",
    "identifier": {"value": "'$SSN'"},
    "active": true,
    "name": [
        {
        "use": "official",
        "family": "'$last'",
        "given": ["'$first'", "'$middle'"]
        },
        {
        "use": "usual",
        "given": ["'$first'"]
        }
    ],
    "gender": "male",
    "birthDate": "2007-01-01",
    "contact": [{
        "telecom": [{
            "system": "phone",
            "value": "0401231234"
        }, 
        {
            "system": "email",
            "value": "Kimmo.Kuu@gmail.com"
        }],
        "organization": {"reference": "Organization/c8909a6f-6556-4557-8dba-496ee75de51c"}
    }]
    }')

# Sample response
# {"resourceType":"Patient","id":"37773cc2-9fd7-424e-bbea-17a7d3bf4691","meta":{"versionId":"1","lastUpdated":"2025-03-21T07:14:47.559+00:00"},"identifier":[{"value":"010107A903C"}],"active":true,"name":[{"use":"official","family":"Kuu","given":["Kimmo","Petteri"]},{"use":"usual","given":["Kimmo"]}],"gender":"male","birthDate":"2007-01-01","contact":[{"telecom":[{"system":"phone","value":"0401231234"},{"system":"email","value":"Kimmo.Kuu@gmail.com"}],"organization":{"reference":"Organization/c8909a6f-6556-4557-8dba-496ee75de51c"}}]}

# Extract and display the patient ID
patient_id=$(echo $response | grep -o '"id":"[^"]*"' | cut -d'"' -f4)
echo "$patient_id"

