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

#import <objc/runtime.h>

#import "Global.h"

static bool seperators = true;
static bool enabled = true;

@interface _UIAlertControllerShadowedScrollView : UIScrollView
@end


@interface UIView (ViewHierarchyLogging)
- (void)logViewHierarchy;
@end

@interface CALayer (CALayersHierarchy)
-(void)logLayerHierarchy;
@end

@implementation CALayer (CALayersHierarchy)
-(void)logLayerHierarchy
{
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	CGFloat screenWidth = screenRect.size.width;
	for (CALayer *layer in self.sublayers)
	{
		[layer logLayerHierarchy];
	}
	self.frame = CGRectMake(self.frame.origin.x,0, screenWidth, self.frame.size.height);
}
@end


// UIView+HierarchyLogging.m
@implementation UIView (ViewHierarchyLogging)
- (void)logViewHierarchy
{
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	CGFloat screenWidth = screenRect.size.width;

    //self.autoresizingMask = UIViewAutoresizingWidth;
    
    //[self setBackgroundColor:test[i]];

    for (UIView *subview in self.subviews)
    {
        [subview logViewHierarchy];
        
    }
    [self setFrame:CGRectMake(self.frame.origin.x, 0, screenWidth, self.frame.size.height)];
    //self.layer.frame = CGRectMake(0,self.frame.origin.y, screenWidth, self.frame.size.height);
    //self.clipsToBounds = NO;
}
@end


@interface UIAlertControllerVisualStyle : NSObject
-(UIEdgeInsets)contentInsets;
@end
@interface UIAlertController (test)
@property (nonatomic, retain) UIAlertControllerVisualStyle *_visualStyle;

@end

%hook UIAlertController

-(id)visualStyleForAlertControllerStyle:(long long)arg1 traitCollection:(id)arg2 descriptor:(id)arg3{
	arg1 = 0;
	return %orig;
}

-(int) preferredStyle 
{
	return 1;
	//return %orig;
}

- (BOOL)_canDismissWithGestureRecognizer
{
	return true;
}

- (void)viewDidLayoutSubviews
{
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	CGFloat screenWidth = screenRect.size.width;
	//[self.view logViewHierarchy];
	%orig;

	self.view.frame = CGRectMake(self.view.frame.origin.x,0, screenWidth, self.view.frame.size.height);
	
}

- (void)viewWillAppear:(BOOL)arg1{
	%orig;
	
	CGFloat conRadius = 10.0f;
	//HBLogDebug(@"View location: %@", self.view);
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

%end


/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* Hook into UIAlertControllerVisualStyle																				 *
* Header url: http://developer.limneos.net/?ios=8.0&framework=UIKit.framework&header=UIAlertControllerVisualStyle.h 	 *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
%hook UIAlertControllerVisualStyle

-(bool) hideActionSeparators{
	//bool seperators_hide = (bool) [CleanSheets loadSettings][@"seperators_hide"];
	//HBLogDebug(@"%ld", (long) seperators_hide);
	if (enabled)
		return seperators;
	else{
		return %orig;
	}
}

%end

%hook UIActivityViewController

- (void)viewDidLayoutSubviews
{
	
	
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	CGFloat screenWidth = screenRect.size.width;
	CGFloat screenHeight = screenRect.size.height;
	//[self.view logViewHierarchy];
	%orig;

	self.view.frame = CGRectMake(self.view.frame.origin.x, (screenHeight-self.view.frame.size.height)/2 , screenWidth, self.view.frame.size.height);
	//
	//[self.view logViewHierarchy];
	//[self.view.layer logLayerHierarchy];
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

