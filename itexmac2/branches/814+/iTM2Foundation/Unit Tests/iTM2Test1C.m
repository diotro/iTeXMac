//
//  iTM2Test1C
//  iTM2Foundation
//
//  Created by Jérôme Laurens on 16/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "iTeXMac2.h"
#import "iTM2BundleKit.h"
#import "iTM2DistributedObjectKit.h"
#import "iTM2FileManagerKit.h"
#import "iTM2Implementation.h"
#import "iTM2InstallationKit.h"
#import "iTM2Invocation.h"
#import "iTM2NotificationKit.h"
#import "iTM2ObjectServer.h"
#import "iTM2PathUtilities.h"
#import "iTM2Runtime.h"
#import "iTM2TreeKit.h"
#import "RegexKitLite.h"
#import "ICURegEx.h"

#import "iTM2ButtonKit.h"
#import "iTM2CursorKit.h"
#import "iTM2EventKit.h"
#import "iTM2ImageKit.h"
#import "iTM2MenuKit.h"
#import "iTM2ResponderKit.h"
#import "iTM2ValidationKit.h"
#import "iTM2ViewKit.h"
#import "iTM2WindowKit.h"

#import "iTM2ContextKit.h"
#import "iTM2AutoKit.h"
#import "iTM2MacroKit.h"
#import "iTM2MacroKit_String.h"
#import "iTM2DocumentKit.h"
#import "iTM2InheritanceKit.h"
#import "iTM2ApplicationDelegate.h"

#import "iTM2ProjectDocumentKit.h"
#import "iTM2ProjectControllerKit.h"
#import "iTM2InfoWrapperKit.h"

#import "iTM2Test1C.h"

@implementation iTM2Test1C
- (void) setUp
{
    // Create data structures here.
}
- (void) tearDown
{
    // Release data structures here.
}
- (void) testCase_orderedBaseProjectNames
{
    //  create a shared project controller
    //  create projects in various locations
    //  then test if those projects are known by the shared project controller
    iTM2ProjectController * PC = nil;
    PC = [[iTM2ProjectController alloc] init];
    STAssertTrue(PC.projects.count == 0,@"MISSED",nil);
    //  As default value, the various locations where we look for project are:
    STAssertTrue(PC.orderedBaseProjectNames.count == 0,@"MISSED",nil);
    [PC performSelector:@selector(updateBaseProjectsNotified:) withObject:nil];
    
    return;
    
}
- (void) testCase
{
    //  create a shared project controller
    //  create projects in various locations
    //  then test if those projects are known by the shared project controller
    iTM2ProjectController * PC = nil;
    PC = [[iTM2ProjectController alloc] init];
    STAssertTrue(PC.projects.count == 0,@"MISSED",nil);
    //  As default value, the various locations where we look for project are:
    
    return;
}
@end

