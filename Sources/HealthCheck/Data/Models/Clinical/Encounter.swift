import GRDB

struct Encounter: Codable, FetchableRecord, MutablePersistableRecord, Sendable {
    static let databaseTableName = "encounter"
    static let databaseColumnDecodingStrategy = DatabaseColumnDecodingStrategy.convertFromSnakeCase
    static let databaseColumnEncodingStrategy = DatabaseColumnEncodingStrategy.convertToSnakeCase

    var id: Int64?
    var patientId: Int64
    var facilityId: Int64?
    var doctorId: Int64?
    var encounterDate: String
    var encounterType: String
    var chiefComplaint: String?
    var notes: String?
    var createdAt: String

    mutating func didInsert(_ inserted: InsertionSuccess) {
        id = inserted.rowID
    }
}
