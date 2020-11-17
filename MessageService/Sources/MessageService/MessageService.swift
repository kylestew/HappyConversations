import Foundation
import SwiftyJSON

/**
 # MessageService

 Simple service to interact with message REST API. The service takes care of preparing request and returning responses as immutable Swift `Message` objects.

 */
public struct MessageService {

    /// Main URL for service (can override)
    public static let DEFAULT_BASE_URL = URL(string: "https://abraxvasbh.execute-api.us-east-2.amazonaws.com/proto")!

    private let ENDPOINT_MESSAGES = "/messages"

    private let baseURL: URL
    private let session: URLSession

    /**
     Initializer provides optional overrides. Can be used to provide a staging instance or inject test dependencies.

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
     Get messages from API.
     This function can be used to fetch all messages or messages for a single user.

     - Parameters:
       - username: (optional) fetches only messages for specific user
       - completion: emits `MessageResponseData` if successful, `ServiceError` otherwise

     - Returns: cancellable handle to terminate request
     */
    public func fetch(username: String? = nil, completion: @escaping (Result<MessageResponseData, MessageService.ServiceError>) -> ()) -> URLSessionDataTask {
        var url = baseURL.appendingPathComponent(ENDPOINT_MESSAGES)
        if let username = username {
            url.appendPathComponent("/\(username)")
        }
        return performRequest(url, completion: completion)
    }

    /**
     Post a message to the API from the given `Message` object.

     - Parameters:
       - message: `Message` object to be posted to the message service
       - completion: emits `MessageResponseData` if successful, `ServiceError` otherwise

     - Returns: cancellable handle to terminate request
     */
    public func post(_ message: Message, completion: @escaping (Result<MessageResponseData, MessageService.ServiceError>) -> ()) -> URLSessionDataTask? {
        do {
            let json = try! message.toJSON().merged(with: Message.addMessageOperation)
            let rawData = try json.rawData()
            let url = baseURL.appendingPathComponent(ENDPOINT_MESSAGES)
            return performRequest(url, body: rawData, completion: completion)
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

     - Returns: cancellable handle to terminate request
     */
    private func performRequest(_ url: URL,
                                body: Data? = nil,
                                completion: @escaping (Result<MessageResponseData, MessageService.ServiceError>) -> ())
    -> URLSessionDataTask {

        var request = URLRequest.init(url: url)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")

        if let body = body {
            request.httpBody = body
            request.httpMethod = "POST"
        }

        let task = session.dataTask(with: request) { (data, response, error) in
            // check for request error
            if let error = error {
                completion(.failure(.generalError(error)))
                return
            }

            // check response headers
            guard let response = response as? HTTPURLResponse,
                  200...299 ~= response.statusCode else {
                completion(.failure(.invalidStatusCode))
                return
            }

            // did we receive data?
            guard let data = data else {
                completion(.failure(.noDataReturned))
                return
            }

            // attempt to parse body out of response data
            do {
                // all critical JSON decoding happens (and traps exceptions) here
                let json = try JSON(data: data)

                let statusCode = json["statusCode"].intValue
                // need to additionally decode the body data (string -> JSON)
                let body = JSON.init(parseJSON: json["body"].stringValue)

                let messageResponse = MessageResponseData(statusCode: statusCode, body: body)
                completion(.success(messageResponse))
            } catch (let error) {
                completion(.failure(.generalError(error)))
            }
        }
        task.resume()

        return task
    }
}
