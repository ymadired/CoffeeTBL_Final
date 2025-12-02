import SwiftUI

extension Color {
    static let brown = Color("CoffeeBrown")
    static let cream = Color("CoffeeCream")
}

struct ContentView: View {
    @State private var step: Int = 1

    @State private var userName: String = ""

    @State private var company: String = ""
    @State private var role: String = ""

    @State private var employeeFirstName: String = ""
    @State private var employeeLastName: String = ""
    @State private var employeeEmail: String = ""

    @State private var draftBody: String = ""
    @State private var includeSignature: Bool = true

    @State private var isLoading: Bool = false
    @State private var errorMessage: String?

    var body: some View {
        ZStack {
            Color.cream.ignoresSafeArea()

            VStack(spacing: 24) {
                CoffeeHeader()

                VStack(spacing: 16) {
                    if step == 1 {
                        UserInfoView(
                            userName: $userName,
                            onNext: { step = 2 }
                        )
                    } else if step == 2 {
                        EmployeeInfoView(
                            company: $company,
                            role: $role,
                            isLoading: isLoading,
                            errorMessage: errorMessage,
                            onGenerate: generateEmployeeAndDraft
                        )
                    } else {
                        EmailResultView(
                            userName: userName,
                            employeeFirstName: employeeFirstName,
                            employeeLastName: employeeLastName,
                            role: role,
                            company: company,
                            email: employeeEmail,
                            draftBody: $draftBody,
                            includeSignature: $includeSignature
                        )
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(24)
                .shadow(radius: 10)
                .padding(.horizontal)

                Spacer()
            }
            .padding(.top, 40)
        }
    }

    private func generateEmployeeAndDraft() {
        errorMessage = nil
        isLoading = true

        Task {
            do {
                let employee = try await RandomUserService.fetchEmployee()
                employeeFirstName = employee.firstName
                employeeLastName = employee.lastName

                employeeEmail = makeEmail(
                    first: employeeFirstName,
                    last: employeeLastName,
                    company: company
                )

                draftBody = makeDraft(
                    userName: userName,
                    employeeFirstName: employeeFirstName,
                    role: role,
                    company: company,
                    includeSignature: includeSignature
                )

                isLoading = false
                step = 3
            } catch {
                isLoading = false
                errorMessage = "Could not load employee. Please try again."
                print(error)
            }
        }
    }

    private func makeEmail(first: String, last: String, company: String) -> String {
        let cleanedCompany = company
            .lowercased()
            .replacingOccurrences(of: " ", with: "")
        let cleanedFirst = first.lowercased()
        let cleanedLastInitial = last.lowercased().prefix(1)
        return "\(cleanedFirst)\(cleanedLastInitial)@\(cleanedCompany).com"
    }

    private func makeDraft(
        userName: String,
        employeeFirstName: String,
        role: String,
        company: String,
        includeSignature: Bool
    ) -> String {
        var lines: [String] = []

        lines.append("Hi \(employeeFirstName),")
        lines.append("")
        lines.append("I’m \(userName), and I’m really interested in \(role) work at \(company). I’d love to learn a bit more about your experience and what skills are most valuable on your team.")
        lines.append("")
        lines.append("If you’re open to it, I’d appreciate a quick 15–20 minute chat sometime this week or next.")
        lines.append("")
        if includeSignature {
            lines.append("Best,")
            lines.append(userName)
        }

        return lines.joined(separator: "\n")
    }
}

struct CoffeeHeader: View {
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(Color.brown)
                    .frame(width: 64, height: 64)

                Image(systemName: "cup.and.saucer.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 30))
            }

            Text("CoffeeTBL")
                .font(.largeTitle).bold()
                .foregroundColor(.brown)

            Text("Email Lookup & Outreach")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

struct UserInfoView: View {
    @Binding var userName: String
    var onNext: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Info")
                .font(.title2).bold()
                .foregroundColor(.brown)

            Text("We’ll use this in the closing of your email.")
                .font(.subheadline)
                .foregroundColor(.secondary)

            TextField("Your name", text: $userName)
                .padding()
                .background(Color.cream)
                .cornerRadius(12)

            Button(action: onNext) {
                Text("Next")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(userName.isEmpty ? Color.gray.opacity(0.4) : Color.brown)
                    .foregroundColor(.white)
                    .cornerRadius(14)
            }
            .disabled(userName.isEmpty)
        }
    }
}

struct EmployeeInfoView: View {
    @Binding var company: String
    @Binding var role: String

    let isLoading: Bool
    let errorMessage: String?
    let onGenerate: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Employee Info")
                .font(.title2).bold()
                .foregroundColor(.brown)

            Text("Tell us the company and the role you want to talk to.")
                .font(.subheadline)
                .foregroundColor(.secondary)

            TextField("Company (ex: Fidelity)", text: $company)
                .padding()
                .background(Color.cream)
                .cornerRadius(12)

            TextField("Role (ex: Product Manager)", text: $role)
                .padding()
                .background(Color.cream)
                .cornerRadius(12)

            if let error = errorMessage {
                Text(error)
                    .font(.footnote)
                    .foregroundColor(.red)
            }

            Button(action: onGenerate) {
                HStack {
                    if isLoading {
                        ProgressView()
                    }
                    Text(isLoading ? "Finding person..." : "Generate Email")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background((company.isEmpty || role.isEmpty) ? Color.gray.opacity(0.4) : Color.brown)
                .foregroundColor(.white)
                .cornerRadius(14)
            }
            .disabled(company.isEmpty || role.isEmpty || isLoading)
        }
    }
}

struct EmailResultView: View {
    @Environment(\.openURL) private var openURL

    let userName: String
    let employeeFirstName: String
    let employeeLastName: String
    let role: String
    let company: String
    let email: String

    @Binding var draftBody: String
    @Binding var includeSignature: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Result")
                .font(.title2).bold()
                .foregroundColor(.brown)

            let summaryItems: [(String, String)] = [
                ("Employee", "\(employeeFirstName) \(employeeLastName)"),
                ("Role", role),
                ("Company", company),
                ("Email", email)
            ]

            ForEach(summaryItems, id: \.0) { item in
                SummaryRow(title: item.0, value: item.1)
            }

            DraftOptionsView(includeSignature: $includeSignature) {
                draftBody = """
                Hi \(employeeFirstName),

                I’m \(userName), and I’m really interested in \(role) work at \(company). I’d love to learn a bit more about your experience and what skills are most valuable on your team.

                If you’re open to it, I’d appreciate a quick 15–20 minute chat sometime this week or next.

                \(includeSignature ? "Best,\n\(userName)" : "")
                """
            }

            Text("Email Draft")
                .font(.headline)
                .foregroundColor(.brown)

            ScrollView {
                Text(draftBody)
                    .padding()
                    .background(Color.cream)
                    .cornerRadius(12)
            }

            HStack {
                Button("Copy Draft") {
                    UIPasteboard.general.string = draftBody
                }
                .buttonStyle(CoffeeButtonStyle())

                Button("Open Mail") {
                    if let url = mailtoURL(to: email, body: draftBody) {
                        openURL(url)
                    }
                }
                .buttonStyle(CoffeeButtonStyle())
            }

            Button("Search on LinkedIn") {
                if let url = linkedinURL(first: employeeFirstName, last: employeeLastName) {
                    openURL(url)
                }
            }
            .buttonStyle(CoffeeButtonStyle())
        }
    }

    private func mailtoURL(to email: String, body: String) -> URL? {
        let subject = "Quick coffee chat?"
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "mailto:\(email)?subject=\(subjectEncoded)&body=\(bodyEncoded)"
        return URL(string: urlString)
    }

    private func linkedinURL(first: String, last: String) -> URL? {
        let nameQuery = "\(first) \(last)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://www.linkedin.com/search/results/all/?keywords=\(nameQuery)&origin=GLOBAL_SEARCH_HEADER"
        return URL(string: urlString)
    }
}

struct SummaryRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline).bold()
                .foregroundColor(.brown)
            Spacer()
            Text(value)
                .font(.subheadline)
        }
        .padding(.vertical, 4)
    }
}

struct DraftOptionsView: View {
    @Binding var includeSignature: Bool
    var onChange: () -> Void

    var body: some View {
        Toggle("Include my name at the end", isOn: $includeSignature)
            .onChange(of: includeSignature) { _ in
                onChange()
            }
    }
}

struct CoffeeButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.brown.opacity(configuration.isPressed ? 0.8 : 1.0))
            .foregroundColor(.white)
            .cornerRadius(14)
    }
}

#Preview {
    ContentView()
}
