fhirservice="https://hdsfhircontexttest-contextchangefhirservice.fhir.azurehealthcareapis.com/"

# Store access token in a variable
access_token=$(az account get-access-token --resource=$fhirservice --query accessToken --output tsv)