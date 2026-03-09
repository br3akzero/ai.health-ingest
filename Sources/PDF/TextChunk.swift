public struct TextChunk: Sendable {
    public let content: String
    public let chunkIndex: Int
    public let pageNumber: Int?
    public let sectionHeading: String?
    public let tokenCount: Int
}
