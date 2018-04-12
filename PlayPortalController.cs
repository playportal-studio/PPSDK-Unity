using System;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices; // include linkage to iOS / Android libs
using UnityEngine;


public class PPSDK_PlayerObject
{
    public string userId;
    public string handle;
    public string firstName;
    public string lastName;
    public string country;
    public string accountType;
    public string userType;
    //public string profilePicId;
    //public UIImage profilePic;
    //public string coverPhotoId;
    //public UIImage* coverPhoto;
    public string myAge;
    //public Boolean isAnonymousUser;
};


public class PlayPortalController : MonoBehaviour {  

    public static bool isLoggedIn = false;
    public static bool inProcessOfLoggingIn = false;

    private string urlpre = @"https://sandbox.iokids.net/oauth/signin?client_id=";
    private static string myRedirectURI = @"ondeck://redirect";
    private static string urlmid = @"&redirect_uri=";
    private static string urlpost = @"&state=beans&response_type=code";

    // On iOS plugins are statically linked into the executable, so we have to 
    // use __Internal as the library name.

    [DllImport("__Internal")]
    private static extern void _PPSDK_configure(string clientId, string secret, string redirectURI);
    [DllImport("__Internal")]
    private static extern void _PPSDK_loginAnonymously(int age);
    [DllImport("__Internal")]
    private static extern void _PPSDK_setCallback();
    [DllImport("__Internal")]
    private static extern void _PPSDK_writeMyData(string key, string value);
    [DllImport("__Internal")]
    public static extern void _PPSDK_readMyData(string key, out string value);  // returns value
    [DllImport("__Internal")]
    static extern string _PPSDK_amIloggedIn();
    [DllImport("__Internal")]
    static extern string _PPSDK_getMyProfile();
    [DllImport("__Internal")]
    public static extern void _PPSDK_logout();
    [DllImport("__Internal")]
    public static extern void _PPSDK_presentSafariViewController();


    public Texture2D image;  // for holding UI button image
    public GUIContent content; // for displaying button
    public Texture BoxTexture;              // Drag a Texture onto this item in the Inspector
    GUIStyle style = new GUIStyle();

    public Action<PPSDK_PlayerObject> savedCallback;
    public PPSDK_PlayerObject playerObject;


    public void writeMyData(string key, string value)
    {
        _PPSDK_writeMyData(key, value);
    }

    public void readMyData(string key, out string value)
    {
        string v;
        _PPSDK_readMyData(key, out v);
        value = v;
        return;
    }

    // Entry point
    public void Start()
    {
        isLoggedIn = false;
    }

    public void Update() { }
    public void FixedUpdate() { }
    public void OnGUI()
    {
        Debug.Log("PlayPortalController.cs onGUI()");
    }

    public void Logout()
    {
        isLoggedIn = false;
        _PPSDK_logout();
    }


    public void Login(bool guest, string id, string secret)
    {
        _PPSDK_setCallback();
        _PPSDK_configure(id, secret, myRedirectURI);

        if (guest == false)
        {
            Debug.Log("PlayerController login via SSO");
            _PPSDK_presentSafariViewController();
        }
        else
        {

            Debug.Log("PlayerController login as Guest");
            _PPSDK_loginAnonymously(22);
        }
    }



    // -----------------------------------------------------------------
    //
    // playPORTAL SDK
    //
    // Method to be "called back" from iOS Obj-C on completion of SSO
    //
    // -----------------------------------------------------------------
    public PPSDK_PlayerObject GetPlayerObject()
    {
        Debug.Log("PlayPortalController getPlayerObject");

        // Now read up this player's info
        string playerJson = _PPSDK_getMyProfile();
        playerObject = (PPSDK_PlayerObject)JsonUtility.FromJson(playerJson, typeof(PPSDK_PlayerObject));
        Debug.Log(playerJson);
        return playerObject;
    }


}
