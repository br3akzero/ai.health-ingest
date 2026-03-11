import Testing
import Foundation
import MCP
import GRDB
@testable import HealthCheck

// MARK: - Core Tools Tests

@Test("upsert_patient creates a new patient")
func upsertPatientCreate() async throws {
    let manager = try makeDB()
    let tools = CRUDCoreTools(db: manager)

    let params = CallTool.Parameters(name: "upsert_patient", arguments: [
        "first_name": .string("Jane"),
        "last_name": .string("Doe"),
        "date_of_birth": .string("1985-03-20"),
        "gender": .string("female"),
        "blood_type": .string("A+"),
    ])

    let result = try await tools.handle(params)
    let id = try #require(extractId(from: result))

    let patient = try await manager.dbQueue.read { db in
        try Patient.fetchOne(db, key: id)
    }

    let p = try #require(patient)
    #expect(p.firstName == "Jane")
    #expect(p.lastName == "Doe")
    #expect(p.bloodType == "A+")
}

@Test("upsert_patient updates an existing patient")
func upsertPatientUpdate() async throws {
    let manager = try makeDB()
    let tools = CRUDCoreTools(db: manager)

    let createResult = try await tools.handle(CallTool.Parameters(name: "upsert_patient", arguments: [
        "first_name": .string("Jane"),
        "last_name": .string("Doe"),
    ]))
    let id = try #require(extractId(from: createResult))

    let updateResult = try await tools.handle(CallTool.Parameters(name: "upsert_patient", arguments: [
        "id": .int(Int(id)),
        "first_name": .string("Janet"),
        "last_name": .string("Smith"),
        "blood_type": .string("B-"),
    ]))
    let updatedId = try #require(extractId(from: updateResult))
    #expect(updatedId == id)

    let patient = try await manager.dbQueue.read { db in
        try Patient.fetchOne(db, key: id)
    }

    let p = try #require(patient)
    #expect(p.firstName == "Janet")
    #expect(p.lastName == "Smith")
    #expect(p.bloodType == "B-")

    let count = try await manager.dbQueue.read { db in
        try Patient.fetchCount(db)
    }
    #expect(count == 1)
}

@Test("upsert_facility creates a new facility")
func upsertFacilityCreate() async throws {
    let manager = try makeDB()
    let tools = CRUDCoreTools(db: manager)

    let result = try await tools.handle(CallTool.Parameters(name: "upsert_facility", arguments: [
        "name": .string("City Hospital"),
        "facility_type": .string("hospital"),
        "phone": .string("555-0100"),
    ]))
    let id = try #require(extractId(from: result))

    let facility = try await manager.dbQueue.read { db in
        try Facility.fetchOne(db, key: id)
    }

    let f = try #require(facility)
    #expect(f.name == "City Hospital")
    #expect(f.facilityType == "hospital")
    #expect(f.phone == "555-0100")
}

@Test("upsert_doctor creates a new doctor")
func upsertDoctorCreate() async throws {
    let manager = try makeDB()
    let tools = CRUDCoreTools(db: manager)

    let result = try await tools.handle(CallTool.Parameters(name: "upsert_doctor", arguments: [
        "first_name": .string("Robert"),
        "last_name": .string("Chen"),
        "specialty": .string("Cardiology"),
    ]))
    let id = try #require(extractId(from: result))

    let doctor = try await manager.dbQueue.read { db in
        try Doctor.fetchOne(db, key: id)
    }

    let d = try #require(doctor)
    #expect(d.firstName == "Robert")
    #expect(d.lastName == "Chen")
    #expect(d.specialty == "Cardiology")
}

@Test("link_doctor_to_facility creates idempotent relationship")
func linkDoctorToFacility() async throws {
    let manager = try makeDB()
    let tools = CRUDCoreTools(db: manager)

    let facilityResult = try await tools.handle(CallTool.Parameters(name: "upsert_facility", arguments: [
        "name": .string("Lab"), "facility_type": .string("lab"),
    ]))
    let facilityId = try #require(extractId(from: facilityResult))

    let doctorResult = try await tools.handle(CallTool.Parameters(name: "upsert_doctor", arguments: [
        "first_name": .string("Ann"), "last_name": .string("Lee"),
    ]))
    let doctorId = try #require(extractId(from: doctorResult))

    let linkParams = CallTool.Parameters(name: "link_doctor_to_facility", arguments: [
        "facility_id": .int(Int(facilityId)),
        "doctor_id": .int(Int(doctorId)),
    ])

    _ = try await tools.handle(linkParams)
    _ = try await tools.handle(linkParams)

    let count = try await manager.dbQueue.read { db in
        try FacilityDoctor.fetchCount(db)
    }
    #expect(count == 1)
}
