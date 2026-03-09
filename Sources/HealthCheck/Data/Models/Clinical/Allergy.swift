import GRDB

struct Allergy: Codable, FetchableRecord, MutablePersistableRecord, Sendable {
    static let databaseTableName = "allergy"
    static let databaseColumnDecodingStrategy = DatabaseColumnDecodingStrategy.convertFromSnakeCase
    static let databaseColumnEncodingStrategy = DatabaseColumnEncodingStrategy.convertToSnakeCase

    var id: Int64?
    var patientId: Int64
    var allergen: String
    var allergenType: String
    var reaction: String?
    var severity: String
    var onsetDate: String?
    var status: String
    var createdAt: String

    mutating func didInsert(_ inserted: InsertionSuccess) {
        id = inserted.rowID
    }
}
