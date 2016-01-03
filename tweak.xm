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

static bool seperators = true;
static bool enabled = true;
static bool isActivity = false;
static bool customRadius = true;
static bool tapDismiss = true;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
* Hook into UIAlertController																			 		     *
* Header url: https://github.com/nst/iOS-Runtime-Headers/blob/master/Frameworks/UIKit.framework/UIAlertController.h  *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
%hook UIAlertController

-(id)visualStyleForAlertControllerStyle:(long long)arg1 traitCollection:(id)arg2 descriptor:(id)arg3{
	if (isActivity && enabled)
		arg1 = 0;
	return %orig;
}

-(int) preferredStyle 
{
	if(enabled)
		return 1;
	else
		return %orig;
}

- (BOOL)_canDismissWithGestureRecognizer
{
	if(enabled && tapDismiss)
		return true;
	else
		return %orig;
}

- (void)viewDidLayoutSubviews
{
	
	//[self.view logViewHierarchy];
	%orig;
	if(enabled){
		CGRect screenRect = [[UIScreen mainScreen] bounds];
		CGFloat screenWidth = screenRect.size.width;
		if (isActivity)
			self.view.frame = CGRectMake(self.view.frame.origin.x,0, screenWidth, self.view.frame.size.height);
	}
}

- (void)viewWillAppear:(BOOL)arg1{
	%orig;
	if (enabled && customRadius){
		CGFloat conRadius = 10.0f;
		for (UIView *subview in [self.view subviews])
		{
			for (UIView *subview2 in [subview subviews])
			{
				[subview2.layer setCornerRadius:conRadius];
					for (UIView *subview3 in [subview2 subviews])
					{	
						[subview3.layer setCornerRadius:conRadius];
						for (UIView *subview4 in [subview3 subviews])
						{
							[subview4.layer setCornerRadius:conRadius];
						}
						
					}
			}
		}
	}
	
	
}

%end


/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* Hook into UIAlertControllerVisualStyle																			 		   *
* Header url: https://github.com/nst/iOS-Runtime-Headers/blob/master/Frameworks/UIKit.framework/UIAlertControllerVisualStyle.h *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
%hook UIAlertControllerVisualStyle

-(bool) hideActionSeparators{
	if (enabled)
		return seperators;
	else{
		return %orig;
	}
}

%end


/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* Hook into UIActivityViewController																			 		   *
* Header url: https://github.com/nst/iOS-Runtime-Headers/blob/master/Frameworks/UIKit.framework/UIActivityViewController.h *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
%hook UIActivityViewController

- (void)viewDidLoad
{
	isActivity = true;
	%orig;
}

- (void)viewWillDisappear:(BOOL)arg1
{
	isActivity = false;
	%orig;
}

- (void)viewDidLayoutSubviews
{
	
	
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	CGFloat screenWidth = screenRect.size.width;
	CGFloat screenHeight = screenRect.size.height;
	%orig;
	if(enabled)
		self.view.frame = CGRectMake(self.view.frame.origin.x, (screenHeight-self.view.frame.size.height)/2 , screenWidth, self.view.frame.size.height);
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

