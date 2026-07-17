# ALU Catalyst
This project was build for the ALU community to bridge the gap between the challenge of limitted internships and the strugle to find qualified labour force.

## Objectices
•	Enable startups to post verified internship/opportunity listings
•	Enable students to discover, filter, and apply to opportunities

## Features
- Email/password authentication restricted to ALU emails (@alustudent.com, @alueducation.com), with role selection (student or startup founder) at sign-up

- Opportunity discovery feed with category filter chips and live Firestore updates

- Application form and tracking; students apply directly from an opportunity's details page and receive a confirmation on submission

- Real-time status updates; status changes made by a startup founder propagate live to anywhere that application is displayed, via Firestore streams

- Settings and Help & Support pages, with dark mode toggle and language selector
- Shared preferences features


## Security Rules 
- Opportunities are publicly readable but only the posting startup's founder can create/edit/delete them
- Applications can only be created by an authenticated user; only the applicant or the owning startup's founder can read or update one
- Only ALU-domain emails (`@alustudent.com`, `@alueducation.com`) can create a `users` profile document

## UI/UX Reasoning
- Role-based navigation: students and startup founders see structurally different home experiences (a discovery feed versus a dashboard), since their goals, permissions, and most-used actions differ substantially rather than being variations on one generic screen.

- Category chips over search alone: tappable filters are faster than typing a query for a small-to-medium opportunity list, and make available categories discoverable to new users


## Tech stack
- firebase Auth
- Firestore Auth for email/password sign-in, restricted to ALU domains
- Cloud Firestore; primary database for users, startups, opportunities, and applications
- Provider for State management
- Flutter for plattform UI

## Firebase Backend Structure
Authentication and four Firestore collections(see schema below)
### Firestore schema
`users`

| Field | Type | Description |
|---|---|---|
| uid | string (doc ID) | Firebase Auth UID |
| role | string | `'student'` or `'startup'` |
| name | string | Display name |
| bio | string | Short profile bio |
| skills | array\<string\> | Tags used for skill matching |

`startups`

| Field | Type | Description |
|---|---|---|
| startupId | string (doc ID) | Unique startup identifier |
| startupName | string | Startup name |
| description | string | About the startup |
| industry | string | Startup's industry/sector |
| logo | string | URL to startup logo image |
| founder | string | UID of the founder account |
| email | string | Contact email |
| website | string | Startup website |
| location | string | City/campus location |
| members | array\<string\> | Team member identifiers |
| createdAt | timestamp | Startup profile creation date |

`Opportunities`

| Field | Type | Description |
|---|---|---|
| oppId | string (doc ID) | Unique opportunity identifier |
| startupId | string | Reference to `startups/{startupId}` |
| startupName | string | Denormalized for cheap list reads |
| title | string | Role title |
| description | string | Role details |
| category | string | e.g. Software Development, Marketing |
| type | string | e.g. Internship, Part-time, Event |
| duration | string | e.g. "3 months" |
| location | string | Where the role is based |
| requirements | array\<string\> | Used for skill-match scoring |
| deadline | timestamp | Application deadline |
| postedBy | string | UID of the poster |
| createdAt | timestamp | For sorting newest-first |

`application`
| Field | Type | Description |
|---|---|---|
| appId | string (doc ID) | Unique application identifier |
| opportunityId | string | Reference to `opportunities/{oppId}` |
| studentId | string | Reference to `users/{uid}` |
| startupId | string | Reference to `startups/{startupId}` |
| studentName | string | Denormalized for cheap list reads |
| studentEmail | string | Contact information |
| phone | string | Contact phone number |
| resumeUrl | string | Link to uploaded resume (stubbed) |
| coverLetter | string | Student's motivation statement |
| opportunityTitle | string | Denormalized for cheap list reads |
| startupName | string | Denormalized for cheap list reads |
| status | string | `'pending'` / `'accepted'` / `'rejected'` |
| appliedAt | timestamp | For sorting |
 
## System architecture
The app follows a layered architecture: UI screens never call Firestore directly. Instead, they read state exposed through Provider (ChangeNotifier), which in turn goes through a Firestore service layer that isolates all reads and writes from the rest of the app.

- <img width="425" height="283" alt="image" src="https://github.com/user-attachments/assets/671663be-4e04-4675-900a-49c0e705dc2b" />

## State Management Approach
ALU Connect uses the Provider package for state management in selected parts of the application where shared or reactive state was required. Provider was mainly used to manage application-level states such as user-related data and UI updates that needed to be accessed across multiple widgets. However, not every screen uses Provider because many parts of the application rely on local widget state (`setState`) or direct Firebase interactions where introducing global state management would add unnecessary complexity. This approach follows a practical state management strategy by using Provider only where it improves code organization, maintainability, and data flow, while keeping simpler screens lightweight.

## How to run
Prerequisites:
- Flutter SDK (3.x or later)
- A Firebase project with Authentication (Email/Password and gmail enabled) and Cloud Firestore created
- FlutterFire CLI installed
- Setup firebase console(authentication, firestore database)

setup 
```
# clone the repo
git clone https://github.com/Linda5-umwali/LindaUmwali_FinalFlutterProject.git

# install  dependencies
flutterr pub get

# connect flutter project to firebase project
flutterfire configure

flutter run
```
### Author
Linda Umwali
