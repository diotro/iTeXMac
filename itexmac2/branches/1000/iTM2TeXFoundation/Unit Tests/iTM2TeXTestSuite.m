//
//  iTM2TeXTestSuite.m
//  iTM2TeXFoundation
//
//  Created by coder on 22/10/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "iTM2TeXTestSuite.h"
#import <iTM3Foundation/iTM3Foundation.h>
#import <iTM2TeXFoundation/iTM2TeXFoundation.h>


@implementation iTM2TeXTestSuite

- (void)testTEST1;
{
//	STAssertTrue([[SPC TeXBaseProjectsProperties] count]>ZER0, @"There must be some base projects");
	NSLog(@"This is perfectly OK");
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

