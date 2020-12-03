#  Perpetua SpaceX Challenge

We provide our mobile candidates a challenge to showcase their abilities when implementing a basic iOS application that requests information from a REST API, written using Swift. This is meant to demonstrate your knowledge of not only the iOS platform, but also best practices for mobile development. What we're looking for is a strong iOS engineer who is also deeply familiar with the platform, so use your initiative how best you can showcase this.

## Rules

Usage of Xcode is recommended.
Please do not copy and paste solutions from the web if you encounter any, although using a search engine is perfectly fine.
You should spend around 2 hours total on this challenge, however if it takes longer that's perfectly fine! We don't want you spending all of your free time on it however, so try and timebox yourself to less than 3 hours.

## Setup

This was last tested with Xcode 11.3, and is fully functional.

## Goal

Using SpaceX's [open API](https://docs.spacexdata.com/ ), we would love to have an app that is able to list Rocket Launches, along with the ability to click into a Launch for additional information on the rocket. For reference, check out the included [gif](spacex.gif)

In the list, we would like to see the following for each launch:
    - The patch image
    - The name of the mission
    - The day/time that it was launched
    - The status of the launch (failed, successful, upcoming)

After tapping on a launch in the list, we would like to have a screen that shows the following information about the rocket
    - The rocket name
    - The rocket type
    - Whether it was reused or not

## Technical Requirements

You are free to use any first class technologies you'd like (Autolayout, Storyboard, Xibs, etc) 
**note: Perpetua is entirely programmatic autolayout and does not make use of Interface Builder**

You are able to edit the project as you see fit - including adding, deleting and modifying any files that you would like.

### Dependencies

You are able to incorporate dependencies, however please let us know reasoning for including any libraries. Using dependencies is not required.
**note: Perpetua uses Carthage + SPM to manage dependencies**

## Design Requirements

### Launch List

- Launch Cell
    - mission name should have size 16 font, semibold, black
    - launch date should have size 14 font, medium, gray
    - image should be 56x56
    - if the image is loading, display the provided [placeholder image](SpaceXChallenge/Assets.xcassets/launch_placeholder.imageset/spacex_logo_square.png)
    - status should have size 12 font, bold, red if failed, green if success, blue if upcoming

### Rocket Details

- rocket name should be size 18 font
- rocket type and whether its reused should be size 14 font
## Helpful Notes

We will be evaluating the code that you send back to us.
Comments are not required, however you will be judged on your ability to write clean, well architected code. Keep that in mind while implementing your solution.

## When Completed...

Zip up the entire project and send it back to us. If you chose any third party dependencies, please let us know instructions on how to get the project running!
