//
//  Task.m
//  iTM2Foundation
//
//  @version Subversion: $Id: Task.m 800 2009-10-22 21:10:32Z jlaurens $ 
//
//  Created by Coder on 02/02/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#ifdef __iTM2_LIVE_TEST__
#import "iTM3SenTestKit.h"
#import "ICURegEx.h"
#import "iTM2Runtime.h"
#import "iTM2Invocation.h"

NSString *STComposeString(NSString * first, ...)
{
    return @"STComposeString";
}

NSString *getScalarDescription(NSValue *left)
{
    return @"getScalarDescription";
}

@implementation NSFileManager (SenTestingAdditions)
- (BOOL) fileExistsAtPathOrLink:(NSString *)aPath;
{
    return NO;
}
@end

@implementation NSValue (SenTestingAdditions)
- (NSString *) contentDescription;
{
    return @"NSValue's contentDescription";
}
@end


@implementation SenTestCase
/*"Mimics: Invoking a test performs only its setUp, invocation, and tearDown, outside the context of a run; it's the primitive method used by -performTest:."*/
- (void) invokeTest;
{
    [self setUp];
    ICURegEx * RE = [ICURegEx regExWithSearchPattern:@"^testCase" error:NULL];
    NSInvocation * I = nil;
    [[NSInvocation getInvocation4iTM3:&I withTarget:self] setUp];
    NSPointerArray * PAs = [iTM2Runtime instanceSelectorsOfClass:self.class matchedBy:RE signature:I.methodSignature inherited:NO];
    NSUInteger i = ZER0;
    for (i=ZER0;i<PAs.count;++i) {
        I.selector = (SEL)[PAs pointerAtIndex:i];
        I.invoke;
    }
    [self tearDown];
}
/*"Pre- and post-test methods"*/
- (void) setUp;
{
    // 4 subclassers
}
- (void) tearDown;
{
    // 4 subclassers
}
- (void) failWithException:(NSException *) anException;
{
    [anException raise];
    return;
}
@end

@implementation NSException (SenTestFailure)

- (NSString *) filename;
{
    return @"";
}
- (NSString *) filePathInProject;
{
    return @"";
}
- (NSNumber *) lineNumber;
{
    return [NSNumber numberWithInt:-1];
}

+ (NSException *) failureInFile:(NSString *) filename atLine:(int) lineNumber withDescription:(NSString *) formatString, ...;
{
    return [NSException exceptionWithName:filename reason:[[NSNumber numberWithInt:lineNumber] description] userInfo:nil];
}
+ (NSException *) failureInCondition:(NSString *) condition isTrue:(BOOL) isTrue inFile:(NSString *) filename atLine:(int) lineNumber withDescription:(NSString *) formatString, ...;
{
    return [NSException exceptionWithName:filename reason:condition userInfo:nil];
}
+ (NSException *) failureInEqualityBetweenObject:(id) left andObject:(id) right  inFile:(NSString *) filename atLine:(int) lineNumber withDescription:(NSString *)formatString, ...;
{
    return [NSException exceptionWithName:filename reason:[NSString stringWithFormat:@"%@<!>%@",left,right] userInfo:nil];
}
+ (NSException *) failureInEqualityBetweenValue:(NSValue *) left andValue:(NSValue *) right withAccuracy:(NSValue *) accuracy inFile:(NSString *) filename atLine:(int) lineNumber withDescription:(NSString *)formatString, ...;
{
    return [NSException exceptionWithName:filename reason:[NSString stringWithFormat:@"%@=!=%@",left,right] userInfo:nil];
}
+ (NSException *) failureInRaise:(NSString *) expression inFile:(NSString *) filename atLine:(int) lineNumber withDescription:(NSString *)formatString, ...;
{
    return [NSException exceptionWithName:filename reason:expression userInfo:nil];
}
+ (NSException *) failureInRaise:(NSString *) expression exception:(NSException *) exception inFile:(NSString *) filename atLine:(int) lineNumber withDescription:(NSString *)formatString, ...;
{
    return exception;
}

@end

#endif
