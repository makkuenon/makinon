import Foundation

struct SigningConfig: Codable {
    let certificateID: String
    let profilePath: String
    let teamID: String?
    let codeSignIdentity: String
    let provisioningProfileName: String
    let shouldReplaceProfile: Bool
    let shouldInjectMobileProvision: Bool
    
    enum CodingKeys: String, CodingKey {
        case certificateID
        case profilePath
        case teamID
        case codeSignIdentity
        case provisioningProfileName
        case shouldReplaceProfile
        case shouldInjectMobileProvision
    }
}

struct SigningResult: Codable {
    let success: Bool
    let signedIPAPath: String
    let originalIPAPath: String
    let signingTime: TimeInterval
    let bundleID: String
    let certificateUsed: String
}
