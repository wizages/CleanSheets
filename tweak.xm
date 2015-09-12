#import "Global.h"

static bool fullsizeActivity = false; // Deteremine if they need fullsize or not
static bool isActivity = false; // Determines if the alert is an activity alert
static int activityCount = 0; // Array count for activities

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
	if (!isActivity)
	{
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
	if (fullsizeActivity)
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
	return true;
}

/*
*	Cleans up the variables after the alert is shown so no errors will occur
*/
-(void)viewDidAppear:(BOOL)arg1{
	%orig;
	isActivity = false;
	fullsizeActivity = false;
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
	return true;
}

%end


/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* Hook into UIActivityViewController																					 *
* Header url: http://developer.limneos.net/?ios=8.0&framework=UIKit.framework&header=UIActivityViewController.h 		 *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
%hook UIActivityViewController

/*
*	Gets array count of UIActivity because some people suck at coding
*/
-(id)initWithActivityItems:(NSArray *)arg1 applicationActivities:(NSArray *)arg2 
{
	%orig;
	activityCount = arg1.count;
	return %orig;
}

/*
*	A hack to change only UIActivityViewContoller alerts, the issue was that some
* 	app developers do not know how to use UIActivityViewController so they dont
*	pass an actual value to share until the person choses and opition. So to 
*	dectect what is going on we decide to not give the style to devs that only
* 	give the "default" items, which magically fixes the crashes.
*/
-(UIAlertController *)activityAlertController {
	fullsizeActivity = true;
	%orig;
	UIAlertController *alert = %orig;
	isActivity = true;
	if ([alert.parentViewController isKindOfClass:[UIActivityViewController class]])
	{
		[alert setPreferredStyle: 1];
	}
	else if (alert.parentViewController == nil && activityCount == 1){
		[alert setPreferredStyle: 0];
	}
	else{
		[alert setPreferredStyle: 1];
	}
	return alert;

}

%end

