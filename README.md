
# playPORTAL Unity

---
For complete documentation and API instruction, visit <https://docs.playportal.io>.


**NOTE**: This SDK uses C# 7 features, which requires Unity 2018.3 and will require your project to use the .NET 4.6 runtime. Check out this [link][scripting runtime upgrade] for info on how to change it. 

[scripting runtime upgrade]: https://docs.unity3d.com/Manual/ScriptingRuntimeUpgrade.html

## Installation

1. Clone the **PPSDK-Unity** repo.
2. To import, select **Assets** > **Import Package** > **Custom Package...** and select **PPSDK-Unity.unitypackage**.
3. Import TMP Essentials by going to **Window** > **TextMeshPro** > **Import TMP Essential Resources**.

**NOTE**: If you are getting errors in your console related to TextMeshPro, even after importing **TMP Essential Resources**, they should be cleared if you run your project.



## Register Credentials

1. Select **Window** > **playPORTAL Configuration**.
4. Enter Client ID and Client Secret from your playPORTAL studio account.

**NOTE**: Default environment is Sandbox, choose Production when ready for release.


## Usage


To setup the authentication flow, you will use the **playPORTAL Login Button** Prefab, found in the **Project** tab under **Assets** > **playPORTAL** > **Prefabs**, and drop it into one of your scenes. Let's refer to it as your **LoginScene**. When the button is clicked, it will load the **playPORTAL Login** scene, which will allow users to authenticate into your game. If you are testing the SDK with a newly created Unity project, you can simply use the **Sample Scene** that Unity should automatically generate when creating a new project.

You will also need to add the **playPORTAL Login** scene to your build settings. To do so, go to **File** > **Build Settings** and drag the scene, found in your **Project** tab under **Assets** > **playPORTAL** > **Scenes**, to **Scenes In Build**.

Next, you will need to drop the **playPORTAL Unity** prefab into your **LoginScene**. From the **Project** tab, go to **Assets** > **playPORTAL** > **Prefabs** and drag the **playPORTAL Unity** prefab into your **LoginScene's** hierarchy. Then, create a new empty GameObject in your **Login Scene** hierarchy. With your Empty GameObject selected, open the **Inspecter** tab and choose **Add Component** > **New script**. Let's call it **LoginHandler** and then open it in your editor. 

We want to implement the `Awake` method in the script and inside it, we want to call `DontDestroyOnLoad(gameObject);`, so that when the **playPORTAL Login** scene gets loaded, the script won't be destroyed. Next, add this method to your script:

	public void LoginComplete(Exception error, PlayPortalProfile userProfile)
    {
    }

The `LoginComplete` method will be called once the user finishes authenticating. It will be called with an `Exception` argument if authentication fails; otherwise, it will be called with a `PlayPortalProfile` instance representing the authenticated user. You will also need to add `using playPORTAL.Profile;` and `using System;` to the top of your script to import `PlayPortalProfile` and `Exception`. Let's add some logging to `LoginComplete` to let us know if the user authenticated successfully or not:

	if (error != null) {
		Debug.Log("Error logging in.");
		Debug.Log(error.message);
	} else {
		Debug.Log("Login successful.");
		Debug.Log(userProfile.handle);
	}
		
At this point, your script should look something like this:

	using System;
	using playPORTAL.Profile;
	using UnityEngine;

	public class LoginHandler : MonoBehaviour
	{
    	private void Awake()
    	{
        	DontDestroyOnLoad(gameObject);
    	}

    	public void LoginComplete(Exception error, PlayPortalProfile userProfile)
    	{
    		if (error != null) {
				Debug.Log("Error logging in.");
				Debug.Log(error.Message);
			} else {
				Debug.Log("Login successful.");
				Debug.Log(userProfile.handle);
			}
    	}
	}


Back to your **LoginScene**, select the **playPORTAL Login Button** prefab in your hierarchy and go to the **Inspector** tab. The last component for the prefab should be a script, **PlayPortal Login Manager**. You will see that it has a **Login Complete Event**. Click the plus icon to add a new event subscriber. Without selecting it, drag the Game Object you created earlier to the box that says "None (Object)." In the function dropdown (which should at this point say "No Function"), select **Login Handler** > **LoginComplete**.

Run the project. Your scene should contain the **playPORTAL Login Button** and when you click on it, open the **playPORTAL Login** scene. Enter one of your Sandbox user's credentials and select "Login." If the user authenticates successfully, you should see their handle output in the **Console** tab. Finally, you have the SDK setup and are ready to start developing!
 


## Examples

The SDK includes a **playPORTAL Example** scene and accompanying **PlayPortalExample** script. You can find the scene and script from your **Project** tab under **playPORTAL** > **Scenes** > **playPORTAL Example** and **playPORTAL** > **Scripts** > **PlayPortalExample**, respectively.

Opening the **playPORTAL Example** scene, you'll see that it's a simple 2D screen with a number of buttons. Each button, when pressed, will call an accompanying method in the **PlayPortalExample** script. For example, pressing the 'Login' button from the example scene will call the `Login` method in **PlayPortalExample**.

Note that to login through the example scene, you will need to enter the credentials for one of your Sandbox users. With the **playPORTAL Example** scene loaded, go to your **Hierarchy** tab and click the **PlayPortalExample** GameObject. Then, in the **Inspector** tab, you should see the **Play Portal Example** component that has a section called **Login Input**. Enter the username and password for one of your Sandbox users there. (You will have to also have your client Id and secret entered in **playPORTAL Configuration**. If you haven't already, take a look at the **Register Credentials** section for info on how to do that.)

Feel free to edit the **PlayPortalExample** script as you please. Its purpose is for you to try out the SDK, see what methods/functionality is available, and how it works. 


## Buckets and Data

We'll give a high level overview of how data storage works with playPORTAL. Data is essentially stored as formless key-value pairs. If you have any experience with Javascript/JSON, then this should be familiar to you. There are three major ways of storing data: in a user's private app data, a shared bucket, and a global bucket. The main difference between the three is who has access to the data; however, they are all similar in that they are stored as key-value pairs. 

User's private app data is data that only that user can edit and retrieve, and, if the user is a child, their parent as well.

A bucket is data shared between one or more users. When creating a bucket, you specify what users are part of the bucket. Then the bucket can be edited and retrieved by any of those users.

A global bucket is similar to a regular bucket, except that it is shared by all app users and therefore any user can edit or retrieve it.

It's important to note that data is on a per-app basis. For example, if you have two apps on the playPORTAL platform, a bucket created in App1 is not available in App2. This is the same for private user data and global buckets. All data is scoped to a single app.











