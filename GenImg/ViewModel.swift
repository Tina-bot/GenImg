import Foundation

final class ViewModel: ObservableObject{
    private let urlSession: URLSession
    @Published var imageURL: URL?
    @Published var isLoading = false
    
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func generateImage(withText text: String) async {
        guard let url = URL(string: "https://api.openai.com/v1/images/generations") else {
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("Bearer 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", forHTTPHeaderField: "Authorization")
        
        let dictionary: [String: Any] = [
            "n": 1,
            "size": "1024x1024",
            "prompt": text
        ]
        urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        if let requestBody = String(data: urlRequest.httpBody ?? Data(), encoding: .utf8) {
             print("Request Body: \(requestBody)")
         }
        do{
            DispatchQueue.main.async {
                self.isLoading = true
            }
            let (data, _) = try await urlSession.data(for: urlRequest)
            print("Response Data: \(String(data: data, encoding: .utf8) ?? "No data")")
            let model = try JSONDecoder().decode(ModelResponse.self, from: data)
            print("Response JSON: \(model)")

            DispatchQueue.main.async {
                self.isLoading = false
                if let firstModel = model.data.first {
                    self.imageURL = URL(string: firstModel.url)
                    print(self.imageURL ?? "No result")
                } else {
                    print("No models in the response data.")
                }
            }
        }catch{
            print(error.localizedDescription)
        }
    }
}
