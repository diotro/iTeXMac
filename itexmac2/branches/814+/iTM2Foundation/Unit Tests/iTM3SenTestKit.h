//
//  Task.h
//  iTM2Foundation
//
//  @version Subversion: $Id: Task.h 800 2009-10-22 21:10:32Z jlaurens $ 
//
//  Created by Coder on 02/02/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#ifdef __iTM2_LIVE_TEST__
#import <SenTestingKit/NSException_SenTestFailure.h>
#import <SenTestingKit/SenTestCase_Macros.h>
#import <SenTestingKit/SenTestingUtilities.h>
@interface SenTestCase: NSObject {

}
/*"Invoking a test performs only its setUp, invocation, and tearDown, outside the context of a run; it's the primitive method used by -performTest:."*/
- (void) invokeTest;
/*"Pre- and post-test methods"*/
- (void) setUp;
- (void) tearDown;
- (void) failWithException:(NSException *) anException;
@end
#else
#import <SenTestingKit/SenTestingKit.h>
#endif

