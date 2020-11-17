# MessageService

This library can be used to build clients for the [Happy Message Service](https://abraxvasbh.execute-api.us-east-2.amazonaws.com/proto/messages). The API is a simple REST service that implements storage and retrieval of simple message objects. This library makes it easy to create, post, and retrieve messages from the service. Helpers have been provided to allow multiple display formats for the frontend client using this library (i.e. group messages by user or list all messages at once).

Please consult the documentation for usage of the main `MessageService` object as well as the response data (`MessageResponseData`, `Message`) it returns.

## Design Decisions

Originally Swift Codable was used to decode JSON responses from the REST API. This quickly became very complex due to the lack of consistency in the API datatypes and use of values as keys. SwiftyJSON was chosen as a less strict JSON parsing library allowing flexibility in parsing the REST responses.

The main goal of the project was to design, document, and fully test a client library for this REST API. Here are some decisions that were made.

+ Users of the library do not interact with JSON objects directly, or even dictionaries. All returned types are mutable structs such as `Message`.
+ REST API responses are not regular or consistent, this client provides a bridge to allow simpler use of the backend service.
+ A test suite is implemented that decouples the live HTTP calls by recording them to JSON once and replaying them. This increases testing speed and relability.
+ The `Message` type encapsulates serialize/deserialze operations from JSON data, all important sensitive keys should live there.
+ Testing for JSON parsing is decoupled form testing the HTTP calls (`MessageServiceTests` vs `MessageTypesTests`)

