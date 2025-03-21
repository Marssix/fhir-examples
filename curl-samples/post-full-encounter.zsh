#!/bin/zsh
source ./get-access-token.zsh

# Remove the existing data
rm -rf ./results/*

# Post a new Patient
patient_id=$(./post-patient.zsh)
echo "Patient created with ID: $patient_id"

# Post a new Practitioner
practitioner_id=$(./post-practitioner.zsh)
echo "Practitioner created with ID: $practitioner_id"

# Post a new Encounter
encounter_id=$(./post-encounter.zsh $patient_id $practitioner_id)
echo "Encounter created with ID: $encounter_id"

# Post a new Condition
condition_id=$(./post-condition.zsh $patient_id $encounter_id)
echo "Condition created with ID: $condition_id"

# Patch the Encounter with full details
encounter_id2=$(./patch-encounter.zsh $encounter_id $patient_id $practitioner_id $condition_id)
echo "Encounter patched with ID: $encounter_id2"

# Post a new MedicationRequest
medication_request_id=$(./post-medication-request.zsh $patient_id $encounter_id)
echo "MedicationRequest created with ID: $medication_request_id"

# Post a new ServiceRequest
service_request_id=$(./post-service-request.zsh $patient_id $encounter_id)
echo "ServiceRequest created with ID: $service_request_id"

# Post a new DocumentReference, SickLeave
sickleave_document_id=$(./post-sickleave-document.zsh $patient_id $encounter_id $practitioner_id)
echo "DocumentReference, SickLeave created with ID: $sickleave_document_id"

# Post a new Composition, Journal Entry
journal_entry_composition_id=$(./post-journal-entry-composition.zsh $patient_id $encounter_id $practitioner_id $sickleave_document_id)
echo "Composition, Journal Entry created with ID: $journal_entry_composition_id"

echo "Full Encounter created successfully"

# Get the Patient data
./get-patient.zsh $patient_id

# List resources created for the Patient
cat results/patient_data_all_formatted.json | grep resourceType