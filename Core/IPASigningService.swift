import Foundation
public final class IPASigningService {
    public init() {}
    public func sign(ipa: IPAFile, config: SigningConfig) {
        print("Signing \(ipa.url.lastPathComponent) with \(config.certificate)")
    }
}
