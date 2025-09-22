//
//  ContentView.swift
//  example
//
//  Created by mimik on 2024-05-21.
//

import SwiftUI
import Network
import EdgeCore
import EdgeEngine
import Alamofire
@preconcurrency import SwiftyJSON

struct ContentView: View {
    
    private let kMicroserviceServiceName01 = "MY-SERVICE-01"
    private let kMicroserviceServiceName02 = "MY-SERVICE-02"
    private let kMicroserviceServiceBasePath01 = "/MY-SERVICE-BASE-PATH-01/v1"
    private let kMicroserviceServiceBasePath02 = "/MY-SERVICE-BASE-PATH-02/v1"
    
    private static let runtimeLicense = "{ADD-YOUR-RUNTIME-LICENSE-HERE}"
    
    @State private var text: String = "Hello developer!"
    @State private var accessToken: String = ""
    @State private var devConsoleAccessToken: String = ""
    @State private var devConsoleAppName: String = "Example-App"
    @State private var devConsoleValidationCodes: ClientLibrary.Authorization.ValidationCodes?
    
    var body: some View {
        
        AdaptiveStack(phone: .horizontal, tablet: .horizontal) {
            
            ScrollView {
                
                Divider()
                
                Button("Login with Developer Console") {
                    Task {
                        await authenticateDeveloperConsole()
                    }
                }
                
                Button("Create \(devConsoleAppName) App at Developer Console") {
                    Task {
                        try await createAppAtDeveloperConsole()
                    }
                }
                
                Button("List apps at Developer Console") {
                    Task {
                        try await listAppsAtDeveloperConsole()
                    }
                }
                
                Button("Delete \(devConsoleAppName) App at Developer Console") {
                    Task {
                        try await deleteCreatedAppAtDeveloperConsole()
                    }
                }
                
                Button("⚠️ Delete all apps at Developer Console ⚠️") {
                    Task {
                        try await deleteAllAppsAtDeveloperConsole()
                    }
                }
                
                Button("Id Token for \(devConsoleAppName) at Developer Console") {
                    Task {
                        try await idTokenAtDeveloperConsole()
                    }
                }
                
                Button("Shared Id Token for \(devConsoleAppName) at Developer Console") {
                    Task {
                        try await sharedIdTokenAtDeveloperConsole()
                    }
                }
                
                Divider()
                
                Button("Start mim OE") {
                    Task {
                        try await startRuntime()
                    }
                }
                
                Button("Authorize mim OE runtime for \(devConsoleAppName) App") {
                    Task {
                        try await authorizeRuntime()
                    }
                }
                
                Divider()
                
                Button("mim OE info") {
                    Task {
                        try? await runtimeInfo()
                    }
                }
                
                Divider()
                
                Button("Deploy edge microservice 1") {
                    Task {
                        try await deployMicroservice(accessToken: accessToken, containerName: kMicroserviceServiceName01, basePath: kMicroserviceServiceBasePath01)
                    }
                }

                Spacer()

                Button("Deploy edge microservice 2") {
                    Task {
                        try await deployMicroservice(accessToken: accessToken, containerName: kMicroserviceServiceName02, basePath: kMicroserviceServiceBasePath02)
                    }
                }

                Spacer()

                Button("List edge microservices") {
                    Task {
                        try await listMicroservices(accessToken: accessToken)
                    }
                }

                Divider()

                Button("Call edge microservice") {
                    Task {
                        try await callMicroservice(accessToken: accessToken, serviceName: kMicroserviceServiceName01)
                    }
                }

                Spacer()

                Button("Update Env of edge microservice") {
                    Task {
                        try await updateEnvMicroservice(accessToken: accessToken, serviceName: kMicroserviceServiceName01)
                    }
                }
                
                Button("Undeploy edge microservice") {
                    Task {
                        try await undeployMicroservice(accessToken: accessToken, serviceName: kMicroserviceServiceName01)
                    }
                }
                
                Divider()
                
                Button("Stop mim OE") {
                    stopRuntime()
                }
                
                Spacer()
                
                Button("Reset mim OE") {
                    Task {
                        try await resetRuntime()
                    }
                }
                
                Divider()
                VStack(spacing: 20) {
                    Text("Useful web links:")
                    Link("mimik developer documentation", destination: URL(string: "https://devdocs.mimik.com")!)
                        .foregroundStyle(.orange)
                    Link("mimik developer console", destination: URL(string: "https://console.mimik.com")!)
                        .foregroundStyle(.brown)
                    Link("mimik iOS client library documentation", destination: URL(string: "https://mimikgit.github.io/cocoapod-EdgeCore/documentation/edgecore/")!)
                        .foregroundStyle(.purple)
                }
            }
            .customBackground(backgroundColor: .gray.opacity(0.2), cornerRadius: 15.0)
            .frame(maxWidth: ScreenSize.screenWidth / 2)
            
            ScrollView {
                Text(text)
                    .foregroundStyle(.red)
            }
            .customBackground(backgroundColor: .gray.opacity(0.3), cornerRadius: 15.0)
            .frame(maxWidth: ScreenSize.screenWidth / 2)
        }
        .safeAreaPadding([.top,.bottom], 30)
        .safeAreaPadding([.leading, .trailing], 10)
        .task {
            ClientLibrary.setLoggingLevel(module: .mimikCore, level: .debug, privacy: .publicAccess)
            ClientLibrary.setLoggingLevel(module: .mimikRuntime, level: .debug, privacy: .publicAccess)
            ClientLibrary.setLoggingLevel(module: .mimikApps, level: .debug, privacy: .publicAccess)
            
            do {
                try ClientLibrary.manageRuntimeLifecycle(manage: true)
                print("Manage runtime lifecycle setup successful")
            }
            catch {
                print("Error setting up lifecycle management:", error.localizedDescription)
            }
        }
    }
    
    func startRuntime() async throws {
        
        do {
            // Using developer license from the mimik developer console at https://console.mimik.com
            let runtimeLicense = ContentView.runtimeLicense

            // Configuring the StartupParameters object with the developer edge license.
            let startupParameters = ClientLibrary.RuntimeParameters(license: runtimeLicense)
            
            try await ClientLibrary.startRuntime(parameters: startupParameters)
            print("Successfully started the runtime")
            // Startup successful, returning success.
            text = "Successfully started the runtime"
        }
        catch {
            print("Failed to start the runtime", error.localizedDescription)
            // Startup unsuccessful, returning failure.
            text = "Failed to start the runtime"
        }
    }
    
    func stopRuntime() {
        // Calling mimik Client Library method to stop mim OE runtime synchronously.
        ClientLibrary.stopRuntime()
        text = "Successfully stopped the runtime"
    }
    
    func runtimeInfo() async throws -> JSON {
        
        do {
            // Calling mimik Client Library method to get the mim OE runtime information
            let info = try await ClientLibrary.runtimeInfo()
            print("Successfully fetched the runtime info:\n", info)
            // Call successful, returning success with the mim OE runtime information JSON
            text = "Successfully fetched the runtime info:\n\(info)"
            return info
        }
        
        catch let error as NSError {
            print("Error", error.localizedDescription)
            text = "Runtime failed" + error.localizedDescription
            throw error
        }
    }
    
    func authenticateDeveloperConsole() async -> Result<String, NSError> {
        
        // Your developer credentials for https://console.mimik.com
        let email = "{ADD-YOUR-DEVELOPER-EMAIL-ADDRESS-HERE}"
        let password = "{ADD-YOUR-DEVELOPER-PASSWORD-HERE}"
        
        do {
            let authorization = try await DeveloperConsole.Auth.authenticate(email: email, password: password)
            print("Successfully authenticated, access token:\n", authorization)
            
            if let token = authorization.token?.accessToken, let expiresIn = authorization.token?.expiresIn {
                text = "Successfully authenticated with developer console account.\n\nYour access token:\n" + token + "\n\nExpires in: " + expiresIn.description(with: .current)
                devConsoleAccessToken = token
            }
            
            return .success(devConsoleAccessToken)
        }
        catch let error as NSError {
            print("Error", error.localizedDescription)
            text = "Authentication failed" + error.localizedDescription
            return .failure(error)
        }
    }
    
    func signupAtDeveloperConsole() async -> Result<ClientLibrary.Authorization.ValidationCodes, NSError> {
        
        // Signup for a https://console.mimik.com account
        let email = "{ADD-YOUR-DEVELOPER-EMAIL-ADDRESS-HERE}"
        let password = "{ADD-YOUR-DEVELOPER-PASSWORD-HERE}"
        
        do {
            let signupAuth = try await DeveloperConsole.Auth.authenticate(email: email, password: password)
            
            guard let codes = signupAuth.validationCodes else {
                print("Error")
                text = "Error initiating signup at developer console"
                throw NSError(domain: "Error initializing signup", code: 500)
            }
            
            print("✅ Successfully initialized signup at developer console with validation codes: \(codes)")
            
            devConsoleValidationCodes = codes
            return .success(codes)
        }
        catch let error as NSError {
            print("Error", error.localizedDescription)
            text = "Error signing up at developer console" + error.localizedDescription
            return .failure(error)
        }
    }
    
    func signupValidationAtDeveloperConsole() async -> Result<String, NSError> {
                        
        do {
            // Validate signup for a https://console.mimik.com account
            let password = "{ADD-YOUR-DEVELOPER-PASSWORD-HERE}"
            let codesWithBinding = ClientLibrary.Authorization.ValidationCodes(mfaCode: "{YOUR-MFA-CODE-HERE}", oobCode: "{YOUR-OOB-CODE-HERE}", bindingCode: "YOUR-BINDING-CODE-HERE-FROM-THE-EMAIL")

            let signupValidateAuth = try await DeveloperConsole.Auth.verifySignup(codes: codesWithBinding, password: password)
            
            guard let accessToken = signupValidateAuth.token?.accessToken else {
                text = "Error validating sign up at developer console"
                throw NSError(domain: "Error validating sign up at developer console", code: 500)
            }
            
            self.devConsoleAccessToken = accessToken
            print("✅Successfully validated signup at developer console. AccessToken: \(accessToken)")
            text = "Successfully validated signup at developer console:\n\(accessToken)"
            
            return .success(devConsoleAccessToken)
        }
        catch let error as NSError {
            text = "Error validating sign up at developer console:" + error.localizedDescription
            return .failure(error)
        }
    }
    
    func createAppAtDeveloperConsole() async throws {
        
        guard let appNamed = try await DeveloperConsole.Apps.find(accessToken: devConsoleAccessToken, name: devConsoleAppName) else {
            let createdApp = try await DeveloperConsole.Apps.create(accessToken: self.devConsoleAccessToken, payload: .init(clientName: devConsoleAppName, redirectUris: ["com.example.\(UUID().uuidString)://callback"], clientUri: "https://example.\(UUID().uuidString).com/"))
            print("createdApp: \(createdApp.jsonString() ?? "N/A")")
            
            text = "Created \(devConsoleAppName) app at developer console:\n\n\(createdApp.description)"
            return
        }
        
        text = "\(devConsoleAppName) app already exists:\n\n\(appNamed.description)"
    }
    
    func listAppsAtDeveloperConsole() async throws {
        
        let apps = try await DeveloperConsole.Apps.list(accessToken: self.devConsoleAccessToken)
        
        if !apps.isEmpty {
            print("Apps: \(apps.jsonString() ?? "N/A")")
            let readable: String = apps.map { $0.description }.joined(separator: "\n\n")
            text = readable
        }
        else {
            print("No apps found")
            text = "No apps found at developer console"
        }
    }
    
    func deleteCreatedAppAtDeveloperConsole() async throws {
        guard let appNamed = try await DeveloperConsole.Apps.find(accessToken: devConsoleAccessToken, name: devConsoleAppName) else {
            print("Could not find \(devConsoleAppName) app at developer console")
            text = "Could not find \(devConsoleAppName) app at developer console"
            return
        }
        
        let deletedId = try await DeveloperConsole.Apps.delete(accessToken: self.devConsoleAccessToken, clientId: appNamed.clientId)
        print("deleted app: \(deletedId.jsonString() ?? "N/A")")
        text = "\(devConsoleAppName) app with id \(deletedId) deleted."
    }
    
    func deleteAllAppsAtDeveloperConsole() async throws {
        do {
            fatalError("Remove This line if you are sure you want to permanently delete all apps at the developer console.")
            
            let apps = try await DeveloperConsole.Apps.list(accessToken: self.devConsoleAccessToken)
            guard !apps.isEmpty else {
                print("No apps found")
                text = "No apps found at developer console"
                return
            }

            var deleted: [String] = []
            var failed: [String] = []

            for app in apps {
                print("Deleting app: \(app.description)")
                do {
                    let deletedAppId = try await DeveloperConsole.Apps.delete(accessToken: self.devConsoleAccessToken, clientId: app.clientId)
                    print("Deleted app: \(deletedAppId)")
                    deleted.append(deletedAppId)
                } catch {
                    print("Failed to delete app \(app.clientId):", error.localizedDescription)
                    failed.append(app.clientId)
                }
            }

            var summary: [String] = []
            if !deleted.isEmpty {
                summary.append("Deleted \(deleted.count) app\(deleted.count == 1 ? "" : "s"):\n" + deleted.joined(separator: "\n"))
            }
            if !failed.isEmpty {
                summary.append("Failed to delete \(failed.count) app\(failed.count == 1 ? "" : "s"):\n" + failed.joined(separator: "\n"))
            }

            text = summary.joined(separator: "\n\n")

            if !failed.isEmpty {
                throw NSError(domain: "DeleteAllApps", code: 500, userInfo: [NSLocalizedDescriptionKey: "Some apps failed to delete: \(failed.joined(separator: ", "))"])
            }
        } catch {
            print("Error", error.localizedDescription)
            text = "Error: Deleting apps failed — " + error.localizedDescription
            throw error as NSError
        }
    }
    
    func idTokenAtDeveloperConsole() async throws {
        
        do {
            guard let appNamed = try await DeveloperConsole.Apps.find(accessToken: devConsoleAccessToken, name: devConsoleAppName) else {
                print("⚠️ Error: Could not find App named \(devConsoleAppName) at Developer Console")
                text = "Could not find \(devConsoleAppName) app at developer console"
                return
            }
            
            let appIdToken = try await DeveloperConsole.Auth.issueToken(accessToken: devConsoleAccessToken, clientId: appNamed.clientId, expiresIn: 1500)
            print("App id token: \(appIdToken)")
            text = appIdToken.description
        }
        
        catch {
            print("Error", error.localizedDescription)
            text = error.localizedDescription
            throw error
        }
    }
    
    func sharedIdTokenAtDeveloperConsole() async throws {
        
        do {
            guard let appNamed = try await DeveloperConsole.Apps.find(accessToken: devConsoleAccessToken, name: devConsoleAppName) else {
                print("⚠️ Error: Could not find App named \(devConsoleAppName) at Developer Console")
                text = "Could not find \(devConsoleAppName) app at developer console"
                return
            }
            
            let appSharedIdToken = try await DeveloperConsole.Auth.issueSharedToken(accessToken: devConsoleAccessToken, clientId: appNamed.clientId, expiresIn: 1500)
            print("App shared id token: \(appSharedIdToken)")
            text = appSharedIdToken.description
        }
        
        catch {
            print("Error", error.localizedDescription)
            text = "Error:" + error.localizedDescription
            throw error
        }
    }

    func authorizeRuntime() async throws {
        
        do {
            guard let appNamed = try await DeveloperConsole.Apps.find(accessToken: devConsoleAccessToken, name: devConsoleAppName) else {
                print("⚠️ Error: Could not find App named \(devConsoleAppName) at Developer Console")
                text = "Could not find \(devConsoleAppName) app at developer console"
                return
            }
            
            // Developer ID Token from mimik Developer Console
            let developerIdToken = try await DeveloperConsole.Auth.issueToken(accessToken: devConsoleAccessToken, clientId: appNamed.clientId)
            
            // Calling mimik Client Library method to get the Access Token for mim OE runtime access
            let authorization = try await DeveloperConsole.Auth.authorizeRuntimeAccess(idToken: developerIdToken, runtimeIdToken: nil)
            
            guard let accessToken = authorization.token?.accessToken else {
                throw NSError.init(domain: "Error", code: 500)
            }
            
            self.accessToken = accessToken
            print("Successfully authenticated, access token:\n", accessToken)
            text = "Successfully authenticated, access token:\n" + accessToken
            return
        }
        catch {
            print("Error", error.localizedDescription)
            text = "Authentication failed" + error.localizedDescription
            throw error
        }
    }
    
    // We pass the mim OE runtime access token required to deploy the edge microservice as a parameter. See "Creating an Access Token" in the previous tutorial
    func deployMicroservice(accessToken: String, containerName: String, basePath: String) async throws -> ClientLibrary.Microservice {
        
        guard let imageTarPath = Bundle.main.path(forResource: "randomnumber_v1", ofType: "tar") else {
            throw NSError(domain: "DeployMicroservice", code: 404, userInfo: [NSLocalizedDescriptionKey: "randomnumber_v1.tar not found in bundle."])
        }

        let config = ClientLibrary.Microservice.Config(imageName: "randomnumber-v1", containerName: containerName, basePath: basePath, envVariables: ["some-key": "some-value"])

        do {
            let microservice = try await ClientLibrary.deployMicroservice(accessToken: accessToken, config: config, imageTarPath: imageTarPath)
            print("Successfully deployed microservice:\n", microservice)
            text = "Successfully deployed microservice:\n" + (microservice.jsonString() ?? "")
            return microservice
        } catch {
            print("Error", error.localizedDescription)
            text = "Error deploying microservice: " + error.localizedDescription
            throw error as NSError
        }
    }
    
    // We pass the mim OE runtime access token required to list the deployed the edge microservice as a parameter. See "Creating an Access Token" in the previous tutorial
    func listMicroservices(accessToken: String) async throws -> [ClientLibrary.Microservice] {
        
        do {
            let microservices = try await ClientLibrary.microservices(accessToken: accessToken)

            guard !microservices.isEmpty else {
                print("Success, but found no deployed microservices")
                text = "Found no deployed microservices"
                return microservices
            }

            for microservice in microservices {
                guard let url = microservice.urlComponents(withEndpoint: "/randomNumber")?.url else {
                    print("Error")
                    continue
                }
                print("Success", microservice.json() ?? "N/A", url)
            }

            print("Success")
            let count = microservices.count
            text = "Found \(count) deployed microservice\(count == 1 ? "" : "s"):\n" + (microservices.jsonString() ?? "N/A")
            return microservices
        } catch {
            print("Error", error.localizedDescription)
            text = "Error listing microservices: " + error.localizedDescription
            throw error as NSError
        }
    }
    
    // We pass the mim OE runtime access token required to list the deployed edge microservices as a parameter. See "Creating an Access Token" in the previous tutorial
    func callMicroservice(accessToken: String, serviceName: String) async throws -> Int {
        
        guard let microservice = try? await ClientLibrary.microservice(containerName: serviceName, accessToken: accessToken),
              let url = microservice.urlComponents(withEndpoint: "/randomNumber")?.url else {
            print("Error")
            text = "Error calling microservice"
            throw NSError(domain: "CallMicroservice", code: 404, userInfo: [NSLocalizedDescriptionKey: "Microservice not found or invalid URL."])
        }

        let httpHeaders = HTTPHeaders(["Authorization": "Bearer \(accessToken)"])
        let dataTask = AF.request(url, headers: httpHeaders).serializingDecodable(Int.self)

        guard let value = try? await dataTask.value else {
            print("Error calling microservice")
            text = "Error calling microservice"
            throw NSError(domain: "CallMicroservice", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to decode response from microservice."])
        }

        print("Successfully called microservice, returned value:", value)
        text = "Successfully called microservice, returned value:\n" + String(value)
        return value
    }
    
    func updateEnvMicroservice(accessToken: String, serviceName: String) async throws -> ClientLibrary.Microservice {
        
        guard let microservice = try? await ClientLibrary.microservice(containerName: serviceName, accessToken: accessToken) else {
            print("\(serviceName) edge microservice not found Error")
            text = "Error updating microservice"
            throw NSError(domain: "UpdateEnvMicroservice", code: 404, userInfo: [NSLocalizedDescriptionKey: "\(serviceName) microservice not found"])
        }

        do {
            let updatedMicroservice = try await microservice.updateEnv(accessToken: accessToken, envVariables: ["some-new-key": "some-new-value"])
            print("Success updating microservice:", updatedMicroservice.json() ?? "")
            text = "Successfully updated microservice environment variables:\n" + (updatedMicroservice.jsonString() ?? "")
            return updatedMicroservice
        } catch {
            print("Error updating microservice:", error.localizedDescription)
            text = "Error updating microservice: " + error.localizedDescription
            throw error as NSError
        }
    }

    
    // We pass the mim OE runtime access token required to update the deployed edge microservices as a parameter. See "Creating an Access Token" in the previous tutorial
    func undeployMicroservice(accessToken: String, serviceName: String) async throws {
        
        guard let microservice = try? await ClientLibrary.microservice(containerName: serviceName, accessToken: accessToken) else {
            print("\(serviceName) edge microservice not found Error")
            text = "Error undeploying microservice"
            throw NSError(domain: "UndeployMicroservice", code: 404, userInfo: [NSLocalizedDescriptionKey: "\(serviceName) microservice not found"])
        }

        do {
            try await ClientLibrary.undeployMicroservice(accessToken: accessToken, microservice: microservice)
            print("Success undeploying microservice")
            text = "Successfully undeployed microservice"
        } catch {
            print("Error", error.localizedDescription)
            text = "Error undeploying microservice: " + error.localizedDescription
            throw error as NSError
        }
    }
    
    func resetRuntime() async throws {
        
        do {
            // Calling mimik Client Library method to shut down and erase mim OE runtime storage
           try ClientLibrary.resetRuntime()
            print("Successfully reset the runtime")
            text = "Successfully reset the runtime"
            // Call successful, returning success
        }
        catch {
            print("Error", error.localizedDescription)
            text = "Error resetting runtime: " + error.localizedDescription
            // Call unsuccessful, returning failure
        }
    }
    
    func activateExternalRuntime() -> Result<URLComponents, NSError> {
        
        do {
            // Calling mimik Client Library class method to activate the external mim OE runtime support
            let urlComponents = try ClientLibrary.activateExternalRuntime(host: "192.168.4.47", port: 8083)
            print("Success", urlComponents)
            return .success(urlComponents)
        } catch {
            let nsError = error as NSError
            print("Error", nsError.localizedDescription)
            return .failure(nsError)
        }
    }
    
    func runtimeLifecycleIsManaged() -> Bool {
        // Calling mimik Client Library method to determine the lifecycle management state
        switch ClientLibrary.runtimeLifecycleIsManaged() {
        case true:
            print("Success")
            // Call successful, returning true
            return true
        case false:
            print("Error")
            // mim OE runtime lifecycle is not being managed by the mimik Client Library, returning false
            return false
        }
    }
}
