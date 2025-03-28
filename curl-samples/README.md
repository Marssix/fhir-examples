# FHIR API Curl Samples

This folder contains a collection of shell scripts for interacting with a FHIR server using curl commands. These scripts demonstrate how to perform various operations against the Azure Healthcare APIs FHIR service.

## Prerequisites

- zsh shell
- Azure CLI installed and configured 
- jq for JSON processing
- Access to an Azure Healthcare FHIR service instance

## Authentication

All scripts utilize the `get-access-token.zsh` script which retrieves an access token from Azure CLI. Make sure you're logged into Azure CLI before running these scripts.

## Available Scripts

### Patient Management

- `post-patient.zsh` - Create a new patient with randomly generated Finnish details
- `post-ok-fi-base-patient.zsh` - Create a patient conforming to the Finnish base patient profile
- `post-nok-fi-base-patient.zsh` - Example of a non-compliant Finnish base patient
- `get-patient.zsh <patient_id>` - Retrieve a patient and all related resources

### Healthcare Professionals

- `post-practitioner.zsh` - Create a new practitioner (healthcare professional)

### Clinical Resources

- `post-condition.zsh <patient_id> <encounter_id>` - Record a medical condition
- `post-encounter.zsh <patient_id> <practitioner_id>` - Create a patient encounter
- `patch-encounter.zsh <encounter_id> <patient_id> <practitioner_id> <condition_id>` - Update encounter details
- `post-service-request.zsh <patient_id> <encounter_id> <practitioner_id>` - Create a service request (lab order)
- `post-medication-request.zsh <patient_id> <encounter_id>` - Create a medication prescription
- `post-sickleave-document.zsh <patient_id> <encounter_id> <practitioner_id>` - Create a sick leave document

### Documentation

- `post-journal-entry-composition.zsh <patient_id> <encounter_id> <practitioner_id> <document_reference_id>` - Create a clinical note composition
- `get-composition.zsh <composition_id>` - Retrieve a composition
- `get-bundle.zsh <bundle_id>` - Retrieve a bundle

### Structural Definitions

- `put-fi-base-patient-structure-definition.zsh` - Create/update the Finnish base patient profile definition

### Comprehensive Examples

- `post-full-encounter.zsh` - Create a complete patient visit including all related resources

## Example Usage

To create a complete patient encounter with all associated resources:

```bash
./post-full-encounter.zsh
```

This will:
1. Create a patient
2. Create a practitioner
3. Create an encounter
4. Create a condition
5. Update the encounter with details
6. Add a medication request
7. Add a service request
8. Add a sick leave document
9. Create a journal entry composition
10. Retrieve the created patient data

## Output

Most scripts return the ID of the created resource, which can be used in subsequent API calls. 
The `get-patient.zsh` script stores its output in the `./results/` directory.

## Notes

- These scripts are designed for testing and demonstration purposes
- The FHIR server URL is configured for a specific test environment
- Random Finnish personal information is generated for demo purposes
