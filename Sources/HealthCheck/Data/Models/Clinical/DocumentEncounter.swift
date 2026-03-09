import GRDB

struct DocumentEncounter: Codable, FetchableRecord, PersistableRecord, Sendable {
    static let databaseTableName = "document_encounter"
    static let databaseColumnDecodingStrategy = DatabaseColumnDecodingStrategy.convertFromSnakeCase
    static let databaseColumnEncodingStrategy = DatabaseColumnEncodingStrategy.convertToSnakeCase

    var documentId: Int64
    var encounterId: Int64
}
