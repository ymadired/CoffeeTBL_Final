import Foundation

struct RandomUserResponse: Codable {
    let results: [RandomUser]
}

struct RandomUser: Codable {
    struct Name: Codable {
        let title: String
        let first: String
        let last: String
    }

    let name: Name
}

// A simple "employee" model we use inside the app
struct Employee {
    let firstName: String
    let lastName: String
}

enum RandomUserServiceError: Error {
    case noResults
}

enum RandomUserService {
    static func fetchEmployee() async throws -> Employee {
        let url = URL(string: "https://randomuser.me/api/")!
        let (data, _) = try await URLSession.shared.data(from: url)

        let decoded = try JSONDecoder().decode(RandomUserResponse.self, from: data)

        guard let user = decoded.results.first else {
            throw RandomUserServiceError.noResults
        }

        return Employee(firstName: user.name.first, lastName: user.name.last)
    }
}
