import GRDB

struct Medication: Codable, FetchableRecord, MutablePersistableRecord, Sendable {
    static let databaseTableName = "medication"
    static let databaseColumnDecodingStrategy = DatabaseColumnDecodingStrategy.convertFromSnakeCase
    static let databaseColumnEncodingStrategy = DatabaseColumnEncodingStrategy.convertToSnakeCase

    var id: Int64?
    var patientId: Int64
    var diagnosisId: Int64?
    var doctorId: Int64?
    var name: String
    var atcCode: String?
    var ndcCode: String?
    var dosage: String
    var frequency: String
    var route: String
    var startDate: String
    var endDate: String?
    var isActive: Bool
    var notes: String?
    var createdAt: String

    mutating func didInsert(_ inserted: InsertionSuccess) {
        id = inserted.rowID
    }
}
