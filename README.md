# Persons
A master-detail iOS app developed as a test task.
This project demonstrates my preferred architecture, project structure, and technology stack.

### Prerequisites
- Xcode 16.2
- Pipedrive API credentials (company domain + API token)

### Setup Instructions
⚠️ Before opening the project, run the following command:
```sh
make auth credentials=COMPANY_DOMAIN,API_TOKEN
```
This command:
- Generates an obfuscated file containing the app's secrets,
- And places a gitignored file with the same credentials in the `PipedriveAPI` package's tests folder.

Now you can open the `Persons.xcodeproj` file.

### Scalable and Collaborative Development
To make the project easy to scale and collaborate on, I follow a simple principle: isolate solutions to different problems so developers can focus on one thing at a time without worrying about unrelated parts of the system.
- I prefer extracting reusable components (such as networking, caching, UI elements, or complex logic) into Swift packages. This keeps them independent, easier to test, and allows multiple developers to work on them without affecting the main app.
- Screens should be fully functional in SwiftUI Previews, enabling developers to build the UI without relying on real data, other screens, or backend dependencies.
- Developers should be able to work on navigation flows using placeholder views, making it easy to build and test navigation without requiring fully implemented screens.

This approach ensures the project remains clean, scalable, and easy to maintain.

### Packages
- `PipedriveAPI` – Can be opened separately and used like a Postman collection. You can run tests and check backend responses in the console. More methods can be added manually or generated from an OpenAPI schema.
- `Cache` – A simple cache for any `Codable` types, following the `Caching` protocol. If the data grows, it can be replaced with a Core Data or SwiftData implementation.
- `Views` – Reusable views built like standard SwiftUI components, using generics and ViewBuilders.

### Tests
Besides package tests, there are UI tests.
Run them with:
```sh
make ui-tests
```

### CI
This project uses GitHub Actions to automate checks.

Check [workflow](.github/workflows/check.yml):
- Verifies code formatting.
- Uses repository secrets to generate an obfuscated file (needed for the build).
- Runs package tests if any of its files were changed.
- Runs UI tests if code or config was modified.

### About XcodeGen and `.xcodeproj`
This project uses [XcodeGen](https://github.com/yonaskolb/XcodeGen) for project configuration, with the `project.yml` file as the source of truth.
While I typically recommend excluding `.xcodeproj` from the repository, I’ve included it here for the reviewers' convenience. 

Here’s why `.xcodeproj` should be gitignored in favor of `project.yml`:
- Fewer merge conflicts: `.xcodeproj` files often cause issues during merges.
- Keeps git history clean by avoiding unnecessary `.xcodeproj` changes.
- `project.yml` is shorter, more readable, and easier to manage.

### Other Notes
- `DataLoader` actor ensures that duplicate requests for the same resource never happen. For example, if one screen requests data and another screen requests the same data a second later, `DataLoader` will wait for the first request's response instead of creating a new one.
- `AsyncContentView` is more complex than it could be due to the pull-to-refresh mechanism.
- `Destination.empty` used in previews because `nil` changes `NavigationLink` appearance.

### Things to Improve
- `CachePolicy` could be moved to a `Primitives` package, which would be used as a dependency by the `Views` package, the `Cache` package, and the app.
- If `PersonDetailsView` needs more data than the `/persons` response provides, it should receive only `Person.ID`, and `PersonDetailsView` should also use `AsyncContentView`.
- `AsyncContentView` could support more container types, like a simple VStack.
- The `createAndDeletePerson` test case isn’t ideal since it tests two methods at once, but separating them would leave the database cluttered with test data.

### Missing Details & Questions
In a real project, I would ask for more details to clarify the requirements, such as:
- How important is iPad support? If required, probably NavigationSplitView should be used. Is landscape orientation required?
- Which person's properties should be displayed?
- What is the lowest iOS version that needs to be supported?
- Should the app support multiple languages?
