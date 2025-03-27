#!/bin/zsh
# Usage: ./post-ok-fi-base-patient.zsh

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
    last=${last_names[$((RANDOM % ${#last_names[@]} + 1))]}
    echo "$first" "$last"
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

# Generate random name
read first last <<< $(generate_name)

# Create a Finnish postal code
postal_codes=("00100" "20100" "33100" "90100" "70100" "40100" "15100" "50100" "60100" "80100")
postal_code=${postal_codes[$((RANDOM % ${#postal_codes[@]} + 1))]}

# Create a Finnish city
cities=("Helsinki" "Turku" "Tampere" "Oulu" "Kuopio" "Jyväskylä" "Lahti" "Joensuu" "Vaasa" "Rovaniemi")
city=${cities[$((RANDOM % ${#cities[@]} + 1))]}

# Generate a random shoe size between 35-48
shoe_size=$((RANDOM % 14 + 35))

# Validate a patient against the Finnish base profile
response=$(curl -s --location 'https://hdsfhircontexttest-contextchangefhirservice.fhir.azurehealthcareapis.com/Patient/$validate' \
    --header 'Content-Type: application/json' \
    --header "Authorization: Bearer $access_token" \
    --data '{
    "resourceType": "Patient",
    "meta": {
        "security": [
            {
                "system": "https://hl7.fi/fhir/finnish-base-profiles/CodeSystem/fi-base-security-label-cs"
            }
        ],
        "profile": [
            "https://hdsfhircontexttest-contextchangefhirservice.fhir.azurehealthcareapis.com/StructureDefinition/fi-base-patient"
        ]
    },
    "identifier": [
        {
            "use": "official",
            "type": {
                "coding": [
                    {
                        "system": "http://terminology.hl7.org/CodeSystem/v2-0203",
                        "code": "NNFIN"
                    }
                ]
            },
            "system": "urn:oid:1.2.246.21",
            "value": "'$SSN'"
        }
    ],
    "gender": "male",
    "birthDate": "2000-01-11",
    "name": [
        {
            "given": [
                "'$first'"
            ],
            "family": "'$last'",
            "text": "'$first' '$last'"
        }
    ],
    "telecom": [
        {
            "system": "phone",
            "value": "+35840'$((RANDOM % 9000000 + 1000000))'"
        }
    ],
    "address": [
        {
            "use": "home",
            "line": [
                "'$last'katu '$((RANDOM % 100 + 1))'"
            ],
            "city": "'$city'",
            "postalCode": "'$postal_code'",
            "country": "FI"
        }
    ],
    "extension": [
        {
            "url": "https://hdsfhircontexttest-contextchangefhirservice.fhir.azurehealthcareapis.com/StructureDefinition/Shoe-Size",
            "valueInteger": '$shoe_size'
        }
    ]
}')

# Display validation results
echo "Validation Result:"
echo "$response" | jq '.' 2>/dev/null || echo "$response"