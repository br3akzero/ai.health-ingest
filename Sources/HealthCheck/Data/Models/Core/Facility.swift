import GRDB

struct Facility: Codable, FetchableRecord, MutablePersistableRecord, Sendable {
    static let databaseTableName = "facility"
    static let databaseColumnDecodingStrategy = DatabaseColumnDecodingStrategy.convertFromSnakeCase
    static let databaseColumnEncodingStrategy = DatabaseColumnEncodingStrategy.convertToSnakeCase

    var id: Int64?
    var name: String
    var facilityType: String
    var phone: String?
    var address: String?
    var website: String?
    var createdAt: String

    mutating func didInsert(_ inserted: InsertionSuccess) {
        id = inserted.rowID
    }
}
