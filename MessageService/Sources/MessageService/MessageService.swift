import Foundation
import Combine

public struct MessageService {

    public static let DEFAULT_BASE_URL = URL(string: "https://abraxvasbh.execute-api.us-east-2.amazonaws.com/proto")!

    private let ENDPOINT_MESSAGES = "/messages"

    private let baseURL: URL
    private let session: URLSession

    /**
     ???

     - Parameters:
     - baseURL: (optional) set to override default service URL
     - session: (optional) exposed for using in testing via dependency injection
     */
    public init(
        baseURL: URL = MessageService.DEFAULT_BASE_URL,
        session: URLSession = URLSession.shared
    ) {
        self.baseURL = baseURL
        self.session = session
    }

    /**
     Get all messages from API.

     - Parameters:
     - completion: emits `MessageResult` if successful, `ServiceError` if not

     - Returns:
     - cancellable handle to terminate request
     */
    public func fetch(completion: @escaping (Result<MessagesResult, MessageService.ServiceError>) -> ()) -> AnyCancellable {
        let url = baseURL.appendingPathComponent(ENDPOINT_MESSAGES)
        return performRequest(url, completion: completion)
    }
    /**
     Post a message to the API from the given `Message` object.

     // TODO:...

     */
    public func post(_ message: Message, completion: @escaping (Result<MessagesResult, MessageService.ServiceError>) -> ()) -> AnyCancellable? {
        do {
            let jsonData = try JSONEncoder().encode(message.asCreateOp())
            let url = baseURL.appendingPathComponent(ENDPOINT_MESSAGES)
            return performRequest(url, body: jsonData, completion: completion)
        } catch (let error) {
            completion(.failure(.generalError(error)))
        }
        return nil
    }

    /**
     Generic HTTP request method that will handle coding/decoding any codable types.
     We are assuming standard JSON encoded responses.

     - Parameters:
     - url: endpoint and query string params
     - body: treated as JSON data in POST requests
     - completion: returns an object of type `T` if successful, returns `ServiceError` if not

     - Returns:
     - cancellable handle to terminate request
     */
    private func performRequest<T: Codable>(_ url: URL, body: Data? = nil, completion: @escaping (Result<T, MessageService.ServiceError>) -> ()) -> AnyCancellable {
        var request = URLRequest.init(url: url)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")

        if let body = body {
            request.httpBody = body
            request.httpMethod = "POST"
        }

        return session.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw ServiceError.invalidStatusCode
                }
                return output.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    // handled by completion in recieveValue
                    break
                case .failure(let error):
                    if let serviceError = error as? ServiceError {
                        completion(.failure(serviceError))
                    } else {
                        completion(.failure(.generalError(error)))
                    }
                }
            }, receiveValue: { value in
                completion(.success(value))
            })
    }
}

