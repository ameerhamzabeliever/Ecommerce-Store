# pisiffik_ios

Supports: iOS 13.x and above

## Branches:

* main - stable app releases
* develop - development branch

## Dependencies:

The project is using cocoapods for managing external libraries and a Gemfile for managing the cocoapods version.

Get Bundler

```
sudo gem install bundler
```

To install the specific cocoapods version run

```
bundle install
```

Then install the pods

```
bundle exec pod install
```

### Core Dependencies

* Swiftlint - A tool to enforce Swift style and conventions.
* R.swift - Get strong typed, autocompleted resources like images, fonts and segues in Swift projects

## Project structure:

* Resources - fonts, strings, images, generated files etc.
* SupportingFiles - configuration plist files
* Models - model objects
* Modules - contains app modules (UI + Code)
* Helpers - protocols, extension and utility classes
