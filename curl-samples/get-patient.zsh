#!/bin/zsh
# ./get-patient.zsh $patient_id

# Check if patient ID is provided
if [[ -z "$1" ]]; then
    echo "Error: Patient ID is required"
    echo "Usage: ./get-patient.zsh <patient_id>"
    exit 1
fi

patient_id="$1"

source ./get-access-token.zsh

echo "Fetching patient data for ID: $patient_id..."

# Create results directory if it doesn't exist
results_dir="./results"
if [[ ! -d "$results_dir" ]]; then
    echo "Creating results directory..."
    mkdir -p "$results_dir"
fi

# Initialize variables
page_url1="https://hdsfhircontexttest-contextchangefhirservice.fhir.azurehealthcareapis.com/Patient/$patient_id/\$everything?_type=Patient%2CEncounter%2CCondition%2CServiceRequest%2CMedicationRequest%2CDocumentReference%2CComposition%2CBundle"
page_url="https://hdsfhircontexttest-contextchangefhirservice.fhir.azurehealthcareapis.com/Patient/$patient_id/\$everything"
page_count=1
all_entries=()

# Initialize our results file
echo "[]" > "$results_dir/patient_data_all.json"

while [ -n "$page_url" ]; do
    echo "Fetching page $page_count..."
    
    # Get the current page
    response=$(curl --silent --location --request GET "$page_url" \
        --header "Authorization: Bearer $access_token" \
        --data '')
    
    # Extract entries from this page and add to our collection
    entries=$(echo "$response" | jq -c '.entry[]')
    if [ -n "$entries" ]; then
        # Append entries to our all_entries array
        while IFS= read -r entry; do
            all_entries+=("$entry")
        done < <(echo "$entries")
    fi
    
    # Check if there's a next link
    next_link=$(echo "$response" | jq -r '.link[] | select(.relation == "next") | .url')
    
    if [ "$next_link" = "null" ] || [ -z "$next_link" ]; then
        # No more pages
        page_url=""
    else
        # Update URL to the next page
        page_url="$next_link"
        ((page_count++))
    fi
done

echo "Total pages fetched: $page_count"
echo "Total entries collected: ${#all_entries[@]}"

# Combine all entries into a single bundle
echo "Creating combined dataset..."
all_data="{ \"resourceType\": \"Bundle\", \"type\": \"searchset\", \"entry\": ["

# Add all entries
first=true
for entry in "${all_entries[@]}"; do
    if [ "$first" = true ]; then
        first=false
    else
        all_data="$all_data,"
    fi
    all_data="$all_data$entry"
done

all_data="$all_data]}"

# Save the combined data
echo "$all_data" > "$results_dir/patient_data_all.json"

# Format the combined data for readability
all_data_formatted=$(echo "$all_data" | jq '.')
echo "$all_data_formatted" > "$results_dir/patient_data_all_formatted.json"

echo "All patient data collected and saved to:"
echo "- Raw data: $results_dir/patient_data_all.json"
echo "- Formatted data: $results_dir/patient_data_all_formatted.json"