public struct ReconciledPage: Sendable {
    public let pageNumber: Int
    public let text: String
    public let textSource: TextSource
    public let qualityScore: Float
    public let ocrConfidence: Float
    public let tables: [DocumentTable]
    public let lists: [DocumentList]
    public let paragraphs: [String]
    public let detectedData: [DetectedDataItem]
}
