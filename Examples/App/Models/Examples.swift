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
        ExampleGroup(groupTitle: "GROUP A", examples: [
           Example(title: "We're no strangers to love", description: "Add a marker to the map", language: [.swift, .objc], fileName: "SimpleMapViewExample.swift"),
           Example(title: "You know the rules and so do I", description: "Animate a line along a path", language: [.swift, .objc], fileName: "AnimatedLineExample.swift"),
           Example(title: "A full commitment's what I'm thinking of", description: "Switch between map styles", language: [.swift, .objc], fileName: "SwitchStylesExample.swift")
        ]),
        ExampleGroup(groupTitle: "GROUP B", examples: [
           Example(title: "You wouldn't get this from any other guy", description: "Add a marker to the map", language: [.swift, .objc], fileName: "SomeFileName"),
           Example(title: "I just wanna tell you how I'm feeling", description: "Animate a line along a path", language: [.swift, .objc], fileName: "AnimatedLineExample.swift"),
           Example(title: "Gotta make you understand", description: "Switch between map styles", language: [.swift, .objc], fileName: "SwitchStylesExample.swift"),
           Example(title: "Never gonna give you up", description: "Switch between map styles", language: [.swift, .objc], fileName: "SwitchStylesExample.swift"),
           Example(title: "Never gonna let you down", description: "Switch between map styles", language: [.swift, .objc], fileName: "SwitchStylesExample.swift"),
           Example(title: "Never gonna run around and desert you", description: "Switch between map styles", language: [.swift, .objc], fileName: "SwitchStylesExample.swift"),
           Example(title: "Never gonna make you cry", description: "Switch between map styles", language: [.swift, .objc], fileName: "SwitchStylesExample.swift"),
           Example(title: "Never gonna say goodbye", description: "Switch between map styles", language: [.swift, .objc], fileName: "SwitchStylesExample.swift"),
           Example(title: "Never gonna tell a lie and hurt you", description: "Switch between map styles", language: [.swift, .objc], fileName: "SwitchStylesExample.swift")
        ])
    ]
}
