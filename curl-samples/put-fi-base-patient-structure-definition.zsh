#!/bin/zsh
# Usage: ./put-fi-base-patient-structure-definition.zsh

source ./get-access-token.zsh

# Replace the patient structure definition

definition_response=$(curl -s --location --request PUT 'https://hdsfhircontexttest-contextchangefhirservice.fhir.azurehealthcareapis.com/StructureDefinition/fi-base-patient' \
    --header 'Content-Type: application/json' \
    --header "Authorization: Bearer $access_token" \
    --data '{
    "resourceType": "StructureDefinition",
    "id": "fi-base-patient",
    "extension": [
        {
            "url": "http://hl7.org/fhir/StructureDefinition/structuredefinition-category",
            "valueString": "Base.Individuals"
        },
        {
            "url": "http://hl7.org/fhir/StructureDefinition/structuredefinition-security-category",
            "valueCode": "patient"
        }
    ],
    "url": "https://hdsfhircontexttest-contextchangefhirservice.fhir.azurehealthcareapis.com/StructureDefinition/fi-base-patient",
    "name": "FiBasePatient",
    "title": "FI Base Patient",
    "status": "active",
    "description": "This is the Finnish base profile for the Patient resource.",
    "fhirVersion": "4.0.1",
    "mapping": [
        {
            "identity": "rim",
            "uri": "http://hl7.org/v3",
            "name": "RIM Mapping"
        },
        {
            "identity": "cda",
            "uri": "http://hl7.org/v3/cda",
            "name": "CDA (R2)"
        },
        {
            "identity": "w5",
            "uri": "http://hl7.org/fhir/fivews",
            "name": "FiveWs Pattern Mapping"
        },
        {
            "identity": "v2",
            "uri": "http://hl7.org/v2",
            "name": "HL7 v2 Mapping"
        },
        {
            "identity": "loinc",
            "uri": "http://loinc.org",
            "name": "LOINC code for the element"
        }
    ],
    "kind": "resource",
    "abstract": false,
    "type": "Patient",
    "baseDefinition": "http://hl7.org/fhir/StructureDefinition/Patient",
    "derivation": "constraint",
    "differential": {
        "element": [
            {
                "id": "Patient.meta.security",
                "path": "Patient.meta.security",
                "slicing": {
                    "discriminator": [
                        {
                            "type": "value",
                            "path": "system"
                        }
                    ],
                    "ordered": false,
                    "rules": "open"
                },
                "short": "Information about TURVAKIELTO SHALL be handled in meta.security."
            },
            {
                "id": "Patient.meta.security:turvakielto",
                "path": "Patient.meta.security",
                "sliceName": "turvakielto",
                "min": 0,
                "max": "1"
            },
            {
                "id": "Patient.meta.security:turvakielto.system",
                "path": "Patient.meta.security.system",
                "min": 1,
                "patternUri": "https://hl7.fi/fhir/finnish-base-profiles/CodeSystem/fi-base-security-label-cs"
            },
            {
                "id": "Patient.extension",
                "path": "Patient.extension",
                "slicing": {
                    "discriminator": [
                        {
                            "type": "value",
                            "path": "url"
                        }
                    ],
                    "ordered": false,
                    "rules": "open"
                }
            },
            {
                "id": "Patient.extension:ShoeSize",
                "path": "Patient.extension",
                "sliceName": "ShoeSize",
                "min": 0,
                "max": "1",
                "type": [
                    {
                        "code": "Extension",
                        "profile": [
                            "https://hdsfhircontexttest-contextchangefhirservice.fhir.azurehealthcareapis.com/StructureDefinition/Shoe-Size"
                        ]
                    }
                ]
            },
            {
                "id": "Patient.identifier",
                "path": "Patient.identifier",
                "slicing": {
                    "discriminator": [
                        {
                            "type": "value",
                            "path": "use"
                        }
                    ],
                    "ordered": false,
                    "rules": "open"
                },
                "short": "PIC (aka HETU).",
                "definition": "When using the official Finnish personal identifier code (PIC, also known as *HETU*), identifier.system SHALL be `urn:oid:1.2.246.21`.",
                "min": 1
            },
            {
                "id": "Patient.identifier:PIC",
                "path": "Patient.identifier",
                "sliceName": "PIC",
                "min": 1,
                "max": "1"
            },
            {
                "id": "Patient.identifier:PIC.use",
                "path": "Patient.identifier.use",
                "min": 1,
                "patternCode": "official"
            },
            {
                "id": "Patient.identifier:PIC.type.coding.system",
                "path": "Patient.identifier.type.coding.system",
                "patternUri": "http://terminology.hl7.org/CodeSystem/v2-0203"
            },
            {
                "id": "Patient.identifier:PIC.type.coding.code",
                "path": "Patient.identifier.type.coding.code",
                "patternCode": "NNFIN"
            },
            {
                "id": "Patient.identifier:PIC.system",
                "path": "Patient.identifier.system",
                "patternUri": "urn:oid:1.2.246.21"
            },
            {
                "id": "Patient.identifier:PIC.value",
                "path": "Patient.identifier.value",
                "short": "PIC value should not be empty or missing",
                "definition": "The PIC value is mandatory and must be provided",
                "min": 1,
                "type": [
                    {
                        "code": "string"
                    }
                ]
            },
            {
                "id": "Patient.link.other",
                "path": "Patient.link.other",
                "type": [
                    {
                        "extension": [
                            {
                                "url": "http://hl7.org/fhir/StructureDefinition/structuredefinition-hierarchy",
                                "valueBoolean": false
                            }
                        ],
                        "code": "Reference",
                        "targetProfile": [
                            "https://hdsfhircontexttest-contextchangefhirservice.fhir.azurehealthcareapis.com/StructureDefinition/fi-base-patient",
                            "http://hl7.org/fhir/StructureDefinition/RelatedPerson"
                        ]
                    }
                ]
            }
        ]
    }
}')

# Display the definition
echo "Structure Definition:"
echo "$definition_response"