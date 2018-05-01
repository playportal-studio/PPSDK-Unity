![](./readmeAssets/wordmark.png)
##### playPORTAL <sup>TM</sup> provides a service to app developers for managing users of all ages and the data associated with the app and the app users, while providing compliance with required COPPA laws and guidelines.

# Unity\_PPSDK\_plugin
Unity Plugin for playPORTAL SDK by Dynepic, Inc.

## Overview
The playPORTAL SDK, as supported with this Unity plugin, provides a simple mechanism for achieving COPPA compliance in Unity games. This README will cover the basics of getting started with this plugin.

## Getting Started

* ### <b>Step 1:</b> Create playPORTAL Partner Account

	* Navigate to [playPORTAL Partner Dashboard](https://partner.iokids.net)
	* Click on <b>Sign Up For Developer Account</b>
	* After creating your account, email us at [info@playportal.io](mailto:info@playportal.io?subject=Developer%20Sandbox%20Access%20Request) to verify your account.
  </br>

* ### <b>Step 2:</b> Register your App with playPORTAL

	* After confirmation, log in to the [playPORTAL Partner Dashboard](https://partner.iokids.net)
	* In the left navigation bar click on the <b>Apps</b> tab.
	* In the <b>Apps</b> panel, click on the "+ Add App" button.
	* Add an icon, name & description for your app.
	* For "Environment" leave "Sandbox" selected.
	* Click "Add App"
  </br>

* ### <b>Step 3:</b> Generate your Client ID and Client Secret

	* Tap "Client IDs & Secrets"
	* Tap "Generate Client ID"
	* The values generated will be used in 'Step 4'.
  </br>


* ### <b>Step 4:</b> Download/Clone this repo.
	*  This repo contains the dynepic-ppsdk.unitypackage

* ### <b>Step 5:</b> Import the Unity Package
	* In the Unity menu select: "Assets" --> "Import Package" --> "Custom Package"
	* Navigate to the directory where you cloned/downloaded this repo and choose the dynepic-ppsdk.unitypackage or the dynepic-ppsdk-withscene.unitypackage
	* If you are trying the playPORTAL SDK for the first time, it's easiest to use the package with the test scene as the scene binds the controllers (C# files) to the objects in the scene.
	* Ensure that all of the items are selected and click "Import"
	* If using the "withscene" package, then switch into the Unity project view (Unity main menu --> Window --> Project). Then double click the "prescene-v1" scene (looks like the Unity logo). This will instantiate a scene, two 3D objects (a sphere and a capsule), and make the appropriate script/object associations. The sphere will also be renamed as "Player". The capsule object may overlay the player object in the scene view, but can be moved without impact.

* ### <b>Step 6:</b> Add Client ID and Client Secret:
	* In "PlayerController.cs"  replace the following values with the values generated in 'Step 3':
	```
	private static string myClientID = @"<YOUR_CLIENT_ID_HERE>";
	private static string mySecret = @"<YOUR_CLIENT_SECRET_HERE";
	```

* ### <b>Step 7:</b> Player Setup
	* In the Unity menu select: "Edit" --> "Project Settings" --> "Player"
	* In the Unity "Inspector" window, select the phone icon:
		* ![](./readmeAssets/unity-phone.png)
		* Look in the window below...
	* Other Settings / Identification
		* Check Automatically Sign
		* Automatic Signing Team ID: Your Apple Dev Team (this can be done in Xcode as well)
	* Other Settings / Configuration
		* Scripting Backend: "IL2CPP"
  	* Supported URL Schemes -  Size: 1, Element 0: "PRODUCT_NAME" (insure Element 0 matches the redirect URL entered in the PlayPortal. "/redirect" is not required on this URI).

* ### <b>Step 8:</b> Build & Run
	* In the Unity menu select: "File" --> "Build and Run"
	* When Unity completes this step, it should have launched Xcode.

* ### <b>Step 9:</b> XCode Setup
    * Select Targets/Unity-iPhone --> Build Phases
    * Add the following frameworks by tapping --> Link Binary with Libraries, the "+" for each of:
       - Security.framework
       - Webkit.framework
       - MobileCoreServices.framework
       - SafariServices.framework

    * Select an attached target device
		- Tap "Play button" (run)
		- App should build and run on the attached iOS device
     	- Note: If Xcode generates an error regarding Objective-c exceptions; fix error in Xcode by selecting "Project" / "Unity-iPhone" and search for "exception". Set "Enable Objective-C Exceptions" to "Yes".
		- Tap "Play" button again

-----

### Utilizing SDK functionality
After the Unity environment configuration is complete, it's time to configure your Unity application to utilize the playPORTAL SDK for various operations.

#### Configuring the SDK runtime
The SDK must be configured in conjunction with the playPORTAL, so that your Unity app can consume playPORTAL services. The following must be done (statements in grey blocks are code snippets and examples can be seen in the Unity_PPSDK_example project):

* Edit your PlayerController.cs script
	* There is a *starter* PlayerController.cs included with the dynepic-ppsdk.unitypackage. It provides a trivial example of using SSO, and the script just needs to be attached to your *player* object via Unity "Inspector".

	* Include the PlayPortal namespace by adding the following statement at the top of your app.
	```
	using PlayPortal;
	```

	* Update your myClientID and mySecret string vars with the information from your app definition/configuration in playportal.io.
		```
		private static string myClientID = @"<YOUR_CLIENT_ID_HERE>";
		private static string mySecret = @"<YOUR_CLIENT_SECRET_HERE";
		private static strimng myRedirectURI = @"appname/redirect";  // this must match Unity Other settings
		```

	* Define and Instantiate a class level PlayPortalController object to use for communicating with the playPORTAL:
		```
		public PlayPortalController ppsdk;
	        ppsdk = PlayPortalController.Instance;
		```
	* Instantiate a playerObject to use for storing player profile information:
		```
		public PPSDK_PlayerObject playerObject = new PPSDK_PlayerObject();
		```

	* Instantiate a method to receive callbacks from Unity message notifications ("true" on login success, else "false").
	```
	public void playPortalLoginDidSucceed(string p) {
		if(p == "true") 
		{
			// login success
			playerObject = ppsdk.GetPlayerObject();
			Debug.Log("PlayerController player:" + playerObject);
		} else {
			// present some error status
		}
	}
	```


Your app is now ready to begin making calls into the PPSDK plugin.


#### Making calls into the PPSDK plugin.

##### SSO Login
The SSO login validates a single player (user) against the playPORTAL. Players may log in with a valid playPORTAL set of credentials, or as a guest player.
This method will initiate the login process. If a player is already logged in, it will reconnect that Player to their playPORTAL account

		void ppsdk.Login(bool isGuest,string myClientID,string mySecret, string myRedirectURI);

			bool isGuest - if false, will take this player through the SSO login process. If true, allow player to play as a guest.
			string myClientID - described above; from your playPORTAL app config
			string mySecret - described above; this is from your playPORTAL app config
			string myRedirectURI - described above; this is from your playPORTAL app config.

		Note: The method you created in your code, defined above as:

			public void playPortalLoginDidSucceed(string p);

		will be invoked upon login completion.


--
##### Data
The SDK provides a simple Key Value (KV) read/write model. On login, there are two data stores opened / created for this player. There is a private data store for this players exclusive use, and there is a global data store this player shares with all other players of this same app. If a player logs out and logs in at a later date, the data in the private data store should be as left upon logout. The contents of the global data store will most likely have changed.


	    void writeMyData(string key, string value);

   			string key - a key to associate with this data
    		string value - value to store

    	This method will write a KV pair to this user's private data store. If a key is used more than once, the value associated with the key will be updated.



	    void writeGlobalData(string key, string value);

   			string key - a key to associate with this data
    		string value - value to store

    	This method will write a KV pair to this application's global data store. Again, if a key is used more than once (by any user), the value associated with the key will be updated.

--

         public void readMyData(string key, Action<string>callback);

			string key - a key to read from.
			callback - C# method that takes a string parameter containing the returned value

			The callback method is defined as:
						
			private delegate void ReadDataDelegate(string value);
			[AOT.MonoPInvokeCallback(typeof(ReadDataDelegate))]  
			protected static void ReadCallback(string value)
			{
				// do something with the value
			}

	public void readMyDataAsDictionary(string key, Action<string>callback);
		// This returns the KV pair in a JSON string format. The JSON string can be converted to a C# object with:
	        someObject = (SomeObject)JsonUtility.FromJson(theJsonString, typeof(SomeObject)); 
		// where SomeObject is defined as appropriate for the data being stored (a simple example is included).


	public void readGlobalData(string key, Action<string>callback);

			string key - a key to read from.
			callback - C# method that takes a string parameter containing the returned value (see previous example for method of defining a callback fnx.)


-----

### Android
    - coming soon
