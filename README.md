# Window

##Installation
1. Clone the repo
2. Download cocoapods if not already installed
3. run pod init
4. run pod install
5. You should be good to go!

##About
Window uses augmented reality to place a custom mannequin with your proportions right in the store’s front window 
so you can check out what’s in stock without ever having to step inside. With intuitive swiping, customizable filters, 
and sharing capabilities, you’ll see shopping through a whole new lens.

##How to use
The first screen shown uses a "wizard of oz technique" to scan a store name. Instead of using any OCR we display a red box that if tapped
will mock the recognition of a store name and allow access to the AR aspect of the app. 

On the AR screen, 3D models are rendered into the view on the marker. For marker and object rendering we are using the ARToolKit SDK. We
downloaded the sourcecode and rewrote some of the methods to better fit our needs. Swiping left and right will move the models in the view.
Selecting filters will display only the models that the user desires to see.

The models are all downloaded from the web and are here to display functionality. Higher quality models would be used in production.

On the bottom left is a share button. This takes a screenshot of the current page and will format a text message containing this image
to send to someone in your contacts.

On the top left is a "home" button that will pull up a menue. From this menu a user can view their profile, begin the scan-store process
again,view stores nearby, and view settings. Note that the profile, stores nearby, and settings all contain mock information.

##Where we want to go
We made this for CS147 at Stanford University. It was an incredible learning experience and we are very proud of what we created. All of
us would be excited it something like this were to become a reality. 
