/*
*	Copyright 2015 Wizage
*
*	Licensed under the Apache License, Version 2.0 (the "License");
*	you may not use this file except in compliance with the License.
*	You may obtain a copy of the License at
*
*    http://www.apache.org/licenses/LICENSE-2.0
*
*	Unless required by applicable law or agreed to in writing, software
*	distributed under the License is distributed on an "AS IS" BASIS,
*	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
*	See the License for the specific language governing permissions and
*	limitations under the License.
*/

#import "Global.h"

static bool fullsizeActivity = false; // Deteremine if they need fullsize or not
static bool isActivity = false; // Determines if the alert is an activity alert
static NSString *activityItem = @""; //Stores the first or secound activity item
static bool seperators = true;
static bool enabled = true;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* Hook into UIAlertControllerVisualStyle																				 *
* Header url: http://developer.limneos.net/?ios=8.0&framework=UIKit.framework&header=UIAlertController.h				 *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
%hook UIAlertController

/*
*	This will tell the system that it needs to resize for an activity or not.
*	Note: Removed or now because it was causing wrong resizing on some alerts
*		  we will use this later to change the look of alerts hence why it is
*		  staying
*/
/*
+ (id)alertControllerWithTitle:(id)arg1 message:(id)arg2 preferredStyle:(int)arg3 {

if (arg3 == 0)
{
	fullsizeActivity= true;
}
else {
	fullsizeActivity = false;
}
%orig;
return %orig;
}
*/

/*
*	If the menu was supposed to be an actionsheet, it will change it to an alert
* 	and tell the system to use the correct size for an alert.
*
*	Note: If it is an activity it should ignore this and follow what is defined below.
*/
-(long long)preferredStyle {
	if (!isActivity && enabled)
	{
		fullsizeActivity = false;
		return 1;
	}
	else{
		%orig;
		return %orig;
	}
}

/*
*	This changes the size of the alert to be the correct size. (Add switch here to make all alerts long)
*/
-(id)visualStyleForAlertControllerStyle:(long long)arg1 traitCollection:(id)arg2 descriptor:(id)arg3{
	if (fullsizeActivity && enabled)
	{
	arg1 = 0;
	}
	%orig;
	return %orig;
}

/*
*	Enables background touches to dismass the sheet.
*/
-(BOOL)_canDismissWithGestureRecognizer {
	if(enabled)
		return TRUE;
	else{
		%orig;
		return %orig;
	}
}


%end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* Hook into UIAlertControllerVisualStyle																				 *
* Header url: http://developer.limneos.net/?ios=8.0&framework=UIKit.framework&header=UIAlertControllerVisualStyle.h 	 *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
%hook UIAlertControllerVisualStyle


/*
*	Hides seperators for all the UIAlerts
*/
-(bool) hideActionSeparators{
	//bool seperators_hide = (bool) [CleanSheets loadSettings][@"seperators_hide"];
	//HBLogDebug(@"%ld", (long) seperators_hide);
	if (enabled)
		return seperators;
	else{
		%orig;
		return %orig;
	}
}

%end


/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* Hook into UIActivityViewController																					 *
* Header url: http://developer.limneos.net/?ios=8.0&framework=UIKit.framework&header=UIActivityViewController.h 		 *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
%hook UIActivityViewController

/*
*	Gets array count of UIActivity then takes a look at the first entry and secound
*	if it exists. If it exists it checks to see if it has a memory address in the 
*	description. If it does then it will move on and store that activity name.
*/
-(id)initWithActivityItems:(NSArray *)arg1 applicationActivities:(NSArray *)arg2 
{
	activityItem = @"";
	%orig;
	if(arg1.count >= 1)
	{
		activityItem = [arg1[0] description];
		if ([activityItem rangeOfString:@"0x"].location == NSNotFound 
		 && arg1.count > 1)
		{
			activityItem = [arg1[1] description];
		}
	}
	return %orig;
}

/*
*	Once the activityname is ready to be passed in we will then turn on two switches
* 	to enable special themeing for the activity controller. After that we look into
*	see if the first or secound item of the activity items is equal to a UI or Image
* 	activity item. These items were causing crashes in apps so we had to just tell
* 	the tweak to not change there style which magically fixes everything. My theory
* 	behind why it is broken is because someone wrote a library and some companies
* 	use the same library and they original lib writer didnt know how to code 
*	Activity Views properly.... (Because all of apples apps are just fine)
*	Note: Since the photos app uses a special activity controller we dont touch it.
*/
-(UIAlertController *)activityAlertController {
	if (enabled){
	fullsizeActivity = true;
	%orig;
	UIAlertController *alert = %orig;
	isActivity = true;
	if ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.mobileslideshow"])
	{
		//Do nothing for apples photo app
	}
	else if ([alert.parentViewController isKindOfClass:[UIActivityViewController class]])
	{
		[alert setPreferredStyle: 1];
	}
	else if (alert.parentViewController == nil 
		  && ( [activityItem rangeOfString:@"ImageActivityItem"].location != NSNotFound 
		  	|| [activityItem rangeOfString:@"UIActivityItem"].location != NSNotFound ) ){
		[alert setPreferredStyle: 0];
	}
	else{
		[alert setPreferredStyle: 1];
	}
	isActivity = false;
	return alert;
	}
	else{
	%orig;
	return %orig;
	}
}

%end

static void loadPrefs()
{
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.wizages.cleansheets.plist"];
    if(prefs)
    {
        seperators = ( [prefs objectForKey:@"seperators_hide"] ? [[prefs objectForKey:@"seperators_hide"] boolValue] : seperators );
        enabled =  ( [prefs objectForKey:@"enabled"] ? [[prefs objectForKey:@"enabled"] boolValue] :enabled );
    }
    [prefs release];
}

%ctor 
{
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.wizages.cleansheets/settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    loadPrefs();
}

