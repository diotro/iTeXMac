//
//  iTM3SenTestKit.h
//  iTM3Foundation
//
//  @version Subversion: $Id: Task.h 800 2009-10-22 21:10:32Z jlaurens $ 
//
//  Created by Coder on ?
//  Révisé par itexmac2: 2010-12-30 14:08:07 +0100
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#ifdef __iTM3_LIVE_TEST__
#warning LIVE TEST: all the tests are run from a test application
#import <SenTestingKit/NSException_SenTestFailure.h>
#import <SenTestingKit/SenTestCase_Macros.h>
#import <SenTestingKit/SenTestingUtilities.h>
@interface iTM3TestCase: NSObject {

}
/*"Invoking a test performs only its setUp, invocation, and tearDown, outside the context of a run; it's the primitive method used by -performTest:."*/
- (void) invokeTest;
/*"Pre- and post-test methods"*/
- (void) setUp;
- (void) tearDown;
- (void) failWithException:(NSException *) anException;
@end
#else
//#import <SenTestingKit/SenTestingKit.h>
#import "GTMSenTestCase.h"
@interface iTM3TestCase: SenTestCase {

}
/*"Invoking a test performs only its setUp, invocation, and tearDown, outside the context of a run; it's the primitive method used by -performTest:."*/
- (void) invokeTest;
/*"Pre- and post-test methods"*/
- (void) setUp;
- (void) tearDown;
- (void) failWithException:(NSException *) anException;
@end
#endif
//  We assume that the mutable set below is defined in iTM3Foundation
//  This is true if this framework was built with the development build configuration.
#if __iTM3_DEVELOPMENT__
#   warning: This is in development mode
extern NSMutableSet * ReachCodeTags4iTM3;
#   define HasReachedCode4iTM3(TAG) [ReachCodeTags4iTM3 containsObject:TAG]
#   define ResetReachCodeTags4iTM3 [ReachCodeTags4iTM3 removeAllObjects]
//  In the following macros, __CODE_TAG__ is an NSString instance
#   define STAssertReachCode4iTM3(INSTRUCTION) \
    do {\
        LOG4iTM3(@"ReachCode?%@",__CODE_TAG__);\
        ResetReachCodeTags4iTM3;\
        INSTRUCTION;\
        STAssertTrue(HasReachedCode4iTM3(__CODE_TAG__)||(NSLog(@"MISSED:%@ not in %@",__CODE_TAG__, ReachCodeTags4iTM3),NO),@"MISSED",NULL);\
    } while (NO);
#   define STAssertDontReachCode4iTM3(INSTRUCTION)\
    do {\
        LOG4iTM3(@"DontReachCode?%@",__CODE_TAG__);\
        ResetReachCodeTags4iTM3;\
        INSTRUCTION;\
        STAssertFalse(HasReachedCode4iTM3(__CODE_TAG__)||(NSLog(@"MISSED:%@ should belong to %@",__CODE_TAG__, ReachCodeTags4iTM3),NO),@"MISSED",NULL);\
    } while (NO);
#else
#   warning: This is NOT in development mode
#   define HasReachedCode4iTM3(TAG) YES
#   define ResetReachCodeTags4iTM3
#   define STAssertReachCode4iTM3(INSTRUCTION)
#   define STAssertDontReachCode4iTM3(INSTRUCTION)
#endif
