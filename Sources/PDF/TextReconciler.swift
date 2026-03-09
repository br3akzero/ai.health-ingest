import Foundation

public struct TextReconciler {
    public init() {}

    public func reconcile(page: PageExtraction) -> ReconciledPage {
        let pdfKit = page.pdfKitText.trimmingCharacters(in: .whitespacesAndNewlines)
        let ocr = page.ocrText.trimmingCharacters(in: .whitespacesAndNewlines)

        if let result = checkEmptiness(page: page, pdfKit: pdfKit, ocr: ocr) {
            return result
        }

        if let result = checkAgreement(page: page, pdfKit: pdfKit, ocr: ocr) {
            return result
        }

        return scoreAndPickWinner(page: page, pdfKit: pdfKit, ocr: ocr)
    }

    private func checkEmptiness(page: PageExtraction, pdfKit: String, ocr: String) -> ReconciledPage? {
        if pdfKit.count < 10 && ocr.count < 10 {
            return buildResult(page: page, text: ocr, source: .ocr, score: 0.0)
        }
        if pdfKit.count < 10 {
            return buildResult(page: page, text: ocr, source: .ocr, score: page.ocrConfidence)
        }
        if ocr.count < 10 {
            return buildResult(page: page, text: pdfKit, source: .pdfKit, score: 1.0)
        }
        return nil
    }

    private func checkAgreement(page: PageExtraction, pdfKit: String, ocr: String) -> ReconciledPage? {
        let agreement = wordOverlap(pdfKit, ocr)
        if agreement > 0.8 {
            return buildResult(page: page, text: pdfKit, source: .pdfKit, score: 0.9)
        }
        return nil
    }

    private func scoreAndPickWinner(page: PageExtraction, pdfKit: String, ocr: String) -> ReconciledPage {
        let pdfKitScore = lexicalQuality(pdfKit) * 0.7 + domainSignal(pdfKit) * 0.3
        let ocrScore = lexicalQuality(ocr) * 0.5 + domainSignal(ocr) * 0.2 + page.ocrConfidence * 0.3

        if pdfKitScore >= ocrScore - 0.1 {
            return buildResult(page: page, text: pdfKit, source: .pdfKit, score: pdfKitScore)
        }
        return buildResult(page: page, text: ocr, source: .ocr, score: ocrScore)
    }

    private func wordOverlap(_ textA: String, _ textB: String) -> Float {
        let wordsA = Set(textA.lowercased().split(whereSeparator: { !$0.isLetter }).map(String.init))
        let wordsB = Set(textB.lowercased().split(whereSeparator: { !$0.isLetter }).map(String.init))

        guard !wordsA.isEmpty || !wordsB.isEmpty else { return 0.0 }

        let intersection = wordsA.intersection(wordsB).count
        let union = wordsA.union(wordsB).count

        return Float(intersection) / Float(union)
    }

    private func lexicalQuality(_ text: String) -> Float {
        let totalChars = text.count
        guard totalChars > 0 else { return 0.0 }

        let garbageChars = text.filter { char in
            char.unicodeScalars.contains { scalar in
                scalar.value < 32 && scalar.value != 10 && scalar.value != 13
                || scalar.value == 0xFFFD
            }
        }.count

        return 1.0 - Float(garbageChars) / Float(totalChars)
    }

    private func domainSignal(_ text: String) -> Float {
        let lowered = text.lowercased()
        var hits: Float = 0.0
        let patterns = ["mg/dl", "mmol/l", "bpm", "mmhg", "mg", "ml",
                        "patient", "diagnosis", "medication", "result",
                        "blood", "pressure", "glucose", "cholesterol"]

        for pattern in patterns {
            if lowered.contains(pattern) { hits += 1.0 }
        }

        return min(hits / 5.0, 1.0)
    }

    private func buildResult(page: PageExtraction, text: String, source: TextSource, score: Float) -> ReconciledPage {
        ReconciledPage(
            pageNumber: page.pageNumber,
            text: text,
            textSource: source,
            qualityScore: score,
            ocrConfidence: page.ocrConfidence,
            tables: page.tables,
            lists: page.lists,
            paragraphs: page.paragraphs,
            detectedData: page.detectedData
        )
    }
}
