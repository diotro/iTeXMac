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


@implementation Alias
-(void) testAlias
{
	NSString * temp = NSTemporaryDirectory();
	NSString * component = @"TARGET";
	NSString * target = [temp stringByAppendingPathComponent:component];
	if([DFM removeFileAtPath:target handler:nil])
		NSLog(@"No more: %@", target);
	NSAssert([DFM createFileAtPath:target contents:[NSData data] attributes:nil], @"Could not create test file.");
	NSData * DD = [target dataAliasRelativeTo:nil error:nil];
	component = @"MOVED-TARGET";
	NSString * movedTarget = [temp stringByAppendingPathComponent:component];
	[DFM removeFileAtPath:movedTarget handler:nil];
	NSAssert([DFM movePath:target toPath:movedTarget handler:nil], @"Could not move test file");
	target = movedTarget;
	NSAssert([target isEqual:[DD pathByResolvingDataAliasRelativeTo:nil error:nil]], @"FAILURE");
	DD = [target dataAliasRelativeTo:temp error:nil];
	component = @"MORE_MOVED-TARGET";
	movedTarget = [temp stringByAppendingPathComponent:component];
	[DFM removeFileAtPath:movedTarget handler:nil];
	NSAssert([DFM movePath:target toPath:movedTarget handler:nil], @"Could not move test file");
	target = movedTarget;
	NSAssert([target isEqual:[DD pathByResolvingDataAliasRelativeTo:temp error:nil]], @"FAILURE");
	return;
}
@end
