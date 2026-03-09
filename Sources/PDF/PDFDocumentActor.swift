import PDFKit

actor PDFDocumentActor {
    let document: PDFDocument

    init(_ document: PDFDocument) {
        self.document = document
    }

    var pageCount: Int { document.pageCount }

    func pageText(at index: Int) -> String? {
        document.page(at: index)?.string
    }

    func renderPageToImage(at index: Int, scale: CGFloat = 2.0) throws -> CGImage {
        guard let page = document.page(at: index) else {
            throw PDFParserError.cannotRenderPage
        }

        let pageRect = page.bounds(for: .mediaBox)
        let width = Int(pageRect.width * scale)
        let height = Int(pageRect.height * scale)

        guard let colorSpace = CGColorSpace(name: CGColorSpace.sRGB),
              let context = CGContext(
                  data: nil,
                  width: width,
                  height: height,
                  bitsPerComponent: 8,
                  bytesPerRow: 0,
                  space: colorSpace,
                  bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
              ) else {
            throw PDFParserError.cannotRenderPage
        }

        context.setFillColor(.white)
        context.fill(CGRect(x: 0, y: 0, width: width, height: height))
        context.scaleBy(x: scale, y: scale)
        page.draw(with: .mediaBox, to: context)

        guard let cgImage = context.makeImage() else {
            throw PDFParserError.cannotRenderPage
        }

        return cgImage
    }
}
