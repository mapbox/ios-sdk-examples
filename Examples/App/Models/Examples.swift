import Foundation

enum ExampleLanguage {
    case objc
    case swift
}

struct Example {
    var title: String
    var description: String
    var language: [ExampleLanguage]
    var fileName: String
}

struct ExampleGroup {
    var groupTitle: String
    var examples: [Example]
}

struct TestData {
    static let allExamples = [
        ExampleGroup(groupTitle: "Markers and callouts", examples: [
           Example(title: "Add a basic marker", description: "Add the default Mapbox marker to a map", language: [.swift, .objc], fileName: "SimpleMapViewExample.swift"),
           Example(title: "Display a callout", description: "Display additional information inside a callout", language: [.swift, .objc], fileName: "AnimatedLineExample.swift")
        ]),
        ExampleGroup(groupTitle: "User interaction", examples: [
           Example(title: "Restrict map movement", description: "Prevent the user from panning outside of a certain area", language: [.swift, .objc], fileName: "SomeFileName"),
           Example(title: "Show and hide layers", description: "Toggle a layer's visibility", language: [.swift, .objc], fileName: "AnimatedLineExample.swift"),
           Example(title: "Select a feature on the map", description: "Respond to a user tapping on the map", language: [.swift, .objc], fileName: "SwitchStylesExample.swift"),
           Example(title: "Create draggable markers", description: "Add draggable UIView markers to the map", language: [.swift, .objc], fileName: "SwitchStylesExample.swift")
        ])
    ]
}
