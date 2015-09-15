#import "CleanSheets.h"

NSMutableDictionary *prefs = nil;

@implementation CleanSheets
+(NSMutableDictionary*) loadSettings
{
    if (!prefs)
    {
        prefs = [NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.wizages.cleansheets.plist"];
        if (prefs == nil)
            prefs = [NSMutableDictionary dictionary];
    }
    return prefs;
}

+(void) reloadSettings
{
    prefs = nil;
    [CleanSheets loadSettings];
}
@end
