import Testing
import Foundation
import MCP
import GRDB
@testable import HealthCheck

// MARK: - Document Tools Tests

@Test("store_extraction_results batch inserts entities")
func storeExtractionResults() async throws {
    let manager = try makeDB()
    let patientId = try insertPatient(db: manager)
    let tools = CRUDDocumentTools(db: manager)

    let docId = try await manager.dbQueue.write { db in
        try makeDocument(patientId: patientId).inserted(db).id!
    }

    let result = try await tools.handle(CallTool.Parameters(name: "store_extraction_results", arguments: [
        "document_id": .int(Int(docId)),
        "entities": .array([
            .object([
                "entity_type": .string("diagnosis"),
                "raw_text": .string("Type 2 diabetes mellitus"),
                "confidence": .double(0.95),
            ]),
            .object([
                "entity_type": .string("medication"),
                "raw_text": .string("Metformin 500mg"),
                "confidence": .double(0.9),
            ]),
            .object([
                "entity_type": .string("lab_result"),
                "raw_text": .string("Glucose 126 mg/dL"),
                "confidence": .double(0.85),
            ]),
        ])
    ]))

    let json = try #require(extractJSON(from: result))
    #expect(json["stored"] as? Int == 3)

    let entities = try await manager.dbQueue.read { db in
        try ExtractedEntity
            .filter(Column("document_id") == docId)
            .fetchAll(db)
    }
    #expect(entities.count == 3)
}

@Test("save_document_summary stores summary")
func saveDocumentSummary() async throws {
    let manager = try makeDB()
    let patientId = try insertPatient(db: manager)
    let tools = CRUDDocumentTools(db: manager)

    let docId = try await manager.dbQueue.write { db in
        try makeDocument(patientId: patientId).inserted(db).id!
    }

    let result = try await tools.handle(CallTool.Parameters(name: "save_document_summary", arguments: [
        "document_id": .int(Int(docId)),
        "summary_type": .string("brief"),
        "content": .string("Lab report showing elevated glucose levels."),
    ]))
    let id = try #require(extractId(from: result))

    let summary = try await manager.dbQueue.read { db in
        try DocumentSummary.fetchOne(db, key: id)
    }

    let s = try #require(summary)
    #expect(s.summaryType == "brief")
    #expect(s.content == "Lab report showing elevated glucose levels.")
}

// MARK: - Error Handling

@Test("Missing required params returns isError true")
func missingRequiredParams() async throws {
    let manager = try makeDB()
    let tools = CRUDCoreTools(db: manager)

    let result = try await tools.handle(CallTool.Parameters(name: "upsert_patient", arguments: [:]))

    let r = try #require(result)
    #expect(r.isError == true)
}
