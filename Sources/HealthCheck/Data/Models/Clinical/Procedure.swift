import GRDB

struct ProcedureRecord: Codable, FetchableRecord, MutablePersistableRecord, Sendable {
    static let databaseTableName = "procedure_record"
    static let databaseColumnDecodingStrategy = DatabaseColumnDecodingStrategy.convertFromSnakeCase
    static let databaseColumnEncodingStrategy = DatabaseColumnEncodingStrategy.convertToSnakeCase

    var id: Int64?
    var patientId: Int64
    var encounterId: Int64?
    var doctorId: Int64?
    var procedureName: String
    var procedureCode: String?
    var procedureDate: String
    var bodySite: String?
    var outcome: String?
    var notes: String?
    var createdAt: String

    mutating func didInsert(_ inserted: InsertionSuccess) {
        id = inserted.rowID
    }
}
