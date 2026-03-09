import GRDB

struct Diagnosis: Codable, FetchableRecord, MutablePersistableRecord, Sendable {
    static let databaseTableName = "diagnosis"
    static let databaseColumnDecodingStrategy = DatabaseColumnDecodingStrategy.convertFromSnakeCase
    static let databaseColumnEncodingStrategy = DatabaseColumnEncodingStrategy.convertToSnakeCase

    var id: Int64?
    var patientId: Int64
    var encounterId: Int64?
    var icdCode: String?
    var description: String
    var diagnosisDate: String
    var status: String
    var notes: String?
    var createdAt: String

    mutating func didInsert(_ inserted: InsertionSuccess) {
        id = inserted.rowID
    }
}
