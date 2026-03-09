import GRDB

struct FacilityDoctor: Codable, FetchableRecord, PersistableRecord, Sendable {
    static let databaseTableName = "facility_doctor"
    static let databaseColumnDecodingStrategy = DatabaseColumnDecodingStrategy.convertFromSnakeCase
    static let databaseColumnEncodingStrategy = DatabaseColumnEncodingStrategy.convertToSnakeCase

    var facilityId: Int64
    var doctorId: Int64
}
