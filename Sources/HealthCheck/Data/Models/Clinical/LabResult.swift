import GRDB

struct LabResult: Codable, FetchableRecord, MutablePersistableRecord, Sendable {
    static let databaseTableName = "lab_result"
    static let databaseColumnDecodingStrategy = DatabaseColumnDecodingStrategy.convertFromSnakeCase
    static let databaseColumnEncodingStrategy = DatabaseColumnEncodingStrategy.convertToSnakeCase

    var id: Int64?
    var patientId: Int64
    var encounterId: Int64?
    var testName: String
    var testCategory: String?
    var value: String
    var numericValue: Double?
    var unit: String?
    var referenceRangeLow: Double?
    var referenceRangeHigh: Double?
    var referenceRangeText: String?
    var flag: String?
    var testDate: String
    var notes: String?
    var createdAt: String

    mutating func didInsert(_ inserted: InsertionSuccess) {
        id = inserted.rowID
    }
}
