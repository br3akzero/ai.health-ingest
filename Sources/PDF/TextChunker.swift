import Foundation

public struct TextChunker {
    public let maxTokens: Int
    public let overlapTokens: Int

    public init(maxTokens: Int = 500, overlapTokens: Int = 50) {
        self.maxTokens = maxTokens
        self.overlapTokens = overlapTokens
    }

    public func chunk(pages: [ReconciledPage]) -> [TextChunk] {
        let paragraphs = collectParagraphs(from: pages)
        let grouped = groupIntoChunks(paragraphs)
        return buildChunks(from: grouped)
    }

    private func collectParagraphs(from pages: [ReconciledPage]) -> [Paragraph] {
        var result: [Paragraph] = []

        for page in pages {
            if page.paragraphs.isEmpty {
                let sentences = splitIntoSentences(page.text)
                for sentence in sentences {
                    let tokens = estimateTokens(sentence)
                    if tokens > 0 {
                        result.append(Paragraph(text: sentence, pageNumber: page.pageNumber, tokenCount: tokens))
                    }
                }
            } else {
                for para in page.paragraphs {
                    let tokens = estimateTokens(para)
                    if tokens > 0 {
                        result.append(Paragraph(text: para, pageNumber: page.pageNumber, tokenCount: tokens))
                    }
                }
            }
        }

        return result
    }

    private func groupIntoChunks(_ paragraphs: [Paragraph]) -> [[Paragraph]] {
        var groups: [[Paragraph]] = []
        var current: [Paragraph] = []
        var currentTokens = 0

        for para in paragraphs {
            if para.tokenCount > maxTokens {
                if !current.isEmpty {
                    groups.append(current)
                    current = []
                    currentTokens = 0
                }
                let split = splitLongParagraph(para)
                for sub in split {
                    groups.append([sub])
                }
                continue
            }

            if currentTokens + para.tokenCount > maxTokens && !current.isEmpty {
                groups.append(current)
                current = []
                currentTokens = 0
            }

            current.append(para)
            currentTokens += para.tokenCount
        }

        if !current.isEmpty {
            groups.append(current)
        }

        return groups
    }

    private func buildChunks(from groups: [[Paragraph]]) -> [TextChunk] {
        var chunks: [TextChunk] = []

        for (index, group) in groups.enumerated() {
            var text = group.map { $0.text }.joined(separator: "\n\n")

            if index > 0, let previousGroup = groups[index - 1].last {
                let overlap = extractOverlap(from: previousGroup.text)
                if !overlap.isEmpty {
                    text = overlap + "\n\n" + text
                }
            }

            let pageNumber = group.first?.pageNumber
            let tokenCount = estimateTokens(text)

            chunks.append(TextChunk(
                content: text,
                chunkIndex: index,
                pageNumber: pageNumber,
                sectionHeading: nil,
                tokenCount: tokenCount
            ))
        }

        return chunks
    }

    private func estimateTokens(_ text: String) -> Int {
        text.split(whereSeparator: { $0.isWhitespace }).count * 4 / 3
    }

    private func splitIntoSentences(_ text: String) -> [String] {
        var sentences: [String] = []
        text.enumerateSubstrings(in: text.startIndex..., options: .bySentences) { substring, _, _, _ in
            if let sentence = substring?.trimmingCharacters(in: .whitespacesAndNewlines), !sentence.isEmpty {
                sentences.append(sentence)
            }
        }
        return sentences.isEmpty ? [text] : sentences
    }

    private func splitLongParagraph(_ para: Paragraph) -> [Paragraph] {
        let sentences = splitIntoSentences(para.text)
        var result: [Paragraph] = []
        var current = ""
        var currentTokens = 0

        for sentence in sentences {
            let tokens = estimateTokens(sentence)
            if currentTokens + tokens > maxTokens && !current.isEmpty {
                result.append(Paragraph(text: current, pageNumber: para.pageNumber, tokenCount: currentTokens))
                current = ""
                currentTokens = 0
            }
            current += (current.isEmpty ? "" : " ") + sentence
            currentTokens += tokens
        }

        if !current.isEmpty {
            result.append(Paragraph(text: current, pageNumber: para.pageNumber, tokenCount: currentTokens))
        }

        return result
    }

    private func extractOverlap(from text: String) -> String {
        let words = text.split(whereSeparator: { $0.isWhitespace })
        let overlapWords = words.suffix(overlapTokens * 3 / 4)
        return overlapWords.joined(separator: " ")
    }
}

private struct Paragraph {
    let text: String
    let pageNumber: Int
    let tokenCount: Int
}
