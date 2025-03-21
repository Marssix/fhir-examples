#!/bin/zsh
# Usage: ./get-bundle.zsh <bundle-id>

# Check if bundle ID is provided
if [[ -z "$1" ]]; then
    echo "Error: Bundle ID is required"
    echo "Usage: ./get-bundle.zsh <bundle-id>"
    exit 1
fi

bundle_id="$1"

source ./get-access-token.zsh

echo "Fetching bundle data for ID: $bundle_id..."

result=$(curl -X GET \
  "https://hdsfhircontexttest-contextchangefhirservice.fhir.azurehealthcareapis.com/Bundle/$bundle_id" \
  -H "Authorization: Bearer $access_token" \
  -H "Accept: application/fhir+json")

echo "$result" | jq '.' > "./results/bundle_data_$bundle_id.json"
