public struct PageExtraction: Sendable {
    public let pageNumber: Int
    public let pdfKitText: String
    public let ocrText: String
    public let ocrConfidence: Float
    public let tables: [DocumentTable]
    public let lists: [DocumentList]
    public let paragraphs: [String]
    public let detectedData: [DetectedDataItem]
}

public struct DocumentTable: Sendable {
    public let rows: [[String]]
}

public struct DocumentList: Sendable {
    public let items: [String]
}

public struct DetectedDataItem: Sendable {
    public let kind: String
    public let value: String
}
