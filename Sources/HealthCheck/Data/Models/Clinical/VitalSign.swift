import GRDB

struct VitalSign: Codable, FetchableRecord, MutablePersistableRecord, Sendable {
    static let databaseTableName = "vital_sign"
    static let databaseColumnDecodingStrategy = DatabaseColumnDecodingStrategy.convertFromSnakeCase
    static let databaseColumnEncodingStrategy = DatabaseColumnEncodingStrategy.convertToSnakeCase

    var id: Int64?
    var patientId: Int64
    var encounterId: Int64?
    var vitalType: String
    var value: String
    var numericValue: Double?
    var numericValue2: Double?
    var unit: String?
    var measuredDate: String
    var createdAt: String

    mutating func didInsert(_ inserted: InsertionSuccess) {
        id = inserted.rowID
    }
}
