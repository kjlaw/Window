# Window

Created by Kristen Law, Max Freundlich, and Elisa Lupin-Jimenez
Website: http://hci.stanford.edu/courses/cs147/2016/au/projects/MixedReality/Window/

##Installation
1. Clone the repo
2. Download cocoapods if not already installed
3. run `pod init`
4. run `pod install`
5. Launch xcworkspace
6. You should be good to go!

You will also need to print out a marker for the clothing items to be rendered above.  The marker we used can be found [here](https://github.com/kjlaw/Window/blob/master/Marker.pdf).

##About
Window uses augmented reality to place a custom mannequin with your proportions right in the store’s front window 
so you can check out what’s in stock without ever having to step inside. With intuitive swiping, customizable filters, 
and sharing capabilities, you’ll see shopping through a whole new lens.

##How to use
The first screen shown uses a "wizard of oz technique" to scan a store name. Instead of using an OCR, we display a red box that if tapped will turn green to mock the recognition of a store name and allow you to start shopping.  Clicking the “Start Shopping” button will take you to a selection of clothing items available at the store, displayed using AR.

On the AR screen, 3D models are rendered into the view above the marker. For marker and object rendering we are using the ARToolKit SDK. We downloaded the source code and rewrote some of the methods to better fit our needs. Swiping left and right will move the models in the view. 

Double tapping on a model will bring it up in the detail view. Clicking detection is done with halves on the screen in conjunction with the currently centered model. This means that we do not detect clicks on the surface of the 3d object, instead we use a “wizard of oz” technique where the top of the screen will correspond to the top piece of clothing and the bottom part of the screen will correspond to the bottom piece of clothing.

The top right of the AR view has a filter button that allows the user to specify gender, style, color, sizing, and price range. Selecting filters will display only the models that the user desires to see. Note that we did not implement every possible filtering combination. We implemented the ones necessary to complete our tasks as well as some additional filters. 

On the bottom right is a share button. This takes a screenshot of the current page and will format a text message containing this image to send to someone in your contacts. On the top left is a "home" button that will pull up a menu. From this menu a user can view their profile, begin the scan-store process again, view stores nearby, and view settings. Note that the profile, stores nearby, and settings all contain mock information.

##Where we want to go
We made this for CS147 at Stanford University. It was an incredible learning experience and we are very proud of what we created. All of
us would be excited it something like this were to become a reality. 
