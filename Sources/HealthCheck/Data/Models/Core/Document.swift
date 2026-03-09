import GRDB

struct Document: Codable, FetchableRecord, MutablePersistableRecord, Sendable {
    static let databaseTableName = "document"
    static let databaseColumnDecodingStrategy = DatabaseColumnDecodingStrategy.convertFromSnakeCase
    static let databaseColumnEncodingStrategy = DatabaseColumnEncodingStrategy.convertToSnakeCase

    var id: Int64?
    var patientId: Int64
    var facilityId: Int64?
    var doctorId: Int64?
    var filePath: String
    var fileHash: String
    var fileName: String
    var documentDate: String?
    var documentType: String
    var tags: String?
    var language: String
    var pageCount: Int
    var processingStatus: String
    var processingError: String?
    var rawText: String?
    var createdAt: String
    var updatedAt: String

    mutating func didInsert(_ inserted: InsertionSuccess) {
        id = inserted.rowID
    }
}
