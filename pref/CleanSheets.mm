#import <Preferences/Preferences.h>
#import <SettingsKit/SKListControllerProtocol.h>
#import <SettingsKit/SKTintedListController.h>
#import <SettingsKit/SKSharedHelper.h>
#import <SettingsKit/SKPersonCell.h>

@interface twitterCell : SKPersonCell
@end
@implementation  twitterCell
-(NSString*)personDescription { return @"The Magical Developer"; }
-(NSString*)name { return @"Wizage"; }
-(NSString*)twitterHandle { return @"Wizage"; }
-(NSString*)imageName { return @"Icon/Wizages.png"; } /* should be a circular image, 200x200 retina */
@end

@interface CleanSheetsListController: SKTintedListController<SKListControllerProtocol>
@end

@implementation CleanSheetsListController
#define tweakPreferencePath @"/User/Library/Preferences/com.wizages.cleansheets.plist"
-(id) readPreferenceValue:(PSSpecifier*)specifier {
    NSDictionary *tweakSettings = [NSDictionary dictionaryWithContentsOfFile:tweakPreferencePath];
    if (!tweakSettings[specifier.properties[@"key"]]) {
        return specifier.properties[@"default"];
    }
    return tweakSettings[specifier.properties[@"key"]];
}
 
-(void) setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    [defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:tweakPreferencePath]];
    [defaults setObject:value forKey:specifier.properties[@"key"]];
    [defaults writeToFile:tweakPreferencePath atomically:YES];
    CFStringRef toPost = (__bridge CFStringRef)specifier.properties[@"PostNotification"];
    if(toPost) CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), toPost, NULL, NULL, YES);
}

 -(BOOL) tintSwitches {return false;}
 -(UIColor*) tintColor{ return [UIColor colorWithRed:127.0f/255.0f green:71.0f/255.0f blue:221.0f/255.0f alpha:1.0];}
 
-(NSString*) shareMessage { return @"I mustache you a question, why you not using #CleanSheets by @Wizages because dirty was so yesterday."; }

-(NSString*) headerText { return @"CleanSheets"; }
-(NSString*) headerSubText { return @"Because clean is always better."; }

-(NSString*) customTitle { return @""; }
-(NSArray*) customSpecifiers
{
    return @[
             @{
                 @"cell": @"PSGroupCell",
                 @"label": @"CleanSheets Settings"
                 },
             @{
                 @"cell": @"PSSwitchCell",
                 @"default": @YES,
                 @"defaults": @"com.wizages.cleansheets",
                 @"key": @"enabled",
                 @"label": @"Enabled",
                 @"PostNotification": @"com.wizage.cleansheets/reloadSettings",
                 @"cellClass": @"SKTintedSwitchCell"
                 },
            @{
                 @"cell": @"PSSwitchCell",
                 @"default": @YES,
                 @"defaults": @"com.wizages.cleansheets",
                 @"key": @"seperators_hide",
                 @"label": @"Hide Seperators",
                 @"PostNotification": @"CleanSheets/reloadSettings",
                 @"cellClass": @"SKTintedSwitchCell"
            },
            @{
                 @"cell": @"PSButtonCell",
                 @"action": @"respring",
                 @"label": @"Respring to apply changes",
            },
            @{
                 @"cell": @"PSGroupCell",
                 @"label": @""
            },
            @{
                @"cell": @"PSLinkCell",
                @"cellClass":@"twitterCell",
                @"height": @100,
                @"action":@"openWizageTwitter"
            }
             ];
}
-(void) openWizageTwitter
{
    [SKSharedHelper openTwitter:@"Wizages"];
}

-(void)respring
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    system("killall -9 SpringBoard");
#pragma clang diagnostic pop
}
@end

