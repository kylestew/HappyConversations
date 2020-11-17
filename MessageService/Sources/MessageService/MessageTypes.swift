import Foundation

extension MessageService {

    /**
     */
    public struct Message: Codable, Equatable {
        public let user: String
        public let subject: String
        public let message: String
        public let operation: String?

        public init(user: String, subject: String, message: String, operation: String? = nil) {
            self.user = user
            self.subject = subject
            self.message = message
            self.operation = operation
        }

        public func asCreateOp() -> Message {
            return Message.init(user: self.user, subject: self.subject, message: self.message, operation: "add_message")
        }
    }

    /**
     TODO: document these types
     */
    public struct MessagesResult {
        public let statusCode: Int
        public let messages: [Message]
    }

    struct BodyData {
//        let user: String
//        let messageStubs: [MessageStub]

//        var message: Message {
//            return Message
//        }
    }

}

extension MessageService.MessagesResult: Codable {

   enum CodingError: Error {
        case decoding(String)
        case encoding(String)
    }

    enum CodingKeys: String, CodingKey {
        case statusCode
        case body
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        guard let statusCode = try? values.decode(Int.self, forKey: .statusCode) else {
            throw CodingError.decoding("Could not decode statusCode for \(dump(values))")
        }
        self.statusCode = statusCode

        if let body = try? values.decode(MessageService.BodyData.self, forKey: .body) {
            print(body)
    //            self.messages = body.messages
        }
//        } else {
            self.messages = []
//        }
    }

    public func encode(to encoder: Encoder) throws {
        throw CodingError.encoding("NOT IMPLEMENTED")
    }

}

extension MessageService.BodyData: Decodable {

    enum CodingError: Error {
        case decoding(String)
    }


    struct CustomCodingKey: CodingKey {

        let intValue: Int?
        let stringValue: String

        init?(stringValue: String) {
            self.intValue = Int(stringValue)
            self.stringValue = stringValue
        }

        init?(intValue: Int) {
            self.intValue = intValue
            self.stringValue = "\(intValue)"
        }
    }

    public init(from decoder: Decoder) throws {

        let value = try decoder.singleValueContainer()
        print(value)

//        as? JSONDecoder {
//            bob.keyDecodingStrategy = .custom { keys in
//                print(keys)
//                return CustomCodingKey(stringValue: "asfd")!
//            }
//        }
//        let container = try! decoder.container(keyedBy: CustomCodingKey.self)


//         guard let statusCode = try? values.decode(Int.self, forKey: .statusCode) else {
//         }
//         self.statusCode = statusCode
//
//         if let body = try? values.decode([MessageService.BodyData].self, forKey: .body) {
//             print(body)
//     //            self.messages = body.messages
//         }
// //        } else {
//             self.messages = []
// //        }
     }

}
