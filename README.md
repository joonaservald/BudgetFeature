# BudgetFeature

A SwiftUI feature package that displays budget overview for the current month.

<img height="600" alt="image" src="https://github.com/user-attachments/assets/bfe8d2c7-5dc7-4e30-a209-97c3c48036d2" /><img height="600" alt="image" src="https://github.com/user-attachments/assets/92da1518-2078-4d62-9371-e66278573cc6" />



## How to use / run

The package was made using Xcode 26.2. It requires Swift 6.2 and iOS 17+.

Add package dependency into `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/joonaservald/BudgetFeature", from: "1.0.0")
]
```

Use the public entry view:

```swift
import SwiftUI
import BudgetFeature

struct ContentView: View {
    var body: some View {
        BudgetOverviewView()
    }
}
```

## Architecture

Based on MVVM with SwiftUI's `@Observable`. I did not include any coordinator / router logic since the feature itself is quite small. 
Public entry point is `BudgetOverviewView`. The host app can inject dependencies or use the default `BudgetService`.
Since the module implementation does not require networking, I have omitted `Sendable` from some models as they are not required for this implementation but obviously this is not consistent with a real-world scenario. 

I have separated data transfer objects from the ones that the views use for maintainability. Only `Transaction` is shared since I did not want to introduce duplication of the model. 

For a bigger task I would've maybe gone with a coordinator or a different architecture entirely but in this scenario it would've been an overkill. 
Building a lot of generic routing or flow logic is out of scope for a two-view feature. 
I could've also added a VideModel for the `SpendingCategoryDetail` View but I felt that this would've artificially padded the feature without any real benefit other than introducing more boilerplate. 

## Localization

Current solution uses `Localizable.xcstrings` with generated localization keys for type safety. 
The solution was introduced with Xcode 26 and I believe is sufficient for the given scope.

## What could be improved

### Architecture

If this would be developed into a larger feature, then I would first revisit the routing logic and introduce a generic way of routing.
Real apps and bigger features introduce navigational difficulties that are hard to maintain without it.
I am personally a huge fan of uber/RIBs although I would implement it with less boilerplate and overhead. But there are great alternatives and anything that is modular, maintainable and allows to separate business logic from view and navigational logic is a winner. Bonus points if the architecture also helps deal with any possible retention loops, lifecycle issues or other memory leak problems.

In bigger projects I also like to use project generation (Tuist, XcodeGen, or similar) where possible. It was not necessary for this task since it is a SPM package.

### Resources

Currently I use an enum to handle the color scheme. Although it supports light and dark mode, in a bigger feature this can get out of hand quite fast. There are third party tools to fix this or the solution could be broken up into smaller bits manually when necessary. For the given task I believe current solution is enough. Given the scope of the task, it might've been a good idea to allow injecting a "theme" into the feature but I think for the task this would have been overengineered.

## Testing

Uses Swift Testing framework to cover the `BudgetOverviewViewModel` unit tests. 
`BudgetService` is a protocol and thus allows mock injection.

## Repository

Git commit style is loosely based on the guidelines of [Chris Beams](https://chris.beams.io/posts/git-commit/).
