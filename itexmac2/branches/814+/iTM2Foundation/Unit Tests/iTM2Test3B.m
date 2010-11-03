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
    NSError * ROR = nil;
    // test without the text storage: delete methods
    //  work with one mode line
#   undef TEST_NO
#   define TEST_NO(WHERE) \
    STAssertFalse([TSP textStorageDidDeleteCharacterAtIndex:WHERE editedAttributesRangeIn:&R error:&ROR],@"MISSED",NULL)
    TEST_NO(ZER0);
    TEST_NO(1);
    TEST_NO(NSUIntegerMax);
    // only one EOL
    ML = [[iTM2ModeLine alloc] initWithString:@"\n" atCursor:NULL];
    ML.EOLMode = [[[NSProcessInfo processInfo] globallyUniqueString] hash];
    [TSP replaceModeLineAtIndex:ZER0 withModeLine:ML];
    TEST_NO(1);
    TEST_NO(2);
    TEST_NO(NSUIntegerMax);
#   undef TEST_ML
#   define TEST_ML(CONTENTS_LENGTH,EOL_LENGTH)\
    STAssertFalse(ML.diagnostic,@"MISSED",NULL);\
    STAssertTrue((ML.contentsLength==CONTENTS_LENGTH)||(NSLog(@"%lu(ML)<!>%lu(Expected)",ML.contentsLength,CONTENTS_LENGTH),NO),@"MISSED",NULL);\
    STAssertTrue((ML.EOLLength==EOL_LENGTH)||(NSLog(@"%lu(ML)<!>%lu(Expected)",ML.EOLLength,EOL_LENGTH),NO),@"MISSED",NULL);\
    [ML validateLocalRange:iTM3FullRange]
#   undef TEST_YES
#   define TEST_YES(WHERE,LOCATION,LENGTH,EOL_LENGTH) \
    STAssertTrue([TSP textStorageDidDeleteCharacterAtIndex:WHERE editedAttributesRangeIn:&R error:&ROR],@"MISSED textStorageDidDeleteCharacterAtIndex",NULL);\
    ML.describe;\
    STAssertNil(ROR,@"MISSED ROR",NULL);\
    STAssertTrue(NSEqualRanges(R,NSMakeRange(LOCATION,LENGTH))||(NSLog(@"%@(R)<!>{%lu,%lu}(Expected)",NSStringFromRange(R),(LOCATION),(LENGTH)),NO),@"MISSED NSEqualRanges",NULL);\
    STAssertTrue((ML.EOLLength==EOL_LENGTH)||(NSLog(@"%lu(ML)<!>%lu(Expected)",ML.EOLLength,EOL_LENGTH),NO),@"MISSED",NULL)
    TEST_YES(ZER0,ZER0,ZER0,ZER0);
    TEST_ML(ZER0,ZER0);
    ML = [[iTM2ModeLine alloc] initWithString:@"\r\n" atCursor:NULL];
    ML.EOLMode = [[[NSProcessInfo processInfo] globallyUniqueString] hash];
    [TSP replaceModeLineAtIndex:ZER0 withModeLine:ML];
    TEST_NO(2);
    TEST_NO(3);
    TEST_NO(NSUIntegerMax);
    TEST_YES(ZER0,ZER0,1,1);
    TEST_ML(ZER0,1);
    ML = [[iTM2ModeLine alloc] initWithString:@"\r\n" atCursor:NULL];
    ML.EOLMode = [[[NSProcessInfo processInfo] globallyUniqueString] hash];
    [TSP replaceModeLineAtIndex:ZER0 withModeLine:ML];
    TEST_NO(2);
    TEST_NO(3);
    TEST_NO(NSUIntegerMax);
    TEST_YES(1,ZER0,1,1);
    TEST_ML(ZER0,1);
    [ML appendSyntaxModesAndLengths:(UI)9,(UI)9,ZER0,ZER0];// 10 chars (including EOL)
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
    TEST_YES(1,ZER0,2,1);
    TEST_YES(ZER0,ZER0,1,1);
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)1,(UI)6,(UI)1,ZER0,ZER0];// 2 chars
    [ML validateLocalRange:iTM3FullRange];
    TEST_YES(ZER0,ZER0,1,1);
    TEST_YES(ZER0,ZER0,1,1);
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)2,(UI)6,(UI)1,ZER0,ZER0];// 3 chars
    [ML validateLocalRange:iTM3FullRange];
    TEST_YES(2,ZER0,3,1);//2
    TEST_ML(2,1);
    TEST_YES(ZER0,ZER0,1,1);
    TEST_YES(ZER0,ZER0,1,1);
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)2,(UI)6,(UI)2,ZER0,ZER0];// 4 chars
    [ML validateLocalRange:iTM3FullRange];
    TEST_YES(ZER0,ZER0,1,1);
    TEST_ML(3,1);
    TEST_YES(ZER0,ZER0,2,1);
    TEST_YES(ZER0,ZER0,2,1);
    TEST_YES(ZER0,ZER0,1,1);
    
    TEST_YES(ZER0,ZER0,ZER0,ZER0);
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)5,(UI)6,(UI)6,ZER0,ZER0];// 11 chars
    [ML validateLocalRange:iTM3FullRange];
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
    TEST_YES(1,ZER0,1,ZER0);
    TEST_YES(ZER0,ZER0,ZER0,ZER0);
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)1,(UI)6,(UI)1,ZER0,ZER0];// 2 chars
    [ML validateLocalRange:iTM3FullRange];
    TEST_YES(ZER0,ZER0,1,ZER0);
    TEST_YES(ZER0,ZER0,ZER0,ZER0);
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)2,(UI)6,(UI)1,ZER0,ZER0];// 3 chars
    [ML validateLocalRange:iTM3FullRange];
    TEST_YES(2,ZER0,2,ZER0);// 1,1
    TEST_YES(ZER0,ZER0,1,ZER0);// 1
    TEST_YES(ZER0,ZER0,ZER0,ZER0);// ZER0
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)2,(UI)6,(UI)2,ZER0,ZER0];// 4 chars
    [ML validateLocalRange:iTM3FullRange];
    TEST_YES(ZER0,ZER0,1,ZER0);
    TEST_YES(ZER0,ZER0,2,ZER0);
    TEST_YES(ZER0,ZER0,1,ZER0);
    TEST_YES(ZER0,ZER0,ZER0,ZER0);
    
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)5,(UI)6,(UI)1,(UI)5,(UI)5,ZER0,ZER0];// 11 chars
    [ML validateLocalRange:iTM3FullRange];
    TEST_NO(11);
    TEST_NO(NSUIntegerMax);
    TEST_YES(5,ZER0,10,ZER0);// 5,1,5 -> 10
    return;
}
- (void)testCase_textStorageDidDeleteCharactersAtIndex_1;
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
    NSError * ROR = nil;
    // test without the text storage: delete methods
    //  work with one mode line
#   undef TEST_NO
#   undef TEST_NO
#   define TEST_NO(WHERE) \
    STAssertFalse([TSP textStorageDidDeleteCharactersAtIndex:WHERE count:1 editedAttributesRangeIn:&R error:&ROR],@"MISSED",NULL)
    TEST_NO(ZER0);
    TEST_NO(1);
    TEST_NO(NSUIntegerMax);
    // only one EOL
    ML = [[iTM2ModeLine alloc] initWithString:@"\n" atCursor:NULL];
    ML.EOLMode = [[[NSProcessInfo processInfo] globallyUniqueString] hash];
    [TSP replaceModeLineAtIndex:ZER0 withModeLine:ML];
    TEST_NO(1);
    TEST_NO(2);
    TEST_NO(NSUIntegerMax);
#   undef TEST_YES
#   undef TEST_YES
#   define TEST_YES(WHERE,LOCATION,LENGTH,EOL_LENGTH) \
    STAssertTrue([TSP textStorageDidDeleteCharactersAtIndex:WHERE count:1 editedAttributesRangeIn:&R error:&ROR],@"MISSED textStorageDidDeleteCharacterAtIndex",NULL);\
    STAssertNil(ROR,@"MISSED ROR",NULL);\
    STAssertTrue(NSEqualRanges(R,NSMakeRange(LOCATION,LENGTH)),@"MISSED NSEqualRanges",NULL);\
    STAssertTrue((ML.EOLLength==EOL_LENGTH)||(NSLog(@"%lu(ML)<!>%lu(Expected)",ML.EOLLength,EOL_LENGTH),NO),@"MISSED",NULL)
#   undef TEST_ML
#   undef TEST_ML
#   define TEST_ML(CONTENTS_LENGTH,EOL_LENGTH)\
    STAssertFalse(ML.diagnostic,@"MISSED",NULL);\
    STAssertTrue((ML.contentsLength==CONTENTS_LENGTH)||(NSLog(@"%lu(ML)<!>%lu(Expected)",ML.contentsLength,CONTENTS_LENGTH),NO),@"MISSED",NULL);\
    STAssertTrue((ML.EOLLength==EOL_LENGTH)||(NSLog(@"%lu(ML)<!>%lu(Expected)",ML.EOLLength,EOL_LENGTH),NO),@"MISSED",NULL);\
    [ML validateLocalRange:iTM3FullRange]
    TEST_YES(ZER0,ZER0,ZER0,ZER0);
    TEST_ML(ZER0,ZER0);
    ML = [[iTM2ModeLine alloc] initWithString:@"\r\n" atCursor:NULL];
    ML.EOLMode = [[[NSProcessInfo processInfo] globallyUniqueString] hash];
    [TSP replaceModeLineAtIndex:ZER0 withModeLine:ML];
    TEST_NO(2);
    TEST_NO(3);
    TEST_NO(NSUIntegerMax);
    TEST_YES(ZER0,ZER0,1,1);
    TEST_ML(ZER0,1);
    ML = [[iTM2ModeLine alloc] initWithString:@"\r\n" atCursor:NULL];
    ML.EOLMode = [[[NSProcessInfo processInfo] globallyUniqueString] hash];
    [TSP replaceModeLineAtIndex:ZER0 withModeLine:ML];
    TEST_NO(2);
    TEST_NO(3);
    TEST_NO(NSUIntegerMax);
    TEST_YES(1,ZER0,1,1);
    TEST_ML(ZER0,1);
    [ML appendSyntaxModesAndLengths:(UI)9,(UI)9,ZER0,ZER0];// 10 chars (including EOL)
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
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)5,(UI)6,(UI)6,ZER0,ZER0];// 12 chars
    TEST_NO(12);
    TEST_NO(NSUIntegerMax);
    TEST_YES(ZER0,ZER0,4,1);// 4,6
    TEST_YES(3,ZER0,9,1);// 3,6
    TEST_YES(3,ZER0,9,1);// 3,5
    TEST_ML(8,1);
    TEST_YES(7,1,7,1);// 3,4
    TEST_YES(5,1,6,1);// 3,3
    TEST_YES(5,1,5,1);// 3,2
    TEST_YES(4,1,4,1);// 3,1
    TEST_ML(4,1);
    TEST_YES(3,ZER0,4,1);// 3
    TEST_YES(2,ZER0,3,1);// 2
    TEST_YES(1,ZER0,2,1);// 1
    TEST_YES(ZER0,ZER0,1,1);// ZER0
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)1,(UI)6,(UI)1,ZER0,ZER0];// 2 chars
    TEST_YES(1,ZER0,2,1);
    TEST_YES(ZER0,ZER0,1,1);
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)1,(UI)6,(UI)1,ZER0,ZER0];// 2 chars
    TEST_ML(2,1);
    TEST_YES(ZER0,ZER0,1,1);
    TEST_YES(ZER0,ZER0,1,1);
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)2,(UI)6,(UI)1,ZER0,ZER0];// 3 chars
    TEST_YES(2,ZER0,3,1);//2
    TEST_ML(2,1);
    TEST_YES(ZER0,ZER0,1,1);
    TEST_YES(ZER0,ZER0,1,1);
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)2,(UI)6,(UI)2,ZER0,ZER0];// 4 chars
    TEST_ML(4,1);
    TEST_YES(ZER0,ZER0,1,1);
    TEST_YES(ZER0,ZER0,2,1);
    TEST_YES(ZER0,ZER0,2,1);
    TEST_YES(ZER0,ZER0,1,1);
    
    TEST_YES(ZER0,ZER0,ZER0,ZER0);
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)5,(UI)6,(UI)6,ZER0,ZER0];// 11 chars
    TEST_NO(11);
    TEST_NO(NSUIntegerMax);
    TEST_ML(11,ZER0);
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
    TEST_YES(1,ZER0,1,ZER0);
    TEST_YES(ZER0,ZER0,ZER0,ZER0);
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)1,(UI)6,(UI)1,ZER0,ZER0];// 2 chars
    TEST_YES(ZER0,ZER0,1,ZER0);
    TEST_YES(ZER0,ZER0,ZER0,ZER0);
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)2,(UI)6,(UI)1,ZER0,ZER0];// 3 chars
    TEST_YES(2,ZER0,2,ZER0);// 1,1
    TEST_YES(ZER0,ZER0,1,ZER0);// 1
    TEST_YES(ZER0,ZER0,ZER0,ZER0);// ZER0
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)2,(UI)6,(UI)2,ZER0,ZER0];// 4 chars
    TEST_YES(ZER0,ZER0,1,ZER0);
    TEST_YES(ZER0,ZER0,2,ZER0);
    TEST_YES(ZER0,ZER0,1,ZER0);
    TEST_YES(ZER0,ZER0,ZER0,ZER0);
    
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)5,(UI)6,(UI)1,(UI)5,(UI)5,ZER0,ZER0];// 11 chars
    TEST_NO(11);
    TEST_NO(NSUIntegerMax);
    TEST_YES(5,ZER0,10,ZER0);// 5,1,5 -> 10
    return;
}
- (void)testCase_textStorageDidDeleteCharacterAtIndex_2MLs;
{
    iTM2TextSyntaxParser * TSP = [[iTM2TextSyntaxParser alloc] init];
    STAssertNil(TSP.textStorage,@"MISSED",nil);
    STAssertTrue(TSP.numberOfModeLines == ZER0,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:ZER0] == NSUIntegerMax,@"MISSED",nil);
    TSP.textStorageDidChange;
    STAssertTrue(TSP.numberOfModeLines == 1,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:ZER0] == ZER0,@"MISSED",nil);
    iTM2ModeLine * ML = nil;
    ML = [[iTM2ModeLine alloc] initWithString:@"XXXXXXXXX\n" atCursor:NULL];
    ML.EOLMode = [[[NSProcessInfo processInfo] globallyUniqueString] hash];
    [TSP replaceModeLineAtIndex:ZER0 withModeLine:ML];
    NSRange R;
    NSError * ROR = nil;
    // test without the text storage: delete methods
    //  work with one mode line
#   undef TEST_NO
#   undef TEST_NO
#   define TEST_NO(WHERE) \
    STAssertFalse([TSP textStorageDidDeleteCharacterAtIndex:(10+WHERE) editedAttributesRangeIn:&R error:&ROR],@"MISSED",NULL)
    TEST_NO(ZER0);
    TEST_NO(1);
    TEST_NO(NSUIntegerMax-10);
    // only one EOL
    ML = [[iTM2ModeLine alloc] initWithString:@"\n" atCursor:NULL];
    ML.EOLMode = [[[NSProcessInfo processInfo] globallyUniqueString] hash];
    [TSP insertModeLine:ML atIndex:1];
    TEST_NO(1);
    TEST_NO(2);
    TEST_NO(NSUIntegerMax-10);
#   undef TEST_YES
#   undef TEST_YES
#   define TEST_YES(WHERE,LOCATION,LENGTH,EOL_LENGTH) \
    STAssertTrue([TSP textStorageDidDeleteCharacterAtIndex:(10+WHERE) editedAttributesRangeIn:&R error:&ROR],@"MISSED textStorageDidDeleteCharacterAtIndex",NULL);\
    STAssertNil(ROR,@"MISSED ROR",NULL);\
    STAssertTrue(NSEqualRanges(R,NSMakeRange(10+LOCATION,LENGTH)),@"MISSED NSEqualRanges",NULL);\
    STAssertTrue((ML.EOLLength==EOL_LENGTH)||(NSLog(@"%lu(ML)<!>%lu(Expected)",ML.EOLLength,EOL_LENGTH),NO),@"MISSED",NULL)
#   undef TEST_ML
#   undef TEST_ML
#   define TEST_ML(CONTENTS_LENGTH,EOL_LENGTH)\
    STAssertFalse(ML.diagnostic,@"MISSED",NULL);\
    STAssertTrue((ML.contentsLength==CONTENTS_LENGTH)||(NSLog(@"%lu(ML)<!>%lu(Expected)",ML.contentsLength,CONTENTS_LENGTH),NO),@"MISSED",NULL);\
    STAssertTrue((ML.EOLLength==EOL_LENGTH)||(NSLog(@"%lu(ML)<!>%lu(Expected)",ML.EOLLength,EOL_LENGTH),NO),@"MISSED",NULL);\
    [ML validateLocalRange:iTM3FullRange]
    TEST_YES(ZER0,ZER0,ZER0,ZER0);
    TEST_ML(ZER0,ZER0);
    ML = [[iTM2ModeLine alloc] initWithString:@"\r\n" atCursor:NULL];
    ML.EOLMode = [[[NSProcessInfo processInfo] globallyUniqueString] hash];
    [TSP replaceModeLineAtIndex:1 withModeLine:ML];
    TEST_NO(2);
    TEST_NO(3);
    TEST_NO(NSUIntegerMax-10);
    TEST_YES(ZER0,ZER0,1,1);
    TEST_ML(ZER0,1);
    ML = [[iTM2ModeLine alloc] initWithString:@"\r\n" atCursor:NULL];
    ML.EOLMode = [[[NSProcessInfo processInfo] globallyUniqueString] hash];
    [TSP replaceModeLineAtIndex:1 withModeLine:ML];
    TEST_NO(2);
    TEST_NO(3);
    TEST_NO(NSUIntegerMax-10);
    TEST_YES(1,ZER0,1,1);
    TEST_ML(ZER0,1);
    [ML appendSyntaxModesAndLengths:(UI)9,(UI)9,ZER0,ZER0];// 10 chars (including EOL)
    TEST_ML(9,1);
    TEST_NO(10);
    TEST_NO(NSUIntegerMax-10);
    ML.describe;
    TEST_ML(9,1);
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
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)5,(UI)6,(UI)6,ZER0,ZER0];// 12 chars
    TEST_NO(12);
    TEST_NO(NSUIntegerMax-10);
    TEST_ML(11,1);
    TEST_YES(ZER0,ZER0,4,1);// 4,6
    TEST_YES(3,ZER0,9,1);// 3,6
    TEST_YES(3,ZER0,9,1);// 3,5
    TEST_ML(8,1);
    TEST_YES(7,1,7,1);// 3,4
    TEST_YES(5,1,6,1);// 3,3
    TEST_YES(5,1,5,1);// 3,2
    TEST_YES(4,1,4,1);// 3,1
    TEST_ML(4,1);
    TEST_YES(3,ZER0,4,1);// 3
    TEST_YES(2,ZER0,3,1);// 2
    TEST_YES(1,ZER0,2,1);// 1
    TEST_YES(ZER0,ZER0,1,1);// ZER0
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)1,(UI)6,(UI)1,ZER0,ZER0];// 2 chars
    TEST_YES(1,ZER0,2,1);
    TEST_YES(ZER0,ZER0,1,1);
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)1,(UI)6,(UI)1,ZER0,ZER0];// 2 chars
    TEST_ML(2,1);
    TEST_YES(ZER0,ZER0,1,1);
    TEST_YES(ZER0,ZER0,1,1);
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)2,(UI)6,(UI)1,ZER0,ZER0];// 3 chars
    TEST_YES(2,ZER0,3,1);//2
    TEST_ML(2,1);
    TEST_YES(ZER0,ZER0,1,1);
    TEST_YES(ZER0,ZER0,1,1);
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)2,(UI)6,(UI)2,ZER0,ZER0];// 4 chars
    TEST_ML(4,1);
    TEST_YES(ZER0,ZER0,1,1);
    TEST_YES(ZER0,ZER0,2,1);
    TEST_YES(ZER0,ZER0,2,1);
    TEST_YES(ZER0,ZER0,1,1);
    
    TEST_YES(ZER0,ZER0,ZER0,ZER0);
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)5,(UI)6,(UI)6,ZER0,ZER0];// 11 chars
    TEST_NO(11);
    TEST_NO(NSUIntegerMax-10);
    TEST_ML(11,ZER0);
    TEST_YES(ZER0,ZER0,4,ZER0);// 4,6
    TEST_YES(3,ZER0,9,ZER0);// 3,6
    TEST_YES(3,ZER0,8,ZER0);// 3,5
    TEST_ML(8,ZER0);
    TEST_YES(7,1,6,ZER0);// 3,4
    TEST_YES(5,1,5,ZER0);// 3,3
    TEST_YES(5,1,4,ZER0);// 3,2
    TEST_YES(4,ZER0,4,ZER0);// 3,1
    TEST_YES(3,ZER0,3,ZER0);// 3
    TEST_YES(2,ZER0,2,ZER0);
    TEST_YES(1,ZER0,1,ZER0);
    TEST_YES(ZER0,ZER0,ZER0,ZER0);
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)1,(UI)6,(UI)1,ZER0,ZER0];// 2 chars
    [TSP insertModeLine:ML atIndex:1];
    TEST_ML(2,ZER0);
    TEST_YES(1,ZER0,1,ZER0);
    TEST_YES(ZER0,ZER0,ZER0,ZER0);
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)1,(UI)6,(UI)1,ZER0,ZER0];// 2 chars
    [TSP insertModeLine:ML atIndex:1];
    TEST_ML(2,ZER0);
    TEST_YES(ZER0,ZER0,1,ZER0);
    TEST_YES(ZER0,ZER0,ZER0,ZER0);
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)2,(UI)6,(UI)1,ZER0,ZER0];// 3 chars
    [TSP insertModeLine:ML atIndex:1];
    TEST_YES(2,ZER0,2,ZER0);// 1,1
    TEST_YES(ZER0,ZER0,1,ZER0);// 1
    TEST_YES(ZER0,ZER0,ZER0,ZER0);// ZER0
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)2,(UI)6,(UI)2,ZER0,ZER0];// 4 chars
    [TSP insertModeLine:ML atIndex:1];
    TEST_ML(4,ZER0);
    TEST_YES(ZER0,ZER0,1,ZER0);
    TEST_YES(ZER0,ZER0,2,ZER0);
    TEST_YES(ZER0,ZER0,1,ZER0);
    TEST_YES(ZER0,ZER0,ZER0,ZER0);
    
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)5,(UI)6,(UI)1,(UI)5,(UI)5,ZER0,ZER0];// 11 chars
    [TSP insertModeLine:ML atIndex:1];
    TEST_NO(11);
    TEST_NO(NSUIntegerMax-10);
    TEST_YES(5,ZER0,10,ZER0);// 5,1,5 -> 10
    return;
}
- (void)testCase_textStorageDidDeleteCharacterAtIndex_1_2MLs;
{
    iTM2TextSyntaxParser * TSP = [[iTM2TextSyntaxParser alloc] init];
    STAssertNil(TSP.textStorage,@"MISSED",nil);
    STAssertTrue(TSP.numberOfModeLines == ZER0,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:ZER0] == NSUIntegerMax,@"MISSED",nil);
    TSP.textStorageDidChange;
    STAssertTrue(TSP.numberOfModeLines == 1,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:ZER0] == ZER0,@"MISSED",nil);
    iTM2ModeLine * ML = nil;
    ML = [[iTM2ModeLine alloc] initWithString:@"XXXXXXXXX\n" atCursor:NULL];
    ML.EOLMode = [[[NSProcessInfo processInfo] globallyUniqueString] hash];
    [TSP replaceModeLineAtIndex:ZER0 withModeLine:ML];
    NSRange R;
    NSError * ROR = nil;
    // test without the text storage: delete methods
    //  work with one mode line
#   undef TEST_NO
#   undef TEST_NO
#   define TEST_NO(WHERE) \
    STAssertFalse([TSP textStorageDidDeleteCharactersAtIndex:(10+WHERE) count:1 editedAttributesRangeIn:&R error:&ROR],@"MISSED",NULL)
    TEST_NO(ZER0);
    TEST_NO(1);
    TEST_NO(NSUIntegerMax-10);
    // only one EOL
    ML = [[iTM2ModeLine alloc] initWithString:@"\n" atCursor:NULL];
    ML.EOLMode = [[[NSProcessInfo processInfo] globallyUniqueString] hash];
    [TSP insertModeLine:ML atIndex:1];
    TEST_NO(1);
    TEST_NO(2);
    TEST_NO(NSUIntegerMax-10);
#   undef TEST_YES
#   undef TEST_YES
#   define TEST_YES(WHERE,LOCATION,LENGTH,EOL_LENGTH) \
    STAssertTrue([TSP textStorageDidDeleteCharactersAtIndex:(10+WHERE) count:1 editedAttributesRangeIn:&R error:&ROR],@"MISSED textStorageDidDeleteCharacterAtIndex",NULL);\
    STAssertNil(ROR,@"MISSED ROR",NULL);\
    STAssertTrue(NSEqualRanges(R,NSMakeRange(10+LOCATION,LENGTH))||(NSLog(@"%@<!>{%lu,%lu}(expected)",NSStringFromRange(R),10+LOCATION,LENGTH),NO),@"MISSED NSEqualRanges",NULL);\
    STAssertTrue((ML.EOLLength==EOL_LENGTH)||(NSLog(@"%lu(ML)<!>%lu(Expected)",ML.EOLLength,EOL_LENGTH),NO),@"MISSED",NULL)
#   undef TEST_ML
#   undef TEST_ML
#   define TEST_ML(CONTENTS_LENGTH,EOL_LENGTH)\
    STAssertFalse(ML.diagnostic,@"MISSED",NULL);\
    STAssertTrue((ML.contentsLength==CONTENTS_LENGTH)||(NSLog(@"%lu(ML)<!>%lu(Expected)",ML.contentsLength,CONTENTS_LENGTH),NO),@"MISSED",NULL);\
    STAssertTrue((ML.EOLLength==EOL_LENGTH)||(NSLog(@"%lu(ML)<!>%lu(Expected)",ML.EOLLength,EOL_LENGTH),NO),@"MISSED",NULL);\
    [ML validateLocalRange:iTM3FullRange]
    TEST_YES(ZER0,ZER0,ZER0,ZER0);
    TEST_ML(ZER0,ZER0);
    ML = [[iTM2ModeLine alloc] initWithString:@"\r\n" atCursor:NULL];
    ML.EOLMode = [[[NSProcessInfo processInfo] globallyUniqueString] hash];
    [TSP insertModeLine:ML atIndex:1];
    TEST_NO(2);
    TEST_NO(3);
    TEST_NO(NSUIntegerMax-10);
    TEST_YES(ZER0,ZER0,1,1);
    TEST_ML(ZER0,1);
    ML = [[iTM2ModeLine alloc] initWithString:@"\r\n" atCursor:NULL];
    ML.EOLMode = [[[NSProcessInfo processInfo] globallyUniqueString] hash];
    [TSP replaceModeLineAtIndex:1 withModeLine:ML];
    TEST_NO(2);
    TEST_NO(3);
    TEST_NO(NSUIntegerMax-10);
    TEST_YES(1,ZER0,1,1);
    TEST_ML(ZER0,1);
    [ML appendSyntaxModesAndLengths:(UI)9,(UI)9,ZER0,ZER0];// 10 chars (including EOL)
    TEST_ML(9,1);
    TEST_NO(10);
    TEST_NO(NSUIntegerMax-10);
    ML.describe;
    TEST_ML(9,1);
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
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)5,(UI)6,(UI)6,ZER0,ZER0];// 12 chars
    TEST_NO(12);
    TEST_NO(NSUIntegerMax-10);
    TEST_ML(11,1);
    TEST_YES(ZER0,ZER0,4,1);// 4,6
    TEST_YES(3,ZER0,9,1);// 3,6
    TEST_YES(3,ZER0,9,1);// 3,5
    TEST_ML(8,1);
    TEST_YES(7,1,7,1);// 3,4
    TEST_YES(5,1,6,1);// 3,3
    TEST_YES(5,1,5,1);// 3,2
    TEST_YES(4,1,4,1);// 3,1
    TEST_YES(3,ZER0,4,1);// 3
    TEST_YES(2,ZER0,3,1);// 2
    TEST_YES(1,ZER0,2,1);// 1
    TEST_YES(ZER0,ZER0,1,1);// ZER0
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)1,(UI)6,(UI)1,ZER0,ZER0];// 2 chars
    TEST_ML(2,1);
    TEST_YES(1,ZER0,2,1);
    TEST_YES(ZER0,ZER0,1,1);
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)1,(UI)6,(UI)1,ZER0,ZER0];// 2 chars
    TEST_ML(2,1);
    TEST_YES(ZER0,ZER0,1,1);
    TEST_YES(ZER0,ZER0,1,1);
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)2,(UI)6,(UI)1,ZER0,ZER0];// 3 chars
    TEST_ML(3,1);
    TEST_YES(2,ZER0,3,1);//2
    TEST_ML(2,1);
    TEST_YES(ZER0,ZER0,1,1);
    TEST_YES(ZER0,ZER0,1,1);
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)2,(UI)6,(UI)2,ZER0,ZER0];// 4 chars
    TEST_ML(4,1);
    TEST_YES(ZER0,ZER0,1,1);
    TEST_YES(ZER0,ZER0,2,1);
    TEST_YES(ZER0,ZER0,2,1);
    TEST_YES(ZER0,ZER0,1,1);
    
    TEST_YES(ZER0,ZER0,ZER0,ZER0);
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)5,(UI)6,(UI)6,ZER0,ZER0];// 11 chars
    [TSP insertModeLine:ML atIndex:1];
    TEST_NO(11);
    TEST_NO(NSUIntegerMax-10);
    TEST_ML(11,ZER0);
    TEST_YES(ZER0,ZER0,4,ZER0);// 4,6
    TEST_YES(3,ZER0,9,ZER0);// 3,6
    TEST_YES(3,ZER0,8,ZER0);// 3,5
    TEST_ML(8,ZER0);
    TEST_YES(7,1,6,ZER0);// 3,4
    TEST_YES(5,1,5,ZER0);// 3,3
    TEST_YES(5,1,4,ZER0);// 3,2
    TEST_YES(4,ZER0,4,ZER0);// 3,1
    TEST_YES(3,ZER0,3,ZER0);// 3
    TEST_YES(2,ZER0,2,ZER0);
    TEST_YES(1,ZER0,1,ZER0);
    TEST_YES(ZER0,ZER0,ZER0,ZER0);
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)1,(UI)6,(UI)1,ZER0,ZER0];// 2 chars
    [TSP insertModeLine:ML atIndex:1];
    TEST_ML(2,ZER0);
    TEST_YES(1,ZER0,1,ZER0);
    TEST_YES(ZER0,ZER0,ZER0,ZER0);
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)1,(UI)6,(UI)1,ZER0,ZER0];// 2 chars
    [TSP insertModeLine:ML atIndex:1];
    TEST_ML(2,ZER0);
    TEST_YES(ZER0,ZER0,1,ZER0);
    TEST_YES(ZER0,ZER0,ZER0,ZER0);
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)2,(UI)6,(UI)1,ZER0,ZER0];// 3 chars
    [TSP insertModeLine:ML atIndex:1];
    TEST_ML(3,ZER0);
    TEST_YES(2,ZER0,2,ZER0);// 1,1
    TEST_YES(ZER0,ZER0,1,ZER0);// 1
    TEST_YES(ZER0,ZER0,ZER0,ZER0);// ZER0
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)2,(UI)6,(UI)2,ZER0,ZER0];// 4 chars
    [TSP insertModeLine:ML atIndex:1];
    TEST_ML(4,ZER0);
    TEST_YES(ZER0,ZER0,1,ZER0);
    TEST_YES(ZER0,ZER0,2,ZER0);
    TEST_YES(ZER0,ZER0,1,ZER0);
    TEST_YES(ZER0,ZER0,ZER0,ZER0);
    
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)5,(UI)6,(UI)1,(UI)5,(UI)5,ZER0,ZER0];// 11 chars
    [TSP insertModeLine:ML atIndex:1];
    TEST_NO(11);
    TEST_NO(NSUIntegerMax-10);
    TEST_ML(11,ZER0);
    TEST_YES(5,ZER0,10,ZER0);// 5,1,5 -> 10
    return;
}
- (void)testCase_textStorageDidDeleteCharacterAtIndex_N_2MLs;
{
    iTM2TextSyntaxParser * TSP = [[iTM2TextSyntaxParser alloc] init];
    STAssertNil(TSP.textStorage,@"MISSED",nil);
    STAssertTrue(TSP.numberOfModeLines == ZER0,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:ZER0] == NSUIntegerMax,@"MISSED",nil);
    TSP.textStorageDidChange;
    STAssertTrue(TSP.numberOfModeLines == 1,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:ZER0] == ZER0,@"MISSED",nil);
    iTM2ModeLine * ML = nil;
    ML = [[iTM2ModeLine alloc] initWithString:@"XXXXXXXXX\n" atCursor:NULL];
    ML.EOLMode = [[[NSProcessInfo processInfo] globallyUniqueString] hash];
    [TSP replaceModeLineAtIndex:ZER0 withModeLine:ML];
    NSRange R;
    NSError * ROR = nil;
    // test without the text storage: delete methods
    //  work with one mode line
#   undef TEST_NO
#   undef TEST_NO
#   define TEST_NO(WHERE,COUNT) \
    STAssertFalse([TSP textStorageDidDeleteCharactersAtIndex:(WHERE) count:(COUNT) editedAttributesRangeIn:&R error:&ROR],@"MISSED",NULL)
    TEST_NO(10+ZER0,1);
    TEST_NO(10+ZER0,2);
    TEST_NO(10+ZER0,NSUIntegerMax);
    TEST_NO(10+1,1);
    TEST_NO(10+1,2);
    TEST_NO(10+1,NSUIntegerMax);
    TEST_NO(NSUIntegerMax,1);
    TEST_NO(NSUIntegerMax,2);
    TEST_NO(NSUIntegerMax,NSUIntegerMax);
    // only one EOL
    ML = [[iTM2ModeLine alloc] initWithString:@"\n" atCursor:NULL];
    ML.EOLMode = [[[NSProcessInfo processInfo] globallyUniqueString] hash];
    [TSP insertModeLine:ML atIndex:1];
    TEST_NO(10+1,1);
    TEST_NO(10+1,2);
    TEST_NO(10+1,NSUIntegerMax);
    TEST_NO(NSUIntegerMax,1);
    TEST_NO(NSUIntegerMax,2);
    TEST_NO(NSUIntegerMax,NSUIntegerMax);
#   undef TEST_YES
#   undef TEST_YES
#   define TEST_YES(WHERE,COUNT,LOCATION,LENGTH,EOL_LENGTH) \
    STAssertTrue([TSP textStorageDidDeleteCharactersAtIndex:(WHERE) count:COUNT editedAttributesRangeIn:&R error:&ROR],@"MISSED textStorageDidDeleteCharacterAtIndex",NULL);\
    STAssertNil(ROR,@"MISSED ROR",NULL);\
    STAssertTrue(NSEqualRanges(R,NSMakeRange(LOCATION,LENGTH)),@"MISSED NSEqualRanges",NULL);\
    STAssertTrue((ML.EOLLength==EOL_LENGTH)||(NSLog(@"%lu(ML)<!>%lu(Expected)",ML.EOLLength,EOL_LENGTH),NO),@"MISSED EOL",NULL)
#   undef TEST_ML
#   undef TEST_ML
#   define TEST_ML(CONTENTS_LENGTH,EOL_LENGTH)\
    STAssertFalse(ML.diagnostic,@"MISSED",NULL);\
    STAssertTrue((ML.contentsLength==CONTENTS_LENGTH)||(NSLog(@"%lu(ML)<!>%lu(Expected)",ML.contentsLength,CONTENTS_LENGTH),NO),@"MISSED",NULL);\
    STAssertTrue((ML.EOLLength==EOL_LENGTH)||(NSLog(@"%lu(ML)<!>%lu(Expected)",ML.EOLLength,EOL_LENGTH),NO),@"MISSED",NULL);\
    [ML validateLocalRange:iTM3FullRange]
    TEST_YES(10+ZER0,1,10+ZER0,ZER0,ZER0);
    TEST_ML(ZER0,ZER0);
    ML = [[iTM2ModeLine alloc] initWithString:@"\r\n" atCursor:NULL];
    ML.EOLMode = [[[NSProcessInfo processInfo] globallyUniqueString] hash];
    [TSP insertModeLine: ML atIndex:1];
    TEST_NO(10+2,1);
    TEST_NO(10+2,2);
    TEST_NO(10+2,NSUIntegerMax);
    TEST_NO(10+3,1);
    TEST_NO(10+3,2);
    TEST_NO(10+3,NSUIntegerMax);
    TEST_NO(NSUIntegerMax,1);
    TEST_NO(NSUIntegerMax,2);
    TEST_NO(NSUIntegerMax,NSUIntegerMax);
    TEST_YES(10+ZER0,1,10+ZER0,1,1);
    TEST_ML(ZER0,1);
    ML = [[iTM2ModeLine alloc] initWithString:@"\r\n" atCursor:NULL];
    ML.EOLMode = [[[NSProcessInfo processInfo] globallyUniqueString] hash];
    [TSP replaceModeLineAtIndex:1 withModeLine:ML];
    TEST_NO(10+2,1);
    TEST_NO(10+2,2);
    TEST_NO(10+2,NSUIntegerMax);
    TEST_NO(10+3,1);
    TEST_NO(10+3,2);
    TEST_NO(10+3,NSUIntegerMax);
    TEST_NO(NSUIntegerMax,1);
    TEST_NO(NSUIntegerMax,2);
    TEST_NO(NSUIntegerMax,NSUIntegerMax);
    TEST_YES(10+1,1,10+ZER0,1,1);
    TEST_ML(ZER0,1);
    [ML appendSyntaxModesAndLengths:(UI)9,(UI)9,ZER0,ZER0];// 10 chars (including EOL)
    TEST_YES(10+ZER0,9,10+ZER0,1,1);
    TEST_ML(ZER0,1);
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)5,(UI)4,(UI)4,ZER0,ZER0];// 10 chars
    TEST_YES(10+ZER0,9,10+ZER0,1,1);
    TEST_ML(ZER0,1);
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)5,(UI)4,(UI)4,ZER0,ZER0];// 10 chars
    TEST_ML(9,1);
    TEST_YES(10+1,7,10+ZER0,2,1);
    TEST_ML(2,1);
    TEST_YES(10+ZER0,2,10+ZER0,1,1);
    TEST_ML(ZER0,1);
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)5,(UI)4,(UI)4,ZER0,ZER0];// 10 chars
    TEST_YES(10+ZER0,7,10+ZER0,2,1);
    TEST_ML(2,1);
    TEST_YES(10+ZER0,2,10+ZER0,1,1);
    TEST_ML(ZER0,1);
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)5,(UI)4,(UI)4,ZER0,ZER0];// 10 chars
    TEST_YES(10+1,7,10+ZER0,2,1);
    TEST_ML(2,1);
    TEST_YES(10+ZER0,2,10+ZER0,1,1);
    TEST_ML(ZER0,1);
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)5,(UI)4,(UI)4,ZER0,ZER0];// 10 chars
    TEST_YES(10+2,7,10+ZER0,3,1);
    TEST_ML(2,1);
    TEST_YES(10+ZER0,2,10+ZER0,1,1);
    TEST_ML(ZER0,1);
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)5,(UI)4,(UI)4,(UI)7,(UI)7,ZER0,ZER0];// 17 chars
    TEST_YES(10+3,5,10+ZER0,4,1);// 5,4,7 -> 3,1,7
    TEST_ML(11,1);
    TEST_YES(10+ZER0,11,10+ZER0,1,1);
    TEST_ML(ZER0,1);
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)5,(UI)4,(UI)4,(UI)7,(UI)7,ZER0,ZER0];// 17 chars
    TEST_YES(10+4,5,10+ZER0,11,1);;// 5,4,7 -> 4+7
    TEST_ML(11,1);
    TEST_YES(10+ZER0,11,10+ZER0,1,1);
    TEST_ML(ZER0,1);
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)5,(UI)4,(UI)4,(UI)7,(UI)7,ZER0,ZER0];// 17 chars
    TEST_YES(10+5,5,10+ZER0,11,1);//  5,4,7 -> 5+6
    TEST_ML(11,1);
    TEST_YES(10+ZER0,11,10+ZER0,1,1);
    TEST_ML(ZER0,1);
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)5,(UI)4,(UI)4,(UI)7,(UI)7,ZER0,ZER0];// 17 chars
    TEST_ML(16,1);
    TEST_YES(10+6,5,10+3,8,1);//  5,4,7 -> 5,1,5
    TEST_ML(11,1);
    TEST_YES(10+ZER0,11,10+ZER0,1,1);
    TEST_ML(ZER0,1);
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)5,(UI)4,(UI)4,(UI)7,(UI)7,ZER0,ZER0];// 17 chars
    TEST_ML(16,1);
    TEST_YES(10+7,5,10+3,8,1);//  5,4,7 -> 5,2,4
    TEST_ML(11,1);
    TEST_YES(10+ZER0,11,10+ZER0,1,1);
    TEST_ML(ZER0,1);
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)5,(UI)4,(UI)4,(UI)7,(UI)7,ZER0,ZER0];// 17 chars
    TEST_ML(16,1);
    TEST_YES(10+8,5,10+3,8,1);//  5,4,7 -> 5,3,3
    TEST_ML(11,1);
    TEST_YES(10+ZER0,11,10+ZER0,1,1);
    TEST_ML(ZER0,1);
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)5,(UI)4,(UI)4,(UI)7,(UI)7,ZER0,ZER0];// 17 chars
    TEST_ML(16,1);
    TEST_YES(10+8,5,10+3,8,1);//  5,4,7 -> 5,4,2
    TEST_ML(11,1);
    TEST_YES(10+ZER0,11,10+ZER0,1,1);
    TEST_ML(ZER0,1);
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)5,(UI)4,(UI)4,(UI)7,(UI)7,ZER0,ZER0];// 17 chars
    TEST_ML(16,1);
    TEST_YES(10+7,9,10+3,5,1);//  5,4,7 -> 5,2
    TEST_ML(7,1);
    TEST_YES(10+ZER0,7,10+ZER0,1,1);
    TEST_ML(ZER0,1);
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)5,(UI)4,(UI)4,(UI)7,(UI)7,ZER0,ZER0];// 17 chars
    TEST_ML(16,1);
    TEST_YES(10+7,10,10+3,4,ZER0);//  5,4,7 -> 5,2
    TEST_ML(7,ZER0);
    TEST_YES(10+ZER0,7,10+ZER0,ZER0,ZER0);
    TEST_ML(ZER0,ZER0);// the ML will be removed
    [ML appendSyntaxModesAndLengths:(UI)5,(UI)5,(UI)4,(UI)4,(UI)7,(UI)7,ZER0,ZER0];// 17 chars
    [TSP insertModeLine:ML atIndex:1];
    TEST_ML(16,ZER0);
    TEST_YES(10+7,11,10+3,4,ZER0);//  5,4,7 -> 5,2
    TEST_ML(7,ZER0);
    TEST_YES(10+ZER0,7,10+ZER0,ZER0,ZER0);
    TEST_ML(ZER0,ZER0);
#   undef TEST_ML
#   undef TEST_NO
#   undef TEST_YES
    return;
}
- (void)testCase_textStorageDidDeleteCharactersAtIndex_3_ML_A;
{
    iTM2TextSyntaxParser * TSP = [[iTM2TextSyntaxParser alloc] init];
    STAssertNil(TSP.textStorage,@"MISSED",nil);
    STAssertTrue(TSP.numberOfModeLines == ZER0,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:ZER0] == NSUIntegerMax,@"MISSED",nil);
    TSP.textStorageDidChange;
    STAssertTrue(TSP.numberOfModeLines == 1,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:ZER0] == ZER0,@"MISSED",nil);
    iTM2ModeLine * ML1 = nil;
    ML1 = [[iTM2ModeLine alloc] initWithString:@"\n" atCursor:NULL];
    ML1.EOLMode = [[[NSProcessInfo processInfo] globallyUniqueString] hash];
    [ML1 appendSyntaxModesAndLengths:(UI)9,(UI)9,ZER0,ZER0];
    [TSP replaceModeLineAtIndex:ZER0 withModeLine:ML1];
    NSRange R;
    NSError * ROR = nil;
    // test without the text storage: delete methods
    //  work with one mode line
#   undef TEST_NO
#   define TEST_NO(WHERE,COUNT) \
    STAssertFalse([TSP textStorageDidDeleteCharactersAtIndex:(WHERE) count:(COUNT) editedAttributesRangeIn:&R error:&ROR],@"MISSED",NULL)
    TEST_NO(10+ZER0,1);
    TEST_NO(10+ZER0,2);
    TEST_NO(10+ZER0,NSUIntegerMax);
    TEST_NO(10+1,1);
    TEST_NO(10+1,2);
    TEST_NO(10+1,NSUIntegerMax);
    TEST_NO(NSUIntegerMax,1);
    TEST_NO(NSUIntegerMax,2);
    TEST_NO(NSUIntegerMax,NSUIntegerMax);
    // only one EOL
    iTM2ModeLine * ML2 = [[iTM2ModeLine alloc] initWithString:@"\n" atCursor:NULL];
    ML2.EOLMode = [[[NSProcessInfo processInfo] globallyUniqueString] hash];
    [TSP insertModeLine:ML2 atIndex:1];
    TEST_NO(10+1,1);
    TEST_NO(10+1,2);
    TEST_NO(10+1,NSUIntegerMax);
    TEST_NO(NSUIntegerMax,1);
    TEST_NO(NSUIntegerMax,2);
    TEST_NO(NSUIntegerMax,NSUIntegerMax);
#   undef TEST_YES
#   define TEST_YES(WHERE,COUNT,LOCATION,LENGTH) \
    STAssertTrue([TSP textStorageDidDeleteCharactersAtIndex:(WHERE) count:COUNT editedAttributesRangeIn:&R error:&ROR],@"MISSED textStorageDidDeleteCharactersAtIndex",NULL);\
    STAssertNil(ROR,@"MISSED ROR",NULL);\
    STAssertTrue(NSEqualRanges(R,NSMakeRange(LOCATION,LENGTH))||(NSLog(@"%@<!>{%lu,%lu}(Expected)",NSStringFromRange(R),LOCATION,LENGTH),NO),@"MISSED NSEqualRanges",NULL)
#   undef TEST
#   define TEST(_ML,CONTENTS_LENGTH,EOL_LENGTH)\
    STAssertFalse(_ML.diagnostic,@"MISSED diagnostic",NULL);\
    STAssertTrue((_ML.contentsLength==CONTENTS_LENGTH)||(NSLog(@"%lu(_ML)<!>%lu(Expected)",_ML.contentsLength,CONTENTS_LENGTH),NO),@"MISSED",NULL);\
    STAssertTrue((_ML.EOLLength==EOL_LENGTH)||(NSLog(@"%lu(_ML)<!>%lu(Expected)",_ML.EOLLength,EOL_LENGTH),NO),@"MISSED",NULL)
    TEST_YES(10+ZER0,1,10+ZER0,ZER0);
    TEST(ML2,ZER0,ZER0);
    ML2 = [[iTM2ModeLine alloc] initWithString:@"\r\n" atCursor:NULL];
    ML2.EOLMode = [[[NSProcessInfo processInfo] globallyUniqueString] hash];
    [TSP insertModeLine: ML2 atIndex:1];
    TEST_NO(10+2,1);
    TEST_NO(10+2,2);
    TEST_NO(10+2,NSUIntegerMax);
    TEST_NO(10+3,1);
    TEST_NO(10+3,2);
    TEST_NO(10+3,NSUIntegerMax);
    TEST_NO(NSUIntegerMax,1);
    TEST_NO(NSUIntegerMax,2);
    TEST_NO(NSUIntegerMax,NSUIntegerMax);
    TEST_YES(10+ZER0,1,10+ZER0,1);
    TEST(ML2,ZER0,1);
    ML2 = [[iTM2ModeLine alloc] initWithString:@"\r\n" atCursor:NULL];
    ML2.EOLMode = [[[NSProcessInfo processInfo] globallyUniqueString] hash];
    [TSP replaceModeLineAtIndex:1 withModeLine:ML2];
    TEST_NO(10+2,1);
    TEST_NO(10+2,2);
    TEST_NO(10+2,NSUIntegerMax);
    TEST_NO(10+3,1);
    TEST_NO(10+3,2);
    TEST_NO(10+3,NSUIntegerMax);
    TEST_NO(NSUIntegerMax,1);
    TEST_NO(NSUIntegerMax,2);
    TEST_NO(NSUIntegerMax,NSUIntegerMax);
    TEST_YES(10+1,1,10+ZER0,1);
    TEST(ML2,ZER0,1);
    [ML2 appendSyntaxModesAndLengths:(UI)9,(UI)9,ZER0,ZER0];// 11 chars (including EOL)
    // remove EOL characters of the first ML
    TEST_YES(9,1,ZER0,18);
    TEST(ML1,18,1);
    TEST_YES(ZER0,9,ZER0,10);
    TEST(ML1,9,1);// 9+1
    ML2 = [[iTM2ModeLine alloc] initWithString:@"\r\n" atCursor:NULL];
    ML2.EOLMode = [[[NSProcessInfo processInfo] globallyUniqueString] hash];
    [TSP insertModeLine:ML2 atIndex:1];
    [ML2 appendSyntaxModesAndLengths:(UI)8,(UI)8,ZER0,ZER0];// 10 chars (including EOL)
    TEST(ML2,8,2);// 8+2
    TEST_YES(8,2,ZER0,16); // 8,8+2
    TEST(ML1,16,2);
    TEST_YES(ZER0,8,ZER0,10); // 8+2
    TEST(ML1,8,2);
    ML2 = [[iTM2ModeLine alloc] initWithString:@"\r" atCursor:NULL];
    ML2.EOLMode = [[[NSProcessInfo processInfo] globallyUniqueString] hash];
    [TSP insertModeLine:ML2 atIndex:1];
    [ML2 appendSyntaxModesAndLengths:(UI)9,(UI)9,ZER0,ZER0];// 11 chars (including EOL)
    TEST(ML2,9,1);// 9+1
    TEST_YES(8,3,ZER0,16); // 8,8+1
    TEST(ML1,16,1);
    TEST_YES(ZER0,8,ZER0,9); // 8+1
    ML2 = [[iTM2ModeLine alloc] initWithString:@"\r\n" atCursor:NULL];
    ML2.EOLMode = [[[NSProcessInfo processInfo] globallyUniqueString] hash];
    [TSP insertModeLine:ML2 atIndex:1];
    [ML2 appendSyntaxModesAndLengths:(UI)8,(UI)8,ZER0,ZER0];// 10 chars (including EOL)
    TEST(ML2,8,2);// 8+2
    TEST_YES(8,2,ZER0,15); // 8,7+2
    TEST(ML1,15,2);
    TEST_YES(ZER0,8,ZER0,9); // 7+2
    TEST(ML1,7,2);
    //  Tests with 3 MLs
    ML2 = [[iTM2ModeLine alloc] initWithString:@"\n" atCursor:NULL];
    ML2.EOLMode = [[[NSProcessInfo processInfo] globallyUniqueString] hash];
    [TSP insertModeLine:ML2 atIndex:1];
    [ML2 appendSyntaxModesAndLengths:(UI)6,(UI)6,ZER0,ZER0];// 7 chars (including EOL)
    iTM2ModeLine * ML3 = [[iTM2ModeLine alloc] initWithString:@"\n" atCursor:NULL];
    ML3.EOLMode = [[[NSProcessInfo processInfo] globallyUniqueString] hash];
    [TSP insertModeLine:ML2 atIndex:2];
    [ML3 appendSyntaxModesAndLengths:(UI)7,(UI)7,ZER0,ZER0];// 8 chars (including EOL)
    //  actual state 7(8)+2,6(6)+1,7(7)+1
    TEST_YES(8,1,7,1); // 7(8)+1,6(6)+1,7(7)+1
    TEST(ML1,7,1);
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
    NSTextStorage * TS = [[NSTextStorage alloc] initWithString:
        @"01234567\r\n"
        @"012345678\r\n"
        @"0123456789\r\n"];
    iTM2ModeLine * ML1 = nil;
    iTM2ModeLine * ML2 = nil;
    iTM2ModeLine * ML3 = nil;
    [TSP setTextStorage:TS];
    ML1 = [TSP modeLineAtIndex:ZER0];
    ML2 = [TSP modeLineAtIndex:1];
    ML3 = [TSP modeLineAtIndex:2];
#   undef TEST
#   undef TEST
#   define TEST(_ML,CONTENTS_LENGTH,EOL_LENGTH)\
    STAssertFalse(_ML.diagnostic,@"MISSED diagnostic",NULL);\
    STAssertTrue((_ML.contentsLength==CONTENTS_LENGTH)||(NSLog(@"%lu(_ML)<!>%lu(Expected)",_ML.contentsLength,CONTENTS_LENGTH),NO),@"MISSED",NULL);\
    STAssertTrue((_ML.EOLLength==EOL_LENGTH)||(NSLog(@"%lu(_ML)<!>%lu(Expected)",_ML.EOLLength,EOL_LENGTH),NO),@"MISSED",NULL)
    TEST(ML1,8,2);
    TEST(ML2,9,2);
    TEST(ML3,10,2);

#   undef TEST_NO
#   undef TEST_NO
#   define TEST_NO(WHERE,COUNT) \
    STAssertFalse([TSP textStorageDidDeleteCharactersAtIndex:(WHERE) count:(COUNT) editedAttributesRangeIn:&R error:&ROR],@"MISSED",NULL)

    NSRange R;
    NSError * ROR = nil;
#   undef TEST_YES
#   undef TEST_YES
#   define TEST_YES(WHERE,COUNT,LOCATION,LENGTH) \
    STAssertTrue([TSP textStorageDidDeleteCharactersAtIndex:(WHERE) count:COUNT editedAttributesRangeIn:&R error:&ROR],@"MISSED textStorageDidDeleteCharactersAtIndex",NULL);\
    STAssertNil(ROR,@"MISSED ROR",NULL);\
    STAssertTrue(NSEqualRanges(R,NSMakeRange(LOCATION,LENGTH)),@"MISSED NSEqualRanges",NULL)

    //  removing partly the EOLs
    STAssertTrue(TS.length == 33,@"MISSED",nil);
    //  @"01234567\r\n"
    //  @"012345678\r\n"
    //  @"0123456789\r\n"
    [TS replaceCharactersInRange:iTM3MakeRange(9,1) withString:@""];
    STAssertTrue(TS.length == 32,@"MISSED",nil);
    //  @"01234567\r"
    //  @"012345678\r\n"
    //  @"0123456789\r\n"
    TEST_YES(9,1,8,1);
    [TS replaceCharactersInRange:iTM3MakeRange(9,9) withString:@""];
    STAssertTrue(TS.length == 23,@"MISSED",nil);
    //  @"01234567\r"
    //  @"\r\n"
    //  @"0123456789\r\n"
    TEST_YES(9,9,9,2);
    [TS replaceCharactersInRange:iTM3MakeRange(9,1) withString:@""];
    STAssertTrue(TS.length == 22,@"MISSED",nil);
    //  @"01234567\r\n"
    //  @"0123456789\r\n"
    TEST_YES(9,1,8,2);
    [TS replaceCharactersInRange:iTM3MakeRange(9,12) withString:@""];
    STAssertTrue(TS.length == 10,@"MISSED",nil);
    //  @"01234567\r\n"
    TEST_YES(9,12,6,4);
#   undef TEST
#   undef TEST_NO
#   undef TEST_YES

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
    NSError * ROR = nil;
    ML1.describe;
    ML2 = [ML1 modeLineBySplittingFromGlobalLocation:ZER0 error:&ROR];
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
        ML2 = [ML1 modeLineBySplittingFromGlobalLocation:WHERE error:&ROR];\
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
- (void)testCase_textStorageDidInsertCarriageReturnAtIndex;
{
    iTM2TextSyntaxParser * TSP = [[iTM2TextSyntaxParser alloc] init];
    STAssertNil(TSP.textStorage,@"MISSED",nil);
    STAssertTrue(TSP.numberOfModeLines == ZER0,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:ZER0] == NSUIntegerMax,@"MISSED",nil);
    TSP.textStorageDidChange;
    STAssertTrue(TSP.numberOfModeLines == 1,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:ZER0] == ZER0,@"MISSED",nil);
    iTM2ModeLine * ML0 = nil;
    iTM2ModeLine * ML1 = nil;
    iTM2ModeLine * ML2 = nil;
    iTM2ModeLine * ML3 = nil;
    NSTextStorage * TS = nil;
    NSRange R;
    NSError * ROR = nil;
#   define NEW_TEST(WHERE,LOCATION,RANGE,NUMBER_OF_MODE_LINES) do {\
        [TS replaceCharactersInRange:iTM3MakeRange(WHERE,ZER0) withString:@"\r"];\
        STAssertTrue([TSP textStorageDidInsertCharacterAtIndex:WHERE editedAttributesRangeIn:&R error:&ROR],@"MISSED textStorageDidInsertCharacterAtIndex",nil);\
        STAssertNil(ROR,@"MISSED non nil ROR",nil);\
        STAssertTrue(NSEqualRanges(R,iTM3MakeRange(LOCATION,RANGE)),@"MISSED NSEqualRanges",nil);\
        STAssertTrue(TSP.numberOfModeLines==NUMBER_OF_MODE_LINES,@"MISSED numberOfModeLines",nil);\
    } while (NO)
#   undef TEST
#   define TEST(IDX,CONTENTS_LENGTH,EOL_LENGTH,NUMBER_OF_SYNTAX_WORDS) do {\
        ML##IDX = [TSP modeLineAtIndex:IDX];\
        STAssertFalse(ML##IDX.diagnostic,@"MISSED diagnostic",NULL);\
        STAssertTrue((ML##IDX.contentsLength==CONTENTS_LENGTH)||(NSLog(@"%lu(_ML)<!>%lu(Expected)",ML##IDX.contentsLength,CONTENTS_LENGTH),NO),@"MISSED contentsLength",NULL);\
        STAssertTrue((ML##IDX.EOLLength==EOL_LENGTH)||(NSLog(@"%lu(_ML)<!>%lu(Expected)",ML##IDX.EOLLength,EOL_LENGTH),NO),@"MISSED EOLLength",NULL);\
        STAssertTrue((ML##IDX.numberOfSyntaxWords==NUMBER_OF_SYNTAX_WORDS)||(NSLog(@"%lu(_ML)<!>%lu(Expected)",ML##IDX.numberOfSyntaxWords,NUMBER_OF_SYNTAX_WORDS),NO),@"MISSED numberOfSyntaxWords",NULL);\
    } while (NO)
#   undef TEST_K
#   define TEST_K(IDX,INDEX,MODE,LENGTH) do {\
        STAssertTrue(INDEX < ML##IDX.numberOfSyntaxWords,@"MISSED # of modes",nil);\
        STAssertTrue(MODE == [ML##IDX syntaxModeAtIndex:INDEX],@"MISSED MODE",nil);\
        STAssertTrue(LENGTH == [ML##IDX syntaxLengthAtIndex:INDEX],@"MISSED LENGTH",nil);\
    } while (NO)
#   define PREPARE_TEST(STRING) do {\
        ML0 = ML1 = ML2 = ML3 = nil;\
        TS = [[NSTextStorage alloc] initWithString:STRING];\
        [TSP setTextStorage:TS];\
    } while (NO)
    PREPARE_TEST(@"");
    TEST(0,ZER0,ZER0,ZER0);
    NEW_TEST(0,ZER0,1,2);// "\r"
    TEST(0,ZER0,1,ZER0);
    TEST(1,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"X");
    TEST(0,1,ZER0,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(0,ZER0,1,2);// "\rX"
    TEST(0,ZER0,1,ZER0);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    //--
    PREPARE_TEST(@"X");
    TEST(0,1,ZER0,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(1,1,1,2);// "X\r"
    TEST(0,1,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    //--
    PREPARE_TEST(@"XY");
    TEST(0,2,ZER0,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2);
    NEW_TEST(1,ZER0,2,2);// "X\rY"
    TEST(0,1,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    //--
    PREPARE_TEST(@"\n");
    TEST(0,ZER0,1,ZER0);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(0,ZER0,2,2);// "\r\n"
    TEST(0,ZER0,2,ZER0);
    TEST(1,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"\n");
    TEST(0,ZER0,1,ZER0);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(1,1,1,3);// "\n\r"
    TEST(0,ZER0,1,ZER0);
    TEST(1,ZER0,1,ZER0);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"\r\n");
    TEST(0,ZER0,2,ZER0);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(0,ZER0,3,3);// "\r\r\n"
    TEST(0,ZER0,1,ZER0);
    TEST(1,ZER0,2,ZER0);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"\r\n");
    TEST(0,ZER0,2,ZER0);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(1,ZER0,3,3);// "\r\r\n"
    TEST(0,ZER0,1,ZER0);
    TEST(1,ZER0,2,ZER0);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"\r\n");
    TEST(0,ZER0,2,ZER0);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(2,2,1,3);// "\r\n\r"
    TEST(0,ZER0,2,ZER0);
    TEST(1,ZER0,1,ZER0);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"X\r\n");
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(0,ZER0,1,3);// "\rX\r\n"
    TEST(0,ZER0,1,ZER0);
    TEST(1,1,2,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"X\r\n");
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(1,1,3,3);// "X\r\r\n"
    TEST(0,1,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,2,ZER0);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"X\r\n");
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(2,1,3,3);// "X\r\r\n"
    TEST(0,1,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,2,ZER0);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"X\r\n");
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(3,3,1,3);// "X\r\n\r"
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,1,ZER0);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"\r\nX");
    TEST(0,ZER0,2,ZER0);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(0,ZER0,3,3);// "\r\r\nX"
    TEST(0,ZER0,1,ZER0);
    TEST(1,ZER0,2,ZER0);
    TEST(2,1,ZER0,1);
    TEST_K(2,ZER0,kiTM2TextUnknownSyntaxMode,1);
    //--
    PREPARE_TEST(@"\r\nX");
    TEST(0,ZER0,2,ZER0);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(1,ZER0,3,3);// "\r\r\nX"
    TEST(0,ZER0,1,ZER0);
    TEST(1,ZER0,2,ZER0);
    TEST(2,1,ZER0,1);
    TEST_K(2,ZER0,kiTM2TextUnknownSyntaxMode,1);
    //--
    PREPARE_TEST(@"\r\nX");
    TEST(0,ZER0,2,ZER0);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(2,2,1,3);// "\r\n\rX"
    TEST(0,ZER0,2,ZER0);
    TEST(1,ZER0,1,ZER0);
    TEST(2,1,ZER0,1);
    TEST_K(2,ZER0,kiTM2TextUnknownSyntaxMode,1);
    //--
    PREPARE_TEST(@"\r\nX");
    TEST(0,ZER0,2,ZER0);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(3,3,1,3);// "\r\nX\r"
    TEST(0,ZER0,2,ZER0);
    TEST(1,1,1,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"XY");
    TEST(0,2,ZER0,1);
    NEW_TEST(0,ZER0,1,2);// "\rXY"
    TEST(0,ZER0,1,ZER0);
    TEST(1,2,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,2);
    //--
    PREPARE_TEST(@"XY");
    TEST(0,2,ZER0,1);
    NEW_TEST(1,ZER0,2,2);// "X\rY"
    TEST(0,1,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    //--
    PREPARE_TEST(@"XY");
    TEST(0,2,ZER0,1);
    NEW_TEST(2,2,1,2);// "XY\r"
    TEST(0,2,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2);
    TEST(1,ZER0,ZER0,ZER0);
    //--
#   define INIT_TEST \
    PREPARE_TEST(@"XY"); \
    ML0 = [TSP modeLineAtIndex:ZER0]; \
    TEST(0,2,ZER0,1); \
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2); \
    [ML0 deleteModesInGlobalRange:iTM3MakeRange(ZER0,2) error:&ROR]; \
    STAssertNil(ROR,@"MISSED !ROR",nil); \
    [ML0 appendSyntaxModesAndLengths:(UI)1,(UI)1,(UI)2,(UI)1,ZER0,ZER0]; \
    TEST(0,2,ZER0,2); \
    TEST_K(0,ZER0,1,1); \
    TEST_K(0,1,2,1)
    INIT_TEST;// "XY"
    NEW_TEST(0,ZER0,1,2);// "\rXY"
    TEST(0,ZER0,1,ZER0);
    TEST(1,2,ZER0,2);
    TEST_K(1,ZER0,1,1);
    TEST_K(1,1,2,1);
    //--
    INIT_TEST;
    NEW_TEST(1,ZER0,2,2);// "X\rY"
    TEST(0,1,1,1);
    TEST_K(0,ZER0,1,1);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,2,1);
    //--
    INIT_TEST;
    NEW_TEST(2,2,1,2);// "XY\r"
    TEST(0,2,1,2);
    TEST_K(0,ZER0,1,1);
    TEST_K(0,1,2,1);
    TEST(1,ZER0,ZER0,ZER0);
    //--
    return;
#   undef INIT_TEST
#   undef NEW_TEST
#   undef PREPARE_TEST
#   undef TEST
#   undef TEST_K
}
- (void)testCase_textStorageDidInsertLineFeedAtIndex;
{
    iTM2TextSyntaxParser * TSP = [[iTM2TextSyntaxParser alloc] init];
    STAssertNil(TSP.textStorage,@"MISSED",nil);
    STAssertTrue(TSP.numberOfModeLines == ZER0,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:ZER0] == NSUIntegerMax,@"MISSED",nil);
    TSP.textStorageDidChange;
    STAssertTrue(TSP.numberOfModeLines == 1,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:ZER0] == ZER0,@"MISSED",nil);
    iTM2ModeLine * ML0 = nil;
    iTM2ModeLine * ML1 = nil;
    iTM2ModeLine * ML2 = nil;
    iTM2ModeLine * ML3 = nil;
    NSTextStorage * TS = nil;
    NSRange R;
    NSError * ROR = nil;
#   define NEW_TEST(WHERE,LOCATION,RANGE,NUMBER_OF_MODE_LINES) do {\
        [TS replaceCharactersInRange:iTM3MakeRange(WHERE,ZER0) withString:@"\n"];\
        STAssertTrue([TSP textStorageDidInsertCharacterAtIndex:WHERE editedAttributesRangeIn:&R error:&ROR],@"MISSED textStorageDidInsertCharacterAtIndex",nil);\
        STAssertNil(ROR,@"MISSED non nil ROR",nil);\
        STAssertTrue(NSEqualRanges(R,iTM3MakeRange(LOCATION,RANGE)),@"MISSED NSEqualRanges",nil);\
        STAssertTrue(TSP.numberOfModeLines==NUMBER_OF_MODE_LINES,@"MISSED numberOfModeLines",nil);\
    } while (NO)
#   undef TEST
#   define TEST(IDX,CONTENTS_LENGTH,EOL_LENGTH,NUMBER_OF_SYNTAX_WORDS) do {\
        ML##IDX = [TSP modeLineAtIndex:IDX];\
        STAssertFalse(ML##IDX.diagnostic,@"MISSED diagnostic",NULL);\
        STAssertTrue((ML##IDX.contentsLength==CONTENTS_LENGTH)||(NSLog(@"%lu(_ML)<!>%lu(Expected)",ML##IDX.contentsLength,CONTENTS_LENGTH),NO),@"MISSED contentsLength",NULL);\
        STAssertTrue((ML##IDX.EOLLength==EOL_LENGTH)||(NSLog(@"%lu(_ML)<!>%lu(Expected)",ML##IDX.EOLLength,EOL_LENGTH),NO),@"MISSED EOLLength",NULL);\
        STAssertTrue((ML##IDX.numberOfSyntaxWords==NUMBER_OF_SYNTAX_WORDS)||(NSLog(@"%lu(_ML)<!>%lu(Expected)",ML##IDX.numberOfSyntaxWords,NUMBER_OF_SYNTAX_WORDS),NO),@"MISSED numberOfSyntaxWords",NULL);\
    } while (NO)
#   undef TEST_K
#   define TEST_K(IDX,INDEX,MODE,LENGTH) do {\
        STAssertTrue(INDEX < ML##IDX.numberOfSyntaxWords,@"MISSED # of modes",nil);\
        STAssertTrue(MODE == [ML##IDX syntaxModeAtIndex:INDEX],@"MISSED MODE",nil);\
        STAssertTrue(LENGTH == [ML##IDX syntaxLengthAtIndex:INDEX],@"MISSED LENGTH",nil);\
    } while (NO)
#   define PREPARE_TEST(STRING) do {\
        ML0 = ML1 = ML2 = ML3 = nil;\
        TS = [[NSTextStorage alloc] initWithString:STRING];\
        [TSP setTextStorage:TS];\
    } while (NO)
    PREPARE_TEST(@"");
    TEST(0,ZER0,ZER0,ZER0);
    NEW_TEST(0,ZER0,1,2);// "\n"
    TEST(0,ZER0,1,ZER0);
    TEST(1,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"X");
    TEST(0,1,ZER0,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(0,ZER0,1,2);// "\nX"
    TEST(0,ZER0,1,ZER0);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    //--
    PREPARE_TEST(@"X");
    TEST(0,1,ZER0,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(1,1,1,2);// "X\n"
    TEST(0,1,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    //--
    PREPARE_TEST(@"XY");
    TEST(0,2,ZER0,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2);
    NEW_TEST(1,ZER0,2,2);// "X\nY"
    TEST(0,1,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    //--
    PREPARE_TEST(@"\r");
    TEST(0,ZER0,1,ZER0);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(0,ZER0,1,3);// "\n\r"
    TEST(0,ZER0,1,ZER0);
    TEST(1,ZER0,1,ZER0);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"\r");
    TEST(0,ZER0,1,ZER0);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(1,ZER0,2,2);// "\r\n"
    TEST(0,ZER0,2,ZER0);
    TEST(1,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"\r\n");
    TEST(0,ZER0,2,ZER0);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(0,ZER0,1,3);// "\n\r\n"
    TEST(0,ZER0,1,ZER0);
    TEST(1,ZER0,2,ZER0);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"\r\n");
    TEST(0,ZER0,2,ZER0);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(1,ZER0,3,3);// "\r\n\n"
    TEST(0,ZER0,2,ZER0);
    TEST(1,ZER0,1,ZER0);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"\r\n");
    TEST(0,ZER0,2,ZER0);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(2,2,1,3);// "\r\n\n"
    TEST(0,ZER0,2,ZER0);
    TEST(1,ZER0,1,ZER0);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"X\r\n");
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(0,ZER0,1,3);// "\nX\r\n"
    TEST(0,ZER0,1,ZER0);
    TEST(1,1,2,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"X\r\n");
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(1,1,3,3);// "X\n\r\n"
    TEST(0,1,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,2,ZER0);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"X\r\n");
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(2,1,3,3);// "X\r\n\n"
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,1,ZER0);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"X\r\n");
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(3,3,1,3);// "X\r\n\n"
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,1,ZER0);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"\r\nX");
    TEST(0,ZER0,2,ZER0);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(0,ZER0,1,3);// "\n\r\nX"
    TEST(0,ZER0,1,ZER0);
    TEST(1,ZER0,2,ZER0);
    TEST(2,1,ZER0,1);
    TEST_K(2,ZER0,kiTM2TextUnknownSyntaxMode,1);
    //--
    PREPARE_TEST(@"\r\nX");
    TEST(0,ZER0,2,ZER0);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(1,ZER0,3,3);// "\r\n\nX"
    TEST(0,ZER0,2,ZER0);
    TEST(1,ZER0,1,ZER0);
    TEST(2,1,ZER0,1);
    TEST_K(2,ZER0,kiTM2TextUnknownSyntaxMode,1);
    //--
    PREPARE_TEST(@"\r\nX");
    TEST(0,ZER0,2,ZER0);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(2,2,1,3);// "\r\n\nX"
    TEST(0,ZER0,2,ZER0);
    TEST(1,ZER0,1,ZER0);
    TEST(2,1,ZER0,1);
    TEST_K(2,ZER0,kiTM2TextUnknownSyntaxMode,1);
    //--
    PREPARE_TEST(@"\r\nX");
    TEST(0,ZER0,2,ZER0);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(3,3,1,3);// "\r\nX\n"
    TEST(0,ZER0,2,ZER0);
    TEST(1,1,1,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"XY");
    TEST(0,2,ZER0,1);
    NEW_TEST(0,ZER0,1,2);// "\nXY"
    TEST(0,ZER0,1,ZER0);
    TEST(1,2,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,2);
    //--
    PREPARE_TEST(@"XY");
    TEST(0,2,ZER0,1);
    NEW_TEST(1,ZER0,2,2);// "X\nY"
    TEST(0,1,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    //--
    PREPARE_TEST(@"XY");
    TEST(0,2,ZER0,1);
    NEW_TEST(2,2,1,2);// "XY\n"
    TEST(0,2,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2);
    TEST(1,ZER0,ZER0,ZER0);
    //--
#   define INIT_TEST \
    PREPARE_TEST(@"XY"); \
    ML0 = [TSP modeLineAtIndex:ZER0]; \
    TEST(0,2,ZER0,1); \
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2); \
    [ML0 deleteModesInGlobalRange:iTM3MakeRange(ZER0,2) error:&ROR]; \
    STAssertNil(ROR,@"MISSED !ROR",nil); \
    [ML0 appendSyntaxModesAndLengths:(UI)1,(UI)1,(UI)2,(UI)1,ZER0,ZER0]; \
    TEST(0,2,ZER0,2); \
    TEST_K(0,ZER0,1,1); \
    TEST_K(0,1,2,1)
    INIT_TEST;// "XY"
    NEW_TEST(0,ZER0,1,2);// "\nXY"
    TEST(0,ZER0,1,ZER0);
    TEST(1,2,ZER0,2);
    TEST_K(1,ZER0,1,1);
    TEST_K(1,1,2,1);
    //--
    INIT_TEST;
    NEW_TEST(1,ZER0,2,2);// "X\nY"
    TEST(0,1,1,1);
    TEST_K(0,ZER0,1,1);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,2,1);
    //--
    INIT_TEST;
    NEW_TEST(2,2,1,2);// "XY\n"
    TEST(0,2,1,2);
    TEST_K(0,ZER0,1,1);
    TEST_K(0,1,2,1);
    TEST(1,ZER0,ZER0,ZER0);
    //--
    return;
#   undef INIT_TEST
#   undef NEW_TEST
#   undef PREPARE_TEST
#   undef TEST
#   undef TEST_K
}
- (void)testCase_textStorageDidInsertSingleEOLAtIndex;
{
    iTM2TextSyntaxParser * TSP = [[iTM2TextSyntaxParser alloc] init];
    STAssertNil(TSP.textStorage,@"MISSED",nil);
    STAssertTrue(TSP.numberOfModeLines == ZER0,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:ZER0] == NSUIntegerMax,@"MISSED",nil);
    TSP.textStorageDidChange;
    STAssertTrue(TSP.numberOfModeLines == 1,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:ZER0] == ZER0,@"MISSED",nil);
    iTM2ModeLine * ML0 = nil;
    iTM2ModeLine * ML1 = nil;
    iTM2ModeLine * ML2 = nil;
    iTM2ModeLine * ML3 = nil;
    NSTextStorage * TS = nil;
    NSRange R;
    NSError * ROR = nil;
#   define NEW_TEST(WHERE,LOCATION,RANGE,NUMBER_OF_MODE_LINES) do {\
        [TS replaceCharactersInRange:iTM3MakeRange(WHERE,ZER0) withString:[NSString stringWithFormat:@"%C",0x0085]];\
        STAssertTrue([TSP textStorageDidInsertCharacterAtIndex:WHERE editedAttributesRangeIn:&R error:&ROR],@"MISSED textStorageDidInsertCharacterAtIndex",nil);\
        STAssertNil(ROR,@"MISSED non nil ROR",nil);\
        STAssertTrue(NSEqualRanges(R,iTM3MakeRange(LOCATION,RANGE)),@"MISSED NSEqualRanges",nil);\
        STAssertTrue(TSP.numberOfModeLines==NUMBER_OF_MODE_LINES,@"MISSED numberOfModeLines",nil);\
    } while (NO)
#   undef TEST
#   define TEST(IDX,CONTENTS_LENGTH,EOL_LENGTH,NUMBER_OF_SYNTAX_WORDS) do {\
        ML##IDX = [TSP modeLineAtIndex:IDX];\
        STAssertFalse(ML##IDX.diagnostic,@"MISSED diagnostic",NULL);\
        STAssertTrue((ML##IDX.contentsLength==CONTENTS_LENGTH)||(NSLog(@"%lu(_ML)<!>%lu(Expected)",ML##IDX.contentsLength,CONTENTS_LENGTH),NO),@"MISSED contentsLength",NULL);\
        STAssertTrue((ML##IDX.EOLLength==EOL_LENGTH)||(NSLog(@"%lu(_ML)<!>%lu(Expected)",ML##IDX.EOLLength,EOL_LENGTH),NO),@"MISSED EOLLength",NULL);\
        STAssertTrue((ML##IDX.numberOfSyntaxWords==NUMBER_OF_SYNTAX_WORDS)||(NSLog(@"%lu(_ML)<!>%lu(Expected)",ML##IDX.numberOfSyntaxWords,NUMBER_OF_SYNTAX_WORDS),NO),@"MISSED numberOfSyntaxWords",NULL);\
    } while (NO)
#   undef TEST_K
#   define TEST_K(IDX,INDEX,MODE,LENGTH) do {\
        STAssertTrue(INDEX < ML##IDX.numberOfSyntaxWords,@"MISSED # of modes",nil);\
        STAssertTrue(MODE == [ML##IDX syntaxModeAtIndex:INDEX],@"MISSED MODE",nil);\
        STAssertTrue(LENGTH == [ML##IDX syntaxLengthAtIndex:INDEX],@"MISSED LENGTH",nil);\
    } while (NO)
#   define PREPARE_TEST(STRING) do {\
        ML0 = ML1 = ML2 = ML3 = nil;\
        TS = [[NSTextStorage alloc] initWithString:STRING];\
        [TSP setTextStorage:TS];\
    } while (NO)
    PREPARE_TEST(@"");
    TEST(0,ZER0,ZER0,ZER0);
    NEW_TEST(0,ZER0,1,2);// "nel"
    TEST(0,ZER0,1,ZER0);
    TEST(1,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"X");
    TEST(0,1,ZER0,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(0,ZER0,1,2);// "nelX"
    TEST(0,ZER0,1,ZER0);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    //--
    PREPARE_TEST(@"X");
    TEST(0,1,ZER0,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(1,ZER0,2,2);// "Xnel"
    TEST(0,1,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    //--
    PREPARE_TEST(@"XY");
    TEST(0,2,ZER0,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2);
    NEW_TEST(1,ZER0,2,2);// "XnelY"
    TEST(0,1,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    //--
    PREPARE_TEST(@"\r");
    TEST(0,ZER0,1,ZER0);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(0,ZER0,1,3);// "nel\r"
    TEST(0,ZER0,1,ZER0);
    TEST(1,ZER0,1,ZER0);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"\r");
    TEST(0,ZER0,1,ZER0);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(1,1,1,3);// "\rnel"
    TEST(0,ZER0,1,ZER0);
    TEST(1,ZER0,1,ZER0);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"\r\n");
    TEST(0,ZER0,2,ZER0);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(0,ZER0,1,3);// "nel\r\n"
    TEST(0,ZER0,1,ZER0);
    TEST(1,ZER0,2,ZER0);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"\r\n");
    TEST(0,ZER0,2,ZER0);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(1,ZER0,3,4);// "\rnel\n"
    TEST(0,ZER0,1,ZER0);
    TEST(1,ZER0,1,ZER0);
    TEST(2,ZER0,1,ZER0);
    TEST(3,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"\r\n");
    TEST(0,ZER0,2,ZER0);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(2,2,1,3);// "\r\nnel"
    TEST(0,ZER0,2,ZER0);
    TEST(1,ZER0,1,ZER0);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"X\r\n");
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(0,ZER0,1,3);// "nelX\r\n"
    TEST(0,ZER0,1,ZER0);
    TEST(1,1,2,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"X\r\n");
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(1,ZER0,2,3);// "Xnel\r\n"
    TEST(0,1,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,2,ZER0);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"X\r\n");
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(2,1,3,4);// "X\rnel\n"
    TEST(0,1,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,1,ZER0);
    TEST(2,ZER0,1,ZER0);
    TEST(3,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"X\r\n");
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(3,3,1,3);// "X\r\nnel"
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,1,ZER0);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"\r\nX");
    TEST(0,ZER0,2,ZER0);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(0,ZER0,1,3);// "nel\r\nX"
    TEST(0,ZER0,1,ZER0);
    TEST(1,ZER0,2,ZER0);
    TEST(2,1,ZER0,1);
    TEST_K(2,ZER0,kiTM2TextUnknownSyntaxMode,1);
    //--
    PREPARE_TEST(@"\r\nX");
    TEST(0,ZER0,2,ZER0);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(1,ZER0,3,4);// "\rnel\nX"
    TEST(0,ZER0,1,ZER0);
    TEST(1,ZER0,1,ZER0);
    TEST(2,ZER0,1,ZER0);
    TEST(3,1,ZER0,1);
    TEST_K(3,ZER0,kiTM2TextUnknownSyntaxMode,1);
    //--
    PREPARE_TEST(@"\r\nX");
    TEST(0,ZER0,2,ZER0);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(2,2,1,3);// "\r\nnelX"
    TEST(0,ZER0,2,ZER0);
    TEST(1,ZER0,1,ZER0);
    TEST(2,1,ZER0,1);
    TEST_K(2,ZER0,kiTM2TextUnknownSyntaxMode,1);
    //--
    PREPARE_TEST(@"\r\nX");
    TEST(0,ZER0,2,ZER0);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(3,2,2,3);// "\r\nXnel"
    TEST(0,ZER0,2,ZER0);
    TEST(1,1,1,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"XY");
    TEST(0,2,ZER0,1);
    NEW_TEST(0,ZER0,1,2);// "nelXY"
    TEST(0,ZER0,1,ZER0);
    TEST(1,2,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,2);
    //--
    PREPARE_TEST(@"XY");
    TEST(0,2,ZER0,1);
    NEW_TEST(1,ZER0,2,2);// "XnelY"
    TEST(0,1,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    //--
    PREPARE_TEST(@"XY");
    TEST(0,2,ZER0,1);
    NEW_TEST(2,ZER0,3,2);// "XYnel"
    TEST(0,2,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2);
    TEST(1,ZER0,ZER0,ZER0);
    //--
#   define INIT_TEST \
    PREPARE_TEST(@"XY"); \
    ML0 = [TSP modeLineAtIndex:ZER0]; \
    TEST(0,2,ZER0,1); \
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2); \
    [ML0 deleteModesInGlobalRange:iTM3MakeRange(ZER0,2) error:&ROR]; \
    STAssertNil(ROR,@"MISSED !ROR",nil); \
    [ML0 appendSyntaxModesAndLengths:(UI)1,(UI)1,(UI)2,(UI)1,ZER0,ZER0]; \
    TEST(0,2,ZER0,2); \
    TEST_K(0,ZER0,1,1); \
    TEST_K(0,1,2,1)
    INIT_TEST;// "XY"
    NEW_TEST(0,ZER0,1,2);// "nelXY"
    TEST(0,ZER0,1,ZER0);
    TEST(1,2,ZER0,2);
    TEST_K(1,ZER0,1,1);
    TEST_K(1,1,2,1);
    //--
    INIT_TEST;
    NEW_TEST(1,ZER0,2,2);// "XnelY"
    TEST(0,1,1,1);
    TEST_K(0,ZER0,1,1);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,2,1);
    //--
    INIT_TEST;
    NEW_TEST(2,ZER0,3,2);// "XYnel"
    TEST(0,2,1,2);
    TEST_K(0,ZER0,1,1);
    TEST_K(0,1,2,1);
    TEST(1,ZER0,ZER0,ZER0);
    //--
    return;
#   undef INIT_TEST
#   undef NEW_TEST
#   undef PREPARE_TEST
#   undef TEST
#   undef TEST_K
}
- (void)testCase_textStorageDidInsertNonEOLCharacterAtIndex;
{
    iTM2TextSyntaxParser * TSP = [[iTM2TextSyntaxParser alloc] init];
    STAssertNil(TSP.textStorage,@"MISSED",nil);
    STAssertTrue(TSP.numberOfModeLines == ZER0,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:ZER0] == NSUIntegerMax,@"MISSED",nil);
    TSP.textStorageDidChange;
    STAssertTrue(TSP.numberOfModeLines == 1,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:ZER0] == ZER0,@"MISSED",nil);
    iTM2ModeLine * ML0 = nil;
    iTM2ModeLine * ML1 = nil;
    iTM2ModeLine * ML2 = nil;
    iTM2ModeLine * ML3 = nil;
    NSTextStorage * TS = nil;
    NSRange R;
    NSError * ROR = nil;
#   define NEW_TEST(WHERE,LOCATION,RANGE,NUMBER_OF_MODE_LINES) do {\
        [TS replaceCharactersInRange:iTM3MakeRange(WHERE,ZER0) withString:@"?"];\
        STAssertTrue([TSP textStorageDidInsertCharacterAtIndex:WHERE editedAttributesRangeIn:&R error:&ROR],@"MISSED textStorageDidInsertCharacterAtIndex",nil);\
        STAssertNil(ROR,@"MISSED non nil ROR",nil);\
        STAssertTrue(NSEqualRanges(R,iTM3MakeRange(LOCATION,RANGE)),@"MISSED NSEqualRanges",nil);\
        STAssertTrue(TSP.numberOfModeLines==NUMBER_OF_MODE_LINES,@"MISSED numberOfModeLines",nil);\
    } while (NO)
#   undef TEST
#   define TEST(IDX,CONTENTS_LENGTH,EOL_LENGTH,NUMBER_OF_SYNTAX_WORDS) do {\
        ML##IDX = [TSP modeLineAtIndex:IDX];\
        STAssertFalse(ML##IDX.diagnostic,@"MISSED diagnostic",NULL);\
        STAssertTrue((ML##IDX.contentsLength==CONTENTS_LENGTH)||(NSLog(@"%lu(_ML)<!>%lu(Expected)",ML##IDX.contentsLength,CONTENTS_LENGTH),NO),@"MISSED contentsLength",NULL);\
        STAssertTrue((ML##IDX.EOLLength==EOL_LENGTH)||(NSLog(@"%lu(_ML)<!>%lu(Expected)",ML##IDX.EOLLength,EOL_LENGTH),NO),@"MISSED EOLLength",NULL);\
        STAssertTrue((ML##IDX.numberOfSyntaxWords==NUMBER_OF_SYNTAX_WORDS)||(NSLog(@"%lu(_ML)<!>%lu(Expected)",ML##IDX.numberOfSyntaxWords,NUMBER_OF_SYNTAX_WORDS),NO),@"MISSED numberOfSyntaxWords",NULL);\
        [ML##IDX validateLocalRange:iTM3FullRange];\
    } while (NO)
#   undef TEST_K
#   define TEST_K(IDX,INDEX,MODE,LENGTH) do {\
        STAssertTrue(INDEX < ML##IDX.numberOfSyntaxWords,@"MISSED # of modes",nil);\
        STAssertTrue(MODE == [ML##IDX syntaxModeAtIndex:INDEX],@"MISSED MODE",nil);\
        STAssertTrue(LENGTH == [ML##IDX syntaxLengthAtIndex:INDEX],@"MISSED LENGTH",nil);\
    } while (NO)
#   define PREPARE_TEST(STRING) do {\
        ML0 = ML1 = ML2 = ML3 = nil;\
        TS = [[NSTextStorage alloc] initWithString:STRING];\
        [TSP setTextStorage:TS];\
    } while (NO)
    PREPARE_TEST(@"");
    TEST(0,ZER0,ZER0,ZER0);
    NEW_TEST(0,ZER0,1,1);// "?"
    TEST(0,1,ZER0,1);
    //--
    PREPARE_TEST(@"X");
    TEST(0,1,ZER0,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(0,ZER0,2,1);// "?X"
    TEST(0,2,ZER0,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2);
    //--
    PREPARE_TEST(@"X");
    TEST(0,1,ZER0,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(1,ZER0,2,1);// "X?"
    TEST(0,2,ZER0,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2);
    //--
    PREPARE_TEST(@"XY");
    TEST(0,2,ZER0,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2);
    NEW_TEST(1,ZER0,3,1);// "X?Y"
    TEST(0,3,ZER0,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,3);
    //--
    PREPARE_TEST(@"\r");
    TEST(0,ZER0,1,ZER0);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(0,ZER0,1,2);// "?\r"
    TEST(0,1,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    //--
    PREPARE_TEST(@"\r");
    TEST(0,ZER0,1,ZER0);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(1,1,1,2);// "\r?"
    TEST(0,ZER0,1,ZER0);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    //--
    PREPARE_TEST(@"\r\n");
    TEST(0,ZER0,2,ZER0);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(0,ZER0,1,2);// "?\r\n"
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"\r\n");
    TEST(0,ZER0,2,ZER0);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(1,1,2,3);// "\r?\n"
    TEST(0,ZER0,1,ZER0);
    TEST(1,1,1,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"\r\n");
    TEST(0,ZER0,2,ZER0);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(2,2,1,2);// "\r\n?"
    TEST(0,ZER0,2,ZER0);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    //--
    PREPARE_TEST(@"X\r\n");
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(0,ZER0,2,2);// "?X\r\n"
    TEST(0,2,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2);
    TEST(1,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"X\r\n");
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(1,ZER0,2,2);// "X?\r\n"
    TEST(0,2,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2);
    TEST(1,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"X\r\n");
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(2,2,2,3);// "X\r?\n"
    TEST(0,1,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,1,1,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"X\r\n");
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(3,3,1,2);// "X\r\n?"
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,1,ZER0,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    //--
    PREPARE_TEST(@"\r\nX");
    TEST(0,ZER0,2,ZER0);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(0,ZER0,1,2);// "?\r\nX"
    TEST(0,1,2,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    //--
    PREPARE_TEST(@"\r\nX");
    TEST(0,ZER0,2,ZER0);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(1,1,3,3);// "\r?\nX"
    TEST(0,ZER0,1,ZER0);
    TEST(1,1,1,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(2,1,ZER0,1);
    TEST_K(2,ZER0,kiTM2TextUnknownSyntaxMode,1);
    //--
    PREPARE_TEST(@"\r\nX");
    TEST(0,ZER0,2,ZER0);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(2,2,2,2);// "\r\n?X"
    TEST(0,ZER0,2,ZER0);
    TEST(1,2,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,2);
    //--
    PREPARE_TEST(@"\r\nX");
    TEST(0,ZER0,2,ZER0);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(3,2,2,2);// "\r\nX?"
    TEST(0,ZER0,2,ZER0);
    TEST(1,2,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,2);
    //--
    PREPARE_TEST(@"XY");
    TEST(0,2,ZER0,1);
    NEW_TEST(0,ZER0,3,1);// "?XY"
    TEST(0,3,ZER0,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,3);
    //--
    PREPARE_TEST(@"XY");
    TEST(0,2,ZER0,1);
    NEW_TEST(1,ZER0,3,1);// "X?Y"
    TEST(0,3,ZER0,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,3);
    //--
    PREPARE_TEST(@"XY");
    TEST(0,2,ZER0,1);
    NEW_TEST(2,ZER0,3,1);// "XY?"
    TEST(0,3,ZER0,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,3);
    //--
#   define INIT_TEST \
    PREPARE_TEST(@"XY"); \
    ML0 = [TSP modeLineAtIndex:ZER0]; \
    TEST(0,2,ZER0,1); \
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2); \
    [ML0 deleteModesInGlobalRange:iTM3MakeRange(ZER0,2) error:&ROR]; \
    STAssertNil(ROR,@"MISSED !ROR",nil); \
    [ML0 appendSyntaxModesAndLengths:(UI)1,(UI)1,(UI)2,(UI)1,ZER0,ZER0]; \
    TEST(0,2,ZER0,2); \
    TEST_K(0,ZER0,1,1); \
    TEST_K(0,1,2,1)
    INIT_TEST;// "XY"
    NEW_TEST(0,ZER0,2,1);// "?XY"
    TEST(0,3,ZER0,2);
    TEST_K(0,ZER0,1,2);
    TEST_K(0,1,2,1);
    //--
    INIT_TEST;
    NEW_TEST(1,ZER0,2,1);// "X?Y"
    TEST(0,3,ZER0,2);
    TEST_K(0,ZER0,1,2);
    TEST_K(0,1,2,1);
    //--
    INIT_TEST;
    NEW_TEST(2,ZER0,3,1);// "XY?"
    TEST(0,3,ZER0,2);
    TEST_K(0,ZER0,1,1);
    TEST_K(0,1,2,2);
    //--
    return;
#   undef INIT_TEST
#   undef NEW_TEST
#   undef PREPARE_TEST
#   undef TEST
#   undef TEST_K
}
- (void)testCase_1_textStorageDidInsertCharactersAtIndex_NO_EOLs;
{
    iTM2TextSyntaxParser * TSP = [[iTM2TextSyntaxParser alloc] init];
    STAssertNil(TSP.textStorage,@"MISSED",nil);
    STAssertTrue(TSP.numberOfModeLines == ZER0,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:ZER0] == NSUIntegerMax,@"MISSED",nil);
    TSP.textStorageDidChange;
    STAssertTrue(TSP.numberOfModeLines == 1,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:ZER0] == ZER0,@"MISSED",nil);
    iTM2ModeLine * ML0 = nil;
    iTM2ModeLine * ML1 = nil;
    iTM2ModeLine * ML2 = nil;
    iTM2ModeLine * ML3 = nil;
    NSTextStorage * TS = nil;
    NSRange R;
    NSError * ROR = nil;
    NSString * insertedString = @"zz";
    NSUInteger insertedLength = 2;
#   define NEW_TEST(WHERE,LOCATION,RANGE,NUMBER_OF_MODE_LINES) do {\
        [TS replaceCharactersInRange:iTM3MakeRange(WHERE,ZER0) withString:insertedString];\
        STAssertTrue([TSP textStorageDidInsertCharactersAtIndex:WHERE count:insertedString.length editedAttributesRangeIn:&R error:&ROR],@"MISSED textStorageDidInsertCharactersAtIndex",nil);\
        STAssertNil(ROR,@"MISSED non nil ROR",nil);\
        STAssertTrue(NSEqualRanges(R,iTM3MakeRange(LOCATION,RANGE)),@"MISSED NSEqualRanges",nil);\
        STAssertTrue(TSP.numberOfModeLines==NUMBER_OF_MODE_LINES,@"MISSED numberOfModeLines",nil);\
    } while (NO)
#   undef TEST
#   define TEST(IDX,CONTENTS_LENGTH,EOL_LENGTH,NUMBER_OF_SYNTAX_WORDS) do {\
        ML##IDX = [TSP modeLineAtIndex:IDX];\
        STAssertFalse(ML##IDX.diagnostic,@"MISSED diagnostic",NULL);\
        STAssertTrue((ML##IDX.contentsLength==CONTENTS_LENGTH)||(NSLog(@"%lu(_ML)<!>%lu(Expected)",ML##IDX.contentsLength,CONTENTS_LENGTH),NO),@"MISSED contentsLength",NULL);\
        STAssertTrue((ML##IDX.EOLLength==EOL_LENGTH)||(NSLog(@"%lu(_ML)<!>%lu(Expected)",ML##IDX.EOLLength,EOL_LENGTH),NO),@"MISSED EOLLength",NULL);\
        STAssertTrue((ML##IDX.numberOfSyntaxWords==NUMBER_OF_SYNTAX_WORDS)||(NSLog(@"%lu(_ML)<!>%lu(Expected)",ML##IDX.numberOfSyntaxWords,NUMBER_OF_SYNTAX_WORDS),NO),@"MISSED numberOfSyntaxWords",NULL);\
    } while (NO)
#   undef TEST_K
#   define TEST_K(IDX,INDEX,MODE,LENGTH) do {\
        STAssertTrue(INDEX < ML##IDX.numberOfSyntaxWords,@"MISSED # of modes",nil);\
        STAssertTrue(MODE == [ML##IDX syntaxModeAtIndex:INDEX],@"MISSED MODE",nil);\
        STAssertTrue(LENGTH == [ML##IDX syntaxLengthAtIndex:INDEX],@"MISSED LENGTH",nil);\
    } while (NO)
#   define PREPARE_TEST(STRING) do {\
        ML0 = ML1 = ML2 = ML3 = nil;\
        TS = [[NSTextStorage alloc] initWithString:STRING];\
        [TSP setTextStorage:TS];\
    } while (NO)
    PREPARE_TEST(@"");
    TEST(0,ZER0,ZER0,ZER0);
    NEW_TEST(0,ZER0,insertedLength,1);// "zz"
    TEST(0,insertedLength,ZER0,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,insertedLength);
    //--
    PREPARE_TEST(@"X");
    TEST(0,1,ZER0,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(0,ZER0,insertedLength+1,1);// "zzX"
    TEST(0,3,ZER0,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,insertedLength+1);
    //--
    PREPARE_TEST(@"X");
    TEST(0,1,ZER0,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(1,ZER0,1+insertedLength,1);// "Xzz"
    TEST(0,1+insertedLength,ZER0,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1+insertedLength);
    //--
    PREPARE_TEST(@"XY");
    TEST(0,2,ZER0,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2);
    NEW_TEST(1,ZER0,1+insertedLength+1,1);// "XzzY"
    TEST(0,1+insertedLength+1,ZER0,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1+insertedLength+1);
    //--
    PREPARE_TEST(@"\r");
    TEST(0,ZER0,1,ZER0);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(0,ZER0,insertedLength+1,2);// "zz\r"
    TEST(0,insertedLength,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,insertedLength);
    //--
    PREPARE_TEST(@"\r");
    TEST(0,ZER0,1,ZER0);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(1,1,insertedLength,2);// "\rzz"
    TEST(0,ZER0,1,ZER0);
    TEST(1,insertedLength,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,insertedLength);
    //--
    PREPARE_TEST(@"\r\n");
    TEST(0,ZER0,2,ZER0);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(0,ZER0,insertedLength+2,2);// "zz\r\n"
    TEST(0,2,insertedLength,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,insertedLength);
    TEST(1,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"\r\n");
    TEST(0,ZER0,2,ZER0);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(1,1,insertedLength+1,3);// "\rzz\n"
    TEST(0,ZER0,1,ZER0);
    TEST(1,insertedLength,1,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,insertedLength);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"\r\n");
    TEST(0,ZER0,2,ZER0);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(2,2,insertedLength,2);// "\r\nzz"
    TEST(0,ZER0,2,ZER0);
    TEST(1,insertedLength,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,insertedLength);
    //--
    PREPARE_TEST(@"X\r\n");
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(0,ZER0,insertedLength+1,2);// "zzX\r\n"
    TEST(0,3,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,insertedLength+1);
    TEST(1,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"X\r\n");
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(1,ZER0,1+insertedLength,2);// "Xzz\r\n"
    TEST(0,3,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1+insertedLength);
    TEST(1,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"X\r\n");
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(2,2,insertedLength+1,3);// "X\rzz\n"
    TEST(0,1,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,insertedLength,1,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,insertedLength);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"X\r\n");
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(3,3,insertedLength,2);// "X\r\nzz"
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,insertedLength,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,insertedLength);
    //--
    PREPARE_TEST(@"\r\nX");
    TEST(0,ZER0,2,ZER0);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(0,ZER0,insertedLength+2,2);// "zz\r\nX"
    TEST(0,insertedLength,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,insertedLength);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    //--
    PREPARE_TEST(@"\r\nX");
    TEST(0,ZER0,2,ZER0);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(1,1,insertedLength+2,3);// "\rzz\nX"
    TEST(0,ZER0,1,ZER0);
    TEST(1,insertedLength,1,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,insertedLength);
    TEST(2,1,ZER0,1);
    TEST_K(2,ZER0,kiTM2TextUnknownSyntaxMode,1);
    //--
    PREPARE_TEST(@"\r\nX");
    TEST(0,ZER0,2,ZER0);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(2,2,insertedLength+1,2);// "\r\nzzX"
    TEST(0,ZER0,2,ZER0);
    TEST(1,insertedLength+1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,insertedLength+1);
    //--
    PREPARE_TEST(@"\r\nX");
    TEST(0,ZER0,2,ZER0);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(3,2,1+insertedLength,2);// "\r\nXzz"
    TEST(0,ZER0,2,ZER0);
    TEST(1,1+insertedLength,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1+insertedLength);
    //--
    PREPARE_TEST(@"XY");
    TEST(0,2,ZER0,1);
    NEW_TEST(0,ZER0,insertedLength+2,1);// "zzXY"
    TEST(0,insertedLength+2,ZER0,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,insertedLength+2);
    //--
    PREPARE_TEST(@"XY");
    TEST(0,2,ZER0,1);
    NEW_TEST(1,ZER0,1+insertedLength+1,1);// "XzzY"
    TEST(0,1+insertedLength+1,ZER0,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1+insertedLength+1);
    //--
    PREPARE_TEST(@"XY");
    TEST(0,2,ZER0,1);
    NEW_TEST(2,ZER0,2+insertedLength,1);// "XYzz"
    TEST(0,2+insertedLength,ZER0,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2+insertedLength);
    //--
#   define INIT_TEST \
    PREPARE_TEST(@"XY"); \
    ML0 = [TSP modeLineAtIndex:ZER0]; \
    TEST(0,2,ZER0,1); \
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2); \
    [ML0 deleteModesInGlobalRange:iTM3MakeRange(ZER0,2) error:&ROR]; \
    STAssertNil(ROR,@"MISSED !ROR",nil); \
    [ML0 appendSyntaxModesAndLengths:(UI)1,(UI)1,(UI)2,(UI)1,ZER0,ZER0]; \
    TEST(0,2,ZER0,2); \
    TEST_K(0,ZER0,1,1); \
    TEST_K(0,1,2,1)
    INIT_TEST;// "XY"
    NEW_TEST(0,ZER0,insertedLength+1,1);// "zzXY"
    TEST(0,insertedLength+2,ZER0,2);
    TEST_K(0,ZER0,1,insertedLength+1);
    TEST_K(0,1,2,1);
    //--
    INIT_TEST;
    NEW_TEST(1,ZER0,3,1);// "XzzY"
    TEST(0,1+insertedLength+1,ZER0,2);
    TEST_K(0,ZER0,1,1+insertedLength);
    TEST_K(0,1,2,1);
    //--
    INIT_TEST;
    NEW_TEST(2,ZER0,2+insertedLength,1);// "XYzz"
    TEST(0,2+insertedLength,ZER0,2);
    TEST_K(0,ZER0,1,1);
    TEST_K(0,1,2,1+insertedLength);
    //--
    return;
#   undef INIT_TEST
#   undef NEW_TEST
#   undef PREPARE_TEST
#   undef TEST
#   undef TEST_K
}
- (void)testCase_1_textStorageDidInsertCharactersAtIndex_line_feed;
{
    iTM2TextSyntaxParser * TSP = [[iTM2TextSyntaxParser alloc] init];
    STAssertNil(TSP.textStorage,@"MISSED",nil);
    STAssertTrue(TSP.numberOfModeLines == ZER0,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:ZER0] == NSUIntegerMax,@"MISSED",nil);
    TSP.textStorageDidChange;
    STAssertTrue(TSP.numberOfModeLines == 1,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:ZER0] == ZER0,@"MISSED",nil);
    iTM2ModeLine * ML0 = nil;
    iTM2ModeLine * ML1 = nil;
    iTM2ModeLine * ML2 = nil;
    iTM2ModeLine * ML3 = nil;
    NSTextStorage * TS = nil;
    NSRange R;
    NSError * ROR = nil;
#   define NEW_TEST(WHERE,LOCATION,RANGE,NUMBER_OF_MODE_LINES) do {\
        [TS replaceCharactersInRange:iTM3MakeRange(WHERE,ZER0) withString:@"\nzz"];\
        STAssertTrue([TSP textStorageDidInsertCharactersAtIndex:WHERE count:3 editedAttributesRangeIn:&R error:&ROR],@"MISSED textStorageDidInsertCharactersAtIndex",nil);\
        STAssertNil(ROR,@"MISSED non nil ROR",nil);\
        STAssertTrue(NSEqualRanges(R,iTM3MakeRange(LOCATION,RANGE)),@"MISSED NSEqualRanges",nil);\
        STAssertTrue(TSP.numberOfModeLines==NUMBER_OF_MODE_LINES,@"MISSED numberOfModeLines",nil);\
    } while (NO)
#   undef TEST
#   define TEST(IDX,CONTENTS_LENGTH,EOL_LENGTH,NUMBER_OF_SYNTAX_WORDS) do {\
        ML##IDX = [TSP modeLineAtIndex:IDX];\
        STAssertFalse(ML##IDX.diagnostic,@"MISSED diagnostic",NULL);\
        STAssertTrue((ML##IDX.contentsLength==CONTENTS_LENGTH)||(NSLog(@"%lu(_ML)<!>%lu(Expected)",ML##IDX.contentsLength,CONTENTS_LENGTH),NO),@"MISSED contentsLength",NULL);\
        STAssertTrue((ML##IDX.EOLLength==EOL_LENGTH)||(NSLog(@"%lu(_ML)<!>%lu(Expected)",ML##IDX.EOLLength,EOL_LENGTH),NO),@"MISSED EOLLength",NULL);\
        STAssertTrue((ML##IDX.numberOfSyntaxWords==NUMBER_OF_SYNTAX_WORDS)||(NSLog(@"%lu(_ML)<!>%lu(Expected)",ML##IDX.numberOfSyntaxWords,NUMBER_OF_SYNTAX_WORDS),NO),@"MISSED numberOfSyntaxWords",NULL);\
    } while (NO)
#   undef TEST_K
#   define TEST_K(IDX,INDEX,MODE,LENGTH) do {\
        STAssertTrue(INDEX < ML##IDX.numberOfSyntaxWords,@"MISSED # of modes",nil);\
        STAssertTrue(MODE == [ML##IDX syntaxModeAtIndex:INDEX],@"MISSED MODE",nil);\
        STAssertTrue(LENGTH == [ML##IDX syntaxLengthAtIndex:INDEX],@"MISSED LENGTH",nil);\
    } while (NO)
#   define PREPARE_TEST(STRING) do {\
        ML0 = ML1 = ML2 = ML3 = nil;\
        TS = [[NSTextStorage alloc] initWithString:STRING];\
        [TSP setTextStorage:TS];\
    } while (NO)
    PREPARE_TEST(@"");
    TEST(0,ZER0,ZER0,ZER0);
    NEW_TEST(0,ZER0,3,2);// "\nzz"
    TEST(0,ZER0,1,ZER0);
    TEST(1,2,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,2);
    //--
    PREPARE_TEST(@"X");
    TEST(0,1,ZER0,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(0,ZER0,4,2);// "\nzzX"
    TEST(0,ZER0,1,ZER0);
    TEST(1,3,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,3);
    //--
    PREPARE_TEST(@"X");
    TEST(0,1,ZER0,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(1,ZER0,4,2);// "X\nzz"
    TEST(0,1,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,2,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,2);
    //--
    PREPARE_TEST(@"XY");
    TEST(0,2,ZER0,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2);
    NEW_TEST(1,ZER0,5,2);// "X\nzzY"
    TEST(0,1,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,3,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,3);
    //--
    PREPARE_TEST(@"\r");
    TEST(0,ZER0,1,ZER0);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(0,ZER0,4,3);// "\nzz\r"
    TEST(0,ZER0,1,ZER0);
    TEST(1,2,1,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,2);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"\r");
    TEST(0,ZER0,1,ZER0);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(1,2,2,2);// "\r\nzz"
    TEST(0,ZER0,2,ZER0);
    TEST(1,2,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,2);
    //--
    PREPARE_TEST(@"\r\n");
    TEST(0,ZER0,2,ZER0);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(0,ZER0,5,3);// "\nzz\r\n"
    TEST(0,ZER0,1,ZER0);
    TEST(1,2,2,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,2);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"\r\n");
    TEST(0,ZER0,2,ZER0);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(1,2,3,3);// "\r\nzz\n"
    TEST(0,ZER0,2,ZER0);
    TEST(1,2,1,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,2);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"\r\n");
    TEST(0,ZER0,2,ZER0);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(2,2,3,3);// "\r\n\nzz"
    TEST(0,ZER0,2,ZER0);
    TEST(1,ZER0,1,ZER0);
    TEST(2,2,ZER0,1);
    TEST_K(2,ZER0,kiTM2TextUnknownSyntaxMode,2);
    //--
    PREPARE_TEST(@"X\r\n");
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(0,ZER0,6,3);// "\nzzX\r\n"
    TEST(0,ZER0,1,ZER0);
    TEST(1,3,2,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,3);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"X\r\n");
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(1,ZER0,6,3);// "X\nzz\r\n"
    TEST(0,1,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,2,2,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,2);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"X\r\n");
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(2,3,3,3);// "X\r\nzz\n"
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,2,1,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,2);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"X\r\n");
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(3,3,3,3);// "X\r\n\nzz"
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,1,ZER0);
    TEST(2,2,ZER0,1);
    TEST_K(2,ZER0,kiTM2TextUnknownSyntaxMode,2);
    //--
    PREPARE_TEST(@"\r\nX");
    TEST(0,ZER0,2,ZER0);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(0,ZER0,5,3);// "\nzz\r\nX"
    TEST(0,ZER0,1,ZER0);
    TEST(1,2,2,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,2);
    TEST(2,1,ZER0,1);
    TEST_K(2,ZER0,kiTM2TextUnknownSyntaxMode,1);
    //--
    PREPARE_TEST(@"\r\nX");
    TEST(0,ZER0,2,ZER0);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(1,2,4,3);// "\r\nzz\nX"
    TEST(0,ZER0,2,ZER0);
    TEST(1,2,1,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,2);
    TEST(2,1,ZER0,1);
    TEST_K(2,ZER0,kiTM2TextUnknownSyntaxMode,1);
    //--
    PREPARE_TEST(@"\r\nX");
    TEST(0,ZER0,2,ZER0);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(2,2,4,3);// "\r\n\nzzX"
    TEST(0,ZER0,2,ZER0);
    TEST(1,ZER0,1,ZER0);
    TEST(2,3,ZER0,1);
    TEST_K(2,ZER0,kiTM2TextUnknownSyntaxMode,3);
    //--
    PREPARE_TEST(@"\r\nX");
    TEST(0,ZER0,2,ZER0);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(3,2,4,3);// "\r\nX\nzz"
    TEST(0,ZER0,2,ZER0);
    TEST(1,1,1,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(2,2,ZER0,1);
    TEST_K(2,ZER0,kiTM2TextUnknownSyntaxMode,2);
    //--
    PREPARE_TEST(@"XY");
    TEST(0,2,ZER0,1);
    NEW_TEST(0,ZER0,5,2);// "\nzzXY"
    TEST(0,ZER0,1,ZER0);
    TEST(1,4,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,4);
    //--
    PREPARE_TEST(@"XY");
    TEST(0,2,ZER0,1);
    NEW_TEST(1,ZER0,5,2);// "X\nzzY"
    TEST(0,1,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,3,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,3);
    //--
    PREPARE_TEST(@"XY");
    TEST(0,2,ZER0,1);
    NEW_TEST(2,ZER0,5,2);// "XY\nzz"
    TEST(0,2,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2);
    TEST(1,2,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,2);
    //--
#   define INIT_TEST \
    PREPARE_TEST(@"XY"); \
    ML0 = [TSP modeLineAtIndex:ZER0]; \
    TEST(0,2,ZER0,1); \
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2); \
    [ML0 deleteModesInGlobalRange:iTM3MakeRange(ZER0,2) error:&ROR]; \
    STAssertNil(ROR,@"MISSED !ROR",nil); \
    [ML0 appendSyntaxModesAndLengths:(UI)1,(UI)1,(UI)2,(UI)1,ZER0,ZER0]; \
    TEST(0,2,ZER0,2); \
    TEST_K(0,ZER0,1,1); \
    TEST_K(0,1,2,1)
    INIT_TEST;// "XY"
    NEW_TEST(0,ZER0,5,2);// "\nzzXY"
    TEST(0,ZER0,1,ZER0);
    TEST(1,4,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,4);
    //--
    INIT_TEST;
    NEW_TEST(1,ZER0,5,2);// "X\nzzY"
    TEST(0,1,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,3,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,3);
    //--
    INIT_TEST;
    NEW_TEST(2,ZER0,5,2);// "XY\nzz"
    TEST(0,2,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2);
    TEST(1,2,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,2);
    //--
    return;
#   undef INIT_TEST
#   undef NEW_TEST
#   undef PREPARE_TEST
#   undef TEST
#   undef TEST_K
}
- (void)testCase_1_textStorageDidInsertCharactersAtIndex_carriage_return;
{
    iTM2TextSyntaxParser * TSP = [[iTM2TextSyntaxParser alloc] init];
    STAssertNil(TSP.textStorage,@"MISSED",nil);
    STAssertTrue(TSP.numberOfModeLines == ZER0,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:ZER0] == NSUIntegerMax,@"MISSED",nil);
    TSP.textStorageDidChange;
    STAssertTrue(TSP.numberOfModeLines == 1,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:ZER0] == ZER0,@"MISSED",nil);
    iTM2ModeLine * ML0 = nil;
    iTM2ModeLine * ML1 = nil;
    iTM2ModeLine * ML2 = nil;
    iTM2ModeLine * ML3 = nil;
    NSTextStorage * TS = nil;
    NSRange R;
    NSError * ROR = nil;
    NSString * insertedString = @"zz\r";
    NSUInteger contentsLength = 2;//  contents of insertedString
#   define NEW_TEST(WHERE,LOCATION,RANGE,NUMBER_OF_MODE_LINES) do {\
        [TS replaceCharactersInRange:iTM3MakeRange(WHERE,ZER0) withString:insertedString];\
        STAssertTrue([TSP textStorageDidInsertCharactersAtIndex:WHERE count:3 editedAttributesRangeIn:&R error:&ROR],@"MISSED textStorageDidInsertCharactersAtIndex",nil);\
        STAssertNil(ROR,@"MISSED non nil ROR",nil);\
        STAssertTrue(NSEqualRanges(R,iTM3MakeRange(LOCATION,RANGE)),@"MISSED NSEqualRanges",nil);\
        STAssertTrue(TSP.numberOfModeLines==NUMBER_OF_MODE_LINES,@"MISSED numberOfModeLines",nil);\
    } while (NO)
#   undef TEST
#   define TEST(IDX,CONTENTS_LENGTH,EOL_LENGTH,NUMBER_OF_SYNTAX_WORDS) do {\
        ML##IDX = [TSP modeLineAtIndex:IDX];\
        STAssertFalse(ML##IDX.diagnostic,@"MISSED diagnostic",NULL);\
        STAssertTrue((ML##IDX.contentsLength==CONTENTS_LENGTH)||(NSLog(@"%lu(_ML)<!>%lu(Expected)",ML##IDX.contentsLength,CONTENTS_LENGTH),NO),@"MISSED contentsLength",NULL);\
        STAssertTrue((ML##IDX.EOLLength==EOL_LENGTH)||(NSLog(@"%lu(_ML)<!>%lu(Expected)",ML##IDX.EOLLength,EOL_LENGTH),NO),@"MISSED EOLLength",NULL);\
        STAssertTrue((ML##IDX.numberOfSyntaxWords==NUMBER_OF_SYNTAX_WORDS)||(NSLog(@"%lu(_ML)<!>%lu(Expected)",ML##IDX.numberOfSyntaxWords,NUMBER_OF_SYNTAX_WORDS),NO),@"MISSED numberOfSyntaxWords",NULL);\
    } while (NO)
#   undef TEST_K
#   define TEST_K(IDX,INDEX,MODE,LENGTH) do {\
        STAssertTrue(INDEX < ML##IDX.numberOfSyntaxWords,@"MISSED # of modes",nil);\
        STAssertTrue(MODE == [ML##IDX syntaxModeAtIndex:INDEX],@"MISSED MODE",nil);\
        STAssertTrue(LENGTH == [ML##IDX syntaxLengthAtIndex:INDEX],@"MISSED LENGTH",nil);\
    } while (NO)
#   define PREPARE_TEST(STRING) do {\
        ML0 = ML1 = ML2 = ML3 = nil;\
        TS = [[NSTextStorage alloc] initWithString:STRING];\
        [TSP setTextStorage:TS];\
    } while (NO)
    PREPARE_TEST(@"");
    TEST(0,ZER0,ZER0,ZER0);
    NEW_TEST(0,ZER0,3,2);// "zz\r"
    TEST(0,contentsLength,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,contentsLength);
    TEST(1,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"X");
    TEST(0,1,ZER0,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(0,ZER0,4,2);// "zz\rX"
    TEST(0,contentsLength,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,contentsLength);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    //--
    PREPARE_TEST(@"X");
    TEST(0,1,ZER0,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(1,ZER0,4,2);// "Xzz\r"
    TEST(0,1+contentsLength,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1+contentsLength);
    TEST(1,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"XY");
    TEST(0,contentsLength,ZER0,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2);
    NEW_TEST(1,ZER0,5,2);// "Xzz\rY"
    TEST(0,1+contentsLength,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1+contentsLength);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    //--
    PREPARE_TEST(@"\r");
    TEST(0,ZER0,1,ZER0);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(0,ZER0,4,3);// "zz\r\r"
    TEST(0,contentsLength,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2);
    TEST(1,ZER0,1,ZER0);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"\r");
    TEST(0,ZER0,1,ZER0);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(1,1,3,3);// "\rzz\r"
    TEST(0,ZER0,1,ZER0);
    TEST(1,contentsLength,1,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,2);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"\r\n");
    TEST(0,ZER0,2,ZER0);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(0,ZER0,5,3);// "zz\r\r\n"
    TEST(0,contentsLength,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2);
    TEST(1,ZER0,2,ZER0);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"\r\n");
    TEST(0,ZER0,2,ZER0);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(1,1,4,3);// "\rzz\r\n"
    TEST(0,ZER0,1,ZER0);
    TEST(1,contentsLength,2,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,2);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"\r\n");
    TEST(0,ZER0,2,ZER0);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(2,2,3,3);// "\r\nzz\r"
    TEST(0,ZER0,2,ZER0);
    TEST(1,contentsLength,1,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,2);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"X\r\n");
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(0,ZER0,6,3);// "zz\rX\r\n"
    TEST(0,contentsLength,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2);
    TEST(1,1,2,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"X\r\n");
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(1,ZER0,6,3);// "Xzz\r\r\n"
    TEST(0,1+contentsLength,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1+contentsLength);
    TEST(1,ZER0,2,ZER0);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"X\r\n");
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(2,2,4,3);// "X\rzz\r\n"
    TEST(0,1,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,contentsLength,2,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,2);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"X\r\n");
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(3,3,3,3);// "X\r\nzz\r"
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,contentsLength,1,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,2);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"\r\nX");
    TEST(0,ZER0,2,ZER0);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(0,ZER0,5,3);// "zz\r\r\nX"
    TEST(0,contentsLength,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2);
    TEST(1,ZER0,2,ZER0);
    TEST(2,1,ZER0,1);
    TEST_K(2,ZER0,kiTM2TextUnknownSyntaxMode,1);
    //--
    PREPARE_TEST(@"\r\nX");
    TEST(0,ZER0,2,ZER0);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(1,1,5,3);// "\rzz\r\nX"
    TEST(0,ZER0,1,ZER0);
    TEST(1,contentsLength,2,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,2);
    TEST(2,1,ZER0,1);
    TEST_K(2,ZER0,kiTM2TextUnknownSyntaxMode,1);
    //--
    PREPARE_TEST(@"\r\nX");
    TEST(0,ZER0,2,ZER0);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(2,2,4,3);// "\r\nzz\rX"
    TEST(0,ZER0,2,ZER0);
    TEST(1,contentsLength,1,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,2);
    TEST(2,1,ZER0,1);
    TEST_K(2,ZER0,kiTM2TextUnknownSyntaxMode,1);
    //--
    PREPARE_TEST(@"\r\nX");
    TEST(0,ZER0,2,ZER0);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(3,2,4,3);// "\r\nXzz\r"
    TEST(0,ZER0,2,ZER0);
    TEST(1,1+contentsLength,1,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1+contentsLength);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"XY");
    TEST(0,contentsLength,ZER0,1);
    NEW_TEST(0,ZER0,5,2);// "zz\rXY"
    TEST(0,contentsLength,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,contentsLength);
    TEST(1,2,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,2);
    //--
    PREPARE_TEST(@"XY");
    TEST(0,contentsLength,ZER0,1);
    NEW_TEST(1,ZER0,5,2);// "Xzz\rY"
    TEST(0,1+contentsLength,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1+contentsLength);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    //--
    PREPARE_TEST(@"XY");
    TEST(0,contentsLength,ZER0,1);
    NEW_TEST(2,ZER0,5,2);// "XYzz\r"
    TEST(0,2+contentsLength,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2+contentsLength);
    TEST(1,ZER0,ZER0,ZER0);
    //--
#   define INIT_TEST \
    PREPARE_TEST(@"XY"); \
    ML0 = [TSP modeLineAtIndex:ZER0]; \
    TEST(0,contentsLength,ZER0,1); \
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2); \
    [ML0 deleteModesInGlobalRange:iTM3MakeRange(ZER0,2) error:&ROR]; \
    STAssertNil(ROR,@"MISSED !ROR",nil); \
    [ML0 appendSyntaxModesAndLengths:(UI)1,(UI)1,(UI)2,(UI)1,ZER0,ZER0]; \
    TEST(0,contentsLength,ZER0,2); \
    TEST_K(0,ZER0,1,1); \
    TEST_K(0,1,2,1)
    INIT_TEST;// "XY"
    NEW_TEST(0,ZER0,5,2);// "zz\rXY"
    TEST(0,contentsLength,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,contentsLength);
    TEST(1,2,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,2);
    //--
    INIT_TEST;
    NEW_TEST(1,ZER0,5,2);// "Xzz\rY"
    TEST(0,1+contentsLength,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1+contentsLength);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    //--
    INIT_TEST;
    NEW_TEST(2,ZER0,5,2);// "XYzz\r"
    TEST(0,2+contentsLength,1,2);
    TEST_K(0,ZER0,1,1);
    TEST_K(0,1,2,1+contentsLength);
    TEST(1,ZER0,ZER0,ZER0);
    //--
    return;
#   undef INIT_TEST
#   undef NEW_TEST
#   undef PREPARE_TEST
#   undef TEST
#   undef TEST_K
}
- (void)testCase_1_textStorageDidInsertCharactersAtIndex_new_line;
{
    iTM2TextSyntaxParser * TSP = [[iTM2TextSyntaxParser alloc] init];
    STAssertNil(TSP.textStorage,@"MISSED",nil);
    STAssertTrue(TSP.numberOfModeLines == ZER0,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:ZER0] == NSUIntegerMax,@"MISSED",nil);
    TSP.textStorageDidChange;
    STAssertTrue(TSP.numberOfModeLines == 1,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:ZER0] == ZER0,@"MISSED",nil);
    iTM2ModeLine * ML0 = nil;
    iTM2ModeLine * ML1 = nil;
    iTM2ModeLine * ML2 = nil;
    iTM2ModeLine * ML3 = nil;
    NSTextStorage * TS = nil;
    NSRange R;
    NSError * ROR = nil;
    NSString * insertedString = [NSString stringWithFormat:@"zz%C",0x0085];
    NSUInteger contentsLength = 2;//  contents of insertedString
#   define NEW_TEST(WHERE,LOCATION,RANGE,NUMBER_OF_MODE_LINES) do {\
        [TS replaceCharactersInRange:iTM3MakeRange(WHERE,ZER0) withString:insertedString];\
        STAssertTrue([TSP textStorageDidInsertCharactersAtIndex:WHERE count:3 editedAttributesRangeIn:&R error:&ROR],@"MISSED textStorageDidInsertCharactersAtIndex",nil);\
        STAssertNil(ROR,@"MISSED non nil ROR",nil);\
        STAssertTrue(NSEqualRanges(R,iTM3MakeRange(LOCATION,RANGE)),@"MISSED NSEqualRanges",nil);\
        STAssertTrue(TSP.numberOfModeLines==NUMBER_OF_MODE_LINES,@"MISSED numberOfModeLines",nil);\
    } while (NO)
#   undef TEST
#   define TEST(IDX,CONTENTS_LENGTH,EOL_LENGTH,NUMBER_OF_SYNTAX_WORDS) do {\
        ML##IDX = [TSP modeLineAtIndex:IDX];\
        STAssertFalse(ML##IDX.diagnostic,@"MISSED diagnostic",NULL);\
        STAssertTrue((ML##IDX.contentsLength==CONTENTS_LENGTH)||(NSLog(@"%lu(_ML)<!>%lu(Expected)",ML##IDX.contentsLength,CONTENTS_LENGTH),NO),@"MISSED contentsLength",NULL);\
        STAssertTrue((ML##IDX.EOLLength==EOL_LENGTH)||(NSLog(@"%lu(_ML)<!>%lu(Expected)",ML##IDX.EOLLength,EOL_LENGTH),NO),@"MISSED EOLLength",NULL);\
        STAssertTrue((ML##IDX.numberOfSyntaxWords==NUMBER_OF_SYNTAX_WORDS)||(NSLog(@"%lu(_ML)<!>%lu(Expected)",ML##IDX.numberOfSyntaxWords,NUMBER_OF_SYNTAX_WORDS),NO),@"MISSED numberOfSyntaxWords",NULL);\
    } while (NO)
#   undef TEST_K
#   define TEST_K(IDX,INDEX,MODE,LENGTH) do {\
        STAssertTrue(INDEX < ML##IDX.numberOfSyntaxWords,@"MISSED # of modes",nil);\
        STAssertTrue(MODE == [ML##IDX syntaxModeAtIndex:INDEX],@"MISSED MODE",nil);\
        STAssertTrue(LENGTH == [ML##IDX syntaxLengthAtIndex:INDEX],@"MISSED LENGTH",nil);\
    } while (NO)
#   define PREPARE_TEST(STRING) do {\
        ML0 = ML1 = ML2 = ML3 = nil;\
        TS = [[NSTextStorage alloc] initWithString:STRING];\
        [TSP setTextStorage:TS];\
    } while (NO)
    PREPARE_TEST(@"");
    TEST(0,ZER0,ZER0,ZER0);
    NEW_TEST(0,ZER0,3,2);// "zzNEL"
    TEST(0,contentsLength,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,contentsLength);
    TEST(1,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"X");
    TEST(0,1,ZER0,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(0,ZER0,4,2);// "zzNELX"
    TEST(0,contentsLength,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,contentsLength);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    //--
    PREPARE_TEST(@"X");
    TEST(0,1,ZER0,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(1,ZER0,4,2);// "XzzNEL"
    TEST(0,1+contentsLength,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1+contentsLength);
    TEST(1,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"XY");
    TEST(0,contentsLength,ZER0,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2);
    NEW_TEST(1,ZER0,5,2);// "XzzNELY"
    TEST(0,1+contentsLength,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1+contentsLength);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    //--
    PREPARE_TEST(@"\r");
    TEST(0,ZER0,1,ZER0);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(0,ZER0,4,3);// "zzNEL\r"
    TEST(0,contentsLength,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,contentsLength);
    TEST(1,ZER0,1,ZER0);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"\r");
    TEST(0,ZER0,1,ZER0);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(1,1,3,3);// "\rzzNEL"
    TEST(0,ZER0,1,ZER0);
    TEST(1,contentsLength,1,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,contentsLength);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"\r\n");
    TEST(0,ZER0,2,ZER0);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(0,ZER0,5,3);// "zzNEL\r\n"
    TEST(0,contentsLength,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,contentsLength);
    TEST(1,ZER0,2,ZER0);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"\r\n");
    TEST(0,ZER0,2,ZER0);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(1,1,4,4);// "\rzzNEL\n"
    TEST(0,ZER0,1,ZER0);
    TEST(1,contentsLength,1,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,contentsLength);
    TEST(2,ZER0,1,ZER0);
    TEST(3,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"\r\n");
    TEST(0,ZER0,2,ZER0);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(2,2,3,3);// "\r\nzzNEL"
    TEST(0,ZER0,2,ZER0);
    TEST(1,contentsLength,1,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,contentsLength);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"X\r\n");
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(0,ZER0,6,3);// "zzNELX\r\n"
    TEST(0,contentsLength,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,contentsLength);
    TEST(1,1,2,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"X\r\n");
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(1,ZER0,6,3);// "XzzNEL\r\n"
    TEST(0,1+contentsLength,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1+contentsLength);
    TEST(1,ZER0,2,ZER0);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"X\r\n");
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(2,2,4,4);// "X\rzzNEL\n"
    TEST(0,1,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,contentsLength,1,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,2);
    TEST(2,ZER0,1,ZER0);
    TEST(3,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"X\r\n");
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(3,3,3,3);// "X\r\nzzNEL"
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,contentsLength,1,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,2);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"\r\nX");
    TEST(0,ZER0,2,ZER0);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(0,ZER0,5,3);// "zzNEL\r\nX"
    TEST(0,contentsLength,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2);
    TEST(1,ZER0,2,ZER0);
    TEST(2,1,ZER0,1);
    TEST_K(2,ZER0,kiTM2TextUnknownSyntaxMode,1);
    //--
    PREPARE_TEST(@"\r\nX");
    TEST(0,ZER0,2,ZER0);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(1,1,5,4);// "\rzzNEL\nX"
    TEST(0,ZER0,1,ZER0);
    TEST(1,contentsLength,1,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,2);
    TEST(2,ZER0,1,ZER0);
    TEST(3,1,ZER0,1);
    TEST_K(3,ZER0,kiTM2TextUnknownSyntaxMode,1);
    //--
    PREPARE_TEST(@"\r\nX");
    TEST(0,ZER0,2,ZER0);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(2,2,4,3);// "\r\nzzNELX"
    TEST(0,ZER0,2,ZER0);
    TEST(1,contentsLength,1,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,2);
    TEST(2,1,ZER0,1);
    TEST_K(2,ZER0,kiTM2TextUnknownSyntaxMode,1);
    //--
    PREPARE_TEST(@"\r\nX");
    TEST(0,ZER0,2,ZER0);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(3,2,4,3);// "\r\nXzzNEL"
    TEST(0,ZER0,2,ZER0);
    TEST(1,1+contentsLength,1,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1+contentsLength);
    TEST(2,ZER0,ZER0,ZER0);
    //--
    PREPARE_TEST(@"XY");
    TEST(0,contentsLength,ZER0,1);
    NEW_TEST(0,ZER0,5,2);// "zzNELXY"
    TEST(0,contentsLength,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,contentsLength);
    TEST(1,2,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,2);
    //--
    PREPARE_TEST(@"XY");
    TEST(0,contentsLength,ZER0,1);
    NEW_TEST(1,ZER0,5,2);// "XzzNELY"
    TEST(0,1+contentsLength,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1+contentsLength);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    //--
    PREPARE_TEST(@"XY");
    TEST(0,contentsLength,ZER0,1);
    NEW_TEST(2,ZER0,5,2);// "XYzzNEL"
    TEST(0,2+contentsLength,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2+contentsLength);
    TEST(1,ZER0,ZER0,ZER0);
    //--
#   define INIT_TEST \
    PREPARE_TEST(@"XY"); \
    ML0 = [TSP modeLineAtIndex:ZER0]; \
    TEST(0,contentsLength,ZER0,1); \
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2); \
    [ML0 deleteModesInGlobalRange:iTM3MakeRange(ZER0,2) error:&ROR]; \
    STAssertNil(ROR,@"MISSED !ROR",nil); \
    [ML0 appendSyntaxModesAndLengths:(UI)1,(UI)1,(UI)2,(UI)1,ZER0,ZER0]; \
    TEST(0,contentsLength,ZER0,2); \
    TEST_K(0,ZER0,1,1); \
    TEST_K(0,1,2,1)
    INIT_TEST;// "XY"
    NEW_TEST(0,ZER0,5,2);// "zzNELXY"
    TEST(0,contentsLength,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,contentsLength);
    TEST(1,2,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,2);
    //--
    INIT_TEST;
    NEW_TEST(1,ZER0,5,2);// "XzzNELY"
    TEST(0,1+contentsLength,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1+contentsLength);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    //--
    INIT_TEST;
    NEW_TEST(2,ZER0,5,2);// "XYzzNEL"
    TEST(0,2+contentsLength,1,2);
    TEST_K(0,ZER0,1,1);
    TEST_K(0,1,2,1+contentsLength);
    TEST(1,ZER0,ZER0,ZER0);
    //--
    return;
#   undef INIT_TEST
#   undef NEW_TEST
#   undef PREPARE_TEST
#   undef TEST
#   undef TEST_K
}
- (void)testCase_textStorageDidReplaceCharactersAtIndex;
{
    iTM2TextSyntaxParser * TSP = [[iTM2TextSyntaxParser alloc] init];
    STAssertNil(TSP.textStorage,@"MISSED",nil);
    STAssertTrue(TSP.numberOfModeLines == ZER0,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:ZER0] == NSUIntegerMax,@"MISSED",nil);
    TSP.textStorageDidChange;
    STAssertTrue(TSP.numberOfModeLines == 1,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:ZER0] == ZER0,@"MISSED",nil);
    iTM2ModeLine * ML0 = nil;
    iTM2ModeLine * ML1 = nil;
    iTM2ModeLine * ML2 = nil;
    iTM2ModeLine * ML3 = nil;
    NSTextStorage * TS = nil;
    NSRange R = iTM3VoidRange;
    NSError * ROR = nil;
    NSString * prefix = @"";// eithe void string or end with a complete EOL sequence (no \r alone)
    NSNumber * prefixNumOfEOLs = nil;
#   define PREPARE_TEST(STRING) do {\
        ML0 = ML1 = ML2 = ML3 = nil;\
        TS = [[NSTextStorage alloc] initWithString:[prefix stringByAppendingString:STRING]];\
        [TSP setTextStorage:TS];\
    } while (NO)
#   define NEW_TEST(WHAT,WHERE,LENGTH,REPLACEMENT,LOCATION,RANGE,NUMBER_OF_MODE_LINES) do {\
        PREPARE_TEST(WHAT);\
        [TS replaceCharactersInRange:iTM3MakeRange(WHERE+prefix.length,LENGTH) withString:REPLACEMENT];\
        STAssertTrue([TSP textStorageDidReplaceCharactersAtIndex:WHERE+prefix.length count:LENGTH withCount:[REPLACEMENT length] editedAttributesRangeIn:&R error:&ROR],\
            @"MISSED textStorageDidReplaceCharactersAtIndex",nil);\
        STAssertNil(ROR,@"MISSED non nil ROR",nil);\
        STAssertTrue(NSEqualRanges(R,iTM3MakeRange(LOCATION+prefix.length,RANGE))||(NSLog(@"R: %@",NSStringFromRange(R)),NO),@"MISSED NSEqualRanges",nil);\
        STAssertTrue(TSP.numberOfModeLines==NUMBER_OF_MODE_LINES+prefixNumOfEOLs.unsignedIntegerValue,@"MISSED numberOfModeLines",nil);\
    } while (NO)
#   undef TEST
#   define TEST(IDX,CONTENTS_LENGTH,EOL_LENGTH,NUMBER_OF_SYNTAX_WORDS) do {\
        ML##IDX = [TSP modeLineAtIndex:IDX+prefixNumOfEOLs.unsignedIntegerValue];\
        STAssertFalse(ML##IDX.diagnostic,@"MISSED diagnostic",NULL);\
        STAssertTrue((ML##IDX.contentsLength==CONTENTS_LENGTH)||(NSLog(@"%lu(_ML)<!>%lu(Expected)",ML##IDX.contentsLength,CONTENTS_LENGTH),NO),@"MISSED contentsLength",NULL);\
        STAssertTrue((ML##IDX.EOLLength==EOL_LENGTH)||(NSLog(@"%lu(_ML)<!>%lu(Expected)",ML##IDX.EOLLength,EOL_LENGTH),NO),@"MISSED EOLLength",NULL);\
        STAssertTrue((ML##IDX.numberOfSyntaxWords==NUMBER_OF_SYNTAX_WORDS)||(NSLog(@"%lu(_ML)<!>%lu(Expected)",ML##IDX.numberOfSyntaxWords,NUMBER_OF_SYNTAX_WORDS),NO),@"MISSED numberOfSyntaxWords",NULL);\
    } while (NO)
#   undef TEST_K
#   define TEST_K(IDX,INDEX,MODE,LENGTH) do {\
        STAssertTrue(INDEX < ML##IDX.numberOfSyntaxWords,@"MISSED # of modes",nil);\
        STAssertTrue(MODE == [ML##IDX syntaxModeAtIndex:INDEX],@"MISSED MODE",nil);\
        STAssertTrue(LENGTH == [ML##IDX syntaxLengthAtIndex:INDEX],@"MISSED LENGTH",nil);\
    } while (NO)
    //--length 1, no EOL
#if 0
    NEW_TEST(@"X",ZER0,1,@"Y",ZER0,1,1);
    TEST(0,1,ZER0,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(@"X",ZER0,1,@"YZ",ZER0,2,1);
    TEST(0,2,ZER0,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2);
    NEW_TEST(@"X",ZER0,1,@"\r",ZER0,1,2);
    TEST(0,ZER0,1,ZER0);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(@"X",ZER0,1,@"\r\n",ZER0,2,2);
    TEST(0,ZER0,2,ZER0);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(@"X",ZER0,1,@"1\r\n",ZER0,3,2);
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(@"X",ZER0,1,@"\r\n1",ZER0,3,2);
    TEST(0,ZER0,2,ZER0);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(@"\r",ZER0,1,@"Y",ZER0,1,1);
    TEST(0,1,ZER0,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(@"\r",ZER0,1,@"YZ",ZER0,2,1);
    TEST(0,2,ZER0,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2);
    NEW_TEST(@"\r",ZER0,1,@"\r",ZER0,1,2);
    TEST(0,ZER0,1,ZER0);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(@"\r",ZER0,1,@"\r\n",ZER0,2,2);
    TEST(0,ZER0,2,ZER0);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(@"\r",ZER0,1,@"1\r\n",ZER0,3,2);
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(@"\r",ZER0,1,@"\r\n1",ZER0,3,2);
    TEST(0,ZER0,2,ZER0);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(@"X\r",ZER0,1,@"Y",ZER0,2,2);
    TEST(0,1,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(@"X\r",ZER0,1,@"YZ",ZER0,3,2);
    TEST(0,2,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(@"X\r",ZER0,1,@"\r",ZER0,2,3);
    TEST(0,ZER0,1,ZER0);
    TEST(1,ZER0,1,ZER0);
    TEST(2,ZER0,ZER0,ZER0);
    NEW_TEST(@"X\r",ZER0,1,@"\r\n",ZER0,3,3);
    TEST(0,ZER0,2,ZER0);
    TEST(1,ZER0,1,ZER0);
    TEST(2,ZER0,ZER0,ZER0);
    NEW_TEST(@"X\r",ZER0,1,@"1\r\n",ZER0,4,3);
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,1,ZER0);
    TEST(2,ZER0,ZER0,ZER0);
    NEW_TEST(@"X\r",ZER0,1,@"\r\n1",ZER0,4,3);
    TEST(0,ZER0,2,ZER0);
    TEST(1,1,1,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(2,ZER0,ZER0,ZER0);
    NEW_TEST(@"\rX",ZER0,1,@"Y",ZER0,2,1);
    TEST(0,2,ZER0,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2);
    NEW_TEST(@"\rX",ZER0,1,@"YZ",ZER0,3,1);
    TEST(0,3,ZER0,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,3);
    NEW_TEST(@"\rX",ZER0,1,@"\r",ZER0,2,2);
    TEST(0,ZER0,1,ZER0);
    TEST(1,1,ZER0,1);
    NEW_TEST(@"\rX",ZER0,1,@"\r\n",ZER0,3,2);
    TEST(0,ZER0,2,ZER0);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(@"\rX",ZER0,1,@"1\r\n",ZER0,4,2);
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(@"\rX",ZER0,1,@"\r\n1",ZER0,4,2);
    TEST(0,ZER0,2,ZER0);
    TEST(1,2,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,2);
    NEW_TEST(@"X\r\n",ZER0,1,@"Y",ZER0,3,2);
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(@"X\r\n",ZER0,1,@"YZ",ZER0,4,2);
    TEST(0,2,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(@"X\r\n",ZER0,1,@"\r",ZER0,3,3);
    TEST(0,ZER0,1,ZER0);
    TEST(1,ZER0,2,ZER0);
    TEST(2,ZER0,ZER0,ZER0);
    NEW_TEST(@"X\r\n",ZER0,1,@"\r\n",ZER0,4,3);
    TEST(0,ZER0,2,ZER0);
    TEST(1,ZER0,2,ZER0);
    TEST(2,ZER0,ZER0,ZER0);
    NEW_TEST(@"X\r\n",ZER0,1,@"1\r\n",ZER0,5,3);
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,2,ZER0);
    TEST(2,ZER0,ZER0,ZER0);
    NEW_TEST(@"X\r\n",ZER0,1,@"\r\n1",ZER0,5,3);
    TEST(0,ZER0,2,ZER0);
    TEST(1,1,2,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(2,ZER0,ZER0,ZER0);
    NEW_TEST(@"\r\nX",ZER0,1,@"Y",ZER0,2,2);
    TEST(0,1,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(@"\r\nX",ZER0,1,@"YZ",ZER0,3,2);
    TEST(0,2,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(@"\r\nX",ZER0,1,@"\r",ZER0,2,2);
    TEST(0,ZER0,2,ZER0);
    TEST(1,1,ZER0,1);
    NEW_TEST(@"\r\nX",ZER0,1,@"\r\n",ZER0,3,3);
    TEST(0,ZER0,2,ZER0);
    TEST(1,ZER0,1,ZER0);
    TEST(2,1,ZER0,1);
    TEST_K(2,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(@"\r\nX",ZER0,1,@"1\r\n",ZER0,4,3);
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,1,ZER0);
    TEST(2,1,ZER0,1);
    TEST_K(2,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(@"\r\nX",ZER0,1,@"\r\n1",ZER0,4,3);
    TEST(0,ZER0,2,ZER0);
    TEST(1,1,1,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(2,1,ZER0,1);
    TEST_K(2,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(@"X\r",1,1,@"Y",ZER0,2,1);
    TEST(0,2,ZER0,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2);
    NEW_TEST(@"X\r",1,1,@"YZ",ZER0,3,1);
    TEST(0,3,ZER0,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,3);
    NEW_TEST(@"X\r",1,1,@"\r",ZER0,2,2);
    TEST(0,1,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(@"X\r",1,1,@"\r\n",ZER0,3,2);
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(@"X\r",1,1,@"1\r\n",ZER0,4,2);
    TEST(0,2,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(@"X\r",1,1,@"\r\n1",ZER0,4,2);
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(@"\rX",1,1,@"Y",1,1,2);
    TEST(0,ZER0,1,ZER0);
    TEST(1,1,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(@"\rX",1,1,@"YZ",1,2,2);
    TEST(0,ZER0,1,ZER0);
    TEST(1,2,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,2);
    NEW_TEST(@"\rX",1,1,@"\r",1,1,3);
    TEST(0,ZER0,1,ZER0);
    TEST(1,ZER0,1,ZER0);
    TEST(2,ZER0,ZER0,ZER0);
    NEW_TEST(@"\rX",1,1,@"\n",2,ZER0,2);
    TEST(0,ZER0,2,ZER0);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(@"\rX",1,1,@"\r\n",1,2,3);
    TEST(0,ZER0,1,ZER0);
    TEST(1,ZER0,2,ZER0);
    TEST(2,ZER0,ZER0,ZER0);
    NEW_TEST(@"\rX",1,1,@"1\r\n",1,3,3);
    TEST(0,ZER0,1,ZER0);
    TEST(1,1,2,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(2,ZER0,ZER0,ZER0);
    NEW_TEST(@"\rX",1,1,@"\r\n1",1,3,3);
    TEST(0,ZER0,1,ZER0);
    TEST(1,ZER0,2,ZER0);
    TEST(2,1,ZER0,1);
    TEST_K(2,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(@"X\r\n",1,1,@"Y",ZER0,3,2);
    TEST(0,2,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(@"X\r\n",1,1,@"YZ",ZER0,4,2);
    TEST(0,3,1,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,3);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(@"X\r\n",1,1,@"\r",ZER0,3,2);
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,ZER0,ZER0);
    NEW_TEST(@"X\r\n",1,1,@"\r\n",ZER0,4,3);
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,ZER0,1,ZER0);
    TEST(2,ZER0,ZER0,ZER0);
    NEW_TEST(@"X\r\n",1,1,@"1\r\n",ZER0,5,3);
    TEST(0,2,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2);
    TEST(1,ZER0,1,ZER0);
    TEST(2,ZER0,ZER0,ZER0);
    NEW_TEST(@"X\r\n",1,1,@"\r\n1",ZER0,5,3);
    TEST(0,1,2,1);
    TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(1,1,1,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(2,ZER0,ZER0,ZER0);
    NEW_TEST(@"\r\nX",1,1,@"Y",ZER0,3,2);
    TEST(0,ZER0,1,ZER0);
    TEST(1,2,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,2);
    NEW_TEST(@"\r\nX",1,1,@"YZ",ZER0,4,2);
    TEST(0,ZER0,1,ZER0);
    TEST(1,3,ZER0,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,3);
    NEW_TEST(@"\r\nX",1,1,@"\r",ZER0,3,3);
    TEST(0,ZER0,1,ZER0);
    TEST(1,ZER0,1,ZER0);
    TEST(2,1,ZER0,1);
    TEST_K(2,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(@"\r\nX",1,1,@"\r\n",ZER0,4,3);
    TEST(0,ZER0,1,ZER0);
    TEST(1,ZER0,2,ZER0);
    TEST(2,1,ZER0,1);
    TEST_K(2,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(@"\r\nX",1,1,@"1\r\n",ZER0,5,3);
    TEST(0,ZER0,1,ZER0);
    TEST(1,1,2,1);
    TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
    TEST(2,1,ZER0,1);
    TEST_K(2,ZER0,kiTM2TextUnknownSyntaxMode,1);
    NEW_TEST(@"\r\nX",1,1,@"\r\n1",ZER0,5,3);
    TEST(0,ZER0,1,ZER0);
    TEST(1,ZER0,2,ZER0);
    TEST(2,2,ZER0,1);
    TEST_K(2,ZER0,kiTM2TextUnknownSyntaxMode,2);
#endif
    NSEnumerator * E = [[NSArray arrayWithObjects:
        @"",[NSNumber numberWithUnsignedInteger:ZER0],
        @"\n",[NSNumber numberWithUnsignedInteger:1],
        @"-\n",[NSNumber numberWithUnsignedInteger:1],
        @"\r-\n",[NSNumber numberWithUnsignedInteger:2],
            nil] objectEnumerator];
    while ((prefix = E.nextObject) && (prefixNumOfEOLs = E.nextObject)) {
#if 1
        NEW_TEST(@"X",ZER0,1,@"Y",ZER0,1,1);
        TEST(0,1,ZER0,1);
        TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
        NEW_TEST(@"X",ZER0,1,@"YZ",ZER0,2,1);
        TEST(0,2,ZER0,1);
        TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2);
        NEW_TEST(@"X",ZER0,1,@"\r",ZER0,1,2);
        TEST(0,ZER0,1,ZER0);
        TEST(1,ZER0,ZER0,ZER0);
        NEW_TEST(@"X",ZER0,1,@"\r\n",ZER0,2,2);
        TEST(0,ZER0,2,ZER0);
        TEST(1,ZER0,ZER0,ZER0);
        NEW_TEST(@"X",ZER0,1,@"1\r\n",ZER0,3,2);
        TEST(0,1,2,1);
        TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
        TEST(1,ZER0,ZER0,ZER0);
        NEW_TEST(@"X",ZER0,1,@"\r\n1",ZER0,3,2);
        TEST(0,ZER0,2,ZER0);
        TEST(1,1,ZER0,1);
        TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
        NEW_TEST(@"\r",ZER0,1,@"Y",ZER0,1,1);
        TEST(0,1,ZER0,1);
        TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
        NEW_TEST(@"\r",ZER0,1,@"YZ",ZER0,2,1);
        TEST(0,2,ZER0,1);
        TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2);
        NEW_TEST(@"\r",ZER0,1,@"\r",ZER0,1,2);
        TEST(0,ZER0,1,ZER0);
        TEST(1,ZER0,ZER0,ZER0);
        NEW_TEST(@"\r",ZER0,1,@"\r\n",ZER0,2,2);
        TEST(0,ZER0,2,ZER0);
        TEST(1,ZER0,ZER0,ZER0);
        NEW_TEST(@"\r",ZER0,1,@"1\r\n",ZER0,3,2);
        TEST(0,1,2,1);
        TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
        TEST(1,ZER0,ZER0,ZER0);
        NEW_TEST(@"\r",ZER0,1,@"\r\n1",ZER0,3,2);
        TEST(0,ZER0,2,ZER0);
        TEST(1,1,ZER0,1);
        TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
        NEW_TEST(@"X\r",ZER0,1,@"Y",ZER0,2,2);
        TEST(0,1,1,1);
        TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
        TEST(1,ZER0,ZER0,ZER0);
        NEW_TEST(@"X\r",ZER0,1,@"YZ",ZER0,3,2);
        TEST(0,2,1,1);
        TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2);
        TEST(1,ZER0,ZER0,ZER0);
        NEW_TEST(@"X\r",ZER0,1,@"\r",ZER0,2,3);
        TEST(0,ZER0,1,ZER0);
        TEST(1,ZER0,1,ZER0);
        TEST(2,ZER0,ZER0,ZER0);
        NEW_TEST(@"X\r",ZER0,1,@"\r\n",ZER0,3,3);
        TEST(0,ZER0,2,ZER0);
        TEST(1,ZER0,1,ZER0);
        TEST(2,ZER0,ZER0,ZER0);
        NEW_TEST(@"X\r",ZER0,1,@"1\r\n",ZER0,4,3);
        TEST(0,1,2,1);
        TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
        TEST(1,ZER0,1,ZER0);
        TEST(2,ZER0,ZER0,ZER0);
        NEW_TEST(@"X\r",ZER0,1,@"\r\n1",ZER0,4,3);
        TEST(0,ZER0,2,ZER0);
        TEST(1,1,1,1);
        TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
        TEST(2,ZER0,ZER0,ZER0);
        NEW_TEST(@"\rX",ZER0,1,@"Y",ZER0,2,1);
        TEST(0,2,ZER0,1);
        TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2);
        NEW_TEST(@"\rX",ZER0,1,@"YZ",ZER0,3,1);
        TEST(0,3,ZER0,1);
        TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,3);
        NEW_TEST(@"\rX",ZER0,1,@"\r",ZER0,2,2);
        TEST(0,ZER0,1,ZER0);
        TEST(1,1,ZER0,1);
        NEW_TEST(@"\rX",ZER0,1,@"\r\n",ZER0,3,2);
        TEST(0,ZER0,2,ZER0);
        TEST(1,1,ZER0,1);
        TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
        NEW_TEST(@"\rX",ZER0,1,@"1\r\n",ZER0,4,2);
        TEST(0,1,2,1);
        TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
        TEST(1,1,ZER0,1);
        TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
        NEW_TEST(@"\rX",ZER0,1,@"\r\n1",ZER0,4,2);
        TEST(0,ZER0,2,ZER0);
        TEST(1,2,ZER0,1);
        TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,2);
        NEW_TEST(@"X\r\n",ZER0,1,@"Y",ZER0,3,2);
        TEST(0,1,2,1);
        TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
        TEST(1,ZER0,ZER0,ZER0);
        NEW_TEST(@"X\r\n",ZER0,1,@"YZ",ZER0,4,2);
        TEST(0,2,2,1);
        TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2);
        TEST(1,ZER0,ZER0,ZER0);
        NEW_TEST(@"X\r\n",ZER0,1,@"\r",ZER0,3,3);
        TEST(0,ZER0,1,ZER0);
        TEST(1,ZER0,2,ZER0);
        TEST(2,ZER0,ZER0,ZER0);
        NEW_TEST(@"X\r\n",ZER0,1,@"\r\n",ZER0,4,3);
        TEST(0,ZER0,2,ZER0);
        TEST(1,ZER0,2,ZER0);
        TEST(2,ZER0,ZER0,ZER0);
        NEW_TEST(@"X\r\n",ZER0,1,@"1\r\n",ZER0,5,3);
        TEST(0,1,2,1);
        TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
        TEST(1,ZER0,2,ZER0);
        TEST(2,ZER0,ZER0,ZER0);
        NEW_TEST(@"X\r\n",ZER0,1,@"\r\n1",ZER0,5,3);
        TEST(0,ZER0,2,ZER0);
        TEST(1,1,2,1);
        TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
        TEST(2,ZER0,ZER0,ZER0);
        NEW_TEST(@"\r\nX",ZER0,1,@"Y",ZER0,2,2);
        TEST(0,1,1,1);
        TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
        TEST(1,1,ZER0,1);
        TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
        NEW_TEST(@"\r\nX",ZER0,1,@"YZ",ZER0,3,2);
        TEST(0,2,1,1);
        TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2);
        TEST(1,1,ZER0,1);
        TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
        NEW_TEST(@"\r\nX",ZER0,1,@"\r",ZER0,2,2);
        TEST(0,ZER0,2,ZER0);
        TEST(1,1,ZER0,1);
        NEW_TEST(@"\r\nX",ZER0,1,@"\r\n",ZER0,3,3);
        TEST(0,ZER0,2,ZER0);
        TEST(1,ZER0,1,ZER0);
        TEST(2,1,ZER0,1);
        TEST_K(2,ZER0,kiTM2TextUnknownSyntaxMode,1);
        NEW_TEST(@"\r\nX",ZER0,1,@"1\r\n",ZER0,4,3);
        TEST(0,1,2,1);
        TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
        TEST(1,ZER0,1,ZER0);
        TEST(2,1,ZER0,1);
        TEST_K(2,ZER0,kiTM2TextUnknownSyntaxMode,1);
        NEW_TEST(@"\r\nX",ZER0,1,@"\r\n1",ZER0,4,3);
        TEST(0,ZER0,2,ZER0);
        TEST(1,1,1,1);
        TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
        TEST(2,1,ZER0,1);
        TEST_K(2,ZER0,kiTM2TextUnknownSyntaxMode,1);
        NEW_TEST(@"X\r",1,1,@"Y",ZER0,2,1);
        TEST(0,2,ZER0,1);
        TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2);
        NEW_TEST(@"X\r",1,1,@"YZ",ZER0,3,1);
        TEST(0,3,ZER0,1);
        TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,3);
        NEW_TEST(@"X\r",1,1,@"\r",ZER0,2,2);
        TEST(0,1,1,1);
        TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
        TEST(1,ZER0,ZER0,ZER0);
        NEW_TEST(@"X\r",1,1,@"\r\n",ZER0,3,2);
        TEST(0,1,2,1);
        TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
        TEST(1,ZER0,ZER0,ZER0);
        NEW_TEST(@"X\r",1,1,@"1\r\n",ZER0,4,2);
        TEST(0,2,2,1);
        TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2);
        TEST(1,ZER0,ZER0,ZER0);
        NEW_TEST(@"X\r",1,1,@"\r\n1",ZER0,4,2);
        TEST(0,1,2,1);
        TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
        TEST(1,1,ZER0,1);
        TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
        NEW_TEST(@"\rX",1,1,@"Y",1,1,2);
        TEST(0,ZER0,1,ZER0);
        TEST(1,1,ZER0,1);
        TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
        NEW_TEST(@"\rX",1,1,@"YZ",1,2,2);
        TEST(0,ZER0,1,ZER0);
        TEST(1,2,ZER0,1);
        TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,2);
        NEW_TEST(@"\rX",1,1,@"\r",1,1,3);
        TEST(0,ZER0,1,ZER0);
        TEST(1,ZER0,1,ZER0);
        TEST(2,ZER0,ZER0,ZER0);
        NEW_TEST(@"\rX",1,1,@"\n",2,ZER0,2);
        TEST(0,ZER0,2,ZER0);
        TEST(1,ZER0,ZER0,ZER0);
        NEW_TEST(@"\rX",1,1,@"\r\n",1,2,3);
        TEST(0,ZER0,1,ZER0);
        TEST(1,ZER0,2,ZER0);
        TEST(2,ZER0,ZER0,ZER0);
        NEW_TEST(@"\rX",1,1,@"1\r\n",1,3,3);
        TEST(0,ZER0,1,ZER0);
        TEST(1,1,2,1);
        TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
        TEST(2,ZER0,ZER0,ZER0);
        NEW_TEST(@"\rX",1,1,@"\r\n1",1,3,3);
        TEST(0,ZER0,1,ZER0);
        TEST(1,ZER0,2,ZER0);
        TEST(2,1,ZER0,1);
        TEST_K(2,ZER0,kiTM2TextUnknownSyntaxMode,1);
        NEW_TEST(@"X\r\n",1,1,@"Y",ZER0,3,2);
        TEST(0,2,1,1);
        TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2);
        TEST(1,ZER0,ZER0,ZER0);
        NEW_TEST(@"X\r\n",1,1,@"YZ",ZER0,4,2);
        TEST(0,3,1,1);
        TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,3);
        TEST(1,ZER0,ZER0,ZER0);
        NEW_TEST(@"X\r\n",1,1,@"\r",ZER0,3,2);
        TEST(0,1,2,1);
        TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
        TEST(1,ZER0,ZER0,ZER0);
        NEW_TEST(@"X\r\n",1,1,@"\r\n",ZER0,4,3);
        TEST(0,1,2,1);
        TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
        TEST(1,ZER0,1,ZER0);
        TEST(2,ZER0,ZER0,ZER0);
        NEW_TEST(@"X\r\n",1,1,@"1\r\n",ZER0,5,3);
        TEST(0,2,2,1);
        TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,2);
        TEST(1,ZER0,1,ZER0);
        TEST(2,ZER0,ZER0,ZER0);
        NEW_TEST(@"X\r\n",1,1,@"\r\n1",ZER0,5,3);
        TEST(0,1,2,1);
        TEST_K(0,ZER0,kiTM2TextUnknownSyntaxMode,1);
        TEST(1,1,1,1);
        TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
        TEST(2,ZER0,ZER0,ZER0);
        NEW_TEST(@"\r\nX",1,1,@"Y",ZER0,3,2);
        TEST(0,ZER0,1,ZER0);
        TEST(1,2,ZER0,1);
        TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,2);
        NEW_TEST(@"\r\nX",1,1,@"YZ",ZER0,4,2);
        TEST(0,ZER0,1,ZER0);
        TEST(1,3,ZER0,1);
        TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,3);
        NEW_TEST(@"\r\nX",1,1,@"\r",ZER0,3,3);
        TEST(0,ZER0,1,ZER0);
        TEST(1,ZER0,1,ZER0);
        TEST(2,1,ZER0,1);
        TEST_K(2,ZER0,kiTM2TextUnknownSyntaxMode,1);
        NEW_TEST(@"\r\nX",1,1,@"\r\n",ZER0,4,3);
        TEST(0,ZER0,1,ZER0);
        TEST(1,ZER0,2,ZER0);
        TEST(2,1,ZER0,1);
        TEST_K(2,ZER0,kiTM2TextUnknownSyntaxMode,1);
        NEW_TEST(@"\r\nX",1,1,@"1\r\n",ZER0,5,3);
        TEST(0,ZER0,1,ZER0);
        TEST(1,1,2,1);
        TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
        TEST(2,1,ZER0,1);
        TEST_K(2,ZER0,kiTM2TextUnknownSyntaxMode,1);
        NEW_TEST(@"\r\nX",1,1,@"\r\n1",ZER0,5,3);
        TEST(0,ZER0,1,ZER0);
        TEST(1,ZER0,2,ZER0);
        TEST(2,2,ZER0,1);
        TEST_K(2,ZER0,kiTM2TextUnknownSyntaxMode,2);
#endif
        NEW_TEST(@"\r\nX",1,1,@"\n1",ZER0,4,2);
        TEST(0,ZER0,2,ZER0);
        TEST(1,2,ZER0,1);
        TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,2);
        NEW_TEST(@"\r\nX",1,1,@"\n1\n",ZER0,5,3);
        TEST(0,ZER0,2,ZER0);
        TEST(1,1,1,1);
        TEST_K(1,ZER0,kiTM2TextUnknownSyntaxMode,1);
        TEST(2,1,ZER0,1);
        TEST_K(2,ZER0,kiTM2TextUnknownSyntaxMode,1);
    }
    return;
#   undef INIT_TEST
#   undef NEW_TEST
#   undef PREPARE_TEST
#   undef TEST
#   undef TEST_K
}
- (void)testCase_1_ML;
{
    iTM2TextSyntaxParser * TSP = [[iTM2TextSyntaxParser alloc] init];
    STAssertNil(TSP.textStorage,@"MISSED",nil);
    STAssertTrue(TSP.numberOfModeLines == ZER0,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:ZER0] == NSUIntegerMax,@"MISSED",nil);
    TSP.textStorageDidChange;
    STAssertTrue(TSP.numberOfModeLines == 1,@"MISSED",nil);
    STAssertTrue([TSP lineIndexForLocation4iTM3:ZER0] == ZER0,@"MISSED",nil);
    NSString * S1 = nil;
    iTM2ModeLine * ML1 = nil;
    NSUInteger mode,status;
    NSRange R;
#define TEST_Z(WHERE,STATUS,MODE,LOCATION,LENGTH) do {\
        status = [TSP getSyntaxMode:&mode atIndex:WHERE longestRange:&R];\
        STAssertTrue(TSP.numberOfModeLines == 1,@"MISSED",nil);\
        STAssertTrue((status == STATUS && mode == MODE && NSEqualRanges(R, iTM3MakeRange(LOCATION,LENGTH)))\
            || (NSLog(@"name:result<?>EXPECTED,status:%lu<?>%lu,mode:%lu<?>%lu,range:%@<?>%@",status,STATUS,mode,MODE,NSStringFromRange(R),NSStringFromRange(iTM3MakeRange(LOCATION,LENGTH))),NO),@"MISSED",nil);\
    } while (NO)
    for (S1 in EOLs) {
        if (![S1 isEqual:@"\f"]) {
            ML1 = [[iTM2ModeLine alloc] initWithString:S1 atCursor:NULL];
            ML1.EOLMode = [[[NSProcessInfo processInfo] globallyUniqueString] hash];
            [TSP replaceModeLineAtIndex:ZER0 withModeLine:ML1];
            TEST_Z(ZER0,kiTM2TextNoErrorSyntaxStatus,ML1.EOLMode,ZER0,S1.length);
        }
    }
#   undef TEST_Z
}
@end

