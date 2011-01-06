//
//  iTM2Test3A
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

#import "iTM2SystemSignalKit.h"
#import "iTM2Responders.h"
#import "iTM2SpellKit.h"
#import "iTM2ProjectSpellKit.h"
#import "iTM2TaskKit.h"
#import "iTM2StartupKit.h"

#import "iTM2TextStyleEditionKit.h"
#import "iTM2TextStorageKit.h"

#import "iTM2Test3A.h"

// iTM2ModeLine

@implementation iTM2Test3A
- (void) setUp
{
    // Create data structures here.
    iTM2DebugEnabled = 20000;
}

- (void) tearDown
{
    // Release data structures here.
}
#if 0

- (BOOL)deleteModesInGlobalRange:(NSRange)aRange;
- (BOOL)moreStorage;
- (BOOL)enlargeSyntaxModeAtGlobalLocation:(NSUInteger)aLocation length:(NSUInteger)length;
- (void)appendNormalSyntaxMode:(NSUInteger)mode length:(NSUInteger)length;// beware: the _Length is updated too
- (void)appendCommentedSyntaxMode:(NSUInteger)mode length:(NSUInteger)length;// beware: the _Length is updated too





- (id)initWithString:(NSString *)aString atCursor:(NSUInteger *)cursor;
- (void)describe;
@property (assign, nonatomic) NSUInteger startOff7;
@property (assign, nonatomic) NSUInteger commentOff7;
@property (assign, nonatomic) NSUInteger contentsEndOff7;
@property (assign, nonatomic) NSUInteger endOff7;
@property (readonly, nonatomic) NSUInteger uncommentedLength;
@property (assign, nonatomic) NSUInteger EOLLength;
@property (readonly, nonatomic) NSUInteger contentsLength;
@property (assign, nonatomic) NSUInteger previousMode;
@property (assign, nonatomic) NSUInteger EOLMode;
@property (readonly, nonatomic) NSUInteger numberOfSyntaxWords;
@property (readonly, nonatomic) NSUInteger maxNumberOfSyntaxWords;
@property (readonly, nonatomic) NSUInteger * syntaxWordOff7s;
@property (readonly, nonatomic) NSUInteger * syntaxWordLengths;
@property (readonly, nonatomic) NSUInteger * syntaxWordEnds;
@property (readonly, nonatomic) NSUInteger * syntaxWordModes;
#endif
- (void) testCase_init0
{
    iTM2ModeLine * ML = [iTM2ModeLine modeLine];
    STAssertTrue(ML.startOff7==ZER0,@"MISSED",nil);
    ML.startOff7 = 123987;
    STAssertTrue(ML.startOff7==123987,@"MISSED",nil);
    STAssertTrue(ML.commentedLength==ZER0,@"MISSED",nil);
    STAssertTrue(ML.commentOff7==123987,@"MISSED",nil);
    STAssertTrue(ML.length==ZER0,@"MISSED",nil);
    STAssertTrue(ML.uncommentedLength==ZER0,@"MISSED",nil);
    STAssertTrue(ML.contentsLength==ZER0,@"MISSED",nil);
    STAssertTrue(ML.EOLLength==ZER0,@"MISSED",nil);
    STAssertTrue(ML.previousMode==kiTM2TextOuterDefaultSyntaxMode,@"MISSED",nil);
    ML.previousMode = 46803;
    STAssertTrue(ML.previousMode==(46803|kiTM2TextEndOfLineSyntaxMask),@"MISSED",nil);
    STAssertTrue(ML.EOLMode==kiTM2TextOuterDefaultSyntaxMode,@"MISSED",nil);
    ML.EOLMode = 3862351;
    STAssertTrue(ML.EOLMode==(3862351|kiTM2TextEndOfLineSyntaxMask),@"MISSED",nil);
    STAssertTrue(ML.numberOfSyntaxWords==ZER0,@"MISSED",nil);
    STAssertTrue(ML.maxNumberOfSyntaxWords==16,@"MISSED",nil);
    STAssertTrue([ML syntaxModeAtIndex:ZER0]==ML.EOLMode,@"MISSED",nil);
    STAssertTrue([ML syntaxLengthAtIndex:ZER0]==ZER0,@"MISSED",nil);
    STAssertTrue([ML syntaxModeAtIndex:1]==ML.EOLMode,@"MISSED",nil);
    STAssertTrue([ML syntaxLengthAtIndex:1]==ZER0,@"MISSED",nil);
    NSUInteger mode = 123456;
    NSRange R = iTM3MakeRange(123,456);
    NSUInteger status = ZER0;
    // undefined behaviour STAssertTrue(iTM3EqualRanges(R, iTM3MakeRange(ZER0,ML.startOff7)),@"MISSED",nil);
    status = [ML getSyntaxMode:&mode atGlobalLocation:ZER0 longestRange:&R];
    NSLog(@"status:%lu",status);
    NSLog(@"mode:%lu",mode);
    NSLog(@"R:%@",NSStringFromRange(R));
    STAssertTrue(kiTM2TextOutOfRangeSyntaxStatus==status,@"MISSED",nil);
    STAssertTrue(mode == ML.previousMode,@"MISSED",nil);
    R = iTM3MakeRange(123,456);
    R = [ML longestRangeAtGlobalLocation:ZER0 mask:ZER0];
    NSLog(@"R:%@",NSStringFromRange(R));
    STAssertTrue(iTM3EqualRanges(R, iTM3MakeRange(NSNotFound,ZER0)),@"MISSED",nil);
}
- (void) testCase_initWithString;
{
    NSUInteger cursor = ZER0;
    iTM2ModeLine * MLZERO = [iTM2ModeLine modeLine];
    iTM2ModeLine * ML = nil;
    NSString * S = @"";
    ML = [[iTM2ModeLine alloc] initWithString:S atCursor:&cursor];
    STAssertTrue([ML isEqualToModeLine:MLZERO],@"MISSED",nil);
#   define TEST(_ML,__startOff7,__commentOff7,__contentsEndOff7,__endOff7,__EOLLength,__previousMode,__EOLMode) STAssertTrue(\
        _ML.startOff7 == __startOff7 && \
        _ML.commentOff7 == __commentOff7 && \
        _ML.contentsEndOff7 == __contentsEndOff7 && \
        _ML.endOff7 == __endOff7 && \
        _ML.EOLLength == __EOLLength && \
        _ML.previousMode == __previousMode && \
        _ML.EOLMode == __EOLMode \
            ,@"MISSED",nil)
    TEST(ML,ZER0,ZER0,ZER0,ZER0,ZER0,kiTM2TextOuterDefaultSyntaxMode,kiTM2TextOuterDefaultSyntaxMode);
    S = @"123";
    ML = [[iTM2ModeLine alloc] initWithString:S atCursor:&cursor];
    [ML describe];
    STAssertTrue(cursor==3,@"MISSED",nil);
    TEST(ML,ZER0,3,3,3,ZER0,kiTM2TextOuterDefaultSyntaxMode,kiTM2TextOuterDefaultSyntaxMode);
    cursor = ZER0;
    S = @"123\r";
    ML = [[iTM2ModeLine alloc] initWithString:S atCursor:&cursor];
    [ML describe];
    STAssertTrue(cursor==4,@"MISSED",nil);
    TEST(ML,ZER0,3,3,4,1,kiTM2TextOuterDefaultSyntaxMode,kiTM2TextOuterDefaultSyntaxMode);
    cursor = ZER0;
    S = @"123\r\n";
    ML = [[iTM2ModeLine alloc] initWithString:S atCursor:&cursor];
    [ML describe];
    STAssertTrue(cursor==5,@"MISSED",nil);
    TEST(ML,ZER0,3,3,5,2,kiTM2TextOuterDefaultSyntaxMode,kiTM2TextOuterDefaultSyntaxMode);
    cursor = 2;
    S = @"123\r\n";
    ML = [[iTM2ModeLine alloc] initWithString:S atCursor:&cursor];
    [ML describe];
    STAssertTrue(cursor==5,@"MISSED",nil);
    TEST(ML,2,3,3,5,2,kiTM2TextOuterDefaultSyntaxMode,kiTM2TextOuterDefaultSyntaxMode);
    cursor = 5;
    S = @"123\r\n345\n789";
    ML = [[iTM2ModeLine alloc] initWithString:S atCursor:&cursor];
    [ML describe];
    STAssertTrue(cursor==9,@"MISSED",nil);
    TEST(ML,5,8,8,9,1,kiTM2TextOuterDefaultSyntaxMode,kiTM2TextOuterDefaultSyntaxMode);
    
}
- (void) testCase_iTM3Range_methods;
{
    //  There was a problem with cocoa implementation
    NSRange R1, R2, R3;
    R1 = iTM3MakeRange(10,NSUIntegerMax);
    R2 = iTM3MakeRange(ZER0,NSUIntegerMax);
    R3 = iTM3IntersectionRange(R1,R2);
    STAssertTrue(iTM3EqualRanges(R1,R3),@"MISSED",nil);
    R1 = iTM3MakeRange(10,10);
    R2 = iTM3MakeRange(ZER0,NSUIntegerMax);
    R3 = iTM3IntersectionRange(R1,R2);
    STAssertTrue(iTM3EqualRanges(R1,R3),@"MISSED",nil);
    R1 = iTM3MakeRange(10,10);
    R2 = iTM3MakeRange(10,NSUIntegerMax);
    R3 = iTM3IntersectionRange(R1,R2);
    STAssertTrue(iTM3EqualRanges(R1,R3),@"MISSED",nil);
    R1 = iTM3MakeRange(10,10);
    R2 = iTM3MakeRange(10,NSUIntegerMax-10);
    R3 = iTM3IntersectionRange(R1,R2);
    STAssertTrue(iTM3EqualRanges(R1,R3),@"MISSED",nil);
}
- (void) testCase_NSRange_methods;
{
    //  There was a problem with cocoa implementation
    NSRange R1, R2, R3, R4;
    R1 = NSMakeRange(10,NSUIntegerMax);
    R2 = NSMakeRange(ZER0,NSUIntegerMax);
    R3 = NSIntersectionRange(R1,R2);
    R4 = NSMakeRange(10,NSUIntegerMax-10);
    STAssertFalse(NSEqualRanges(R3,R4),@"COCOA IS FIXED)!",nil);// test failed
    R1 = NSMakeRange(10,NSUIntegerMax);
    R2 = NSMakeRange(ZER0,NSUIntegerMax);
    R3 = NSIntersectionRange(R1,R2);
    R4 = NSMakeRange(10,NSUIntegerMax);
    STAssertTrue(NSEqualRanges(R3,R4),@"COCOA IS FIXED)!",nil);// test failed
    R1 = NSMakeRange(10,10);
    R2 = NSMakeRange(ZER0,NSUIntegerMax);
    R3 = NSIntersectionRange(R1,R2);
    R4 = R1;
    STAssertTrue(NSEqualRanges(R3,R4),@"MISSED",nil);
    R1 = NSMakeRange(10,10);
    R2 = NSMakeRange(10,NSUIntegerMax);
    R3 = NSIntersectionRange(R1,R2);
    R4 = R1;
    STAssertFalse(NSEqualRanges(R3,R4),@"COCOA IS FIXED)!",nil);// test failed
    R1 = NSMakeRange(10,10);
    R2 = NSMakeRange(10,NSUIntegerMax-10);
    R3 = NSIntersectionRange(R1,R2);
    R4 = R1;
    STAssertTrue(NSEqualRanges(R3,R4),@"MISSED",nil);
}
- (void) testCase_validate_range;
{
    NSError * ROR = nil;
    iTM2ModeLine * ML = [iTM2ModeLine modeLine];
#   undef TEST
#   define TEST(_ML,__startOff7,__commentOff7,__contentsEndOff7,__endOff7,__EOLLength,__previousMode,__EOLMode) STAssertTrue(\
        _ML.startOff7 == __startOff7 && \
        _ML.commentOff7 == __commentOff7 && \
        _ML.contentsEndOff7 == __contentsEndOff7 && \
        _ML.endOff7 == __endOff7 && \
        _ML.EOLLength == __EOLLength && \
        _ML.previousMode == __previousMode && \
        _ML.EOLMode == __EOLMode \
            ,@"MISSED",nil)
    TEST(ML,ZER0,ZER0,ZER0,ZER0,ZER0,kiTM2TextOuterDefaultSyntaxMode,kiTM2TextOuterDefaultSyntaxMode);
    ML.startOff7 = 9999;
    [ML appendNormalSyntaxMode:123123 length:1000 error:self.RORef4iTM3];
    STAssertNil(ROR,@"MISSED",nil);
    STAssertTrue(ML.isConsistent,@"MISSED",nil);
    ML.describe;
    TEST(ML,9999,10999,10999,10999,ZER0,kiTM2TextOuterDefaultSyntaxMode,kiTM2TextOuterDefaultSyntaxMode);
#   define TEST_INVALID_LOCAL_RANGE(_ML,_LOCATION,_LENGTH) do {\
        BOOL yorn = iTM3EqualRanges(\
            iTM3IntersectionRange(_ML.invalidLocalRange,iTM3MakeRange(ZER0,_ML.length)),\
            iTM3IntersectionRange(iTM3MakeRange(_LOCATION,_LENGTH),iTM3MakeRange(ZER0,_ML.length))\
                );\
        STAssertTrue(yorn || (!(_LENGTH) &&!_ML.invalidLocalRange.length),@"MISSED",nil);\
        } while (NO);
#   define TEST_INVALID_GLOBAL_RANGE(_ML,_LOCATION,_LENGTH) do {\
            NSRange R1 = iTM3MakeRange(_ML.startOff7,_ML.length);\
            NSRange R2 = iTM3IntersectionRange(_ML.invalidGlobalRange,R1);\
            NSLog(@"iTM3MakeRange(_ML.startOff7,_ML.length):%@",NSStringFromRange(iTM3MakeRange(_ML.startOff7,_ML.length)));\
            NSLog(@"_ML.invalidGlobalRange:%@",NSStringFromRange(_ML.invalidGlobalRange));\
            NSLog(@"iTM3IntersectionRange(_ML.invalidGlobalRange,iTM3MakeRange(_ML.startOff7,_ML.length)):%@",NSStringFromRange(iTM3IntersectionRange(_ML.invalidGlobalRange,iTM3MakeRange(_ML.startOff7,_ML.length))));\
            NSRange R3 = iTM3MakeRange(_LOCATION,_LENGTH);\
            NSRange R4 = iTM3IntersectionRange(R3,R1);\
            NSLog(@"R1:%@,\nR2:%@,\nR3:%@,\nR4:%@",NSStringFromRange(R1),NSStringFromRange(R2),NSStringFromRange(R3),NSStringFromRange(R4));\
            STAssertTrue(iTM3EqualRanges(R2,R4) || (!(_LENGTH) &&!_ML.invalidGlobalRange.length),@"MISSED",nil);\
        } while (NO);
    TEST_INVALID_LOCAL_RANGE(ML,ML.length,ZER0);
    TEST_INVALID_GLOBAL_RANGE(ML,ML.endOff7,ZER0);
    [ML validateLocalRange:iTM3MakeRange(10000,1)];
    ML.describe;
    TEST_INVALID_LOCAL_RANGE(ML,ML.length,ZER0);
    TEST_INVALID_GLOBAL_RANGE(ML,ML.endOff7,ZER0);
    [ML validateLocalRange:iTM3MakeRange(1000,ZER0)];
    ML.describe;
    TEST_INVALID_LOCAL_RANGE(ML,ML.length,ZER0);
    TEST_INVALID_GLOBAL_RANGE(ML,ML.endOff7,ZER0);
    [ML validateLocalRange:iTM3MakeRange(ML.length,10)];
    ML.describe;
    TEST_INVALID_LOCAL_RANGE(ML,ML.length,ZER0);
    TEST_INVALID_GLOBAL_RANGE(ML,ML.endOff7,ZER0);
    [ML validateLocalRange:iTM3MakeRange(ML.length-1,ZER0)];
    ML.describe;
    TEST_INVALID_LOCAL_RANGE(ML,ML.length,ZER0);
    TEST_INVALID_GLOBAL_RANGE(ML,ML.endOff7,ZER0);
    [ML validateLocalRange:iTM3MakeRange(999,1)];
    NSLog(@"[ML validateLocalRange:iTM3MakeRange(999,1)]");
    ML.describe;
    TEST_INVALID_LOCAL_RANGE(ML,ML.length,ZER0);
    TEST_INVALID_GLOBAL_RANGE(ML,ML.endOff7,ZER0);
    [ML validateLocalRange:iTM3MakeRange(998,10)];
    NSLog(@"[ML validateLocalRange:iTM3MakeRange(998,10)]");
    ML.describe;
    TEST_INVALID_LOCAL_RANGE(ML,ML.length,ZER0);
    TEST_INVALID_GLOBAL_RANGE(ML,ML.endOff7,ZER0);
    [ML validateLocalRange:iTM3MakeRange(100,10)];
    NSLog(@"[ML validateLocalRange:iTM3MakeRange(100,10)]");
    ML.describe;
    TEST_INVALID_LOCAL_RANGE(ML,110,ZER0);
    TEST_INVALID_GLOBAL_RANGE(ML,ML.startOff7+110,ZER0);
    [ML validateLocalRange:iTM3MakeRange(ZER0,10)];
    NSLog(@"[ML validateLocalRange:iTM3MakeRange(ZER0,10)]");
    ML.describe;
    TEST_INVALID_LOCAL_RANGE(ML,ML.length,ZER0);
    TEST_INVALID_GLOBAL_RANGE(ML,ML.endOff7,ZER0);
    [ML validateLocalRange:iTM3MakeRange(ZER0,20)];
    NSLog(@"[ML validateLocalRange:iTM3MakeRange(ZER0,20)]");
    ML.describe;
    TEST_INVALID_LOCAL_RANGE(ML,ML.length,ZER0);
    TEST_INVALID_GLOBAL_RANGE(ML,ML.endOff7,ZER0);
    [ML validateLocalRange:iTM3MakeRange(21,100)];
    NSLog(@"[ML validateLocalRange:iTM3MakeRange(21,100)]");
    ML.describe;
    TEST_INVALID_LOCAL_RANGE(ML,ML.length,ZER0);
    TEST_INVALID_GLOBAL_RANGE(ML,ML.endOff7,ZER0);
    [ML validateLocalRange:iTM3MakeRange(20,978)];
    NSLog(@"[ML validateLocalRange:iTM3MakeRange(20,978)]");
    ML.describe;
    TEST_INVALID_LOCAL_RANGE(ML,ML.length,ZER0);
    TEST_INVALID_GLOBAL_RANGE(ML,ML.endOff7,ZER0);
    [ML invalidateLocalRange:iTM3MakeRange(100,100)];
    NSLog(@"[ML invalidateLocalRange:iTM3MakeRange(100,100)]");
    ML.describe;
    TEST_INVALID_LOCAL_RANGE(ML,98,102);
    TEST_INVALID_GLOBAL_RANGE(ML,ML.startOff7+98,102);
    [ML invalidateLocalRange:iTM3MakeRange(10,10)];
    NSLog(@"[ML invalidateLocalRange:iTM3MakeRange(10,10)]");
    ML.describe;
    TEST_INVALID_LOCAL_RANGE(ML,8,192);
    TEST_INVALID_GLOBAL_RANGE(ML,ML.startOff7+8,192);
    [ML invalidateLocalRange:iTM3MakeRange(500,10)];
    NSLog(@"[ML invalidateLocalRange:iTM3MakeRange(500,10)]");
    ML.describe;
    TEST_INVALID_LOCAL_RANGE(ML,8,502);
    TEST_INVALID_GLOBAL_RANGE(ML,ML.startOff7+8,502);
    [ML invalidateLocalRange:iTM3MakeRange(200,1000)];
    NSLog(@"[ML invalidateLocalRange:iTM3MakeRange(200,1000)]");
    ML.describe;
    TEST_INVALID_LOCAL_RANGE(ML,8,992);
    TEST_INVALID_GLOBAL_RANGE(ML,ML.startOff7+8,992);
    [ML invalidateLocalRange:iTM3MakeRange(1,ZER0)];
    NSLog(@"[ML invalidateLocalRange:iTM3MakeRange(1,ZER0)]");
    ML.describe;
    TEST_INVALID_LOCAL_RANGE(ML,8,992);
    TEST_INVALID_GLOBAL_RANGE(ML,ML.startOff7+8,992);
    [ML invalidateLocalRange:iTM3MakeRange(1,1)];
    NSLog(@"[ML invalidateLocalRange:iTM3MakeRange(1,1)]");
    ML.describe;
    TEST_INVALID_LOCAL_RANGE(ML,ZER0,1000);
    TEST_INVALID_GLOBAL_RANGE(ML,ML.startOff7+ZER0,1000);
    //  I am extremely lazy, no test for the global version of the validate method.
}
- (void) testCase_swapContentsWithModeLine
{
    NSError * ROR = nil;
    iTM2ModeLine * ML1 = [iTM2ModeLine modeLine];
    iTM2ModeLine * ML2 = [iTM2ModeLine modeLine];
    iTM2ModeLine * ML3 = [iTM2ModeLine modeLine];
    iTM2ModeLine * ML4 = [iTM2ModeLine modeLine];
    [ML1 appendSyntaxMode:100 length:100 error:self.RORef4iTM3];
    STAssertNil(ROR,@"MISSED");
    [ML2 appendSyntaxMode:100 length:100 error:self.RORef4iTM3];
    STAssertNil(ROR,@"MISSED");
    [ML1 appendSyntaxMode:200 length:200 error:self.RORef4iTM3];
    STAssertNil(ROR,@"MISSED");
    [ML2 appendSyntaxMode:200 length:200 error:self.RORef4iTM3];
    STAssertNil(ROR,@"MISSED");
    STAssertTrue([ML1 isEqualToModeLine:ML2],@"MISSED",nil);
    STAssertTrue([ML3 isEqualToModeLine:ML4],@"MISSED",nil);
    [ML1 swapContentsWithModeLine:ML3];
    STAssertTrue([ML3 isEqualToModeLine:ML2],@"MISSED",nil);
    STAssertTrue([ML1 isEqualToModeLine:ML4],@"MISSED",nil);
#define UI NSUInteger
    [ML1 appendSyntaxModesAndLengths:(UI)300,(UI)300,(UI)400,(UI)400,(UI)500,(UI)500,ZER0,ZER0];
    [ML4 appendSyntaxModesAndLengths:(UI)300,(UI)300,(UI)400,(UI)400,(UI)500,(UI)500,ZER0,ZER0];
    [ML1 appendSyntaxModesAndLengths:(UI)300,(UI)300,(UI)400,(UI)400,(UI)500,(UI)500,ZER0,ZER0];
    [ML4 appendSyntaxModesAndLengths:(UI)300,(UI)300,(UI)400,(UI)400,(UI)500,(UI)500,ZER0,ZER0];
    [ML1 appendSyntaxModesAndLengths:(UI)300,(UI)300,(UI)400,(UI)400,(UI)500,(UI)500,ZER0,ZER0];
    [ML4 appendSyntaxModesAndLengths:(UI)300,(UI)300,(UI)400,(UI)400,(UI)500,(UI)500,ZER0,ZER0];
    [ML1 appendSyntaxModesAndLengths:(UI)300,(UI)300,(UI)400,(UI)400,(UI)500,(UI)500,ZER0,ZER0];
    [ML4 appendSyntaxModesAndLengths:(UI)300,(UI)300,(UI)400,(UI)400,(UI)500,(UI)500,ZER0,ZER0];
    [ML1 appendSyntaxModesAndLengths:(UI)300,(UI)300,(UI)400,(UI)400,(UI)500,(UI)500,ZER0,ZER0];
    [ML4 appendSyntaxModesAndLengths:(UI)300,(UI)300,(UI)400,(UI)400,(UI)500,(UI)500,ZER0,ZER0];
    [ML1 appendSyntaxModesAndLengths:(UI)300,(UI)300,(UI)400,(UI)400,(UI)500,(UI)500,ZER0,ZER0];
    [ML4 appendSyntaxModesAndLengths:(UI)300,(UI)300,(UI)400,(UI)400,(UI)500,(UI)500,ZER0,ZER0];
    [ML1 appendSyntaxModesAndLengths:(UI)300,(UI)300,(UI)400,(UI)400,(UI)500,(UI)500,ZER0,ZER0];
    [ML4 appendSyntaxModesAndLengths:(UI)300,(UI)300,(UI)400,(UI)400,(UI)500,(UI)500,ZER0,ZER0];
    STAssertTrue([ML3 isEqualToModeLine:ML2],@"MISSED",nil);
    STAssertTrue([ML1 isEqualToModeLine:ML4],@"MISSED",nil);
    [ML1 swapContentsWithModeLine:ML3];
    STAssertTrue([ML1 isEqualToModeLine:ML2],@"MISSED",nil);
    STAssertTrue([ML3 isEqualToModeLine:ML4],@"MISSED",nil);
}
- (void) testCase_removeLastMode
{
    iTM2ModeLine * ML1 = [iTM2ModeLine modeLine];
    iTM2ModeLine * ML2 = [iTM2ModeLine modeLine];
    [ML1 appendSyntaxMode:100 length:100 error:self.RORef4iTM3];
#   define ROR (*self.RORef4iTM3)
    STAssertNil(ROR,@"MISSED");
    [ML2 appendSyntaxMode:100 length:100 error:self.RORef4iTM3];
    STAssertNil(ROR,@"MISSED");
    STAssertTrue([ML1 isEqualToModeLine:ML2],@"MISSED",nil);
    [ML1 appendSyntaxMode:200 length:200 error:self.RORef4iTM3];
    STAssertNil(ROR,@"MISSED");
    [ML1 removeLastMode];
    STAssertTrue([ML1 isEqualToModeLine:ML2],@"MISSED",nil);
    [ML1 appendSyntaxMode:200 length:200 error:self.RORef4iTM3];
    STAssertNil(ROR,@"MISSED");
    [ML1 appendSyntaxMode:200 length:300 error:self.RORef4iTM3];
    STAssertNil(ROR,@"MISSED");
    [ML1 removeLastMode];
    STAssertTrue([ML1 isEqualToModeLine:ML2],@"MISSED",nil);
}
- (void) testCase_deleteModes
{
    iTM2ModeLine * ML1 = nil;
    iTM2ModeLine * ML2 = nil;
    ML1 = [iTM2ModeLine modeLine];
    ML2 = [iTM2ModeLine modeLine];
    STAssertTrue(([ML2 appendSyntaxMode:100 length:100 error:self.RORef4iTM3]),@"MISSED",NULL);// 100(100)
    STAssertTrue(([ML1 appendSyntaxModesAndLengths:(UI)100,(UI)50,(UI)100,(UI)50,ZER0,ZER0]),@"MISSED",NULL);
#   define TEST_YES(CONTENTS,EOL)\
    STAssertTrue([ML1 isEqualToModeLine:ML2]||([ML1 describe],[ML2 describe],NO),@"MISSED",nil)
    TEST_YES(100,ZER0);
    [ML1 appendSyntaxMode:100 length:100 error:self.RORef4iTM3];
    [ML1 deleteModesInGlobalMakeRange:50:100 error:self.RORef4iTM3];
    TEST_YES(100,ZER0);
    [ML1 appendSyntaxMode:100 length:100 error:self.RORef4iTM3];
    [ML1 deleteModesInGlobalMakeRange:ZER0:100 error:self.RORef4iTM3];
    TEST_YES(100,ZER0);
    [ML1 appendSyntaxMode:100 length:100 error:self.RORef4iTM3];
    [ML1 deleteModesInGlobalMakeRange:100:100 error:self.RORef4iTM3];
    TEST_YES(100,ZER0);
    [ML2 appendSyntaxMode:200 length:100 error:self.RORef4iTM3];// 100(100) + 100(200)
    [ML1 appendSyntaxMode:200 length:200 error:self.RORef4iTM3];
    [ML1 deleteModesInGlobalMakeRange:150:100 error:self.RORef4iTM3];
    TEST_YES(200,ZER0);
    [ML1 appendSyntaxMode:200 length:100 error:self.RORef4iTM3];
    [ML1 deleteModesInGlobalMakeRange:100:100 error:self.RORef4iTM3];
    TEST_YES(200,ZER0);
    [ML1 appendSyntaxMode:200 length:100 error:self.RORef4iTM3];
    [ML1 deleteModesInGlobalMakeRange:200:100 error:self.RORef4iTM3];
    TEST_YES(200,ZER0);
    [ML1 deleteModesInGlobalMakeRange:100:100 error:self.RORef4iTM3];
    [ML1 appendSyntaxMode:200 length:100 error:self.RORef4iTM3];
    TEST_YES(200,ZER0);
    [ML1 deleteModesInGlobalMakeRange:100:100 error:self.RORef4iTM3];
    [ML1 appendSyntaxModesAndLengths:(UI)100,(UI)100,(UI)200,(UI)100,ZER0,ZER0];
    [ML1 deleteModesInGlobalMakeRange:50:100 error:self.RORef4iTM3];
    TEST_YES(200,ZER0);
    [ML1 deleteModesInGlobalMakeRange:100:100 error:self.RORef4iTM3];
    [ML1 appendSyntaxModesAndLengths:(UI)100,(UI)100,(UI)200,(UI)100,ZER0,ZER0];
    [ML1 deleteModesInGlobalMakeRange:100:100 error:self.RORef4iTM3];
    TEST_YES(200,ZER0);
    [ML1 deleteModesInGlobalMakeRange:100:100 error:self.RORef4iTM3];
    [ML1 appendSyntaxModesAndLengths:(UI)100,(UI)100,(UI)200,(UI)100,ZER0,ZER0];
    [ML1 deleteModesInGlobalMakeRange:ZER0:100 error:self.RORef4iTM3];
    TEST_YES(200,ZER0);
    [ML1 deleteModesInGlobalMakeRange:100:100 error:self.RORef4iTM3];
    [ML1 appendSyntaxModesAndLengths:(UI)100,(UI)100,(UI)200,(UI)200,ZER0,ZER0];
    [ML1 deleteModesInGlobalMakeRange:100:200 error:self.RORef4iTM3];
    TEST_YES(200,ZER0);
    [ML1 deleteModesInGlobalMakeRange:ZER0:200 error:self.RORef4iTM3];ML1.describe;
    STAssertTrue(([ML1 appendSyntaxMode:100 length:50 error:self.RORef4iTM3]),@"MISSED",NULL);
    //[ML1 appendSyntaxModesAndLengths:(UI)100,(UI)50,(UI)300,(UI)100,(UI)100,(UI)50,(UI)200,(UI)100,ZER0,ZER0];ML1.describe;
    [ML1 appendSyntaxModesAndLengths:(UI)300,(UI)100,(UI)100,(UI)50,(UI)200,(UI)100,ZER0,ZER0];ML1.describe;
    [ML1 deleteModesInGlobalMakeRange:50:100 error:self.RORef4iTM3];ML1.describe;
    TEST_YES(200,ZER0);
    [ML1 deleteModesInGlobalMakeRange:ZER0:200 error:self.RORef4iTM3];
    STAssertTrue(([ML1 appendSyntaxMode:100 length:51 error:self.RORef4iTM3]),@"MISSED",NULL);
    //[ML1 appendSyntaxModesAndLengths:(UI)100,(UI)51,(UI)300,(UI)100,(UI)100,(UI)50,(UI)200,(UI)100,ZER0,ZER0];
    [ML1 appendSyntaxModesAndLengths:(UI)300,(UI)100,(UI)100,(UI)50,(UI)200,(UI)100,ZER0,ZER0];ML1.describe;
    [ML1 deleteModesInGlobalMakeRange:50:101 error:self.RORef4iTM3];
    TEST_YES(200,ZER0);
    [ML1 deleteModesInGlobalMakeRange:ZER0:200 error:self.RORef4iTM3];
    [ML1 appendSyntaxModesAndLengths:(UI)100,(UI)50,(UI)300,(UI)99,(UI)100,(UI)51,(UI)200,100,ZER0,ZER0];
    [ML1 deleteModesInGlobalMakeRange:50:100 error:self.RORef4iTM3];
    TEST_YES(200,ZER0);
    [ML1 deleteModesInGlobalMakeRange:ZER0:200 error:self.RORef4iTM3];
    [ML1 appendSyntaxModesAndLengths:(UI)100,(UI)50,(UI)300,(UI)100,(UI)400,(UI)100,(UI)100,(UI)50,(UI)200,100,ZER0,ZER0];
    [ML1 deleteModesInGlobalMakeRange:50:200 error:self.RORef4iTM3];
    TEST_YES(200,ZER0);
    [ML1 deleteModesInGlobalMakeRange:ZER0:200 error:self.RORef4iTM3];
    [ML1 appendSyntaxModesAndLengths:(UI)100,(UI)51,(UI)300,(UI)100,(UI)400,(UI)100,(UI)100,(UI)50,(UI)200,(UI)100,ZER0,ZER0];
    [ML1 deleteModesInGlobalMakeRange:50:201 error:self.RORef4iTM3];
    TEST_YES(200,ZER0);
    [ML1 deleteModesInGlobalMakeRange:ZER0:200 error:self.RORef4iTM3];
    [ML1 appendSyntaxModesAndLengths:(UI)100,(UI)50,(UI)300,(UI)100,(UI)400,(UI)100,(UI)100,(UI)51,(UI)200,(UI)100,ZER0,ZER0];
    [ML1 deleteModesInGlobalMakeRange:50:201 error:self.RORef4iTM3];
    TEST_YES(200,ZER0);
    [ML1 deleteModesInGlobalMakeRange:ZER0:200 error:self.RORef4iTM3];
    [ML1 appendSyntaxModesAndLengths:(UI)100,(UI)50,(UI)300,(UI)50,(UI)100,(UI)100,(UI)200,(UI)100,ZER0,ZER0];
    [ML1 deleteModesInGlobalMakeRange:ZER0:100 error:self.RORef4iTM3];
    TEST_YES(200,ZER0);
    [ML1 deleteModesInGlobalMakeRange:ZER0:200 error:self.RORef4iTM3];
    [ML1 appendSyntaxModesAndLengths:(UI)100,(UI)99,(UI)100,(UI)101,(UI)200,(UI)100,ZER0,ZER0];
    [ML1 deleteModesInGlobalMakeRange:ZER0:100 error:self.RORef4iTM3];
    TEST_YES(200,ZER0);
    [ML1 deleteModesInGlobalMakeRange:ZER0:200 error:self.RORef4iTM3];
    [ML1 appendSyntaxModesAndLengths:(UI)100,(UI)50,(UI)300,(UI)49,(UI)100,(UI)101,(UI)200,(UI)100,ZER0,ZER0];
    [ML1 deleteModesInGlobalMakeRange:ZER0:100 error:self.RORef4iTM3];
    TEST_YES(200,ZER0);
    [ML1 deleteModesInGlobalMakeRange:ZER0:200 error:self.RORef4iTM3];
    [ML1 appendSyntaxModesAndLengths:(UI)100,(UI)100,(UI)300,(UI)99,(UI)200,(UI)101,ZER0,ZER0];
    [ML1 deleteModesInGlobalMakeRange:100:100 error:self.RORef4iTM3];
    TEST_YES(200,ZER0);
    //  Tests with EOL
    [ML2 deleteModesInGlobalMakeRange:ZER0:200 error:self.RORef4iTM3];
    ML1 = [[iTM2ModeLine alloc] initWithString:@"\r\n" atCursor:nil];
    ML1.EOLMode = 421;
    [ML1 deleteModesInGlobalMakeRange:ZER0:2 error:self.RORef4iTM3];
    TEST_YES(ZER0,ZER0);
    ML2 = [iTM2ModeLine modeLine];
    ML1 = [[iTM2ModeLine alloc] initWithString:@"\r\n" atCursor:nil];
    ML1.EOLMode = 421;
    [ML1 describe];
    [ML1 deleteModesInGlobalMakeRange:ZER0:2 error:self.RORef4iTM3];
    TEST_YES(ZER0,ZER0);
    ML1 = [[iTM2ModeLine alloc] initWithString:@"\r\n" atCursor:nil];
    ML1.EOLMode = 421;
    [ML1 describe];
    [ML1 deleteModesInGlobalMakeRange:ZER0:10 error:self.RORef4iTM3];
    TEST_YES(ZER0,ZER0);
    ML2 = [[iTM2ModeLine alloc] initWithString:@"\r" atCursor:nil];
    ML2.EOLMode = 421;
    ML1 = [[iTM2ModeLine alloc] initWithString:@"\r\n" atCursor:nil];
    ML1.EOLMode = 421;
    [ML1 describe];
    [ML1 deleteModesInGlobalMakeRange:ZER0:1 error:self.RORef4iTM3];
    TEST_YES(ZER0,ZER0);
    ML1 = [[iTM2ModeLine alloc] initWithString:@"\r\n" atCursor:nil];
    ML1.EOLMode = 421;
    [ML1 describe];
    [ML1 deleteModesInGlobalMakeRange:1:1 error:self.RORef4iTM3];
    TEST_YES(ZER0,ZER0);
    ML1 = [[iTM2ModeLine alloc] initWithString:@"\r\n" atCursor:nil];
    ML1.EOLMode = 421;
    [ML1 describe];
    [ML1 deleteModesInGlobalMakeRange:1:10 error:self.RORef4iTM3];
    TEST_YES(ZER0,ZER0);
    [ML2 appendSyntaxModesAndLengths:(UI)100,(UI)100,(UI)200,(UI)100,ZER0,ZER0];
    ML1 = [[iTM2ModeLine alloc] initWithString:@"\r\n" atCursor:nil];
    ML1.EOLMode = 421;
    [ML1 appendSyntaxModesAndLengths:(UI)100,(UI)100,(UI)200,(UI)200,ZER0,ZER0];
    [ML1 deleteModesInGlobalMakeRange:200:101 error:self.RORef4iTM3];
    TEST_YES(ZER0,ZER0);
    ML2 = [iTM2ModeLine modeLine];
    [ML2 appendSyntaxModesAndLengths:(UI)100,(UI)100,(UI)200,(UI)100,ZER0,ZER0];
    ML1 = [[iTM2ModeLine alloc] initWithString:@"\r\n" atCursor:nil];
    ML1.EOLMode = 421;
    [ML1 appendSyntaxModesAndLengths:(UI)100,(UI)100,(UI)200,(UI)200,ZER0,ZER0];
    [ML1 deleteModesInGlobalMakeRange:200:200 error:self.RORef4iTM3];
    TEST_YES(ZER0,ZER0);
    ML1 = [[iTM2ModeLine alloc] initWithString:@"\r\n" atCursor:nil];
    ML1.EOLMode = 421;
    [ML1 appendSyntaxModesAndLengths:(UI)100,(UI)100,(UI)200,(UI)200,ZER0,ZER0];
    [ML1 deleteModesInGlobalMakeRange:200:102 error:self.RORef4iTM3];
    TEST_YES(ZER0,ZER0);
#   undef TEST_YES
    return;
}
- (void) testCase_enlargeSyntaxModeAtGlobalLocation
{
    iTM2ModeLine * ML2 = [iTM2ModeLine modeLine];
    [ML2 appendSyntaxMode:kiTM2TextUnknownSyntaxMode length:100 error:self.RORef4iTM3];
    ML2.startOff7 = 1000;
    STAssertTrue(ML2.isConsistent && ([ML2 describe],YES),@"MISSED",nil);
    iTM2ModeLine * ML1 = [iTM2ModeLine modeLine];
    ML1.startOff7 = 900;
    STAssertTrue(ML1.startOff7 == 900,@"MISSED",nil);
    STAssertTrue(ML1.isConsistent && ([ML1 describe],YES),@"MISSED",nil);
    STAssertTrue([ML1 enlargeSyntaxModeAtGlobalLocation:1 length:100 error:self.RORef4iTM3] || ([ML1 describe],NO),@"MISSED",nil);
    STAssertFalse([ML1 enlargeSyntaxModeAtGlobalLocation:1001 length:100 error:self.RORef4iTM3] && ([ML1 describe],YES),@"MISSED",nil);
    STAssertTrue(ML1.isConsistent && ([ML1 describe],YES),@"MISSED",nil);
    STAssertTrue([ML1 enlargeSyntaxModeAtGlobalLocation:1000 length:100 error:self.RORef4iTM3] || ([ML1 describe],NO),@"MISSED",nil);
    [[NSGarbageCollector defaultCollector] collectExhaustively];
    STAssertTrue(ML1.isConsistent && ([ML1 describe],YES),@"MISSED",nil);
    STAssertTrue([ML1 isEqualToModeLine:ML2]||([ML1 describe],[ML2 describe],NO),@"MISSED",nil);
    STAssertTrue(ML1.isConsistent && ([ML1 describe],YES),@"MISSED",nil);
    ML2 = [iTM2ModeLine modeLine];
    [ML2 appendSyntaxModesAndLengths:(UI)100,(UI)100,(UI)200,(UI)200,(UI)300,(UI)300,ZER0,ZER0];
    ML1 = [iTM2ModeLine modeLine];
    ML1.describe;
    [ML1 appendSyntaxModesAndLengths:(UI)100,(UI)50,(UI)200,(UI)200,(UI)300,(UI)300,ZER0,ZER0];
    STAssertTrue([ML1 enlargeSyntaxModeAtGlobalLocation:ZER0 length:50 error:self.RORef4iTM3] || ([ML1 describe],NO),@"MISSED",nil);
    STAssertTrue([ML1 isEqualToModeLine:ML2]||([ML1 describe],[ML2 describe],NO),@"MISSED",nil);
    ML1 = [iTM2ModeLine modeLine];
    ML1.describe;
    [ML1 appendSyntaxModesAndLengths:(UI)100,(UI)50,(UI)200,(UI)200,(UI)300,(UI)300,ZER0,ZER0];
    STAssertTrue([ML1 enlargeSyntaxModeAtGlobalLocation:25 length:50 error:self.RORef4iTM3] || ([ML1 describe],NO),@"MISSED",nil);
    STAssertTrue([ML1 isEqualToModeLine:ML2]||([ML1 describe],[ML2 describe],NO),@"MISSED",nil);
    ML1 = [iTM2ModeLine modeLine];
    ML1.describe;
    [ML1 appendSyntaxModesAndLengths:(UI)100,(UI)50,(UI)200,(UI)200,(UI)300,(UI)300,ZER0,ZER0];
    STAssertTrue([ML1 enlargeSyntaxModeAtGlobalLocation:50 length:50 error:self.RORef4iTM3] || ([ML1 describe],NO),@"MISSED",nil);
    STAssertTrue([ML1 isEqualToModeLine:ML2]||([ML1 describe],[ML2 describe],NO),@"MISSED",nil);
    ML1 = [iTM2ModeLine modeLine];
    ML1.describe;
    [ML1 appendSyntaxModesAndLengths:(UI)100,(UI)100,(UI)200,(UI)100,(UI)300,(UI)300,ZER0,ZER0];
    STAssertTrue([ML1 enlargeSyntaxModeAtGlobalLocation:101 length:100 error:self.RORef4iTM3] || ([ML1 describe],NO),@"MISSED",nil);
    STAssertTrue([ML1 isEqualToModeLine:ML2]||([ML1 describe],[ML2 describe],NO),@"MISSED",nil);
    ML1 = [iTM2ModeLine modeLine];
    ML1.describe;
    [ML1 appendSyntaxModesAndLengths:(UI)100,(UI)100,(UI)200,(UI)100,(UI)300,(UI)300,ZER0,ZER0];
    STAssertTrue([ML1 enlargeSyntaxModeAtGlobalLocation:150 length:100 error:self.RORef4iTM3] || ([ML1 describe],NO),@"MISSED",nil);
    STAssertTrue([ML1 isEqualToModeLine:ML2]||([ML1 describe],[ML2 describe],NO),@"MISSED",nil);
    ML1 = [iTM2ModeLine modeLine];
    ML1.describe;
    [ML1 appendSyntaxModesAndLengths:(UI)100,(UI)100,(UI)200,(UI)100,(UI)300,(UI)300,ZER0,ZER0];
    STAssertTrue([ML1 enlargeSyntaxModeAtGlobalLocation:200 length:100 error:self.RORef4iTM3] || ([ML1 describe],NO),@"MISSED",nil);
    STAssertTrue([ML1 isEqualToModeLine:ML2]||([ML1 describe],[ML2 describe],NO),@"MISSED",nil);
    ML1 = [iTM2ModeLine modeLine];
    ML1.describe;
    [ML1 appendSyntaxModesAndLengths:(UI)100,(UI)100,(UI)200,(UI)200,(UI)300,(UI)200,ZER0,ZER0];
    STAssertTrue([ML1 enlargeSyntaxModeAtGlobalLocation:301 length:100 error:self.RORef4iTM3] || ([ML1 describe],NO),@"MISSED",nil);
    STAssertTrue([ML1 isEqualToModeLine:ML2]||([ML1 describe],[ML2 describe],NO),@"MISSED",nil);
    ML1 = [iTM2ModeLine modeLine];
    ML1.describe;
    [ML1 appendSyntaxModesAndLengths:(UI)100,(UI)100,(UI)200,(UI)200,(UI)300,(UI)200,ZER0,ZER0];
    STAssertTrue([ML1 enlargeSyntaxModeAtGlobalLocation:350 length:100 error:self.RORef4iTM3] || ([ML1 describe],NO),@"MISSED",nil);
    STAssertTrue([ML1 isEqualToModeLine:ML2]||([ML1 describe],[ML2 describe],NO),@"MISSED",nil);
    ML1 = [iTM2ModeLine modeLine];
    ML1.describe;
    [ML1 appendSyntaxModesAndLengths:(UI)100,(UI)100,(UI)200,(UI)200,(UI)300,(UI)200,ZER0,ZER0];
    STAssertTrue([ML1 enlargeSyntaxModeAtGlobalLocation:400 length:100 error:self.RORef4iTM3] || ([ML1 describe],NO),@"MISSED",nil);
    STAssertTrue([ML1 isEqualToModeLine:ML2]||([ML1 describe],[ML2 describe],NO),@"MISSED",nil);
}
- (void) testCase_getSyntaxModeAtIndex;
{
    iTM2ModeLine * ML1 = [iTM2ModeLine modeLine];
    [ML1 appendSyntaxModesAndLengths:(UI)1,(UI)10,(UI)2,(UI)20,(UI)3,(UI)30,ZER0,ZER0];
    NSUInteger mode, status;
    NSRange R;
#   define TEST_S(WHERE,STATUS,MODE,LOCATION,LENGTH) \
    status = [ML1 getSyntaxMode:&mode atGlobalLocation:WHERE longestRange:&R];\
    STAssertTrue((STATUS==status)&&(mode==MODE)&&iTM3EqualRanges(R, iTM3MakeRange(LOCATION,LENGTH)) || (NSLog(@"status:%lu,mode:%lu,R:%@",status,mode,NSStringFromRange(R)),NO),@"MISSED",nil)
    TEST_S(ZER0,kiTM2TextNoErrorSyntaxStatus,1,ZER0,10);
    TEST_S(9,kiTM2TextNoErrorSyntaxStatus,1,ZER0,10);
    TEST_S(10,kiTM2TextNoErrorSyntaxStatus,2,10,20);
    TEST_S(29,kiTM2TextNoErrorSyntaxStatus,2,10,20);
    TEST_S(30,kiTM2TextNoErrorSyntaxStatus,3,30,30);
    TEST_S(59,kiTM2TextNoErrorSyntaxStatus,3,30,30);
    TEST_S(60,kiTM2TextRangeExceededSyntaxStatus,ML1.EOLMode,60,ZER0);
    ML1.startOff7 = 1000;
    TEST_S(ZER0,kiTM2TextOutOfRangeSyntaxStatus,ML1.previousMode,ZER0,1000);
    TEST_S(999,kiTM2TextOutOfRangeSyntaxStatus,ML1.previousMode,999,1);
    TEST_S(1000,kiTM2TextNoErrorSyntaxStatus,1,1000,10);
    TEST_S(1009,kiTM2TextNoErrorSyntaxStatus,1,1000,10);
    TEST_S(1010,kiTM2TextNoErrorSyntaxStatus,2,1010,20);
    TEST_S(1029,kiTM2TextNoErrorSyntaxStatus,2,1010,20);
    TEST_S(1030,kiTM2TextNoErrorSyntaxStatus,3,1030,30);
    TEST_S(1059,kiTM2TextNoErrorSyntaxStatus,3,1030,30);
    TEST_S(1060,kiTM2TextRangeExceededSyntaxStatus,ML1.EOLMode,1060,ZER0);
#   undef TEST_S
}
- (void) testCase_longestRangeAtGlobalLocation;
{
//- (NSRange)longestRangeAtGlobalLocation:(NSUInteger)aGlobalLocation mask:(NSUInteger)mask;
    iTM2ModeLine * ML1 = [iTM2ModeLine modeLine];
    [ML1 appendSyntaxModesAndLengths:(UI)1,(UI)10,(UI)2,(UI)10,(UI)1,(UI)10,(UI)3,(UI)10,(UI)4,(UI)10,(UI)5,(UI)10,(UI)7,(UI)10,(UI)9,(UI)10,(UI)2,(UI)10,(UI)3,(UI)10,ZER0,ZER0];
    NSRange R = [ML1 longestRangeAtGlobalLocation:ZER0 mask:ZER0];
    STAssertTrue(R.length == ZER0,@"MISSED",nil);
#   define TEST_R(WHERE,MASK,LOCATION,LENGTH) \
    R = [ML1 longestRangeAtGlobalLocation:WHERE mask:MASK];\
    STAssertTrue(iTM3EqualRanges(R,iTM3MakeRange(LOCATION,LENGTH)) || (NSLog(@"R:%@",NSStringFromRange(R)),NO),@"MISSED",nil)
    TEST_R(ZER0,1,ZER0,10);
    TEST_R(1,1,ZER0,10);
    TEST_R(9,1,ZER0,10);
    R = [ML1 longestRangeAtGlobalLocation:10 mask:1];
    STAssertTrue(R.length == ZER0 || (NSLog(@"R:%@",NSStringFromRange(R)),NO),@"MISSED",nil);
    R = [ML1 longestRangeAtGlobalLocation:19 mask:1];
    STAssertTrue(R.length == ZER0 || (NSLog(@"R:%@",NSStringFromRange(R)),NO),@"MISSED",nil);
    TEST_R(10,2,10,10);
    TEST_R(11,2,10,10);
    TEST_R(19,2,10,10);
    TEST_R(20,1,20,20);
    TEST_R(21,1,20,20);
    TEST_R(29,1,20,20);
    TEST_R(30,1,20,20);
    TEST_R(31,1,20,20);
    TEST_R(39,1,20,20);
    R = [ML1 longestRangeAtGlobalLocation:40 mask:1];
    STAssertTrue(R.length == ZER0 || (NSLog(@"R:%@",NSStringFromRange(R)),NO),@"MISSED",nil);
    R = [ML1 longestRangeAtGlobalLocation:49 mask:1];
    STAssertTrue(R.length == ZER0 || (NSLog(@"R:%@",NSStringFromRange(R)),NO),@"MISSED",nil);
    TEST_R(50,1,50,30);
    TEST_R(51,1,50,30);
    TEST_R(59,1,50,30);
    TEST_R(60,1,50,30);
    TEST_R(61,1,50,30);
    TEST_R(69,1,50,30);
    TEST_R(70,1,50,30);
    TEST_R(79,1,50,30);
    TEST_R(80,2,80,20);
    TEST_R(89,2,80,20);
    TEST_R(90,2,80,20);
    TEST_R(99,2,80,20);
    R = [ML1 longestRangeAtGlobalLocation:1000 mask:1];
    STAssertTrue(R.length == ZER0 || (NSLog(@"R:%@",NSStringFromRange(R)),NO),@"MISSED",nil);
    ML1.startOff7 = 1000;
    R = [ML1 longestRangeAtGlobalLocation:ZER0 mask:1];
    STAssertTrue(R.length == ZER0 || (NSLog(@"R:%@",NSStringFromRange(R)),NO),@"MISSED",nil);
#   undef TEST_R
}
- (void) testCase_syntaxModeAtIndex
{
    iTM2ModeLine * ML1 = [iTM2ModeLine modeLine];
#   define TEST_K(INDEX,MODE,LENGTH)\
    STAssertTrue(MODE == [ML1 syntaxModeAtIndex:INDEX] && LENGTH == [ML1 syntaxLengthAtIndex:INDEX],@"MISSED",nil)
    ML1.EOLMode = 835526;
    TEST_K(10,ML1.EOLMode,ML1.contentsLength);
    [ML1 appendSyntaxModesAndLengths:(UI)1,(UI)10,(UI)2,(UI)20,(UI)1,(UI)10,(UI)3,(UI)30,(UI)4,(UI)40,(UI)5,(UI)50,(UI)7,(UI)70,(UI)9,(UI)90,(UI)2,(UI)20,(UI)3,(UI)30,ZER0,ZER0];
    TEST_K(ZER0,1,10);
    TEST_K(1,2,20);
    TEST_K(2,1,10);
    TEST_K(3,3,30);
    TEST_K(4,4,40);
    TEST_K(5,5,50);
    TEST_K(6,7,70);
    TEST_K(7,9,90);
    TEST_K(8,2,20);
    TEST_K(9,3,30);
    ML1.EOLMode = 637254;
    TEST_K(10,ML1.EOLMode,ZER0);
    ML1 = [[iTM2ModeLine alloc] initWithString:@"\r\n" atCursor:ZER0];
    ML1.EOLMode = 835526;
    TEST_K(10,ML1.EOLMode,ML1.contentsLength);
    [ML1 appendSyntaxModesAndLengths:(UI)1,(UI)10,(UI)2,(UI)20,(UI)1,(UI)10,(UI)3,(UI)30,(UI)4,(UI)40,(UI)5,(UI)50,(UI)7,(UI)70,(UI)9,(UI)90,(UI)2,(UI)20,(UI)3,(UI)30,ZER0,ZER0];
    TEST_K(ZER0,1,10);
    TEST_K(1,2,20);
    TEST_K(2,1,10);
    TEST_K(3,3,30);
    TEST_K(4,4,40);
    TEST_K(5,5,50);
    TEST_K(6,7,70);
    TEST_K(7,9,90);
    TEST_K(8,2,20);
    TEST_K(9,3,30);
    ML1.EOLMode = 637254;
    TEST_K(10,ML1.EOLMode,ZER0);
    TEST_K(11,ML1.EOLMode,ZER0);
#   undef TEST_K
}
- (void) testCase_appendSyntaxMode;
{
    iTM2ModeLine * ML1 = [iTM2ModeLine modeLine];
    STAssertTrue(([ML1 appendSyntaxMode:111 length:222 error:self.RORef4iTM3] && !ROR),@"MISSED",NULL);
    ML1.describe;
    iTM2ModeLine * ML2 = [iTM2ModeLine modeLine];
    STAssertTrue(([ML2 appendSyntaxModesAndLengths:(UI)111,(UI)222,ZER0,ZER0]),@"MISSED",NULL);
    ML2.describe;
    STAssertTrue(([ML1 isEqualToModeLine:ML2]),@"MISSED",NULL);
    STAssertTrue(([ML1 appendSyntaxMode:333 length:111 error:self.RORef4iTM3] && !ROR),@"MISSED",NULL);
    ML1.describe;
    ML2 = [iTM2ModeLine modeLine];
    STAssertTrue(([ML2 appendSyntaxModesAndLengths:(UI)111,(UI)222,(UI)333,(UI)111,ZER0,ZER0]),@"MISSED",NULL);
    ML2.describe;
    STAssertTrue(([ML1 isEqualToModeLine:ML2]),@"MISSED",NULL);
    STAssertTrue(([ML1 appendSyntaxMode:111 length:444 error:self.RORef4iTM3] && !ROR),@"MISSED",NULL);
    ML1.describe;
    ML2 = [iTM2ModeLine modeLine];
    STAssertTrue(([ML2 appendSyntaxModesAndLengths:(UI)111,(UI)222,(UI)333,(UI)111,(UI)111,(UI)444,ZER0,ZER0]),@"MISSED",NULL);
    ML2.describe;
    STAssertTrue(([ML1 isEqualToModeLine:ML2]),@"MISSED",NULL);
    return;
}
@end

