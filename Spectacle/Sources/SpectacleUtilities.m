#import "SpectacleConstants.h"
#import "SpectacleUtilities.h"

@implementation SpectacleUtilities

+ (NSString *)applicationVersion
{
  NSBundle *mainBundle = NSBundle.mainBundle;
  NSString *bundleVersion = mainBundle.infoDictionary[kCFBundleShortVersionString];

  if (!bundleVersion) {
    bundleVersion = mainBundle.infoDictionary[kCFBundleVersion];
  }

  return bundleVersion;
}

#pragma mark -

+ (void)registerDefaultsForBundle:(NSBundle *)bundle
{
  NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
  NSString *path = [bundle pathForResource:kDefaultPreferencesPropertyListFile
                                    ofType:kPropertyListFileExtension];

  [defaults registerDefaults:[[NSDictionary alloc] initWithContentsOfFile:path]];
}

#pragma mark -

+ (void)displayRunningInBackgroundAlertWithCallback:(void (^)(BOOL, BOOL))callback
{
  NSAlert *alert = [NSAlert new];
  
  alert.alertStyle = NSInformationalAlertStyle;
  alert.showsSuppressionButton = YES;
  alert.messageText = NSLocalizedString(@"AlertMessageTextRunningInBackground", @"The message text of the alert displayed when prompting to run Spectacle in the background");
  alert.informativeText = NSLocalizedString(@"AlertInformativeTextRunningInBackground", @"The informative text of the alert displayed when prompting to run Spectacle in the background");
  
  [alert addButtonWithTitle:NSLocalizedString(@"ButtonLabelAffirmative", @"The button label used in the affirmative")];
  [alert addButtonWithTitle:NSLocalizedString(@"ButtonLabelNegative", @"The button label used in the negative")];
  
  NSInteger response = [alert runModal];
  BOOL isAlertSuppressed = [alert.suppressionButton state] == NSOnState;
  
  switch (response) {
    case NSAlertFirstButtonReturn:
      callback(YES, isAlertSuppressed);
      
      break;
    case NSAlertSecondButtonReturn:
      callback(NO, isAlertSuppressed);
      
      break;
    default:
      break;
  }
}

+ (void)displayRestoreDefaultsAlertWithConfirmationCallback:(void (^)())callback
{
  NSAlert *alert = [NSAlert new];

  alert.messageText = NSLocalizedString(@"AlertMessageTextRestoreDefaults", @"The message text of the alert displayed when prompting to restore Spectacle's default shortcuts");
  alert.informativeText = NSLocalizedString(@"AlertInformativeTextRestoreDefaults", @"The informative text of the alert displayed when prompting to restore Spectacle's default shortcuts");

  [alert addButtonWithTitle:NSLocalizedString(@"ButtonLabelAffirmative", @"The button label used in the affirmative")];
  [alert addButtonWithTitle:NSLocalizedString(@"ButtonLabelNegative", @"The button label used in the negative")];

  NSInteger response = [alert runModal];

  switch (response) {
    case NSAlertFirstButtonReturn:
      callback();

      break;
    case NSAlertSecondButtonReturn:
      break;
    default:
      break;
  }
}

#pragma mark -

+ (NSString *)pathForPreferencePaneNamed:(NSString *)preferencePaneName
{
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSPreferencePanesDirectory, NSAllDomainsMask, YES);
  NSFileManager *fileManager = NSFileManager.defaultManager;
  NSString *preferencePanePath = nil;

  if (preferencePaneName) {
    preferencePaneName = [preferencePaneName stringByAppendingFormat:@".%@", kPreferencePaneExtension];

    for (__strong NSString *path in paths) {
      path = [path stringByAppendingPathComponent:preferencePaneName];

      if (path && [fileManager fileExistsAtPath:path isDirectory:nil]) {
        preferencePanePath = path;

        break;
      }
    }

    if (!preferencePanePath) {
      NSLog(@"There was a problem obtaining the path for the specified preference pane: %@", preferencePaneName);
    }
  }

  return preferencePanePath;
}

@end
