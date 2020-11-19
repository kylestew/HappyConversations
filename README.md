# Happy Messages to You!

This project implements a message service library and provides examples and documentation for client usage. 
The main goal of this project is to design, document, and fully test a client library for this [REST
API](https://abraxvasbh.execute-api.us-east-2.amazonaws.com/proto/messages).

## MessageService Swift Package

A Swift package was created to encapsulate the REST API calls into an easy to consume library for the frontend.

[Documentation and design thinking](MessageService/docs)

[Interactive Playground!](MessagePlayground.playground)

## Design Decisions

SwiftUI was chosen for the frontend implementation for it's rapid development time. The app is broken into various
components that can be developed independently from eachother (mostly).

+ AppComponent - Main UI loaded on app startup, responsible for listing main messages feed and presenting UI based on
login state.
+ AuthComponent - Used to login the user
+ MessagesListComponent - A reusable message listing component that can fetch its own data and track the state of its
network calls.
+ PostingComponent - UI to build and send a post to the API.

### Components

Components are the basic building blocks of the app UI. I've kept them simple for the first iteration.

+ View - UI related layout using SwiftUI. The view code converts the component's current state into an onscreen
representation.
+ State - Current state of the component. Provides reactive (via Combine) variables that the view can subscribe to so it
knows when to re-render.

### Future Improvements

The biggest limitation currently with the component structure is inside the state. Currently, state objects mutate
themselves based on actions from the UI. This works for now since the app is simple, but as it grows the state objects
will become overly complex and hard to debug. A reducer pattern could be used to provide pure function state
transitions. Having immutable state objects will also allow some neat tricks such as app rehydration from serialized
state.

Another nice to have would be some sort of builder pattern for the components to standardize dependencies and the
interface for creating components.

## Testing

Status: 

+ MessageService package tests: 100%
+ Component State tests: none
+ Component View tests: none

### Future Plans

A more comprehensive UI testing strategy would be created as well as a test plan on a CI server (such as Bitrise). 
