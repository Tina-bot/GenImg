import Foundation

struct DataResponse: Decodable {
    let url: String
}

struct ModelResponse: Decodable {
    let data: [DataResponse]
}
