# Unity_PPSDK_plugin
Unity plugin files for playPORTAL SDK.

## Overview
The playPORTAL SDK, as supported with this Unity plugin, provides a simple mechanism for achieving COPPA compliance in Unity games. This README will cover the basics of getting started with this plugin.


### Getting Started for iOS
    - Download this git repo

#### Add files to project
    - Create a Assets/Plugins/iOS directory (if it doesn't exist) in your Unity project
    - Copy the UnityBindings.m file into that directory
    - Copy the PlayPortalController.cs file into your scripts directory (in Unity) so that it can be accessed by your PlayerController.cs file. 

#### Unity Player Settings
    -In the top level settings, select the iphone icon
    - In your Player Settings, make the following changes:
      - Other Settingss: Add Supported URL Schemes: Size:1 and Element 0: ProductName
      - Set Scripting Backend is: IL2CPP
      - Check Automatically Sign
      - Enter the name of your Apple Dev Team

#### Build and Run
     - Tap Build and Run
     - when Unity completes this step, it should have launched Xcode

#### In Xcode
     - Add the PPSDK framework (see instructions below) to the Classes Folder
     - Verify that the UnityBindings.m file is in the Libraries/Plugins/iOS folder
     - Select Targets/Unity-iPhone --> Build Phases
     - Add the following frameworks by tapping --> Link Binary with Libraries
       - Security.framework
       - Webkit.framework
       - MobileCoreServices.framework
       - SafariServices.framework

     - Select Targets/Unity-iPhone --> Info
     - Expand the URL Types()
       - Add 1 row with Identifier: NameFrom_PlayPortal_App_Config  and  URL Schemes: "Same name as Id"

     - Select an attached target
     - Tap "run" 
     - App should build


### Utilizing SDK functionality




-----

### Getting Started for Android
    - coming soon