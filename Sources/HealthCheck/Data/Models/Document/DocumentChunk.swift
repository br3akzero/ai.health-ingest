import GRDB

struct DocumentChunk: Codable, FetchableRecord, MutablePersistableRecord, Sendable {
    static let databaseTableName = "document_chunk"
    static let databaseColumnDecodingStrategy = DatabaseColumnDecodingStrategy.convertFromSnakeCase
    static let databaseColumnEncodingStrategy = DatabaseColumnEncodingStrategy.convertToSnakeCase

    var id: Int64?
    var documentId: Int64
    var chunkIndex: Int
    var content: String
    var pageNumber: Int?
    var sectionHeading: String?
    var tokenCount: Int
    var createdAt: String

    mutating func didInsert(_ inserted: InsertionSuccess) {
        id = inserted.rowID
    }
}
