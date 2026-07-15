import Foundation
import Compression

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
        let extractPath = "\(tempDirectory)\(tempDir)"
        
        try fileManager.createDirectory(atPath: extractPath, withIntermediateDirectories: true)
        
        // IPA files are ZIP archives
        try unzip(from: path, to: extractPath)
        
        return extractPath
    }
    
    func repackageIPA(from extractPath: String, original originalPath: String) throws -> String {
        let originalURL = URL(fileURLWithPath: originalPath)
        let outputName = "signed_\(originalURL.lastPathComponent)"
        let outputPath = "\(tempDirectory)\(outputName)"
        
        try zip(from: extractPath, to: outputPath)
        
        return outputPath
    }
    
    private func unzip(from source: String, to destination: String) throws {
        let sourceURL = URL(fileURLWithPath: source)
        let destinationURL = URL(fileURLWithPath: destination)
        
        try fileManager.unzipItem(at: sourceURL, to: destinationURL)
    }
    
    private func zip(from source: String, to destination: String) throws {
        let sourceURL = URL(fileURLWithPath: source)
        let destinationURL = URL(fileURLWithPath: destination)
        
        try fileManager.zipItem(at: sourceURL, to: destinationURL)
    }
}

// MARK: - FileManager Extensions

extension FileManager {
    func unzipItem(at sourceURL: URL, to destinationURL: URL) throws {
        // Implement unzipping logic using Foundation
        // This is a simplified version
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/unzip")
        process.arguments = ["-q", sourceURL.path, "-d", destinationURL.path]
        try process.run()
        process.waitUntilExit()
    }
    
    func zipItem(at sourceURL: URL, to destinationURL: URL) throws {
        // Implement zipping logic using Foundation
        // This is a simplified version
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/zip")
        process.arguments = ["-r", "-q", destinationURL.path, sourceURL.lastPathComponent]
        let pipe = Pipe()
        process.currentDirectoryURL = sourceURL.deletingLastPathComponent()
        process.standardOutput = pipe
        try process.run()
        process.waitUntilExit()
    }
}
