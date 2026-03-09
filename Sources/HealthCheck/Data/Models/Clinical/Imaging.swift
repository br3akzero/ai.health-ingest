import GRDB

struct Imaging: Codable, FetchableRecord, MutablePersistableRecord, Sendable {
    static let databaseTableName = "imaging"
    static let databaseColumnDecodingStrategy = DatabaseColumnDecodingStrategy.convertFromSnakeCase
    static let databaseColumnEncodingStrategy = DatabaseColumnEncodingStrategy.convertToSnakeCase

    var id: Int64?
    var patientId: Int64
    var encounterId: Int64?
    var doctorId: Int64?
    var imagingType: String
    var bodyPart: String
    var imagingDate: String
    var findings: String?
    var impression: String?
    var notes: String?
    var createdAt: String

    mutating func didInsert(_ inserted: InsertionSuccess) {
        id = inserted.rowID
    }
}
