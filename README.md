# Happy Messages to You!

This project implements a message service library and frontend UI for a simple messaging app.
The main goal of this project is to design, document, and test a solution using this [REST
API](https://abraxvasbh.execute-api.us-east-2.amazonaws.com/proto/messages).

## Design Decisions

SwiftUI was chosen for the frontend implementation for it's rapid development time. The app is broken into various
components that can be developed independently from eachother (mostly, see future improvements).

+ AppComponent - Main UI loaded on app startup, responsible for listing main messages feed and presenting UI based on
login state.
+ AuthComponent - Allows the user to login to the app and select a username.
+ MessagesListComponent - A reusable message listing component that can fetch its own data and track the state of its
network calls. A username can be provided to scope the API query.
+ PostingComponent - UI to build and send a post to the API.

### Components

Components are the basic building blocks of the app UI. I've kept them simple for the first iteration.

+ View - UI related layout using SwiftUI. The view code converts the component's current state into an onscreen
representation.
+ State - Current state of the component. Provides reactive (via Combine) variables that the view can subscribe to so it
knows when to re-render. The state also currently provides methods to mutate app state given user actions.

### MessageService Swift Package

A Swift package was created to encapsulate the REST API calls into an easy to consume library for the frontend.

[Documentation and design thinking](MessageService/docs)

[Interactive Playground!](MessagePlayground.playground)

### Future Improvements

The biggest limitation currently with the component structure is inside the state. Currently, state objects mutate
themselves based on actions from the UI. This works for now since the app is simple, but as it grows the state objects
will become overly complex and hard to debug. A reducer pattern could be used to provide pure function state
transitions. Having immutable state objects will also allow some neat tricks such as app rehydration from serialized
state objects.

Another nice to have would be some sort of builder pattern for the components to standardize dependency injection and make creating new components simpler and more consistent. Currently there isn't a standard pattern to building a view and providing its state in the app.

## Testing

Status: 

+ MessageService package tests: 100%
+ Component State tests: none
+ Component View tests: none

### Future Plans

A more comprehensive UI testing strategy would be created as well as a test plan on a CI server (such as Bitrise). 
