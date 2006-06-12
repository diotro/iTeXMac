//
//  Projects.m
//  iTM2Foundation
//
//  @version Subversion: $Id$ 
//
//  Created by coder on 27/05/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "Projects.h"

UNIMPLEMENTED

@implementation Projects
-(void) testAvailableProjects
{
	NSLog(@"Testing the available projects, won't break if thing go wrong.");
	NSString * path = [[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
		stringByAppendingPathComponent:@"Test TeX"]
			stringByAppendingPathComponent:@"Test TeX 1"];
	NSLog(@"available projects at: %@ are: %@", path, [SPC availableProjectsForPath:path]);
	NSString * path = [[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
		stringByAppendingPathComponent:@"Test TeX"]
			stringByAppendingPathComponent:@"Test TeX 2.texd"];
	NSLog(@"available projects at: %@ are: %@", path, [SPC availableProjectsForPath:path]);
}
@end
