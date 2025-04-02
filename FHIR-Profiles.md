<!DOCTYPE html>
<html>

<body>

<h1>Creating FHIR Profiles</h1>

<p>FHIR (Fast Healthcare Interoperability Resources) profiles are customized definitions of FHIR resources to meet specific use cases or requirements. This guide demonstrates how to create a basic FHIR profile using the <code>StructureDefinition</code> resource.</p>

<h2>Example: Finnish Base Patient Profile</h2>

<p>This profile defines constraints and extensions for the Patient resource tailored for Finnish healthcare systems.</p>

<h3>📌 Key Elements</h3>
<ul>
    <li><strong>Resource Type:</strong> StructureDefinition</li>
    <li><strong>Base Definition:</strong> <code>http://hl7.org/fhir/StructureDefinition/Patient</code></li>
    <li><strong>FHIR Version:</strong> 4.0.1</li>
    <li><strong>Status:</strong> Active</li>
</ul>

<h3>📝 Example Profile JSON</h3>
<pre><code>{
    "resourceType": "StructureDefinition",
    "id": "fi-base-patient",
    "meta": {
        "versionId": "13",
        "lastUpdated": "2025-02-27T09:42:36.496+00:00"
    },
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
}</code></pre>

<h3>🛠️ Tools</h3>
<ul>
    <li><a href="https://fire.ly/products/forge"> Firely Forge for creating FHIR Profiles</a></li>
    <li><a href="https://validator.fhir.org"> FHIR Validator for troubleshooting</a></li>
</ul>

![Preview](/Firely-Forge.png)  

<h3>🔍 Validating Data with $validate</h3>

<p>This function checks resource instances against the defined profiles to ensure they meet the required constraints.</p>
<li><a href="https://github.com/Marssix/fhir-examples/blob/main/curl-samples/post-ok-fi-base-patient.zsh">Example of $validate in cURL</a></li>

<h3>📚 References</h3>
<ul>
    <li><a href="https://www.hl7.org/fhir/structuredefinition.html">FHIR StructureDefinition Documentation</a></li>
    <li><a href="https://hl7.fi/fhir/finnish-base-profiles">Finnish Base Profiles</a></li>
</ul>

<h2>🔗 Links</h2>
<li><a href="https://github.com/Marssix/fhir-examples/tree/main/curl-samples">Link to cURL Examples</a></li>
<li><a href="https://github.com/Marssix/fhir-examples/blob/main/README.md">Link to README Page</a></li>

</body>
</html>
