import Testing
import Foundation
import MCP
import GRDB
@testable import HealthCheck

// MARK: - Clinical Tools Tests

@Test("create_encounter with valid data")
func createEncounter() async throws {
    let manager = try makeDB()
    let patientId = try insertPatient(db: manager)
    let tools = CRUDClinicalTools(db: manager)

    let result = try await tools.handle(CallTool.Parameters(name: "create_encounter", arguments: [
        "patient_id": .int(Int(patientId)),
        "encounter_date": .string("2026-01-15"),
        "encounter_type": .string("office_visit"),
        "chief_complaint": .string("Annual checkup"),
    ]))
    let id = try #require(extractId(from: result))

    let encounter = try await manager.dbQueue.read { db in
        try Encounter.fetchOne(db, key: id)
    }

    let e = try #require(encounter)
    #expect(e.patientId == patientId)
    #expect(e.encounterType == "office_visit")
    #expect(e.chiefComplaint == "Annual checkup")
}

@Test("create_diagnosis with valid data")
func createDiagnosis() async throws {
    let manager = try makeDB()
    let patientId = try insertPatient(db: manager)
    let tools = CRUDClinicalTools(db: manager)

    let result = try await tools.handle(CallTool.Parameters(name: "create_diagnosis", arguments: [
        "patient_id": .int(Int(patientId)),
        "icd_code": .string("E11.9"),
        "description": .string("Type 2 diabetes"),
        "diagnosis_date": .string("2026-01-15"),
        "status": .string("active"),
    ]))
    let id = try #require(extractId(from: result))

    let diagnosis = try await manager.dbQueue.read { db in
        try Diagnosis.fetchOne(db, key: id)
    }

    let d = try #require(diagnosis)
    #expect(d.icdCode == "E11.9")
    #expect(d.status == "active")
}

@Test("create_medication with valid data defaults is_active to true")
func createMedication() async throws {
    let manager = try makeDB()
    let patientId = try insertPatient(db: manager)
    let tools = CRUDClinicalTools(db: manager)

    let result = try await tools.handle(CallTool.Parameters(name: "create_medication", arguments: [
        "patient_id": .int(Int(patientId)),
        "name": .string("Metformin"),
        "dosage": .string("500mg"),
        "frequency": .string("twice daily"),
        "route": .string("oral"),
        "start_date": .string("2026-01-15"),
    ]))
    let id = try #require(extractId(from: result))

    let med = try await manager.dbQueue.read { db in
        try Medication.fetchOne(db, key: id)
    }

    let m = try #require(med)
    #expect(m.name == "Metformin")
    #expect(m.dosage == "500mg")
    #expect(m.isActive == true)
}

@Test("create_lab_result with numeric values and flag")
func createLabResult() async throws {
    let manager = try makeDB()
    let patientId = try insertPatient(db: manager)
    let tools = CRUDClinicalTools(db: manager)

    let result = try await tools.handle(CallTool.Parameters(name: "create_lab_result", arguments: [
        "patient_id": .int(Int(patientId)),
        "test_name": .string("Glucose"),
        "value": .string("126 mg/dL"),
        "numeric_value": .double(126.5),
        "unit": .string("mg/dL"),
        "flag": .string("high"),
        "test_date": .string("2026-01-15"),
    ]))
    let id = try #require(extractId(from: result))

    let lab = try await manager.dbQueue.read { db in
        try LabResult.fetchOne(db, key: id)
    }

    let l = try #require(lab)
    #expect(l.testName == "Glucose")
    #expect(l.numericValue == 126.5)
    #expect(l.flag == "high")
}

@Test("create_vital_sign with vital_type and value")
func createVitalSign() async throws {
    let manager = try makeDB()
    let patientId = try insertPatient(db: manager)
    let tools = CRUDClinicalTools(db: manager)

    let result = try await tools.handle(CallTool.Parameters(name: "create_vital_sign", arguments: [
        "patient_id": .int(Int(patientId)),
        "vital_type": .string("blood_pressure"),
        "value": .string("120/80"),
        "numeric_value": .double(120.0),
        "numeric_value_2": .double(80.0),
        "unit": .string("mmHg"),
        "measured_date": .string("2026-01-15"),
    ]))
    let id = try #require(extractId(from: result))

    let vital = try await manager.dbQueue.read { db in
        try VitalSign.fetchOne(db, key: id)
    }

    let v = try #require(vital)
    #expect(v.vitalType == "blood_pressure")
    #expect(v.value == "120/80")
    #expect(v.numericValue == 120.0)
    #expect(v.numericValue2 == 80.0)
}

@Test("create_procedure with procedure_name and date")
func createProcedure() async throws {
    let manager = try makeDB()
    let patientId = try insertPatient(db: manager)
    let tools = CRUDClinicalTools(db: manager)

    let result = try await tools.handle(CallTool.Parameters(name: "create_procedure", arguments: [
        "patient_id": .int(Int(patientId)),
        "procedure_name": .string("Appendectomy"),
        "procedure_date": .string("2026-01-15"),
        "outcome": .string("successful"),
    ]))
    let id = try #require(extractId(from: result))

    let proc = try await manager.dbQueue.read { db in
        try ProcedureRecord.fetchOne(db, key: id)
    }

    let p = try #require(proc)
    #expect(p.procedureName == "Appendectomy")
    #expect(p.outcome == "successful")
}

@Test("create_immunization with vaccine_name and dose_number")
func createImmunization() async throws {
    let manager = try makeDB()
    let patientId = try insertPatient(db: manager)
    let tools = CRUDClinicalTools(db: manager)

    let result = try await tools.handle(CallTool.Parameters(name: "create_immunization", arguments: [
        "patient_id": .int(Int(patientId)),
        "vaccine_name": .string("COVID-19 mRNA"),
        "dose_number": .int(2),
        "administration_date": .string("2026-01-15"),
        "site": .string("left deltoid"),
    ]))
    let id = try #require(extractId(from: result))

    let imm = try await manager.dbQueue.read { db in
        try Immunization.fetchOne(db, key: id)
    }

    let i = try #require(imm)
    #expect(i.vaccineName == "COVID-19 mRNA")
    #expect(i.doseNumber == 2)
    #expect(i.site == "left deltoid")
}

@Test("create_allergy with allergen, severity, and status")
func createAllergy() async throws {
    let manager = try makeDB()
    let patientId = try insertPatient(db: manager)
    let tools = CRUDClinicalTools(db: manager)

    let result = try await tools.handle(CallTool.Parameters(name: "create_allergy", arguments: [
        "patient_id": .int(Int(patientId)),
        "allergen": .string("Penicillin"),
        "allergen_type": .string("drug"),
        "reaction": .string("rash"),
        "severity": .string("moderate"),
        "status": .string("active"),
    ]))
    let id = try #require(extractId(from: result))

    let allergy = try await manager.dbQueue.read { db in
        try Allergy.fetchOne(db, key: id)
    }

    let a = try #require(allergy)
    #expect(a.allergen == "Penicillin")
    #expect(a.severity == "moderate")
    #expect(a.status == "active")
}

@Test("create_imaging with imaging_type and body_part")
func createImaging() async throws {
    let manager = try makeDB()
    let patientId = try insertPatient(db: manager)
    let tools = CRUDClinicalTools(db: manager)

    let result = try await tools.handle(CallTool.Parameters(name: "create_imaging", arguments: [
        "patient_id": .int(Int(patientId)),
        "imaging_type": .string("x_ray"),
        "body_part": .string("chest"),
        "imaging_date": .string("2026-01-15"),
        "findings": .string("No abnormalities"),
    ]))
    let id = try #require(extractId(from: result))

    let imaging = try await manager.dbQueue.read { db in
        try Imaging.fetchOne(db, key: id)
    }

    let img = try #require(imaging)
    #expect(img.imagingType == "x_ray")
    #expect(img.bodyPart == "chest")
    #expect(img.findings == "No abnormalities")
}
