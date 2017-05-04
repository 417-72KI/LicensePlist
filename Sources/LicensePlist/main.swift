import Foundation
import LicensePlistCore
import Commander

let main = command(Option("cartfile-path", ""),
                   Option("pods-path", ""),
                   Option("output-path", ""),
                   Option("github-token", ""),
                   Option("config-path", ""),
                   Flag("force")) { cartfile, podsPath, output, gitHubToken, configPath, force in
                    let tool = LicensePlist()
                    tool.process(outputPath: output.isEmpty ? nil : URL(fileURLWithPath: output),
                                 cartfilePath: cartfile.isEmpty ? nil : URL(fileURLWithPath: cartfile),
                                 podsPath: podsPath.isEmpty ? nil : URL(fileURLWithPath: podsPath),
                                 gitHubToken: gitHubToken.isEmpty ? nil : gitHubToken,
                                 configPath: configPath.isEmpty ? nil : URL(fileURLWithPath: configPath),
                                 force: force)
}

main.run()
