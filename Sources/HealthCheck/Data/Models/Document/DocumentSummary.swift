import GRDB

struct DocumentSummary: Codable, FetchableRecord, MutablePersistableRecord, Sendable {
    static let databaseTableName = "document_summary"
    static let databaseColumnDecodingStrategy = DatabaseColumnDecodingStrategy.convertFromSnakeCase
    static let databaseColumnEncodingStrategy = DatabaseColumnEncodingStrategy.convertToSnakeCase

    var id: Int64?
    var documentId: Int64
    var summaryType: String
    var content: String
    var createdAt: String

    mutating func didInsert(_ inserted: InsertionSuccess) {
        id = inserted.rowID
    }
}
