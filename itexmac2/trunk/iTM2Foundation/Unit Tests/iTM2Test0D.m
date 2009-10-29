//
//  iTM2Test0C
//  iTM2Foundation
//
//  Created by Jérôme Laurens on 16/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "RegexKitLite.h"
#import "ICURegEx.h"
#import "iTM2StringKit.h"
#import "iTM2Runtime.h"
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
#import "iTM2TreeKit.h"

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
#import "iTM2StringController.h"

#import "iTM2Test0D.h"

@implementation iTM2Test0D
- (void) setUp
{
    // Create data structures here.
}

- (void) tearDown
{
    // Release data structures here.
}
- (void) testCase
{
}
- (void) testCase_indentation_1
{
    iTM2StringController * SC = [iTM2StringController defaultController];
    STAssertNotNil(SC,@"Lost",NULL);
    NSString * aString = @"\\\\\\\\";
    STAssertFalse([SC isEscapedCharacterAtIndex:0 inString:aString],@"Missed 3a",NULL);
    STAssertTrue([SC isEscapedCharacterAtIndex:1 inString:aString],@"Missed 3b",NULL);
    STAssertFalse([SC isEscapedCharacterAtIndex:2 inString:aString],@"Missed 3c",NULL);
    STAssertTrue([SC isEscapedCharacterAtIndex:3 inString:aString],@"Missed 3d",NULL);
    STAssertTrue([SC isControlCharacterAtIndex:0 inString:aString],@"Missed 3xd",NULL);
    STAssertFalse([SC isControlCharacterAtIndex:1 inString:aString],@"Missed 3xa",NULL);
    STAssertTrue([SC isControlCharacterAtIndex:2 inString:aString],@"Missed 3xb",NULL);
    STAssertFalse([SC isControlCharacterAtIndex:3 inString:aString],@"Missed 3xc",NULL);
    aString = @"\\%%\\\\\\%%\\\\%";
    STAssertFalse([SC isCommentCharacterAtIndex:0 inString:aString],@"Missed 3ya",NULL);
    STAssertFalse([SC isCommentCharacterAtIndex:1 inString:aString],@"Missed 3yz",NULL);
    STAssertTrue ([SC isCommentCharacterAtIndex:2 inString:aString],@"Missed 3ye",NULL);
    STAssertFalse([SC isCommentCharacterAtIndex:3 inString:aString],@"Missed 3yr",NULL);
    STAssertFalse([SC isCommentCharacterAtIndex:4 inString:aString],@"Missed 3yt",NULL);
    STAssertFalse([SC isCommentCharacterAtIndex:5 inString:aString],@"Missed 3yy",NULL);
    STAssertFalse([SC isCommentCharacterAtIndex:6 inString:aString],@"Missed 3yu",NULL);
    STAssertTrue ([SC isCommentCharacterAtIndex:7 inString:aString],@"Missed 3yi",NULL);
    STAssertFalse([SC isCommentCharacterAtIndex:8 inString:aString],@"Missed 3yo",NULL);
    STAssertFalse([SC isCommentCharacterAtIndex:9 inString:aString],@"Missed 3yp",NULL);
    STAssertTrue ([SC isCommentCharacterAtIndex:10 inString:aString],@"Missed 3yq",NULL);
}
- (void) testCase_indentation_2
{
    iTM2StringController * SC = [iTM2StringController defaultController];
    STAssertNotNil(SC,@"Lost",NULL);
    NSString * aString = @"\\\\\\\\";
    NSUInteger numberOfSpacesPerTab = SC.numberOfSpacesPerTab;
    STAssertEquals(numberOfSpacesPerTab,(NSUInteger)4,@"Missed %d!=4",numberOfSpacesPerTab);
    SC.numberOfSpacesPerTab = 3;
    NSUInteger index,level,expected_index,expected_level;
    #define TEST(STRING,INDEX,LEVEL)\
    aString = STRING;\
    index = 0;\
    level=[SC indentationLevelStartingAtIndexRef:&index isComment:nil inString:aString];\
    expected_index = INDEX;\
    expected_level = LEVEL;\
    STAssertEquals(level,expected_level,@"Missed indentation <%@> level %d!=%d",aString,level,expected_level);\
    STAssertEquals(index,expected_index,@"Missed indentation <%@> index %d!=%d",aString,index,expected_index)
    TEST(@"",0,0);
    TEST(@" ",1,0);
    TEST(@"  ",2,0);
    TEST(@"   ",3,1);
    TEST(@"    ",4,1);
    TEST(@"     ",5,1);
    TEST(@"      ",6,2);
    TEST(@"X",0,0);
    TEST(@" X",1,0);
    TEST(@"  X",2,0);
    TEST(@"   X",3,1);
    TEST(@"    X",4,1);
    TEST(@"     X",5,1);
    TEST(@"      X",6,2);
    SC.numberOfSpacesPerTab = 2;
    SC.usesTabs = YES;
    STAssertEqualObjects(SC.indentationString,@"\t",@"Bad indentation string a");
    SC.usesTabs = NO;
    STAssertEqualObjects(SC.indentationString,@"  ",@"Bad indentation string z");
    SC.usesTabs = YES;
    STAssertEqualObjects(SC.indentationString,@"\t",@"Bad indentation string e");
    SC.usesTabs = NO;
    STAssertEqualObjects(SC.indentationString,@"  ",@"Bad indentation string r");
    SC.numberOfSpacesPerTab = 3;
    SC.usesTabs = YES;
    STAssertEqualObjects(SC.indentationString,@"\t",@"Bad indentation string a");
    SC.usesTabs = NO;
    STAssertEqualObjects(SC.indentationString,@"   ",@"Bad indentation string z");
    SC.usesTabs = YES;
    STAssertEqualObjects(SC.indentationString,@"\t",@"Bad indentation string e");
    SC.usesTabs = NO;
    STAssertEqualObjects(SC.indentationString,@"   ",@"Bad indentation string r");
    NSString * expectedString;
    #undef TEST
    #define TEST(ORIGINAL,EXPECTED)\
    aString = [SC stringByNormalizingIndentationInString:ORIGINAL];\
    expectedString = EXPECTED;\
    STAssertEqualObjects(aString,expectedString,@"Missed normalization %@ tabs: \"%@\"!=\"%@\"",(SC.usesTabs?@"with":@"without"),aString,expectedString)
    SC.usesTabs = NO;
    TEST(@"",  @"");
    TEST(@" ", @"");
    TEST(@"  ",@"");
    TEST(@"   ",  @"   ");
    TEST(@"    ", @"   ");
    TEST(@"     ",@"   ");
    TEST(@"      ",  @"      ");
    TEST(@"x",  @"x");
    TEST(@" x", @"x");
    TEST(@"  x",@"x");
    TEST(@"   x",  @"   x");
    TEST(@"    x", @"   x");
    TEST(@"     x",@"   x");
    TEST(@"      x",  @"      x");
    TEST(@"\t",  @"   ");
    TEST(@" \t",  @"   ");
    TEST(@"  \t",  @"   ");
    TEST(@"\t ",  @"   ");
    TEST(@"\t  ",  @"   ");
    TEST(@" \t ",  @"   ");
    TEST(@" \t  ",  @"   ");
    TEST(@"  \t ",  @"   ");
    TEST(@"  \t  ",  @"   ");
    TEST(@"\tx",  @"   x");
    TEST(@" \tx",  @"   x");
    TEST(@"  \tx",  @"   x");
    TEST(@"\t x",  @"   x");
    TEST(@"\t  x",  @"   x");
    TEST(@" \t x",  @"   x");
    TEST(@" \t  x",  @"   x");
    TEST(@"  \t x",  @"   x");
    TEST(@"  \t  x",  @"   x");
    TEST(@"\t\t",  @"      ");
    TEST(@"   \t",  @"      ");
    TEST(@"\t   ",  @"      ");
    TEST(@"\t\tx",  @"      x");
    TEST(@"   \tx",  @"      x");
    TEST(@"\t   x",  @"      x");
    SC.usesTabs = YES;
    TEST(@"",  @"");
    TEST(@" ", @"");
    TEST(@"  ",@"");
    TEST(@"   ",  @"\t");
    TEST(@"    ", @"\t");
    TEST(@"     ",@"\t");
    TEST(@"      ",  @"\t\t");
    TEST(@"x",  @"x");
    TEST(@" x", @"x");
    TEST(@"  x",@"x");
    TEST(@"   x",  @"\tx");
    TEST(@"    x", @"\tx");
    TEST(@"     x",@"\tx");
    TEST(@"      x",  @"\t\tx");
    TEST(@"\t",  @"\t");
    TEST(@" \t",  @"\t");
    TEST(@"  \t",  @"\t");
    TEST(@"\t ",  @"\t");
    TEST(@"\t  ",  @"\t");
    TEST(@" \t ",  @"\t");
    TEST(@" \t  ",  @"\t");
    TEST(@"  \t ",  @"\t");
    TEST(@"  \t  ",  @"\t");
    TEST(@"\tx",  @"\tx");
    TEST(@" \tx",  @"\tx");
    TEST(@"  \tx",  @"\tx");
    TEST(@"\t x",  @"\tx");
    TEST(@"\t  x",  @"\tx");
    TEST(@" \t x",  @"\tx");
    TEST(@" \t  x",  @"\tx");
    TEST(@"  \t x",  @"\tx");
    TEST(@"  \t  x",  @"\tx");
    TEST(@"\t\t",  @"\t\t");
    TEST(@"   \t",  @"\t\t");
    TEST(@"\t   ",  @"\t\t");
    TEST(@"\t\tx",  @"\t\tx");
    TEST(@"   \tx",  @"\t\tx");
    TEST(@"\t   x",  @"\t\tx");
    SC.usesTabs = NO;
    SC.numberOfSpacesPerTab = 3;
    TEST(@"%",  @"%");
    TEST(@" %",  @"%");
    TEST(@"  %",  @"%  ");
    TEST(@"   %",  @"%  ");
    TEST(@"   % ",  @"%  ");
    TEST(@"  % % ",  @"%     ");
}
- (void) testCase_indentation_TextKit
{
    
}
@end
#if 0
#define STAssertNil(a1, description, ...)
#define STAssertNotNil(a1, description, ...)
#define STAssertTrue(expression, description, ...)
#define STAssertFalse(expression, description, ...)
#define STAssertEqualObjects(a1, a2, description, ...)
#define STAssertEquals(a1, a2, description, ...)
#define STAssertEqualsWithAccuracy(left, right, accuracy, description, ...)
#define STAssertThrows(expression, description, ...)
#define STAssertThrowsSpecific(expression, specificException, description, ...)
#define STAssertThrowsSpecificNamed(expr, specificException, aName, description, ...)
#define STAssertNoThrow(expression, description, ...)
#define STAssertNoThrowSpecific(expression, specificException, description, ...)
#define STAssertNoThrowSpecificNamed(expr, specificException, aName, description, ...)
#define STFail(description, ...)
#define STAssertTrueNoThrow(expression, description, ...)
#define STAssertFalseNoThrow(expression, description, ...)
#endif
