//
//  iTM2Test3C
//  iTM3Foundation
//
//  Created by Jérôme Laurens on 2010-12-28 19:28:00 +0100
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

#import "iTM2SystemSignalKit.h"
#import "iTM2Responders.h"
#import "iTM2SpellKit.h"
#import "iTM2ProjectSpellKit.h"
#import "iTM2TaskKit.h"
#import "iTM2StartupKit.h"

#import "iTM2TextStyleEditionKit.h"
#import "iTM2TextStorageKit.h"

#import "iTM2Test3C.h"

// iTM2TextSyntaxParser

@implementation iTM2Test3C
- (void) setUp
{
    // Create data structures here.
    iTM2DebugEnabled = 20000;
}
- (void) tearDown
{
    // Release data structures here.
}
- (void) testCase_init0
{
    //  Create a text storage, then test for basic edition involving
    iTM2TextStorage * TS = iTM2TextStorage.new;
    [TS replaceCharactersInRange:iTM3MakeRange(ZER0,ZER0) withString:@"coucouroucoucou"];
    STAssertTrue([TS.string isEqual:@"coucouroucoucou"],@"MISSED",NULL);
    STAssertTrue([TS.syntaxParser isConsistent],@"MISSED",NULL);
    [TS replaceCharactersInRange:iTM3MakeRange(ZER0,TS.length) withString:@""];
    STAssertTrue([TS.string isEqual:@""],@"MISSED",NULL);
    STAssertTrue([TS.syntaxParser isConsistent],@"MISSED",NULL);
    [TS replaceCharactersInRange:iTM3MakeRange(ZER0,TS.length) withString:@"\r\n"];
    STAssertTrue([TS.string isEqual:@"\r\n"],@"MISSED",NULL);
    STAssertTrue([TS.syntaxParser isConsistent],@"MISSED",NULL);
    [TS replaceCharactersInRange:iTM3MakeRange(ZER0,1) withString:@""];
    STAssertTrue([TS.string isEqual:@"\n"],@"MISSED",NULL);
    STAssertTrue([TS.syntaxParser isConsistent],@"MISSED",NULL);
    [TS replaceCharactersInRange:iTM3MakeRange(ZER0,TS.length) withString:@"\r\n"];
    STAssertTrue([TS.string isEqual:@"\r\n"],@"MISSED",NULL);
    STAssertTrue([TS.syntaxParser isConsistent],@"MISSED",NULL);
    [TS replaceCharactersInRange:iTM3MakeRange(1,1) withString:@""];
    STAssertTrue([TS.string isEqual:@"\r"],@"MISSED",NULL);
    STAssertTrue([TS.syntaxParser isConsistent],@"MISSED",NULL);
#   define TEST(IN,LOCATION,LENGTH,RESULT)\
    [TS replaceCharactersInRange:iTM3MakeRange(ZER0,TS.length) withString:IN];\
    STAssertTrue([TS.string isEqual:IN],@"MISSED",NULL);\
    STAssertTrue([TS.syntaxParser isConsistent],@"MISSED",NULL);\
    [TS replaceCharactersInRange:iTM3MakeRange(LOCATION,LENGTH) withString:@""];\
    STAssertTrue([TS.string isEqual:RESULT],@"MISSED",NULL);\
    STAssertTrue([TS.syntaxParser isConsistent],@"MISSED",NULL);
    TEST((@"\r\n"),0,1,(@"\n"));
    TEST((@"\r\n"),1,1,(@"\r"));
    
    return;
}
@end

