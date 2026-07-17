import Foundation
import ZIPFoundation

class FileHandler {
    static let shared = FileHandler()

    private let fileManager = FileManager.default
    private let tempDirectory = NSTemporaryDirectory()

    private init() {}

    func fileExists(at path: String) -> Bool {
        fileManager.fileExists(atPath: path)
    }

    func extractIPA(at path: String) throws -> String {
        let tempDir = UUID().uuidString
        let extractPath = "\(tempDirectory)\(tempDir)/"
        try fileManager.createDirectory(atPath: extractPath, withIntermediateDirectories: true)
        let sourceURL = URL(fileURLWithPath: path)
        let destinationURL = URL(fileURLWithPath: extractPath)

        guard let archive = Archive(url: sourceURL, accessMode: .read) else {
            throw NSError(domain: "FileHandler", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to read archive"])
        }
        try archive.extract(to: destinationURL)
        return extractPath
    }

    func repackageIPA(from extractPath: String, original originalPath: String) throws -> String {
        let originalURL = URL(fileURLWithPath: originalPath)
        let outputName = "signed_\(originalURL.lastPathComponent)"
        let outputPath = "\(tempDirectory)\(outputName)"
        let destinationURL = URL(fileURLWithPath: outputPath)

        guard let archive = Archive(url: destinationURL, accessMode: .create) else {
            throw NSError(domain: "FileHandler", code: 2, userInfo: [NSLocalizedDescriptionKey: "Unable to create archive"])
        }

        let sourceURL = URL(fileURLWithPath: extractPath)
        // Add all files recursively
        let resourceKeys: [URLResourceKey] = [.isDirectoryKey]
        let enumerator = fileManager.enumerator(at: sourceURL, includingPropertiesForKeys: resourceKeys, options: [], errorHandler: nil)
        while let fileURL = enumerator?.nextObject() as? URL {
            let isDirectory = (try fileURL.resourceValues(forKeys: Set(resourceKeys)).isDirectory) ?? false
            let relativePath = fileURL.path.replacingOccurrences(of: sourceURL.path + "/", with: "")
            if isDirectory { continue } // archive will create directories as needed
            try archive.addEntry(with: relativePath, relativeTo: sourceURL)
        }
        return outputPath
    }
}
