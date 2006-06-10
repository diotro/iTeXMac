#import <Foundation/Foundation.h>

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSDictionary * environment = [[NSProcessInfo processInfo] environment];
	NSLog(@"environment: %@", environment);
	NSString * SOURCE = [environment objectForKey: @"XSLTApplicatorSOURCE"];
	NSString * DESTINATION = [environment objectForKey: @"XSLTApplicatorDESTINATION"];
	NSString * XSLT = [environment objectForKey: @"XSLTApplicatorXSLT"];
	id pathComponents = [[[NSFileManager defaultManager] currentDirectoryPath] pathComponents];
	if([pathComponents containsObject:@"build"])
	{
		pathComponents = [[pathComponents mutableCopy] autorelease];
		do
		{
			[pathComponents removeLastObject];
		} while([pathComponents containsObject:@"build"]);
		[[NSFileManager defaultManager] changeCurrentDirectoryPath:[NSString pathWithComponents:pathComponents]];
	}
	NSLog(@"[[NSFileManager defaultManager] currentDirectoryPath]: %@", [[NSFileManager defaultManager] currentDirectoryPath]);
	int index = 0;
	while(++index < argc)
	{
		if(!strncmp(argv[index], "-s", 2)  || !strncmp(argv[index], "--source", 8))
		{
			if(++index < argc)
			{
				SOURCE = [NSString stringWithUTF8String: argv[index]];
			}
			else
				goto ERROR;
		}
		else if(!strncmp(argv[index], "-d", 2)  || !strncmp(argv[index], "--destination", 13))
		{
			if(++index < argc)
			{
				DESTINATION = [NSString stringWithUTF8String: argv[index]];
			}
			else
				goto ERROR;
		}
		else if(!strncmp(argv[index], "-x", 2)  || !strncmp(argv[index], "--xslt", 6))
		{
			if(++index < argc)
			{
				XSLT = [NSString stringWithUTF8String: argv[index]];
			}
			else
				goto ERROR;
		}
	}
	if(![[NSFileManager defaultManager] isReadableFileAtPath: SOURCE]) 
	{
		SOURCE = [[[NSFileManager defaultManager] currentDirectoryPath] stringByAppendingPathComponent:SOURCE];
		if(![[NSFileManager defaultManager] isReadableFileAtPath: SOURCE]) 
		{
			NSLog(@"%s ERROR: no readable file at %@", argv[0], SOURCE);
			goto ERROR;
		}
	}
	if(![[NSFileManager defaultManager] isReadableFileAtPath: XSLT]) 
	{
		XSLT = [[[NSFileManager defaultManager] currentDirectoryPath] stringByAppendingPathComponent:XSLT];
		if(![[NSFileManager defaultManager] isReadableFileAtPath: XSLT]) 
		{
			NSLog(@"%s ERROR: no readable file at %@", argv[0], XSLT);
			goto ERROR;
		}
	}
	NSString * domain = [[SOURCE lastPathComponent] stringByDeletingPathExtension];
	NSString * category = [[SOURCE stringByDeletingLastPathComponent] lastPathComponent];
	if(![DESTINATION length])
	{
		DESTINATION = [[[[SOURCE stringByDeletingLastPathComponent]
						stringByAppendingPathComponent: domain]
							stringByAppendingPathExtension: category]
								stringByAppendingPathExtension: @"translated"];
	}
	if([DESTINATION isEqual:SOURCE] || [DESTINATION isEqual:XSLT])
	{
		NSLog(@"The SOURCE and XSLT must be different from DESTINATION:\nSOURCE: %@\nDESTINATION: %@\nXSLT: %@",
			SOURCE, DESTINATION, XSLT);
		return 1;
	}
	NSLog(@"%s\nConverting\n%@\ninto\n%@", argv[0], SOURCE, DESTINATION);
	NSError * localError = nil;
	NSURL * url = [NSURL fileURLWithPath:SOURCE];
	NSXMLDocument * doc = [[[NSXMLDocument alloc] initWithContentsOfURL:url options:0 error:&localError] autorelease];
	if(localError)
	{
		NSLog(@"There was an error opening\n%@\ndue to\n%@", url, [localError localizedDescription]);
		return 2;
	}
	url = [NSURL fileURLWithPath:XSLT];
	id output = [doc objectByApplyingXSLTAtURL:url arguments:nil error:&localError];
	if(localError)
	{
		NSLog(@"There was an error apllying XSLT at\n%@\ndue to\n%@", url, [localError localizedDescription]);
		return 3;
	}
	if([output isKindOfClass:[NSXMLDocument class]])
	{
		output = [output XMLData];
	}
	else if(![output isKindOfClass:[NSData class]])
	{
		NSLog(@"Unexpected output: got\n%@\ninstead lof a NSXMLDocument or NSData", output);
		return 4;
	}
	url = [NSURL fileURLWithPath:DESTINATION];
	if([output writeToURL:url options:NSAtomicWrite error:&localError])
	{
		return 0;
	}
	if(localError)
	{
		NSLog(@"There was an error writing at\n%@\ndue to\n%@", url, [localError localizedDescription]);
		return 5;
	}
	NSLog(@"There was an unknown error writing at\n%@", url);
	return 6;
ERROR:
	NSLog(@"Usage: %s --source SOURCE --xslt XSLT [--destination DESTINATION]\n", argv[0]);
    return -1;
}
