//
//  Alias.m
//  iTM2Foundation
//
//  @version Subversion: $Id$ 
//
//  Created by Coder on 24/02/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "Alias.h"
#import "iTeXMac2.h"
#import "iTM2FileManagerKit.h"
#import "ICURegEx.h"


@implementation Alias
- (void)testAlias
{
	NSString * temp = NSTemporaryDirectory();
	NSString * component = @"TARGET";
	NSString * target = [temp stringByAppendingPathComponent:component];
	if ([DFM removeItemAtPath:target handler:nil error:NULL])
		NSLog(@"No more: %@", target);
	NSAssert([DFM createFileAtPath:target contents:[NSData data] attributes:nil], @"Could not create test file.");
	NSData * DD = [target iTM2_dataAliasRelativeTo:nil error:nil];
	component = @"MOVED-TARGET";
	NSString * movedTarget = [temp stringByAppendingPathComponent:component];
	[DFM removeItemAtPath:movedTarget handler:nil error:NULL];
	NSAssert([DFM moveItemAtPath:target toPath:movedTarget handler:nil error:NULL], @"Could not move test file");
	target = movedTarget;
	NSAssert([target isEqual:[DD iTM2_pathByResolvingDataAliasRelativeTo:nil error:nil]], @"FAILURE");
	DD = [target iTM2_dataAliasRelativeTo:temp error:nil];
	component = @"MORE_MOVED-TARGET";
	movedTarget = [temp stringByAppendingPathComponent:component];
	[DFM removeItemAtPath:movedTarget handler:nil error:NULL];
	NSAssert([DFM moveItemAtPath:target toPath:movedTarget handler:nil error:NULL], @"Could not move test file");
	target = movedTarget;
	NSAssert([target isEqual:[DD iTM2_pathByResolvingDataAliasRelativeTo:temp error:nil]], @"FAILURE");
	return;
}
@end
