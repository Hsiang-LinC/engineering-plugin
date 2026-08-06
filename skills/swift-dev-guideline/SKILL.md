---
name: swift-dev-guideline
description: Use when writing, reviewing, debugging, or refactoring Swift 6.2, SwiftUI, or SwiftData code for iOS 26 and later in an Xcode project.
---

# Swift Development Guideline

Act as a senior iOS engineer. Follow Apple Human Interface Guidelines and App Review requirements. Prefer modern, safe platform APIs and do not add third-party frameworks without approval.

## Workflow

1. Inspect the deployment target, Swift version, default actor isolation, persistence configuration, localization setup, and existing project conventions.
2. Reuse existing project patterns where they comply with these rules. Avoid UIKit unless requested, and ask before introducing a third-party dependency.
3. Keep view logic testable outside the view layer and add unit tests for core logic. Add UI tests only when unit tests cannot cover the behavior.
4. If Xcode MCP is available, prefer `DocumentationSearch`, `XcodeRead`, `XcodeWrite`, and `XcodeUpdate`; then use `BuildProject`, `GetBuildLog`, `RenderPreview`, `XcodeListNavigatorIssues`, or `ExecuteSnippet` as appropriate.
5. Build after changes. If SwiftLint is installed, require a clean SwiftLint result before committing.

## Swift

- Assume Swift 6.2 strict concurrency. Prefer `async`/`await`; never use `DispatchQueue.main.async()` when Swift concurrency covers the behavior.
- Mark `@Observable` reference types `@MainActor` unless the project uses Main Actor default isolation. Flag violations.
- Model shared data with `@Observable`; own it with `@State` and pass it with `@Bindable` or `@Environment`.
- Use `ObservableObject`, `@Published`, `@StateObject`, `@ObservedObject`, or `@EnvironmentObject` only for unavoidable legacy or integration boundaries.
- Prefer Swift-native operations over older Foundation equivalents, such as `replacing(_:with:)` over `replacingOccurrences(of:with:)`.
- Prefer modern URL APIs such as `URL.documentsDirectory` and `appending(path:)`.
- Format values with `FormatStyle`, never C-style formatting or legacy `Formatter` subclasses. Parse dates with strategies such as `Date(value, strategy: .iso8601)`.
- Prefer static member lookup where available, such as `.circle` and `.borderedProminent`.
- Filter user-entered text with `localizedStandardContains()`.
- Avoid force unwraps and forced `try` unless failure is genuinely unrecoverable.

## SwiftUI

- Use `foregroundStyle()` instead of `foregroundColor()` and `clipShape(.rect(cornerRadius:))` instead of `cornerRadius()`.
- Use the `Tab` API instead of `tabItem()`.
- Use the zero- or two-parameter `onChange()` overload, never the one-parameter overload.
- Use `Button` for actions. Use `onTapGesture()` only when tap count or location is required.
- Use `Task.sleep(for:)`, never `Task.sleep(nanoseconds:)`.
- Never derive layout from `UIScreen.main.bounds`. Prefer modern layout APIs over `GeometryReader`, including `containerRelativeFrame()` and `visualEffect()`.
- Extract substantial view sections into separate `View` types, not computed view properties.
- Support Dynamic Type; do not force font sizes. Prefer `bold()` over `fontWeight(.bold)` and avoid `fontWeight()` without a specific need.
- Use `NavigationStack` with `navigationDestination(for:)`, not `NavigationView`.
- Give image buttons a text label, for example `Button("Add", systemImage: "plus", action: add)`.
- Render SwiftUI content with `ImageRenderer`, not `UIGraphicsImageRenderer`.
- Iterate enumerated collections directly: `ForEach(items.enumerated(), id: \.element.id)`, not `ForEach(Array(items.enumerated()), ...)`.
- Hide scrolling indicators with `.scrollIndicators(.hidden)`. Prefer `ScrollPosition`, `defaultScrollAnchor`, and current scrolling APIs over `ScrollViewReader`.
- Avoid `AnyView`, hard-coded padding or stack spacing unless requested, and UIKit colors in SwiftUI.

## SwiftData with CloudKit

When the model container uses CloudKit:

- Do not use `@Attribute(.unique)`.
- Give every model property a default value or make it optional.
- Make every relationship optional.

## Project hygiene

- Organize source by app feature and use consistent Swift naming.
- Put separate types in separate Swift files.
- Add comments only where they clarify intent or non-obvious behavior.
- Never commit secrets or API keys.
- When `Localizable.xcstrings` exists, prefer symbol keys with `extractionState` set to `manual` and generated members such as `Text(.helloWorld)`. Offer translations for every language already supported by the project.
