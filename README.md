# Unity\_PPSDK\_plugin
Unity plugin file for playPORTAL SDK by Dynepic, Inc.



## Overview
The playPORTAL SDK, as supported with this Unity plugin, provides a simple mechanism for achieving COPPA compliance in Unity games. This README will cover the basics of getting started with this plugin.


### Preparation
	* Download / clone this git repo to your Unity dev computer
	* Identify that dynepic-ppsdk.unitypackage is in the repo 

#### Open your Unity project
	* Select from Unity menu: "Assets" --> "Import Package" --> "Custom Package"
	* Choose the dynepic-ppsdk.unitypackage 
	* Answer the dialog questions to "Import All" of the package contents to the suggested location in Unity

#### Unity Player Settings
	* In the top level settings, select the iphone icon
	* In your Player Settings, make the following changes:
    	Other Settings: 
    		- Add Supported URL Schemes: Size:1 and Element 0: ProductName
      		- Insure Scripting Backend is: IL2CPP
      		- Check Automatically Sign
			- Enter the name of your Apple Dev Team (this can be done in Xcode as well)

#### Build and Run
	* Tap Build and Run
	* when Unity completes this step, it should have launched Xcode	

#### In Xcode
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
 
	* Update your myClientID and mySecret string vars with the information from your app definition/configuration in playportal.io.

			private static string myClientID = @"iok-cid-yourclientidstringhere";
			private static string mySecret = @"iok-cse-yoursecretstringshere";



	* Define and Instantiate a class level PlayPortalController object to use for communicating with the playPORTAL:
	
		      public PlayPortalController ppsdk;
		      ppsdk = new PlayPortalController();


	* Instantiate a playerObject to use for storing player profile information:
	 
	      	public PPSDK_PlayerObject playerObject = new PPSDK_PlayerObject();
	      

	* Instantiate a method to receive callbacks from Unity message notifications ("true" on login success, else "false").
	 
		public void playPortalLoginDidSucceed(string p)
		    {
		    	if(p == "true") {
				// login success
				playerObject = ppsdk.GetPlayerObject();
				Debug.Log("PlayerController player:" + playerObject);
			} else {
				// present some error status
			}
		    }


Your app is now ready to begin making calls into the PPSDK plugin.


#### Making calls into the PPSDK plugin.

##### SSO Login
The SSO login validates a single player (user) against the playPORTAL. Players may log in with a valid playPORTAL set of credentials, or as a guest player. 
This method will initiate the login process. If a player is already logged in, it will reconnect that Player to their playPORTAL account 
      
		void ppsdk.Login(bool isGuest,string myClientID,string mySecret);
 
			bool isGuest - if false, will take this player through the SSO login process. If true, allow player to play as a guest.
			string myClientID - described above; from your playPORTAL app config
			string mySecret - described above; this is from your playPORTAL app config	


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

		void readMyData(string key, out string value);

			string key - a key to read from.
			out string value - will contain the returned value
		

	
		void readGlobalData(string key, out string value);

			string key - a key to read from.
			out string value - will contain the returned value
		
		
-----

### Android
    - coming soon
