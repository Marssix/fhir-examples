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

# Create a new practitioner and store response
response=$(curl -s --location 'https://hdsfhircontexttest-contextchangefhirservice.fhir.azurehealthcareapis.com/Practitioner' \
    --header 'Content-Type: application/json' \
    --header "Authorization: Bearer $access_token" \
    --data-raw '{
    "resourceType": "Practitioner",
    "identifier": [{"value": "'$SSN'"}],
    "active": true,
    "name": [{
        "text": "'$first' '$last'",
        "family": "'$last'",
        "given": ["'$first'", "'$middle'"]
    }],
    "telecom": [{
        "system": "phone",
        "value": "0401231234"
    }],
    "gender": "male",
    "birthDate": "1980-01-01"
    }')

# Extract and display the practitioner ID
practitioner_id=$(echo $response | grep -o '"id":"[^"]*"' | cut -d'"' -f4)
echo "$practitioner_id"

