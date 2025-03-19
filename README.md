<!DOCTYPE html>
<html lang="en">
<body>

<h1>Lab Order Service Request</h1>

<p>This repository provides an implementation of a FHIR-compliant lab order <code>ServiceRequest</code> for Finnish healthcare systems.</p>

<h2>🔹 Features</h2>
<ul>
    <li>Uses the <strong>Finnish laboratory test classification</strong> (Kuntaliitto - Laboratoriotutkimusnimikkeistö).</li>
    <li>FHIR <code>ServiceRequest</code> resource for ordering lab tests.</li>
    <li>Supports bundling multiple tests in a single request.</li>
</ul>

<h2>📌 Usage</h2>
<p>To request a lab order, create a <code>ServiceRequest</code> resource in FHIR JSON format.</p>

<h2>📝 Example ServiceRequest</h2>

<pre><code>{
  "resourceType": "ServiceRequest",
  "id": "sr-all-lab-tests",
  "status": "active",
  "intent": "order",
  "code": {
    "coding": [
      {
        "system": "urn:oid:1.2.246.537.6.98",
        "code": "6428",
        "display": "S -Kolesteroli"
      },
      {
        "system": "urn:oid:1.2.246.537.6.98",
        "code": "6430",
        "display": "S -Kolesteroli, high density lipoproteiinit"
      },
      {
        "system": "urn:oid:1.2.246.537.6.98",
        "code": "6432",
        "display": "S -Kolesteroli, low density lipoproteiinit, analysoitu"
      }
    ]
  },
  "subject": {
    "reference": "Patient/321"
  },
  "requester": {
    "reference": "Practitioner/123"
  },
  "authoredOn": "2022-05-09T11:55:00Z"
}</code></pre>

<h2>📚 Resources</h2>
<ul>
    <li><a href="https://www.hl7.org/fhir/servicerequest.html" target="_blank">FHIR ServiceRequest Documentation</a></li>
    <li><a href="https://build.fhir.org/ig/hl7-eu/laboratory/StructureDefinition-ServiceRequest-eu-lab.html">European FHIR ServiceRequest Documentation</a></li>
    <li><a href="https://koodistopalvelu.kanta.fi/codeserver/pages/classification-list-page.xhtml?clearUserCachedLists=true" target="_blank">
        Finnish Laboratory Test Codes (Koodistopalvelu)
    </a></li>
</ul>

<h1>Finnish Sick Leave Note (Lääkärintodistus A - SV6)</h1>

<h2>Purpose</h2>
<p>The Lääkärintodistus A (SV6) is a medical document used for:</p>
<ul>
    <li>Applying sickness allowance from Kela.</li>
    <li>Informing employers about work incapacity.</li>
    <li>Assessing rehabilitation plans.</li>
</ul>

<h2>FHIR Data</h2>
<p>The following FHIR DocumentReference example structure is used:</p>
<pre><code>{
  "resourceType": "DocumentReference",
  "id": "sairausloma-2025-001",
  "status": "current",
  "type": {
    "coding": [
      {
        "system": "urn:oid:1.2.246.537.6.12.2002.141",
        "code": "SV6",
        "display": "Lääkärintodistus A (SV6)"
      }
    ]
  },
  "subject": {
    "reference": "Patient/00000002",
    "display": "Pasi Potilas"
  },
  "author": [
    {
      "reference": "Practitioner/456",
      "display": "Dr. Testaaja"
    }
  ],
  "date": "2025-03-19T00:00:00Z",
  "content": [
    {
      "attachment": {
        "contentType": "application/pdf",
        "url": "https://example.com/fhir/DocumentReference/sairausloma-2025-001.pdf",
        "title": "Lääkärintodistus A (SV6) - Sairausloma"
      }
    }
  ],
  "context": {
    "encounter": {
      "reference": "Encounter/789"
    },
    "related": [
      {
        "reference": "Condition/321",
        "display": "Ulkomuotoon ja käyttäytymiseen liittyvät oireet ja sairaudenmerkit (R46)"
      },
      {
        "reference": "Condition/322",
        "display": "Merkittävin työkykyä alentava sairaus, vamma tai elimen luovutus"
      }
    ],
    "period": {
      "start": "2025-03-19",
      "end": "2025-04-18"
    }
  },
  "category": [
    {
      "coding": [
        {
          "system": "http://hl7.org/fhir/ValueSet/doc-typecodes",
          "code": "clinical-note",
          "display": "Clinical Note"
        }
      ]
    }
  ],
  "custodian": {
    "reference": "Organization/567",
    "display": "Yritys Oy"
  },
  "securityLabel": [
    {
      "coding": [
        {
          "system": "http://terminology.hl7.org/CodeSystem/v3-Confidentiality",
          "code": "R",
          "display": "Restricted"
        }
      ]
    }
  ]
}</code></pre>

<p>More info: <a href="https://www.kela.fi">Kela’s official website</a>.</p>

<h2>MedicationRequest</h2>
<p>An example of a FHIR-compliant <code>MedicationRequest</code> can be found at: <a href="https://github.com/fhir-fi/finnish-base-profiles" target="_blank">Finnish Base Profiles Repository</a>.</p>

<h2>📝 License</h2>
<p>MIT License - Free to use and modify.</p>

</body>
</html>
