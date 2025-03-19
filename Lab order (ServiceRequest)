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

<h2>📜 Example ServiceRequest</h2>

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
      },
      {
        "system": "urn:oid:1.2.246.537.6.98",
        "code": "6427",
        "display": "S -Triglyseridit"
      },
      {
        "system": "urn:oid:1.2.246.537.6.98",
        "code": "1026",
        "display": "S -Alaniiniaminotransferaasi"
      },
      {
        "system": "urn:oid:1.2.246.537.6.98",
        "code": "6354",
        "display": "Pt-Glomerulussuodosnopeus, estimoitu, CKD-EPI-tutkimuksen kaava"
      },
      {
        "system": "urn:oid:1.2.246.537.6.98",
        "code": "1489",
        "display": "S -Glutamyylitransferaasi"
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

<h2>📖 Resources</h2>
<ul>
    <li><a href="https://www.hl7.org/fhir/servicerequest.html" target="_blank">FHIR ServiceRequest Documentation</a></li>
    <li><a href="https://build.fhir.org/ig/hl7-eu/laboratory/StructureDefinition-ServiceRequest-eu-lab.html">European FHIR ServiceRequest Documentation</a></li>
    <li><a href="https://koodistopalvelu.kanta.fi/codeserver/pages/classification-list-page.xhtml?clearUserCachedLists=true" target="_blank">
        Finnish Laboratory Test Codes (Koodistopalvelu)
    </a></li>
</ul>

<h2>📜 License</h2>
<p>MIT License - Free to use and modify.</p>

</body>
</html>
