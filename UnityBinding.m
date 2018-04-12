
#import "UnityBindingObjcWrapper.h"

void _PPSDK_configure(const char* clientId, const char* secret, const char* redirectURI) 
{
    NSString* c = [NSString stringWithCString:clientId encoding:NSASCIIStringEncoding];
    NSString* s = [NSString stringWithCString:secret encoding:NSASCIIStringEncoding];
    NSString* r = [NSString stringWithCString:redirectURI encoding:NSASCIIStringEncoding];
    
    [UnityBindingObjcWrapper PPSDK_configure_ubow:c andSecret:s andRedirectURI:r];
}

void _PPSDK_presentSafariViewController()
{
    [UnityBindingObjcWrapper PPSDK_presentSafariViewController_ubow];
}

void _PPSDK_loginAnonymously(int age)
{
    // Use users age today "age years ago" to approximate user's birthdate
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger thisyear = [components year];
    components.year = thisyear - age;
    NSDate *bday = [[NSCalendar currentCalendar] dateFromComponents:components];
    NSLog(@"birthday: %@", bday);
    [UnityBindingObjcWrapper PPSDK_loginAnonymously_ubow:bday];
}

void _PPSDK_setCallback()
{
    [UnityBindingObjcWrapper PPSDK_setCallback_ubow];
    NSLog(@"callback from objective-c invoked");
}

void _PPSDK_logout()
{
    [UnityBindingObjcWrapper PPSDK_logout_ubow];
    NSLog(@"logout from PPSDK...");
}

void _PPSDK_writeMyData(const char* key, const char* value)
{
    NSString* k = [NSString stringWithCString:key encoding:NSASCIIStringEncoding];
    NSString* v = [NSString stringWithCString:value encoding:NSASCIIStringEncoding];

    [UnityBindingObjcWrapper PPSDK_writeBucket_ubow:[PPManager sharedInstance].PPuserobj.myDataStorage andKey:k andValue:v push:false handler:^(NSError* error) {
        if(error) NSLog(@" ERROR: writeMyData for key:%@ value:%@", k, v);
    }];
}


void _PPSDK_readMyData(const char* key, const char* value)
{
    NSString* k = [NSString stringWithCString:key encoding:NSASCIIStringEncoding];
    __block NSString* tmp;
    
    [UnityBindingObjcWrapper PPSDK_readBucket_ubow:[PPManager sharedInstance].PPuserobj.myDataStorage andKey:k handler: ^(NSDictionary* d, NSError* error) {
            NSLog(@" readMyData for key:%@ dictionary:%@", k, d);
            tmp = [d valueForKey:k];
        }];
    value = [tmp UTF8String];
}



char* cStringCopy(const char* string)
{
    char* res = (char*)malloc(strlen(string) + 1);
    strcpy(res, string);
    return res;
}

char* createJSONStringFromJSONObjectIOS(UnityDictionaryObject* aDictObj)
{
    NSString* str = [aDictObj convertToJSON: aDictObj.dict];
    char* s = cStringCopy([str UTF8String]);
    return s;
}

char* createJSONStringIOS(const char* key, const char* value)
{
    UnityDictionaryObject* aDictObj = [[UnityDictionaryObject alloc] init];
    NSString* k = [NSString stringWithCString:key encoding:NSASCIIStringEncoding];
    NSString* v = [NSString stringWithCString:value encoding:NSASCIIStringEncoding];
    [aDictObj addKVPair: k andValue:v];
    NSString* str = [aDictObj convertToJSON: aDictObj.dict];
    char* s = cStringCopy([str UTF8String]);
    return s;
}

char* _PPSDK_amIloggedIn()
{
    const char* key = "amIloggedIn";
    const char* value;
    if([UnityBindingObjcWrapper PPSDK_amIAuthenticated_ubow])
    {
        value = "true";
    } else
    {
        value = "false";
    }
    return createJSONStringIOS(key, value);
}

char* _PPSDK_getMyProfile()
{
    NSDictionary* d = [UnityBindingObjcWrapper PPSDK_getMyStoredProfile];
    UnityDictionaryObject* aDictObj = [[UnityDictionaryObject alloc] init];

    for(id key in d) [aDictObj addKVPair:key andValue:d[key]];
    return createJSONStringFromJSONObjectIOS(aDictObj);
}
