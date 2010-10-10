//
//  iTM2Test.h
//  iTM2Foundation
//
//  Created by Jérôme Laurens on 16/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "iTM3SenTestKit.h"

@interface iTM2Test1A : SenTestCase {
    NSArray * fullLines;
    NSArray * fullLinesPrefix;
    NSArray * partsOfLine;
    NSArray * partsOfLinePrefix;
    NSArray * endsOfLine;
    NSArray * SELPlaceholders;
    NSArray * XPCTD_SELPlaceholders;
}

@property (retain) NSArray * fullLines;
@property (retain) NSArray * fullLinesPrefix;
@property (retain) NSArray * partsOfLine;
@property (retain) NSArray * partsOfLinePrefix;
@property (retain) NSArray * endsOfLine;
@property (retain) NSArray * SELPlaceholders;
@property (retain) NSArray * XPCTD_SELPlaceholders;
@end
