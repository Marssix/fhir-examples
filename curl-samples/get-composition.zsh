#!/bin/zsh
# Usage: ./get-composition.zsh <composition-id>

# Check if composition ID is provided
if [[ -z "$1" ]]; then
    echo "Error: Composition ID is required"
    echo "Usage: ./get-composition.zsh <composition-id>"
    exit 1
fi

composition_id="$1"

source ./get-access-token.zsh

echo "Fetching composition data for ID: $composition_id..."

curl -X GET \
  "https://hdsfhircontexttest-contextchangefhirservice.fhir.azurehealthcareapis.com/Composition/$composition_id" \
  -H "Authorization: Bearer $access_token" \
  -H "Accept: application/fhir+json"
