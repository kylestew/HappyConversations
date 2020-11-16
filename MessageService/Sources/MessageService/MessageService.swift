import Foundation
import Combine

public struct MessageService {

    public struct MessagesResult: Codable {
        let statusCode: Int
    }

    public static let DEFAULT_BASE_URL = URL(string: "https://abraxvasbh.execute-api.us-east-2.amazonaws.com/proto")!
    private let ENDPOINT_MESSAGES = "/messages"

    let baseURL: URL

    public init(baseURL: URL = MessageService.DEFAULT_BASE_URL) {
        self.baseURL = baseURL
    }

    public func fetch(completion: @escaping (MessagesResult) -> ()) -> AnyCancellable {
        let url = baseURL.appendingPathComponent(ENDPOINT_MESSAGES)
        return performRequest(url, body: nil, completion: completion)
    }

    public func post() {
    }

    /**
     Generic HTTP request method that will handle coding/decoding any codable types.
     We are assuming standard JSON encoded responses.

     - Parameters:
     - url: endpoint and query string params
     - body: treated as JSON data in POST requests
     - completion: returns an object of type `T` if successful, doesn't return in case of error.

     - Returns:
     - cancellable handle to terminate request
     */
    private enum HTTPError: LocalizedError {
        case statusCode
    }
    private func performRequest<T: Codable>(_ url: URL, body: Data?, completion: @escaping (T) -> ()) -> AnyCancellable {
        var request = URLRequest.init(url: url)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")

        if let body = body {
            request.httpBody = body
            request.httpMethod = "POST"
        }

        let decoder = JSONDecoder()

        let cancellable = URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw HTTPError.statusCode
                }
                return output.data
            }
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    // handled by completion in recieveValue
                    break
                case .failure(let error):
                    // TODO: fire completion error
                    fatalError(error.localizedDescription)
                }
            }, receiveValue: completion)

        return cancellable
    }
}

