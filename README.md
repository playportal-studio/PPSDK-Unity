
# playPORTAL Unity

---
For complete documentation and API instruction, visit <https://docs.playportal.io>.


## Installation

1. Import the PPSDK-Unity.unitypackage file.
2. Open **Assets** > **playPORTAL** > **Scenes** > **playPORTAL example testing**.
3. TMP IMPORTER window will open.
4. Import TMP Essentials.
5. If the importer does not open automatically, you can import manually by going to **Window** > **TextMeshPro** > **Import TMP Essential Resources**.



## Register Credentials

1. Select Game Object "playPORTAL".
2. Click "playPORTAL Configuration" button
3. Alternate: **Window** > **playPORTAL Configuration**
4. Enter Client ID and Client Secret from your playPORTAL studio account.

**NOTE**: Default environment is Sandbox, choose Production when ready for release.


## Usage

**Note**: This SDK uses C# 6, which will require your project to use the .NET 4.6 runtime. Check out this [link][scripting runtime upgrade] for info on how to change it. 
[scripting runtime upgrade]: https://docs.unity3d.com/Manual/ScriptingRuntimeUpgrade.html

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
				Debug.Log(error.message);
			} else {
				Debug.Log("Login successful.");
				Debug.Log(userProfile.handle);
			}
    	}
	}


Back to your **LoginScene**, select the **playPORTAL Login Button** prefab in your hierarchy and go to the **Inspector** tab. The last component for the prefab should be a script, **PlayPortal Login Manager**. You will see that it has a **Login Complete Event**. Click the plus icon to add a new event subscriber. Without selecting it, drag the Game Object you created earlier to the box that says "None (Object)." In the function dropdown (which should at this point say "No Function"), select **Login Handler** > **LoginComplete**.

Run the project. Your scene should contain the **playPORTAL Login Button** and when you click on it, open the **playPORTAL Login** scene. Enter one of your Sandbox user's credentials and select "Login." If the user authenticates successfully, you should see their handle output in the **Console** tab. Finally, you have the SDK setup and are ready to start developing!
 



















