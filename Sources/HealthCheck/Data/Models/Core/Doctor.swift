import GRDB

struct Doctor: Codable, FetchableRecord, MutablePersistableRecord, Sendable {
    static let databaseTableName = "doctor"
    static let databaseColumnDecodingStrategy = DatabaseColumnDecodingStrategy.convertFromSnakeCase
    static let databaseColumnEncodingStrategy = DatabaseColumnEncodingStrategy.convertToSnakeCase

    var id: Int64?
    var firstName: String
    var lastName: String
    var specialty: String?
    var createdAt: String

    mutating func didInsert(_ inserted: InsertionSuccess) {
        id = inserted.rowID
    }
}
