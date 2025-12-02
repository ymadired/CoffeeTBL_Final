# ☕ CoffeeTBL – Email Lookup & Outreach

A SwiftUI iOS app that helps users quickly generate outreach emails by entering a company and role. The app "locates" an employee, generates an email draft, and provides tools to make networking easier and faster.

---

<img width="235" height="512" alt="image" src="https://github.com/user-attachments/assets/fa3529e9-7c0a-440a-a665-c1bb52fde837" />

<img width="235" height="512" alt="image" src="https://github.com/user-attachments/assets/629a0a1b-fa53-4b97-9c2f-0d6c7702f9bf" />

<img width="235" height="512" alt="image" src="https://github.com/user-attachments/assets/4c47b159-99ca-4f3e-b0db-4c5d29ee35cd" />

---

## Description

**CoffeeTBL** is a simple iOS app built using **SwiftUI** that generates professional outreach emails based on a target role and company.

The user enters:

* Their name
* A company
* A role

The app then:

* Generates a mock employee name
* Predicts an email address
* Creates a professional outreach message
* Provides quick-action buttons to copy the draft, open Mail, or search LinkedIn for the generated employee

**Tools Used**

* SwiftUI
* Xcode
* RandomUser API
* Custom UI colors and assets

---

## Features

* **Employee Lookup:**
  Automatically generates an employee name and email from a company and role input.

* **Instant Outreach Email Draft:**
  Produces a clean, professional email message ready to copy or send.

* **LinkedIn Search Button**
  Performs a one-tap search of the employee name on LinkedIn.

* **Simple 3-Step Flow:**
  Your Info → Employee Info → Email Draft.

* **Clean UI Design:**
  Aesthetic layout using card-style components, rounded edges, and custom colors.

---

## Obstacles & Future Additions

### Obstacles

* **Employee data scraping:**
  Free APIs for scraping or verifying employees were unreliable or blocked, so the current version uses random mock data.

* **Multi-page architecture issues:**
  Navigation and state transfer between multiple files caused sequence bugs, so the MVP uses a single SwiftUI file for the entire flow.

### Future Additions

* **Real employee lookup:**
  Integrate a reliable scraper or paid API to pull actual employees by company/role.

* **LLM-generated email variations:**
  Add AI-powered email generation with:

  * different tones
  * short/long versions
  * follow-up email templates

* **Follow-up email builder**
  Let users generate emails to follow-up on connections.
