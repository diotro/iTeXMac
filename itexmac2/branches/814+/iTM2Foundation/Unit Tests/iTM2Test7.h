//
//  iTM2Test7.h
//  iTM2Foundation
//
//  Created by Jérôme Laurens on 16/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "iTM3SenTestKit.h"

@interface iTM2Test7 : SenTestCase {
@private
    NSURL * iVarTemporaryDirectoryURL4iTM3;
}
@property (readwrite,assign) NSURL * temporaryDirectoryURL;
@end
