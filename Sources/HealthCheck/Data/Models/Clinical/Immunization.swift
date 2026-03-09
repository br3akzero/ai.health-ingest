import GRDB

struct Immunization: Codable, FetchableRecord, MutablePersistableRecord, Sendable {
    static let databaseTableName = "immunization"
    static let databaseColumnDecodingStrategy = DatabaseColumnDecodingStrategy.convertFromSnakeCase
    static let databaseColumnEncodingStrategy = DatabaseColumnEncodingStrategy.convertToSnakeCase

    var id: Int64?
    var patientId: Int64
    var vaccineName: String
    var vaccineCode: String?
    var doseNumber: Int?
    var administrationDate: String
    var administeredBy: String?
    var lotNumber: String?
    var site: String?
    var notes: String?
    var createdAt: String

    mutating func didInsert(_ inserted: InsertionSuccess) {
        id = inserted.rowID
    }
}
