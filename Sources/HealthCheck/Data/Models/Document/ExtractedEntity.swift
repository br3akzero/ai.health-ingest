import GRDB

struct ExtractedEntity: Codable, FetchableRecord, MutablePersistableRecord, Sendable {
    static let databaseTableName = "extracted_entity"
    static let databaseColumnDecodingStrategy = DatabaseColumnDecodingStrategy.convertFromSnakeCase
    static let databaseColumnEncodingStrategy = DatabaseColumnEncodingStrategy.convertToSnakeCase

    var id: Int64?
    var documentId: Int64
    var chunkId: Int64?
    var entityType: String
    var entityTable: String?
    var entityId: Int64?
    var rawText: String
    var confidence: Double
    var createdAt: String

    mutating func didInsert(_ inserted: InsertionSuccess) {
        id = inserted.rowID
    }
}
