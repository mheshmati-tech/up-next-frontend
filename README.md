# Up Next
##### An iOS app that generates Spotify playlists of songs by artists with upcoming concerts in your city.

Concert lovers are often in search of upcoming shows in their area. They can turn to Spotify to see a list of concerts by artists they follow, but this list does not include artists they don't already know and it is not linked to a playlist. Up Next generates genre-filtered playlists of songs by artists with upcoming concerts in a given city to help users more easily discover new artists and decide which concerts they would be interested in attending.

Up Next was developed as a capstone project for [Ada Developer's Academy](https://adadevelopersacademy.org/), a nonprofit coding bootcamp for women and gender diverse people in Seattle, WA.

## Technologies
- Back-end:
  - Python Flask API wrapper
- Front-end:
  - Swift (using XCode)
- Infrastructure:
  - The Flask API wrapper is deployed to Heroku
- APIs:
  - Spotify Web API
  - Ticketmaster Discovery API

## Installation
Download this repository, open it in XCode 11.3, and add the following dependencies to your XCode project.
  - Dependencies:
    - [Spotify iOS SDK 1.2.0](https://developer.spotify.com/documentation/ios/quick-start/)
    - [Keychain Swift](https://github.com/evgenyneu/keychain-swift)

Follow the [Spotify iOS SDK installation instructions](https://developer.spotify.com/documentation/ios/quick-start/) and update your project's configurations as necessary. You will need to create a Spotify App in your [Spotify Developer Dashboard](https://developer.spotify.com/dashboard/login) to receive a Spotify Client ID and Client Secret.

Create a file in the "Model" folder of your XCode project called ClientData.swift. In that file, create a struct called ClientData containing the variable clientID which holds your Spotify Client ID. Make sure that this file is included in your gitignore so that it is not committed to github.

If you want to use your own back-end, download the [back-end repository](https://github.com/michaela260/up-next-backend) and its dependencies, and deploy it to Heroku with the required environment variables. You will need to replace the token swap and refresh URLs in the LogInViewController with your own deployed URLs.

Build the project on an iPhone 11 or simulator with iOS 13.2+.

## Learning Goals
- Develop an iOS app using Swift and XCode
- Build an API wrapper back-end using Python and Flask
- Implement an authorization flow with OAuth 2 in a mobile application
- Better understand how to integrate external API data into a front-end mobile application