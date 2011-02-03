//
//  iTM2Test3B
//  iTM2Foundation
//
//  Created by Jérôme Laurens on Mon Apr 12 09:15:02 UTC 2010.
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

#import "iTM2Test3B.h"

// iTM2TextSyntaxParser

@implementation iTM2Test3B
- (void) setUp
{
    // Create data structures here.
    iTM2DebugEnabled = 20000;
    EOLs = [NSArray arrayWithObjects:@"\n",@"\r",@"\r\n",@"\f",
        [NSString stringWithFormat:@"%C",0x0085],
        [NSString stringWithFormat:@"%C",0x2028],
        [NSString stringWithFormat:@"%C",0x2029],
            nil];
}
- (void) tearDown
{
    // Release data structures here.
}
- (void) testCase_init0
{
    iTM2TextSyntaxParser * TSP = [[iTM2TextSyntaxParser alloc] init];
    STAssertNil(TSP.textStorage,@"MISSED",nil);
    STAssertTrue(TSP.numberOfModeLines == ZER0,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:ZER0] == NSUIntegerMax,@"MISSED",nil);
    TSP.textStorageDidChange;
    STAssertTrue(TSP.numberOfModeLines == 1,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:ZER0] == ZER0,@"MISSED",nil);
    iTM2ModeLine * ML = [[iTM2ModeLine alloc] initWithString:@"\n" atCursor:NULL];
    ML.EOLMode = [[[NSProcessInfo processInfo] globallyUniqueString] hash];
    [TSP replaceModeLineAtIndex:ZER0 withModeLine:ML];
#define UI NSUInteger
    [ML appendSyntaxModesAndLengths:(UI)10,(UI)10,(UI)89,(UI)89,ZER0,ZER0];
    STAssertTrue([TSP lineIndexForLocation4iTM3:ZER0] == ZER0,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:1000] == ZER0,@"MISSED",nil);
    NSUInteger mode,status;
    NSRange R;
#define TEST_Y(WHERE,STATUS,MODE,LOCATION,LENGTH) \
    status = [TSP getSyntaxMode:&mode atIndex:WHERE longestRange:&R];\
    STAssertTrue((status == STATUS && mode == MODE && NSEqualRanges(R, iTM3MakeRange(LOCATION,LENGTH)))\
        || (NSLog(@"status:%lu<?>%lu,mode:%lu<?>%lu,range:%@<?>%@",status,STATUS,mode,MODE,NSStringFromRange(R),NSStringFromRange(iTM3MakeRange(LOCATION,LENGTH))),NO),@"MISSED",nil)
    TEST_Y(ZER0,kiTM2TextNoErrorSyntaxStatus,10,ZER0,10);
    TEST_Y(5,kiTM2TextNoErrorSyntaxStatus,10,ZER0,10);
    TEST_Y(9,kiTM2TextNoErrorSyntaxStatus,10,ZER0,10);
    TEST_Y(10,kiTM2TextNoErrorSyntaxStatus,89,10,89);
    TEST_Y(20,kiTM2TextNoErrorSyntaxStatus,89,10,89);
    TEST_Y(98,kiTM2TextNoErrorSyntaxStatus,89,10,89);
    TEST_Y(99,kiTM2TextNoErrorSyntaxStatus,ML.EOLMode,99,1);
    ML = [[iTM2ModeLine alloc] initWithString:@"\r\n" atCursor:NULL];
    ML.EOLMode = [[[NSProcessInfo processInfo] globallyUniqueString] hash];
    [TSP insertModeLine:ML atIndex:TSP.numberOfModeLines];
    TEST_Y(ZER0,kiTM2TextNoErrorSyntaxStatus,10,ZER0,10);
    TEST_Y(5,kiTM2TextNoErrorSyntaxStatus,10,ZER0,10);
    TEST_Y(9,kiTM2TextNoErrorSyntaxStatus,10,ZER0,10);
    TEST_Y(10,kiTM2TextNoErrorSyntaxStatus,89,10,89);
    TEST_Y(20,kiTM2TextNoErrorSyntaxStatus,89,10,89);
    TEST_Y(98,kiTM2TextNoErrorSyntaxStatus,89,10,89);
    TEST_Y(99,kiTM2TextNoErrorSyntaxStatus,[[TSP modeLineAtIndex:ZER0] EOLMode],99,1);
    TEST_Y(100,kiTM2TextNoErrorSyntaxStatus,ML.EOLMode,100,2);
    [ML appendSyntaxModesAndLengths:(UI)8,(UI)8,(UI)20,(UI)20,(UI)70,(UI)70,ZER0,ZER0];
    TEST_Y(ZER0,kiTM2TextNoErrorSyntaxStatus,10,ZER0,10);
    TEST_Y(5,kiTM2TextNoErrorSyntaxStatus,10,ZER0,10);
    TEST_Y(9,kiTM2TextNoErrorSyntaxStatus,10,ZER0,10);
    TEST_Y(10,kiTM2TextNoErrorSyntaxStatus,89,10,89);
    TEST_Y(20,kiTM2TextNoErrorSyntaxStatus,89,10,89);
    TEST_Y(98,kiTM2TextNoErrorSyntaxStatus,89,10,89);
    TEST_Y(99,kiTM2TextNoErrorSyntaxStatus,[[TSP modeLineAtIndex:ZER0] EOLMode],99,1);
    TEST_Y(100,kiTM2TextNoErrorSyntaxStatus,8,100,8);
    TEST_Y(105,kiTM2TextNoErrorSyntaxStatus,8,100,8);
    TEST_Y(107,kiTM2TextNoErrorSyntaxStatus,8,100,8);
    TEST_Y(108,kiTM2TextNoErrorSyntaxStatus,20,108,20);
    TEST_Y(115,kiTM2TextNoErrorSyntaxStatus,20,108,20);
    TEST_Y(127,kiTM2TextNoErrorSyntaxStatus,20,108,20);
    TEST_Y(128,kiTM2TextNoErrorSyntaxStatus,70,128,70);
    TEST_Y(166,kiTM2TextNoErrorSyntaxStatus,70,128,70);
    TEST_Y(197,kiTM2TextNoErrorSyntaxStatus,70,128,70);
    TEST_Y(198,kiTM2TextNoErrorSyntaxStatus,[[TSP modeLineAtIndex:1] EOLMode],198,2);
#   undef TEST_Y
}
- (void)testCase_replaceModeLinesInRange_ML;
{
    // - (void)replaceModeLinesInRange:(NSRange)range withModeLines:(NSArray *)MLs;
    iTM2TextSyntaxParser * TSP = [[iTM2TextSyntaxParser alloc] init];
    STAssertNil(TSP.textStorage,@"MISSED",nil);
    STAssertTrue(TSP.numberOfModeLines == ZER0,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:ZER0] == NSUIntegerMax,@"MISSED",nil);
    TSP.textStorageDidChange;
    STAssertTrue(TSP.numberOfModeLines == 1,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:ZER0] == ZER0,@"MISSED",nil);
    iTM2ModeLine * ML = [[iTM2ModeLine alloc] initWithString:@"\n" atCursor:NULL];
    ML.EOLMode = [[[NSProcessInfo processInfo] globallyUniqueString] hash];
    [ML appendSyntaxModesAndLengths:(UI)10,(UI)10,(UI)89,(UI)89,ZER0,ZER0];
    NSMutableArray * MRA = [NSMutableArray array];
    [MRA addObject:ML];
    ML = nil;
    NSRange R = NSMakeRange(ZER0,1);
    [TSP replaceModeLinesInRange:R withModeLines:MRA];
    [MRA removeAllObjects];
    
    STAssertTrue(TSP.numberOfModeLines == 1,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:ZER0] == ZER0,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:1000] == ZER0,@"MISSED",nil);
    ML = [[iTM2ModeLine alloc] initWithString:@"\n" atCursor:NULL];
    ML.EOLMode = [[[NSProcessInfo processInfo] globallyUniqueString] hash];
    [ML appendSyntaxModesAndLengths:(UI)9,(UI)9,ZER0,ZER0];
    [MRA addObject:ML];
    ML = nil;
    ML = [[iTM2ModeLine alloc] initWithString:@"\n" atCursor:NULL];
    ML.EOLMode = [[[NSProcessInfo processInfo] globallyUniqueString] hash];
    [ML appendSyntaxModesAndLengths:(UI)19,(UI)19,ZER0,ZER0];
    [MRA addObject:ML];
    ML = nil;
    ML = [[iTM2ModeLine alloc] initWithString:@"\n" atCursor:NULL];
    ML.EOLMode = [[[NSProcessInfo processInfo] globallyUniqueString] hash];
    [ML appendSyntaxModesAndLengths:(UI)29,(UI)29,ZER0,ZER0];
    [MRA addObject:ML];
    ML = nil;
    R = NSMakeRange(ZER0,1);
    [TSP replaceModeLinesInRange:R withModeLines:MRA];
    [MRA removeAllObjects];
    STAssertTrue(TSP.numberOfModeLines == 3,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:ZER0] == ZER0,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:9] == ZER0,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:10] == 1,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:29] == 1,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:30] == 2,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:59] == 2,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:60] == 2,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:69] == 2,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:1000] == 2,@"MISSED",nil);
    ML = [[iTM2ModeLine alloc] initWithString:@"\n" atCursor:NULL];
    ML.EOLMode = [[[NSProcessInfo processInfo] globallyUniqueString] hash];
    [ML appendSyntaxModesAndLengths:(UI)19,(UI)19,ZER0,ZER0];
    [MRA addObject:ML];
    ML = nil;
    ML = [[iTM2ModeLine alloc] initWithString:@"\n" atCursor:NULL];
    ML.EOLMode = [[[NSProcessInfo processInfo] globallyUniqueString] hash];
    [ML appendSyntaxModesAndLengths:(UI)29,(UI)29,ZER0,ZER0];
    [MRA addObject:ML];
    ML = nil;
    ML = [[iTM2ModeLine alloc] initWithString:@"\n" atCursor:NULL];
    ML.EOLMode = [[[NSProcessInfo processInfo] globallyUniqueString] hash];
    [ML appendSyntaxModesAndLengths:(UI)39,(UI)39,ZER0,ZER0];
    [MRA addObject:ML];
    ML = nil;
    R = NSMakeRange(1,2);
    [TSP replaceModeLinesInRange:R withModeLines:MRA];
    [MRA removeAllObjects];
    STAssertTrue(TSP.numberOfModeLines == 4,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:ZER0] == ZER0,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:9] == ZER0,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:10] == 1,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:29] == 1,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:30] == 2,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:59] == 2,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:60] == 3,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:99] == 3,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:1000] == 3,@"MISSED",nil);
    ML = [[iTM2ModeLine alloc] initWithString:@"\n" atCursor:NULL];
    ML.EOLMode = [[[NSProcessInfo processInfo] globallyUniqueString] hash];
    [ML appendSyntaxModesAndLengths:(UI)49,(UI)49,ZER0,ZER0];
    [MRA addObject:ML];
    ML = nil;
    R = NSMakeRange(1,2);
    [TSP replaceModeLinesInRange:R withModeLines:MRA];
    [MRA removeAllObjects];
    STAssertTrue(TSP.numberOfModeLines == 3,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:ZER0] == ZER0,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:9] == ZER0,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:10] == 1,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:29] == 1,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:30] == 1,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:59] == 1,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:60] == 2,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:99] == 2,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:1000] == 2,@"MISSED",nil);
    return;
}
- (void)testCase_textStorageDidDeleteCharacterAtIndex;
{
    iTM2TextSyntaxParser * TSP = [[iTM2TextSyntaxParser alloc] init];
    STAssertNil(TSP.textStorage,@"MISSED",nil);
    STAssertTrue(TSP.numberOfModeLines == ZER0,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:ZER0] == NSUIntegerMax,@"MISSED",nil);
    TSP.textStorageDidChange;
    STAssertTrue(TSP.numberOfModeLines == 1,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:ZER0] == ZER0,@"MISSED",nil);
    iTM2ModeLine * ML = [TSP modeLineAtIndex:ZER0];
    NSRange R;
#define ROR (*self.RORef4iTM3)
    // test without the text storage: delete methods
    //  work with one mode line
#   undef TEST_NO
#   define TEST_NO(WHERE) \
    STAssertFalse([TSP textStorageDidDeleteCharacterAtIndex:WHERE editedAttributesRangeIn:&R ROR4iTM3],@"MISSED",NULL)
    TEST_NO(ZER0);
    TEST_NO(1);
    TEST_NO(NSUIntegerMax);
    // only one EOL
#   undef PREPARE_TEST
#   define PREPARE_TEST(WHAT) do {\
    TSP = [[iTM2TextSyntaxParser alloc] init];\
    TSP.textStorageDidChange;\
    ML = [[iTM2ModeLine alloc] initWithString:(WHAT) atCursor:NULL];\
    ML.EOLMode = [[[NSProcessInfo processInfo] globallyUniqueString] hash];\
    [TSP insertModeLine:ML atIndex:ZER0];} while(NO)
    PREPARE_TEST(@"\n");
    TEST_NO(1);
    TEST_NO(2);
    TEST_NO(NSUIntegerMax);
#   undef TEST_ML
#   define TEST_ML(CONTENTS_LENGTH,EOL_LENGTH) do{\
    STAssertTrue(ML.isConsistent,@"MISSED",NULL);\
    STAssertTrue((ML.contentsLength==CONTENTS_LENGTH)||(NSLog(@"%lu(ML)<!>%lu(Expected)",ML.contentsLength,CONTENTS_LENGTH),NO),@"MISSED",NULL);\
    STAssertTrue((ML.EOLLength==EOL_LENGTH)||(NSLog(@"%lu(ML)<!>%lu(Expected)",ML.EOLLength,EOL_LENGTH),NO),@"MISSED",NULL);\
    [ML validateLocalRange:iTM3FullRange];}while(NO)
#   undef TEST_YES
#   define TEST_YES(WHERE,LOCATION,LENGTH,EOL_LENGTH) do{\
    STAssertTrue([TSP textStorageDidDeleteCharacterAtIndex:WHERE editedAttributesRangeIn:&R ROR4iTM3],@"MISSED textStorageDidDeleteCharacterAtIndex",NULL);\
    ML.describe;\
    STAssertNil(ROR,@"MISSED ROR",NULL);\
    STAssertTrue(NSEqualRanges(R,NSMakeRange(LOCATION,LENGTH))||(NSLog(@"%@(R)<!>{%lu,%lu}(Expected)",NSStringFromRange(R),(LOCATION),(LENGTH)),NO),@"MISSED NSEqualRanges",NULL);\
    STAssertTrue((ML.EOLLength==EOL_LENGTH)||(NSLog(@"%lu(ML)<!>%lu(Expected)",ML.EOLLength,EOL_LENGTH),NO),@"MISSED",NULL);}while(NO)
    TEST_YES(ZER0,ZER0,ZER0,ZER0);// only one void mode line
    TEST_ML(ZER0,ZER0);
    PREPARE_TEST(@"\r\n");
    TEST_NO(2);
    TEST_NO(3);
    TEST_NO(NSUIntegerMax);
    TEST_YES(ZER0,ZER0,1,1);
    TEST_ML(ZER0,1);
    PREPARE_TEST(@"\r\n");
    TEST_NO(2);
    TEST_NO(3);
    TEST_NO(NSUIntegerMax);
    TEST_YES(1,ZER0,1,1);
    TEST_ML(ZER0,1);
    [ML appendSyntaxModesAndLengths:(UI)9,(UI)9,ZER0,ZER0];// 10 chars (including EOL)
    #ifdef __ELEPHANT_MODELINE__
    ML.originalString = @"123456789\n";
    #endif
    [ML validateLocalRange:iTM3FullRange];
    TEST_ML(9,1);
    TEST_NO(10);
    TEST_NO(NSUIntegerMax);
    ML.describe;
    TEST_YES(ZER0,ZER0,8,1);
    ML.describe;
    TEST_ML(8,1);
    TEST_YES(4,ZER0,7,1);
    TEST_ML(7,1);
    TEST_YES(6,ZER0,7,1);
    TEST_ML(6,1);
    TEST_YES(ZER0,ZER0,5,1);
    TEST_ML(5,1);
    TEST_YES(ZER0,ZER0,4,1);
    TEST_ML(4,1);
    TEST_YES(ZER0,ZER0,3,1);
    TEST_ML(3,1);
    TEST_YES(ZER0,ZER0,2,1);
    TEST_ML(2,1);
    TEST_YES(ZER0,ZER0,1,1);
    TEST_ML(1,1);
    TEST_YES(ZER0,ZER0,1,1);
    TEST_ML(ZER0,1);
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)5,(UI)6,(UI)6,ZER0,ZER0];// 12 chars (including EOL)
    [ML validateLocalRange:iTM3FullRange];
    #ifdef __ELEPHANT_MODELINE__
    ML.originalString = @"0123456789A\n";
    #endif
    TEST_NO(12);
    TEST_NO(NSUIntegerMax);
    TEST_YES(ZER0,ZER0,4,1);// 4,6
    TEST_YES(3,ZER0,9,1);// 3,6
    TEST_YES(3,ZER0,9,1);// 3,5
    TEST_ML(8,1);
    TEST_YES(7,1,7,1);// 3,4
    TEST_ML(7,1);
    TEST_YES(5,1,5,1);// 3,3
    TEST_ML(6,1);
    TEST_YES(5,1,5,1);// 3,2
    TEST_YES(4,1,4,1);// 3,1
    TEST_YES(3,ZER0,4,1);// 3
    TEST_YES(2,ZER0,3,1);// 2
    TEST_YES(1,ZER0,2,1);// 1
    TEST_YES(ZER0,ZER0,1,1);// ZER0
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)1,(UI)6,(UI)1,ZER0,ZER0];// 2 chars
    [ML validateLocalRange:iTM3FullRange];
    #ifdef __ELEPHANT_MODELINE__
    ML.originalString = @"01\n";
    #endif
    TEST_YES(1,ZER0,2,1);
    TEST_YES(ZER0,ZER0,1,1);
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)1,(UI)6,(UI)1,ZER0,ZER0];// 2 chars
    [ML validateLocalRange:iTM3FullRange];
    #ifdef __ELEPHANT_MODELINE__
    ML.originalString = @"01\n";
    #endif
    TEST_YES(ZER0,ZER0,1,1);
    TEST_YES(ZER0,ZER0,1,1);
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)2,(UI)6,(UI)1,ZER0,ZER0];// 3 chars
    [ML validateLocalRange:iTM3FullRange];
    #ifdef __ELEPHANT_MODELINE__
    ML.originalString = @"012\n";
    #endif
    TEST_YES(2,ZER0,3,1);//2
    TEST_ML(2,1);
    TEST_YES(ZER0,ZER0,1,1);
    TEST_YES(ZER0,ZER0,1,1);
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)2,(UI)6,(UI)2,ZER0,ZER0];// 4 chars
    [ML validateLocalRange:iTM3FullRange];
    #ifdef __ELEPHANT_MODELINE__
    ML.originalString = @"0123\n";
    #endif
    TEST_YES(ZER0,ZER0,1,1);
    TEST_ML(3,1);
    TEST_YES(ZER0,ZER0,2,1);
    TEST_YES(ZER0,ZER0,2,1);
    TEST_YES(ZER0,ZER0,1,1);
    TEST_YES(ZER0,ZER0,ZER0,ZER0);
    PREPARE_TEST(@"");
    [TSP removeModeLineAtIndex:1];
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)5,(UI)6,(UI)6,ZER0,ZER0];// 11 chars, NO EOL
    [ML validateLocalRange:iTM3FullRange];
    #ifdef __ELEPHANT_MODELINE__
    ML.originalString = @"0123456789A";
    #endif
    TEST_NO(11);
    TEST_NO(NSUIntegerMax);
    TEST_YES(ZER0,ZER0,4,ZER0);// 4,6
    TEST_YES(3,ZER0,9,ZER0);// 3,6
    TEST_YES(3,ZER0,8,ZER0);// 3,5
    TEST_ML(8,ZER0);
    TEST_YES(7,1,6,ZER0);// 3,4
    TEST_YES(5,1,5,ZER0);// 3,3
    TEST_YES(5,1,4,ZER0);// 3,2
    TEST_ML(5,ZER0);
    TEST_YES(4,ZER0,4,ZER0);// 3,1
    TEST_YES(3,ZER0,3,ZER0);// 3
    TEST_YES(2,ZER0,2,ZER0);
    TEST_YES(1,ZER0,1,ZER0);
    TEST_YES(ZER0,ZER0,ZER0,ZER0);
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)1,(UI)6,(UI)1,ZER0,ZER0];// 2 chars
    [ML validateLocalRange:iTM3FullRange];
    #ifdef __ELEPHANT_MODELINE__
    ML.originalString = @"01";
    #endif
    TEST_YES(1,ZER0,1,ZER0);
    TEST_YES(ZER0,ZER0,ZER0,ZER0);
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)1,(UI)6,(UI)1,ZER0,ZER0];// 2 chars
    [ML validateLocalRange:iTM3FullRange];
    #ifdef __ELEPHANT_MODELINE__
    ML.originalString = @"01";
    #endif
    TEST_YES(ZER0,ZER0,1,ZER0);
    TEST_YES(ZER0,ZER0,ZER0,ZER0);
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)2,(UI)6,(UI)1,ZER0,ZER0];// 3 chars
    [ML validateLocalRange:iTM3FullRange];
    #ifdef __ELEPHANT_MODELINE__
    ML.originalString = @"012";
    #endif
    TEST_YES(2,ZER0,2,ZER0);// 1,1
    TEST_YES(ZER0,ZER0,1,ZER0);// 1
    TEST_YES(ZER0,ZER0,ZER0,ZER0);// ZER0
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)2,(UI)6,(UI)2,ZER0,ZER0];// 4 chars
    [ML validateLocalRange:iTM3FullRange];
    #ifdef __ELEPHANT_MODELINE__
    ML.originalString = @"0123";
    #endif
    TEST_YES(ZER0,ZER0,1,ZER0);
    TEST_YES(ZER0,ZER0,2,ZER0);
    TEST_YES(ZER0,ZER0,1,ZER0);
    TEST_YES(ZER0,ZER0,ZER0,ZER0);
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)5,(UI)6,(UI)1,(UI)5,(UI)5,ZER0,ZER0];// 11 chars
    [ML validateLocalRange:iTM3FullRange];
    #ifdef __ELEPHANT_MODELINE__
    ML.originalString = @"0123456789A";
    #endif
    TEST_NO(11);
    TEST_NO(NSUIntegerMax);
    TEST_YES(5,ZER0,10,ZER0);// 5,1,5 -> 10
    return;
}
- (void)testCase_textStorageDidDeleteCharactersAtIndex_3_ML_B;
{
    iTM2TextSyntaxParser * TSP = [[iTM2TextSyntaxParser alloc] init];
    STAssertNil(TSP.textStorage,@"MISSED",nil);
    STAssertTrue(TSP.numberOfModeLines == ZER0,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:ZER0] == NSUIntegerMax,@"MISSED",nil);
    TSP.textStorageDidChange;
    STAssertTrue(TSP.numberOfModeLines == 1,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:ZER0] == ZER0,@"MISSED",nil);
    iTM2TextStorage * TS = [[iTM2TextStorage alloc] initWithString:
        @"01234567\r\n"
        @"ABCDEFGHI\r\n"
        @"0123456789\r\n"];
    iTM2ModeLine * ML1 = nil;
    iTM2ModeLine * ML2 = nil;
    iTM2ModeLine * ML3 = nil;
    TS.syntaxParser = TSP; // not the reverse
    ML1 = [TSP modeLineAtIndex:ZER0];
    ML2 = [TSP modeLineAtIndex:1];
    ML3 = [TSP modeLineAtIndex:2];
#   undef TEST
#   undef TEST
#   define TEST(_ML,CONTENTS_LENGTH,EOL_LENGTH)\
    STAssertTrue(_ML.isConsistent,@"MISSED diagnostic",NULL);\
    STAssertTrue((_ML.contentsLength==CONTENTS_LENGTH)||(NSLog(@"%lu(_ML)<!>%lu(Expected)",_ML.contentsLength,CONTENTS_LENGTH),NO),@"MISSED",NULL);\
    STAssertTrue((_ML.EOLLength==EOL_LENGTH)||(NSLog(@"%lu(_ML)<!>%lu(Expected)",_ML.EOLLength,EOL_LENGTH),NO),@"MISSED",NULL)
    TEST(ML1,8,2);
    TEST(ML2,9,2);
    TEST(ML3,10,2);

#   undef TEST_NO
#   undef TEST_NO
#   define TEST_NO(WHERE,COUNT) \
    STAssertFalse((COUNT>1?[TSP textStorageDidDeleteCharactersAtIndex:(WHERE) count:(COUNT) editedAttributesRangeIn:&R ROR4iTM3]:[TSP textStorageDidDeleteCharacterAtIndex:(WHERE) editedAttributesRangeIn:&R ROR4iTM3]),@"MISSED",NULL)

    NSRange R;
    //  removing partly the EOLs
    STAssertTrue(TSP.isConsistent,@"MISSED consistency",NULL);
    STAssertTrue(TS.length == 33,@"MISSED",nil);
    //  @"01234567\r\n"
    //  @"ABCDEFGHI\r\n"
    //  @"0123456789\r\n"
    [TS replaceCharactersInRange:iTM3MakeRange(9,1) withString:@""];
    STAssertTrue(TSP.isConsistent,@"MISSED consistency",NULL);
    STAssertTrue(TS.length == 32,@"MISSED",nil);
    //  @"01234567\r"
    //  @"BCDEFGHI\r\n"
    //  @"0123456789\r\n"
    [TS replaceCharactersInRange:iTM3MakeRange(9,9) withString:@""];
    STAssertTrue(TSP.isConsistent,@"MISSED consistency",NULL);
    STAssertTrue(TS.length == 23,@"MISSED",nil);
    //  @"01234567\r"
    //  @"\n"
    //  @"0123456789\r\n"
    [TS replaceCharactersInRange:iTM3MakeRange(9,1) withString:@""];
    STAssertTrue(TSP.isConsistent,@"MISSED consistency",NULL);
    STAssertTrue(TS.length == 22,@"MISSED",nil);
    //  @"01234567\r\n"
    //  @"0123456789\r\n"
    [TS replaceCharactersInRange:iTM3MakeRange(9,12) withString:@""];
    STAssertTrue(TSP.isConsistent,@"MISSED consistency",NULL);
    STAssertTrue(TS.length == 10,@"MISSED",nil);
    //  @"01234567\r\n"
#   undef TEST
#   undef TEST_NO

    return;
}
- (void)testCase_modeLineBySplittingFromGlobalLocation;
{
    iTM2ModeLine * ML1 = [iTM2ModeLine modeLine];
    iTM2ModeLine * ML2 = nil;
#   undef TEST_K
#   define TEST_K(ML,INDEX,MODE,LENGTH) do {\
        STAssertTrue(INDEX < ML.numberOfSyntaxWords,@"MISSED # of modes",nil);\
        STAssertTrue(MODE == [ML syntaxModeAtIndex:INDEX],@"MISSED MODE",nil);\
        STAssertTrue(LENGTH == [ML syntaxLengthAtIndex:INDEX],@"MISSED LENGTH",nil);\
    } while (NO)
    NSUInteger mode = 835526 | kiTM2TextEndOfLineSyntaxMask;
    NSUInteger off7 = ZER0;
    ML1.EOLMode = mode;
#define UI NSUInteger
    [ML1 appendSyntaxModesAndLengths:(UI)(UI)1,(UI)10,(UI)2,(UI)20,(UI)1,(UI)10,(UI)3,(UI)30,(UI)4,(UI)40,(UI)5,(UI)50,(UI)7,(UI)70,(UI)9,(UI)90,(UI)2,(UI)20,(UI)3,(UI)30,ZER0,ZER0];
    TEST_K(ML1,ZER0,1,10);
    TEST_K(ML1,1,2,20);
    TEST_K(ML1,2,1,10);
    TEST_K(ML1,3,3,30);
    TEST_K(ML1,4,4,40);
    TEST_K(ML1,5,5,50);
    TEST_K(ML1,6,7,70);
    TEST_K(ML1,7,9,90);
    TEST_K(ML1,8,2,20);
    TEST_K(ML1,9,3,30);
    ML1.describe;
    ML2 = [ML1 modeLineBySplittingFromGlobalLocation:ZER0 ROR4iTM3];
    ML1.describe;
    ML2.describe;
    STAssertTrue((ML2.EOLMode == mode) ||(NSLog(@"%lu<!>%lu",mode,ML2.EOLMode),NO),@"MISSED",nil);
    TEST_K(ML2,ZER0,1,10);
    TEST_K(ML2,1,2,20);
    TEST_K(ML2,2,1,10);
    TEST_K(ML2,3,3,30);
    TEST_K(ML2,4,4,40);
    TEST_K(ML2,5,5,50);
    TEST_K(ML2,6,7,70);
    TEST_K(ML2,7,9,90);
    TEST_K(ML2,8,2,20);
    TEST_K(ML2,9,3,30);
#define PREPARE_TEST_K(WHERE) do {\
        ML1 = [iTM2ModeLine modeLine];\
        ML1.EOLMode = mode;\
        ML1.startOff7 = off7;\
        [ML1 appendSyntaxModesAndLengths:(UI)1,(UI)10,(UI)2,(UI)20,(UI)1,(UI)10,(UI)3,(UI)30,(UI)4,(UI)40,(UI)5,(UI)50,(UI)7,(UI)70,(UI)9,(UI)90,(UI)2,(UI)20,(UI)3,(UI)30,ZER0,ZER0];\
        ML2 = [ML1 modeLineBySplittingFromGlobalLocation:WHERE ROR4iTM3];\
        STAssertTrue(!ML2.EOLLength || (ML2.EOLMode == mode),@"MISSED EOLMode",nil);\
    } while (NO)
    PREPARE_TEST_K(1);
    TEST_K(ML1,ZER0,1,1);
    TEST_K(ML2,ZER0,1,9);
    TEST_K(ML2,1,2,20);
    TEST_K(ML2,2,1,10);
    TEST_K(ML2,3,3,30);
    TEST_K(ML2,4,4,40);
    TEST_K(ML2,5,5,50);
    TEST_K(ML2,6,7,70);
    TEST_K(ML2,7,9,90);
    TEST_K(ML2,8,2,20);
    TEST_K(ML2,9,3,30);
    PREPARE_TEST_K(2);
    TEST_K(ML1,ZER0,1,2);
    TEST_K(ML2,ZER0,1,8);
    TEST_K(ML2,1,2,20);
    TEST_K(ML2,2,1,10);
    TEST_K(ML2,3,3,30);
    TEST_K(ML2,4,4,40);
    TEST_K(ML2,5,5,50);
    TEST_K(ML2,6,7,70);
    TEST_K(ML2,7,9,90);
    TEST_K(ML2,8,2,20);
    TEST_K(ML2,9,3,30);
    PREPARE_TEST_K(8);
    TEST_K(ML1,ZER0,1,8);
    TEST_K(ML2,ZER0,1,2);
    TEST_K(ML2,1,2,20);
    TEST_K(ML2,2,1,10);
    TEST_K(ML2,3,3,30);
    TEST_K(ML2,4,4,40);
    TEST_K(ML2,5,5,50);
    TEST_K(ML2,6,7,70);
    TEST_K(ML2,7,9,90);
    TEST_K(ML2,8,2,20);
    TEST_K(ML2,9,3,30);
    PREPARE_TEST_K(9);
    TEST_K(ML1,ZER0,1,9);
    TEST_K(ML2,ZER0,1,1);
    TEST_K(ML2,1,2,20);
    TEST_K(ML2,2,1,10);
    TEST_K(ML2,3,3,30);
    TEST_K(ML2,4,4,40);
    TEST_K(ML2,5,5,50);
    TEST_K(ML2,6,7,70);
    TEST_K(ML2,7,9,90);
    TEST_K(ML2,8,2,20);
    TEST_K(ML2,9,3,30);
    PREPARE_TEST_K(10);
    TEST_K(ML1,ZER0,1,10);
    TEST_K(ML2,1-1,2,20);
    TEST_K(ML2,2-1,1,10);
    TEST_K(ML2,3-1,3,30);
    TEST_K(ML2,4-1,4,40);
    TEST_K(ML2,5-1,5,50);
    TEST_K(ML2,6-1,7,70);
    TEST_K(ML2,7-1,9,90);
    TEST_K(ML2,8-1,2,20);
    TEST_K(ML2,9-1,3,30);
    PREPARE_TEST_K(11);
    TEST_K(ML1,ZER0,1,10);
    TEST_K(ML1,1,2,1);
    TEST_K(ML2,1-1,2,19);
    TEST_K(ML2,2-1,1,10);
    TEST_K(ML2,3-1,3,30);
    TEST_K(ML2,4-1,4,40);
    TEST_K(ML2,5-1,5,50);
    TEST_K(ML2,6-1,7,70);
    TEST_K(ML2,7-1,9,90);
    TEST_K(ML2,8-1,2,20);
    TEST_K(ML2,9-1,3,30);
    PREPARE_TEST_K(12);
    TEST_K(ML1,ZER0,1,10);
    TEST_K(ML1,1,2,2);
    TEST_K(ML2,1-1,2,18);
    TEST_K(ML2,2-1,1,10);
    TEST_K(ML2,3-1,3,30);
    TEST_K(ML2,4-1,4,40);
    TEST_K(ML2,5-1,5,50);
    TEST_K(ML2,6-1,7,70);
    TEST_K(ML2,7-1,9,90);
    TEST_K(ML2,8-1,2,20);
    TEST_K(ML2,9-1,3,30);
    PREPARE_TEST_K(13);
    TEST_K(ML1,ZER0,1,10);
    TEST_K(ML1,1,2,3);
    TEST_K(ML2,1-1,2,17);
    TEST_K(ML2,2-1,1,10);
    TEST_K(ML2,3-1,3,30);
    TEST_K(ML2,4-1,4,40);
    TEST_K(ML2,5-1,5,50);
    TEST_K(ML2,6-1,7,70);
    TEST_K(ML2,7-1,9,90);
    TEST_K(ML2,8-1,2,20);
    TEST_K(ML2,9-1,3,30);
    PREPARE_TEST_K(29);
    TEST_K(ML1,ZER0,1,10);
    TEST_K(ML1,1,2,19);
    TEST_K(ML2,1-1,2,1);
    TEST_K(ML2,2-1,1,10);
    TEST_K(ML2,3-1,3,30);
    TEST_K(ML2,4-1,4,40);
    TEST_K(ML2,5-1,5,50);
    TEST_K(ML2,6-1,7,70);
    TEST_K(ML2,7-1,9,90);
    TEST_K(ML2,8-1,2,20);
    TEST_K(ML2,9-1,3,30);
    PREPARE_TEST_K(30);
    TEST_K(ML1,ZER0,1,10);
    TEST_K(ML1,1,2,20);
    TEST_K(ML2,2-2,1,10);
    TEST_K(ML2,3-2,3,30);
    TEST_K(ML2,4-2,4,40);
    TEST_K(ML2,5-2,5,50);
    TEST_K(ML2,6-2,7,70);
    TEST_K(ML2,7-2,9,90);
    TEST_K(ML2,8-2,2,20);
    TEST_K(ML2,9-2,3,30);
    PREPARE_TEST_K(31);
    TEST_K(ML1,ZER0,1,10);
    TEST_K(ML1,1,2,20);
    TEST_K(ML1,2,1,1);
    TEST_K(ML2,2-2,1,9);
    TEST_K(ML2,3-2,3,30);
    TEST_K(ML2,4-2,4,40);
    TEST_K(ML2,5-2,5,50);
    TEST_K(ML2,6-2,7,70);
    TEST_K(ML2,7-2,9,90);
    TEST_K(ML2,8-2,2,20);
    TEST_K(ML2,9-2,3,30);
    PREPARE_TEST_K(32);
    TEST_K(ML1,ZER0,1,10);
    TEST_K(ML1,1,2,20);
    TEST_K(ML1,2,1,2);
    TEST_K(ML2,2-2,1,8);
    TEST_K(ML2,3-2,3,30);
    TEST_K(ML2,4-2,4,40);
    TEST_K(ML2,5-2,5,50);
    TEST_K(ML2,6-2,7,70);
    TEST_K(ML2,7-2,9,90);
    TEST_K(ML2,8-2,2,20);
    TEST_K(ML2,9-2,3,30);
    PREPARE_TEST_K(39);
    TEST_K(ML1,ZER0,1,10);
    TEST_K(ML1,1,2,20);
    TEST_K(ML1,2,1,9);
    TEST_K(ML2,2-2,1,1);
    TEST_K(ML2,3-2,3,30);
    TEST_K(ML2,4-2,4,40);
    TEST_K(ML2,5-2,5,50);
    TEST_K(ML2,6-2,7,70);
    TEST_K(ML2,7-2,9,90);
    TEST_K(ML2,8-2,2,20);
    TEST_K(ML2,9-2,3,30);
    PREPARE_TEST_K(40);
    TEST_K(ML1,ZER0,1,10);
    TEST_K(ML1,1,2,20);
    TEST_K(ML1,2,1,10);
    TEST_K(ML2,3-3,3,30);
    TEST_K(ML2,4-3,4,40);
    TEST_K(ML2,5-3,5,50);
    TEST_K(ML2,6-3,7,70);
    TEST_K(ML2,7-3,9,90);
    TEST_K(ML2,8-3,2,20);
    TEST_K(ML2,9-3,3,30);
    PREPARE_TEST_K(41);
    TEST_K(ML1,ZER0,1,10);
    TEST_K(ML1,1,2,20);
    TEST_K(ML1,2,1,10);
    TEST_K(ML1,3,3,1);
    TEST_K(ML2,3-3,3,29);
    TEST_K(ML2,4-3,4,40);
    TEST_K(ML2,5-3,5,50);
    TEST_K(ML2,6-3,7,70);
    TEST_K(ML2,7-3,9,90);
    TEST_K(ML2,8-3,2,20);
    TEST_K(ML2,9-3,3,30);
    PREPARE_TEST_K(160);
    TEST_K(ML1,ZER0,1,10);
    TEST_K(ML1,1,2,20);
    TEST_K(ML1,2,1,10);
    TEST_K(ML1,3,3,30);
    TEST_K(ML1,4,4,40);
    TEST_K(ML1,5,5,50);
    TEST_K(ML2,6-6,7,70);
    TEST_K(ML2,7-6,9,90);
    TEST_K(ML2,8-6,2,20);
    TEST_K(ML2,9-6,3,30);
    PREPARE_TEST_K(339);
    TEST_K(ML1,ZER0,1,10);
    TEST_K(ML1,1,2,20);
    TEST_K(ML1,2,1,10);
    TEST_K(ML1,3,3,30);
    TEST_K(ML1,4,4,40);
    TEST_K(ML1,5,5,50);
    TEST_K(ML1,6,7,70);
    TEST_K(ML1,7,9,90);
    TEST_K(ML1,8,2,19);
    TEST_K(ML2,8-8,2,1);
    TEST_K(ML2,9-8,3,30);
    PREPARE_TEST_K(340);
    TEST_K(ML1,ZER0,1,10);
    TEST_K(ML1,1,2,20);
    TEST_K(ML1,2,1,10);
    TEST_K(ML1,3,3,30);
    TEST_K(ML1,4,4,40);
    TEST_K(ML1,5,5,50);
    TEST_K(ML1,6,7,70);
    TEST_K(ML1,7,9,90);
    TEST_K(ML1,8,2,20);
    TEST_K(ML2,9-9,3,30);
    PREPARE_TEST_K(341);
    TEST_K(ML1,ZER0,1,10);
    TEST_K(ML1,1,2,20);
    TEST_K(ML1,2,1,10);
    TEST_K(ML1,3,3,30);
    TEST_K(ML1,4,4,40);
    TEST_K(ML1,5,5,50);
    TEST_K(ML1,6,7,70);
    TEST_K(ML1,7,9,90);
    TEST_K(ML1,8,2,20);
    TEST_K(ML1,9,3,1);
    TEST_K(ML2,9-9,3,29);
    PREPARE_TEST_K(369);
    TEST_K(ML1,ZER0,1,10);
    TEST_K(ML1,1,2,20);
    TEST_K(ML1,2,1,10);
    TEST_K(ML1,3,3,30);
    TEST_K(ML1,4,4,40);
    TEST_K(ML1,5,5,50);
    TEST_K(ML1,6,7,70);
    TEST_K(ML1,7,9,90);
    TEST_K(ML1,8,2,20);
    TEST_K(ML1,9,3,29);
    TEST_K(ML2,9-9,3,1);
    PREPARE_TEST_K(370);
    TEST_K(ML1,ZER0,1,10);
    TEST_K(ML1,1,2,20);
    TEST_K(ML1,2,1,10);
    TEST_K(ML1,3,3,30);
    TEST_K(ML1,4,4,40);
    TEST_K(ML1,5,5,50);
    TEST_K(ML1,6,7,70);
    TEST_K(ML1,7,9,90);
    TEST_K(ML1,8,2,20);
    TEST_K(ML1,9,3,30);
    PREPARE_TEST_K(371);
    TEST_K(ML1,ZER0,1,10);
    TEST_K(ML1,1,2,20);
    TEST_K(ML1,2,1,10);
    TEST_K(ML1,3,3,30);
    TEST_K(ML1,4,4,40);
    TEST_K(ML1,5,5,50);
    TEST_K(ML1,6,7,70);
    TEST_K(ML1,7,9,90);
    TEST_K(ML1,8,2,20);
    TEST_K(ML1,9,3,30);
    PREPARE_TEST_K(372);
    TEST_K(ML1,ZER0,1,10);
    TEST_K(ML1,1,2,20);
    TEST_K(ML1,2,1,10);
    TEST_K(ML1,3,3,30);
    TEST_K(ML1,4,4,40);
    TEST_K(ML1,5,5,50);
    TEST_K(ML1,6,7,70);
    TEST_K(ML1,7,9,90);
    TEST_K(ML1,8,2,20);
    TEST_K(ML1,9,3,30);
    PREPARE_TEST_K(NSUIntegerMax);
    TEST_K(ML1,ZER0,1,10);
    TEST_K(ML1,1,2,20);
    TEST_K(ML1,2,1,10);
    TEST_K(ML1,3,3,30);
    TEST_K(ML1,4,4,40);
    TEST_K(ML1,5,5,50);
    TEST_K(ML1,6,7,70);
    TEST_K(ML1,7,9,90);
    TEST_K(ML1,8,2,20);
    TEST_K(ML1,9,3,30);
    ////
    off7 = 12345;
    PREPARE_TEST_K(off7+1);
    TEST_K(ML1,ZER0,1,1);
    TEST_K(ML2,ZER0,1,9);
    TEST_K(ML2,1,2,20);
    TEST_K(ML2,2,1,10);
    TEST_K(ML2,3,3,30);
    TEST_K(ML2,4,4,40);
    TEST_K(ML2,5,5,50);
    TEST_K(ML2,6,7,70);
    TEST_K(ML2,7,9,90);
    TEST_K(ML2,8,2,20);
    TEST_K(ML2,9,3,30);
    PREPARE_TEST_K(off7+2);
    TEST_K(ML1,ZER0,1,2);
    TEST_K(ML2,ZER0,1,8);
    TEST_K(ML2,1,2,20);
    TEST_K(ML2,2,1,10);
    TEST_K(ML2,3,3,30);
    TEST_K(ML2,4,4,40);
    TEST_K(ML2,5,5,50);
    TEST_K(ML2,6,7,70);
    TEST_K(ML2,7,9,90);
    TEST_K(ML2,8,2,20);
    TEST_K(ML2,9,3,30);
    PREPARE_TEST_K(off7+8);
    TEST_K(ML1,ZER0,1,8);
    TEST_K(ML2,ZER0,1,2);
    TEST_K(ML2,1,2,20);
    TEST_K(ML2,2,1,10);
    TEST_K(ML2,3,3,30);
    TEST_K(ML2,4,4,40);
    TEST_K(ML2,5,5,50);
    TEST_K(ML2,6,7,70);
    TEST_K(ML2,7,9,90);
    TEST_K(ML2,8,2,20);
    TEST_K(ML2,9,3,30);
    PREPARE_TEST_K(off7+9);
    TEST_K(ML1,ZER0,1,9);
    TEST_K(ML2,ZER0,1,1);
    TEST_K(ML2,1,2,20);
    TEST_K(ML2,2,1,10);
    TEST_K(ML2,3,3,30);
    TEST_K(ML2,4,4,40);
    TEST_K(ML2,5,5,50);
    TEST_K(ML2,6,7,70);
    TEST_K(ML2,7,9,90);
    TEST_K(ML2,8,2,20);
    TEST_K(ML2,9,3,30);
    PREPARE_TEST_K(off7+10);
    TEST_K(ML1,ZER0,1,10);
    TEST_K(ML2,1-1,2,20);
    TEST_K(ML2,2-1,1,10);
    TEST_K(ML2,3-1,3,30);
    TEST_K(ML2,4-1,4,40);
    TEST_K(ML2,5-1,5,50);
    TEST_K(ML2,6-1,7,70);
    TEST_K(ML2,7-1,9,90);
    TEST_K(ML2,8-1,2,20);
    TEST_K(ML2,9-1,3,30);
    PREPARE_TEST_K(off7+11);
    TEST_K(ML1,ZER0,1,10);
    TEST_K(ML1,1,2,1);
    TEST_K(ML2,1-1,2,19);
    TEST_K(ML2,2-1,1,10);
    TEST_K(ML2,3-1,3,30);
    TEST_K(ML2,4-1,4,40);
    TEST_K(ML2,5-1,5,50);
    TEST_K(ML2,6-1,7,70);
    TEST_K(ML2,7-1,9,90);
    TEST_K(ML2,8-1,2,20);
    TEST_K(ML2,9-1,3,30);
    PREPARE_TEST_K(off7+12);
    TEST_K(ML1,ZER0,1,10);
    TEST_K(ML1,1,2,2);
    TEST_K(ML2,1-1,2,18);
    TEST_K(ML2,2-1,1,10);
    TEST_K(ML2,3-1,3,30);
    TEST_K(ML2,4-1,4,40);
    TEST_K(ML2,5-1,5,50);
    TEST_K(ML2,6-1,7,70);
    TEST_K(ML2,7-1,9,90);
    TEST_K(ML2,8-1,2,20);
    TEST_K(ML2,9-1,3,30);
    PREPARE_TEST_K(off7+13);
    TEST_K(ML1,ZER0,1,10);
    TEST_K(ML1,1,2,3);
    TEST_K(ML2,1-1,2,17);
    TEST_K(ML2,2-1,1,10);
    TEST_K(ML2,3-1,3,30);
    TEST_K(ML2,4-1,4,40);
    TEST_K(ML2,5-1,5,50);
    TEST_K(ML2,6-1,7,70);
    TEST_K(ML2,7-1,9,90);
    TEST_K(ML2,8-1,2,20);
    TEST_K(ML2,9-1,3,30);
    PREPARE_TEST_K(off7+29);
    TEST_K(ML1,ZER0,1,10);
    TEST_K(ML1,1,2,19);
    TEST_K(ML2,1-1,2,1);
    TEST_K(ML2,2-1,1,10);
    TEST_K(ML2,3-1,3,30);
    TEST_K(ML2,4-1,4,40);
    TEST_K(ML2,5-1,5,50);
    TEST_K(ML2,6-1,7,70);
    TEST_K(ML2,7-1,9,90);
    TEST_K(ML2,8-1,2,20);
    TEST_K(ML2,9-1,3,30);
    PREPARE_TEST_K(off7+30);
    TEST_K(ML1,ZER0,1,10);
    TEST_K(ML1,1,2,20);
    TEST_K(ML2,2-2,1,10);
    TEST_K(ML2,3-2,3,30);
    TEST_K(ML2,4-2,4,40);
    TEST_K(ML2,5-2,5,50);
    TEST_K(ML2,6-2,7,70);
    TEST_K(ML2,7-2,9,90);
    TEST_K(ML2,8-2,2,20);
    TEST_K(ML2,9-2,3,30);
    PREPARE_TEST_K(off7+31);
    TEST_K(ML1,ZER0,1,10);
    TEST_K(ML1,1,2,20);
    TEST_K(ML1,2,1,1);
    TEST_K(ML2,2-2,1,9);
    TEST_K(ML2,3-2,3,30);
    TEST_K(ML2,4-2,4,40);
    TEST_K(ML2,5-2,5,50);
    TEST_K(ML2,6-2,7,70);
    TEST_K(ML2,7-2,9,90);
    TEST_K(ML2,8-2,2,20);
    TEST_K(ML2,9-2,3,30);
    PREPARE_TEST_K(off7+32);
    TEST_K(ML1,ZER0,1,10);
    TEST_K(ML1,1,2,20);
    TEST_K(ML1,2,1,2);
    TEST_K(ML2,2-2,1,8);
    TEST_K(ML2,3-2,3,30);
    TEST_K(ML2,4-2,4,40);
    TEST_K(ML2,5-2,5,50);
    TEST_K(ML2,6-2,7,70);
    TEST_K(ML2,7-2,9,90);
    TEST_K(ML2,8-2,2,20);
    TEST_K(ML2,9-2,3,30);
    PREPARE_TEST_K(off7+39);
    TEST_K(ML1,ZER0,1,10);
    TEST_K(ML1,1,2,20);
    TEST_K(ML1,2,1,9);
    TEST_K(ML2,2-2,1,1);
    TEST_K(ML2,3-2,3,30);
    TEST_K(ML2,4-2,4,40);
    TEST_K(ML2,5-2,5,50);
    TEST_K(ML2,6-2,7,70);
    TEST_K(ML2,7-2,9,90);
    TEST_K(ML2,8-2,2,20);
    TEST_K(ML2,9-2,3,30);
    PREPARE_TEST_K(off7+40);
    TEST_K(ML1,ZER0,1,10);
    TEST_K(ML1,1,2,20);
    TEST_K(ML1,2,1,10);
    TEST_K(ML2,3-3,3,30);
    TEST_K(ML2,4-3,4,40);
    TEST_K(ML2,5-3,5,50);
    TEST_K(ML2,6-3,7,70);
    TEST_K(ML2,7-3,9,90);
    TEST_K(ML2,8-3,2,20);
    TEST_K(ML2,9-3,3,30);
    PREPARE_TEST_K(off7+41);
    TEST_K(ML1,ZER0,1,10);
    TEST_K(ML1,1,2,20);
    TEST_K(ML1,2,1,10);
    TEST_K(ML1,3,3,1);
    TEST_K(ML2,3-3,3,29);
    TEST_K(ML2,4-3,4,40);
    TEST_K(ML2,5-3,5,50);
    TEST_K(ML2,6-3,7,70);
    TEST_K(ML2,7-3,9,90);
    TEST_K(ML2,8-3,2,20);
    TEST_K(ML2,9-3,3,30);
    PREPARE_TEST_K(off7+160);
    TEST_K(ML1,ZER0,1,10);
    TEST_K(ML1,1,2,20);
    TEST_K(ML1,2,1,10);
    TEST_K(ML1,3,3,30);
    TEST_K(ML1,4,4,40);
    TEST_K(ML1,5,5,50);
    TEST_K(ML2,6-6,7,70);
    TEST_K(ML2,7-6,9,90);
    TEST_K(ML2,8-6,2,20);
    TEST_K(ML2,9-6,3,30);
    PREPARE_TEST_K(off7+339);
    TEST_K(ML1,ZER0,1,10);
    TEST_K(ML1,1,2,20);
    TEST_K(ML1,2,1,10);
    TEST_K(ML1,3,3,30);
    TEST_K(ML1,4,4,40);
    TEST_K(ML1,5,5,50);
    TEST_K(ML1,6,7,70);
    TEST_K(ML1,7,9,90);
    TEST_K(ML1,8,2,19);
    TEST_K(ML2,8-8,2,1);
    TEST_K(ML2,9-8,3,30);
    PREPARE_TEST_K(off7+340);
    TEST_K(ML1,ZER0,1,10);
    TEST_K(ML1,1,2,20);
    TEST_K(ML1,2,1,10);
    TEST_K(ML1,3,3,30);
    TEST_K(ML1,4,4,40);
    TEST_K(ML1,5,5,50);
    TEST_K(ML1,6,7,70);
    TEST_K(ML1,7,9,90);
    TEST_K(ML1,8,2,20);
    TEST_K(ML2,9-9,3,30);
    PREPARE_TEST_K(off7+341);
    TEST_K(ML1,ZER0,1,10);
    TEST_K(ML1,1,2,20);
    TEST_K(ML1,2,1,10);
    TEST_K(ML1,3,3,30);
    TEST_K(ML1,4,4,40);
    TEST_K(ML1,5,5,50);
    TEST_K(ML1,6,7,70);
    TEST_K(ML1,7,9,90);
    TEST_K(ML1,8,2,20);
    TEST_K(ML1,9,3,1);
    TEST_K(ML2,9-9,3,29);
    PREPARE_TEST_K(off7+369);
    TEST_K(ML1,ZER0,1,10);
    TEST_K(ML1,1,2,20);
    TEST_K(ML1,2,1,10);
    TEST_K(ML1,3,3,30);
    TEST_K(ML1,4,4,40);
    TEST_K(ML1,5,5,50);
    TEST_K(ML1,6,7,70);
    TEST_K(ML1,7,9,90);
    TEST_K(ML1,8,2,20);
    TEST_K(ML1,9,3,29);
    TEST_K(ML2,9-9,3,1);
    PREPARE_TEST_K(off7+370);
    TEST_K(ML1,ZER0,1,10);
    TEST_K(ML1,1,2,20);
    TEST_K(ML1,2,1,10);
    TEST_K(ML1,3,3,30);
    TEST_K(ML1,4,4,40);
    TEST_K(ML1,5,5,50);
    TEST_K(ML1,6,7,70);
    TEST_K(ML1,7,9,90);
    TEST_K(ML1,8,2,20);
    TEST_K(ML1,9,3,30);
    PREPARE_TEST_K(off7+371);
    TEST_K(ML1,ZER0,1,10);
    TEST_K(ML1,1,2,20);
    TEST_K(ML1,2,1,10);
    TEST_K(ML1,3,3,30);
    TEST_K(ML1,4,4,40);
    TEST_K(ML1,5,5,50);
    TEST_K(ML1,6,7,70);
    TEST_K(ML1,7,9,90);
    TEST_K(ML1,8,2,20);
    TEST_K(ML1,9,3,30);
    PREPARE_TEST_K(off7+372);
    TEST_K(ML1,ZER0,1,10);
    TEST_K(ML1,1,2,20);
    TEST_K(ML1,2,1,10);
    TEST_K(ML1,3,3,30);
    TEST_K(ML1,4,4,40);
    TEST_K(ML1,5,5,50);
    TEST_K(ML1,6,7,70);
    TEST_K(ML1,7,9,90);
    TEST_K(ML1,8,2,20);
    TEST_K(ML1,9,3,30);
    PREPARE_TEST_K(NSUIntegerMax);
    TEST_K(ML1,ZER0,1,10);
    TEST_K(ML1,1,2,20);
    TEST_K(ML1,2,1,10);
    TEST_K(ML1,3,3,30);
    TEST_K(ML1,4,4,40);
    TEST_K(ML1,5,5,50);
    TEST_K(ML1,6,7,70);
    TEST_K(ML1,7,9,90);
    TEST_K(ML1,8,2,20);
    TEST_K(ML1,9,3,30);
    
    PREPARE_TEST_K(off7);
    TEST_K(ML2,ZER0,1,10);
    TEST_K(ML2,1,2,20);
    TEST_K(ML2,2,1,10);
    TEST_K(ML2,3,3,30);
    TEST_K(ML2,4,4,40);
    TEST_K(ML2,5,5,50);
    TEST_K(ML2,6,7,70);
    TEST_K(ML2,7,9,90);
    TEST_K(ML2,8,2,20);
    TEST_K(ML2,9,3,30);
    
    PREPARE_TEST_K(off7-1);
    TEST_K(ML2,ZER0,1,10);
    TEST_K(ML2,1,2,20);
    TEST_K(ML2,2,1,10);
    TEST_K(ML2,3,3,30);
    TEST_K(ML2,4,4,40);
    TEST_K(ML2,5,5,50);
    TEST_K(ML2,6,7,70);
    TEST_K(ML2,7,9,90);
    TEST_K(ML2,8,2,20);
    TEST_K(ML2,9,3,30);
    PREPARE_TEST_K(0);
    TEST_K(ML2,ZER0,1,10);
    TEST_K(ML2,1,2,20);
    TEST_K(ML2,2,1,10);
    TEST_K(ML2,3,3,30);
    TEST_K(ML2,4,4,40);
    TEST_K(ML2,5,5,50);
    TEST_K(ML2,6,7,70);
    TEST_K(ML2,7,9,90);
    TEST_K(ML2,8,2,20);
    TEST_K(ML2,9,3,30);

    return;
#   undef PREPARE_TEST_K
#   undef TEST_K
}

@end

