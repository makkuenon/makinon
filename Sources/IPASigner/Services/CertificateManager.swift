import Foundation
import Security

class CertificateManager {
    static let shared = CertificateManager()
    
    private init() {
        loadCertificates()
    }
    
    private var cachedCertificates: [String] = []
    private var cachedProfiles: [String] = []
    
    func getAvailableCertificates() throws -> [String] {
        return cachedCertificates
    }
    
    func getAvailableProfiles() throws -> [String] {
        return cachedProfiles
    }
    
    func getCertificateData(for identifier: String) throws -> Data {
        // Implement certificate retrieval from keychain
        throw CertificateError.certificateNotFound
    }
    
    private func loadCertificates() {
        Task {
            do {
                cachedCertificates = try queryKeychain()
                cachedProfiles = try loadProvisioningProfiles()
            } catch {
                print("Error loading certificates: \(error)")
            }
        }
    }
    
    private func queryKeychain() throws -> [String] {
        var results: [String] = []
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassCertificate,
            kSecMatchLimit as String: kSecMatchLimitAll,
            kSecReturnAttributes as String: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess, let items = result as? [[String: Any]] {
            results = items.compactMap { item in
                item[kSecAttrLabel as String] as? String
            }
        }
        
        return results
    }
    
    private func loadProvisioningProfiles() throws -> [String] {
        let libraryPath = NSSearchPathForDirectoriesInDomains(
            .libraryDirectory,
            .userDomainMask,
            true
        ).first ?? ""
        
        let profilesPath = "\(libraryPath)/MobileDevice/Provisioning Profiles"
        
        guard FileManager.default.fileExists(atPath: profilesPath) else {
            return []
        }
        
        let files = try FileManager.default.contentsOfDirectory(atPath: profilesPath)
        return files.filter { $0.hasSuffix(".mobileprovision") }
    }
}

enum CertificateError: LocalizedError {
    case certificateNotFound
    case keychainError(String)
    case invalidCertificate
    
    var errorDescription: String? {
        switch self {
        case .certificateNotFound:
            return "Certificate not found in keychain"
        case .keychainError(let reason):
            return "Keychain error: \(reason)"
        case .invalidCertificate:
            return "Invalid certificate format"
        }
    }
}
