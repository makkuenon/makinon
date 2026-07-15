import Foundation

struct IPAFile: Codable {
    let path: String
    let name: String
    let size: Int64
    let bundleID: String?
    let version: String?
    let buildNumber: String?
    let minOS: String?
    
    var url: URL {
        URL(fileURLWithPath: path)
    }
    
    var displaySize: String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useMB, .useGB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: size)
    }
}

struct IPAMetadata: Codable {
    let bundleIdentifier: String
    let version: String
    let buildNumber: String
    let minimumOSVersion: String
    let architectures: [String]
    let frameworks: [String]
}
