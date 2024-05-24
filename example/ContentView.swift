//
//  ContentView.swift
//  example
//
//  Created by mimik on 2024-05-21.
//

import SwiftUI
import EdgeCore
import EdgeEngine
import Alamofire

struct ContentView: View {
    
    let edgeClient: EdgeClient = {
        EdgeClient.setLoggingLevel(level: .debug, module: .edgeCore)
        EdgeClient.setLoggingLevel(level: .debug, module: .edgeEngine)
        
        // Calling mimik Client Library class method to determine the lifecycle management state
        switch EdgeClient.manageEdgeEngineLifecycle(manage: true) {
        case .success():
            print("Success")
            // Call successful
        case .failure(let error):
            print("Error", error.localizedDescription)
            // Call unsuccessful
        }
        
        return EdgeClient()
    }()
    
    let accessToken = "{YOUR-EDGE-ENGINE-ACCESS-TOKEN}"
    
    let devIdToken = "{YOUR-DEVELOPER-ID-TOKEN-FROM-https://console.mimik.com}"
    
    let edgeLicense = "{YOUR-DEVELOPER-EDGE-LICENSE-FROM-https://console.mimik.com}"
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("Hello, mimik developer!")
            
            Button("Start edgeEngine") {
                Task {
                    await startEdgeEngine()
                }
            }
            Button("Stop edgeEngine") {
                stopEdgeEngine()
            }
            Button("edgeEngine info") {
                Task {
                    await edgeEngineInfo()
                }
            }
            Button("Authenticate edgeEngine") {
                Task {
                    await authenticateEdgeEngine()
                }
            }
            Button("Deploy edge microservice") {
                Task {
                    await deployMicroservice(edgeEngineAccessToken: accessToken)
                }
            }
            Button("List edge microservices") {
                Task {
                    await deployedMicroservices(edgeEngineAccessToken: accessToken)
                }
            }
            Button("Call edge microservice") {
                Task {
                    await callMicroservice(edgeEngineAccessToken: accessToken)
                }
            }
            Button("Update edge microservice") {
                Task {
                    await updateMicroservice(edgeEngineAccessToken: accessToken)
                }
            }
            Button("Undeploy edge microservice") {
                Task {
                    await undeployMicroservice(edgeEngineAccessToken: accessToken)
                }
            }
            Button("Reset edgeEngine") {
                Task {
                    await resetEdgeEngine()
                }
            }
            Spacer()
            VStack(spacing: 20) {
                Text("Useful web links:")
                Link("mimik developer documentation", destination: URL(string: "https://devdocs.mimik.com")!)
                    .foregroundStyle(.orange)
                Link("mimik developer console", destination: URL(string: "https://console.mimik.com")!)
                    .foregroundStyle(.green)
                Link("mimik iOS client library documentation", destination: URL(string: "https://mimikgit.github.io/cocoapod-EdgeCore/documentation/edgecore/")!)
                    .foregroundStyle(.yellow)
            }
            Spacer()
        }
        .padding()
    }
    
    func startEdgeEngine() async -> Result<Void, NSError> {
        // Using developer edge license from mimik developer console at https://console.mimik.com
        let edgeLicense = edgeLicense

        // Configuring the StartupParameters object with the developer edge license.
        let startupParameters = EdgeClient.StartupParameters(license: edgeLicense)

        // Calling mimik Client Library method to starting edgeEngine asynchronously, waiting for the result.
        switch await self.edgeClient.startEdgeEngine(parameters: startupParameters) {
        case .success:
            print("Success starting edgeEngine")
            // Startup successful, returning success.
            return .success(())
        case .failure(let error):
            print("Error starting edgeEngine", error.localizedDescription)
            // Startup unsuccessful, returning failure.
            return .failure(error)
        }
    }
    
    func stopEdgeEngine() {
        // Calling mimik Client Library method to stop edgeEngine synchronously.
        self.edgeClient.stopEdgeEngine()
    }
    
    func edgeEngineInfo() async -> Result<Any, NSError> {
        // Calling mimik Client Library method to get the edgeEngine Runtime information
        switch await self.edgeClient.edgeEngineInfo() {
        case .success(let info):
            print("Success", info)
            // Call successful, returning success with the edgeEngine Runtime information JSON
            return .success(info)
        case .failure(let error):
            // Call unsuccessful, returning failure
            print("Error", error.localizedDescription)
            return .failure(error)
        }
    }
    
    func authenticateEdgeEngine() async -> Result<String, NSError> {
        // Using developer ID Token from mimik Developer Console
        let developerIdToken = devIdToken // <DEVELOPER_ID_TOKEN>
        
        // Calling mimik Client Library method to get the Access Token for edgeEngine access
        switch await self.edgeClient.authorizeDeveloper(developerIdToken: developerIdToken) {
        case .success(let authorization):
            
            guard let accessToken = authorization.token?.accessToken else {
                // Authentication unsuccessful, returning failure
                return .failure(NSError.init(domain: "Error", code: 500))
            }
            
            print("Success. Access Token:", accessToken)
            // Authentication successful, returning success with the Access Token
            return .success(accessToken)
        case .failure(let error):
            print("Error", error.localizedDescription)
            // Authentication unsuccessful, returning failure
            return .failure(error)
        }
    }
    
    // We pass the edgeEngine Access Token required to deploy the edge microservice as a parameter. See "Creating an Access Token" in the previous tutorial
    func deployMicroservice(edgeEngineAccessToken: String) async -> Result<EdgeClient.Microservice, NSError> {

        // Application's bundle reference to the edge microservice tar file
        guard let imageTarPath = Bundle.main.path(forResource: "randomnumber_v1", ofType: "tar") else {
            // Tar file not found, returning failing
            return .failure(NSError.init(domain: "Error", code: 404))
        }

        // edge microservice deployment configuration object with example values
        let config = EdgeClient.Microservice.Config(imageName: "randomnumber-v1", containerName: "randomnumber-v1", basePath: "/randomnumber/v1", envVariables: ["some-key": "some-value"])

        // Calling mimik Client Library method to deploy the edge microservice
        switch await self.edgeClient.deployMicroservice(edgeEngineAccessToken: edgeEngineAccessToken, config: config, imageTarPath: imageTarPath) {
        case .success(let microservice):
            print("Success", microservice)
            // Call successful, returning success with the deployed edge microservice object reference
            return .success(microservice)
        case .failure(let error):
            print("Error", error.localizedDescription)
            // Call unsuccessful, returning failure
            return .failure(error)
        }
    }
    
    // We pass the edgeEngine Access Token required to list the deployed the edge microservice as a parameter. See "Creating an Access Token" in the previous tutorial
    func deployedMicroservices(edgeEngineAccessToken: String) async -> Result<[EdgeClient.Microservice], NSError> {
        
        // Calling mimik Client Library method to get the deployed edge microservice references
        switch await self.edgeClient.deployedMicroservices(edgeEngineAccessToken: edgeEngineAccessToken) {
        case .success(let microservices):
            
            // Guarding against the array being empty.
            guard !microservices.isEmpty else {
                print("Success, but no deployed edge microservices found")
                // Call successful, but there were no deployed edge microservices found. Returning a success with the empty array
                return .success(microservices)
            }
            
            for microservice in microservices {
                // Attempting to establish a url to the deployed edge microservice /randomNumber endpoint
                guard let url = microservice.fullPathUrl(withEndpoint: "/randomNumber")?.url else {
                    print("Error")
                    // Unable to establish the full path url to the deployed edge microservice endpoint
                    continue
                }
                
                // Printing the full path url of the deployed edge microservice endpoint
                print("Success", url)
            }
            
            print("Success")
            // Call successful, returning a success with an array of deployed edge microservice references
            return .success(microservices)
            
        case .failure(let error):
            print("Error", error.localizedDescription)
            // Call unsuccessful, returning error
            return .failure(error)
        }
    }
    
    // We pass the edgeEngine Access Token required to list the deployed edge microservices as a parameter. See "Creating an Access Token" in the previous tutorial
    func callMicroservice(edgeEngineAccessToken: String) async -> Result<Any, NSError> {
        
        // Getting a reference to the full path url of the deployed edge microservice endpoint
        guard case let .success(microservices) = await self.edgeClient.deployedMicroservices(edgeEngineAccessToken: accessToken),
              let url = microservices.first?.fullPathUrl(withEndpoint: "/randomNumber")?.url else {
            print("Error")
            // Call unsuccessful, returning a failure
            return .failure(NSError.init(domain: "Error", code: 404))
        }
        
        // In the case of our example edge microservice, the endpoint requires authentication. We will use the edgeEngine Access Token here.
        let httpHeaders = HTTPHeaders(["Authorization" : "Bearer \(edgeEngineAccessToken)"])
        
        // Alamofire request call to the endpoint's full path url, with serialization of a Decodable Int value
        let dataTask = AF.request(url, headers: httpHeaders).serializingDecodable(Int.self)
        guard let value = try? await dataTask.value else {
            print("Error")
            // Response value serialization unsuccessful, returning a failure
            return .failure(NSError.init(domain: "Error", code: 500))
        }
        
        // Response value serialization successful, returning success with the serialized value
        print("Success. value:", value)
        return .success(value)
    }
    
    // We pass the edgeEngine Access Token required to update the deployed edge microservices as a parameter. See "Creating an Access Token" in the previous tutorial
    func updateMicroservice(edgeEngineAccessToken: String) async -> Result<EdgeClient.Microservice, NSError> {
        
        // Getting a reference to the full path url of the deployed edge microservice endpoint
        guard case let .success(microservices) = await self.edgeClient.deployedMicroservices(edgeEngineAccessToken: accessToken), let microservice = microservices.first else {
            // Call unsuccessful, returning a failure
            print("Error")
            return .failure(NSError.init(domain: "Error", code: 500))
        }
        
        // Application's bundle reference to the edge microservice tar file
        guard let imageTarPath = Bundle.main.path(forResource: "randomnumber_v1", ofType: "tar") else {
            // Tar file not found, returning failing
            print("Error")
            return .failure(NSError.init(domain: "Error", code: 404))
        }
        
        // Calling mimik Client Library method to update the selected edge microservice
        switch await self.edgeClient.updateMicroservice(edgeEngineAccessToken: accessToken, microservice: microservice, imageTarPath: imageTarPath, envVariables: ["some-new-key": "some-new-value"]) {
        case .success(let microservice):
            print("Success", microservice)
            // Call successful, returning success with the updated edge microservice reference
            return .success(microservice)
        case .failure(let error):
            print("Error updating microservice", error.localizedDescription)
            // Call unsuccessful, returning failure
            return .failure(NSError.init(domain: "Error", code: 500))
        }
    }
    
    // We pass the edgeEngine Access Token required to update the deployed edge microservices as a parameter. See "Creating an Access Token" in the previous tutorial
    func undeployMicroservice(edgeEngineAccessToken: String) async -> Result<Void, NSError> {
        
        // Getting a reference to the full path url of the deployed edge microservice endpoint
        guard case let .success(microservices) = await self.edgeClient.deployedMicroservices(edgeEngineAccessToken: accessToken), let microservice = microservices.first else {
            // Call unsuccessful, returning a failure
            print("Error")
            return .failure(NSError.init(domain: "Error", code: 500))
        }
        
        // Calling mimik Client Library method to undeploy the selected edge microservice
        switch await self.edgeClient.undeployMicroservice(edgeEngineAccessToken: accessToken, microservice: microservice) {
        case .success:
            print("Success")
            // Call successful, returning a success
            return .success(())
        case .failure(let error):
            print("Error", error.localizedDescription)
            // Call unsuccessful, returning a failure
            return .failure(NSError.init(domain: "Error", code: 500))
        }
    }
    
    func resetEdgeEngine() async -> Result<Void, NSError> {
        // Calling mimik Client Library method to shut down and erase edgeEngine storage
        switch self.edgeClient.resetEdgeEngine() {
        case .success:
            print("Success")
            // Call successful, returning success
            return .success(())
        case .failure(let error):
            print("Error", error.localizedDescription)
            // Call unsuccessful, returning failure
            return .failure(error)
        }
    }
    
    func activateExternalEdgeEngine() -> Result<URLComponents, NSError> {
        // Calling mimik Client Library class method to activate the external edgeEngine support
        switch EdgeClient.activateExternalEdgeEngine(host: "192.168.4.47", port: 8083) {
        case .success(let urlComponents):
            print("Success", urlComponents)
            // Call successful, returning success
            return .success(urlComponents)
        case .failure(let error):
            print("Error", error.localizedDescription)
            // Call unsuccessful, returning failure
            return .failure(error)
        }
    }
    
    func edgeEngineLifecycleIsManaged() -> Bool {
        // Calling mimik Client Library method to determine the lifecycle management state
        switch self.edgeClient.edgeEngineLifecycleIsManaged() {
        case true:
            print("Success")
            // Call successful, returning true
            return true
        case false:
            print("Error")
            // edgeEngine Runtime lifecycle is not being managed by the mimik Client Library, returning false
            return false
        }
    }
}
