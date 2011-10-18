#import <Foundation/Foundation.h>

int main (int argc, const char * argv[]) {
	NSAutoreleasePool * AP = [[NSAutoreleasePool alloc] init];
	// parse the environment variables
	NSDictionary * environment = [[NSProcessInfo processInfo] environment];
	NSString * SOURCE = [environment objectForKey:@"KeyBindingsTranslatorSource"];
	NSString * DTD = [environment objectForKey:@"KeyBindingsTranslatorMenuDTD"];
	NSString * TARGET = [environment objectForKey:@"KeyBindingsTranslatorTarget"];
	NSString * MACROS = [environment objectForKey:@"KeyBindingsTranslatorMacros"];
	int index = 0;
	while(++index < argc)
	{
		if(!strncmp(argv[index], "-s", 2)  || !strncmp(argv[index], "--source", 8))
		{
			if(++index < argc)
			{
				SOURCE = [NSString stringWithUTF8String:argv[index]];
			}
			else
				goto ERROR;
		}
		else if(!strncmp(argv[index], "-d", 2)  || !strncmp(argv[index], "--dtd", 5))
		{
			if(++index < argc)
			{
				DTD = [NSString stringWithUTF8String:argv[index]];
			}
			else
				goto ERROR;
		}
		else if(!strncmp(argv[index], "-t", 2)  || !strncmp(argv[index], "--target", 8))
		{
			if(++index < argc)
			{
				TARGET = [NSString stringWithUTF8String:argv[index]];
			}
			else
				goto ERROR;
		}
		else if(!strncmp(argv[index], "-m", 2)  || !strncmp(argv[index], "--macros", 8))
		{
			if(++index < argc)
			{
				MACROS = [NSString stringWithUTF8String:argv[index]];
			}
			else
				goto ERROR;
		}
	}
	if(![[NSFileManager defaultManager] isReadableFileAtPath:SOURCE]) 
	{
		NSLog(@"%s ERROR: no readable file at %@", argv[0], SOURCE);
		goto ERROR;
	}
	if(![[NSFileManager defaultManager] isReadableFileAtPath:DTD]) 
	{
		NSLog(@"%s ERROR: no readable file at %@", argv[0], DTD);
		goto ERROR;
	}
	if(!TARGET.length)
	{
		TARGET = [[SOURCE stringByDeletingLastPathComponent]
							stringByAppendingPathComponent: @"iTM2ActionsIndex.xml"];
	}
	if(!MACROS.length)
	{
		MACROS = [[SOURCE stringByDeletingLastPathComponent]
							stringByAppendingPathComponent: @"iTM2Macros.xml"];
	}
	if(![[NSFileManager defaultManager] isWritableFileAtPath:[TARGET stringByDeletingLastPathComponent]]) 
	{
		NSLog(@"%s ERROR: no writable directory at %@", argv[0], TARGET);
		goto ERROR;
	}
	NSError * error = nil;
	NSURL * url = [NSURL fileURLWithPath:SOURCE];
	NSXMLDocument *xmlDoc = [[[NSXMLDocument alloc] initWithContentsOfURL:url options:0 error:&error] autorelease];
	if(error)
	{
		NSLog(@"error: %@\npath: %@", error, SOURCE);
	}
	NSXMLElement * element = [xmlDoc rootElement];// dict
	NSXMLElement * rootElement = [[[NSXMLElement alloc] initWithName:@"LIST"] autorelease];
	do
	{
		if([element isKindOfClass:[NSXMLElement class]])
		{
			NSString * key = [[element attributeForName:@"KEY"] stringValue];
			if(key.length)
			{
				NSXMLElement * item = [NSXMLNode elementWithName:@"ITEM"];
				[item addAttribute:[NSXMLNode attributeWithName:@"KEY" stringValue:key]];
				NSString * actionName = [[element attributeForName:@"ACT"] stringValue];
				if(actionName.length)
				{
					[item addAttribute:[NSXMLNode attributeWithName:@"ACT" stringValue:actionName]];
					NSXMLElement * E = [[element elementsForName:@"ARGLIST"] lastObject];
					if(E)
					{
						id list = [NSXMLNode elementWithName:@"ARGLIST"];
						id node = [E childAtIndex:0];
						do
						{
							NSString * s = [node stringValue];
							if(s.length)
							{
								[list addChild:[NSXMLNode elementWithName:@"ARG" stringValue:s]];
							}
						}
						while(node = [node nextSibling]);
						[item addChild:list];
					}
					else if(E = [[element elementsForName:@"ARG"] lastObject])
					{
						NSString * s = [E stringValue];
						if(s.length)
						{
							[item addChild:[NSXMLNode elementWithName:@"ARG" stringValue:s]];
						}
					}
					[rootElement addChild:item];
				}
			}
		}
	}
	while(element = (NSXMLElement *)[element nextNode]);

	xmlDoc = [[[NSXMLDocument alloc] initWithRootElement:rootElement] autorelease];
	[xmlDoc setVersion:@"1.0"];
	[xmlDoc setCharacterEncoding:@"UTF-8"];
	// add the embedded DTD
	// DON'T RELY ON COCOA: THERE IS A BUG in 10.4.4
	[xmlDoc setDTD:[[[NSXMLDTD alloc] init] autorelease]];
	NSMutableString * MS = [[[xmlDoc XMLStringWithOptions:NSXMLNodePrettyPrint] mutableCopy] autorelease];
	NSRange R = [MS rangeOfString:@"<!DOCTYPE >"];
	if(R.length)
	{
		url = [NSURL fileURLWithPath:DTD];
		NSString * DTDContents = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
		DTDContents = [DTDContents stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		[MS replaceCharactersInRange:R withString:[NSString stringWithFormat:@"<!DOCTYPE %@ [\n%@\n]>", [[xmlDoc rootElement] name], DTDContents]];
	}
	if([MS writeToURL:[NSURL fileURLWithPath:TARGET] atomically:YES encoding:NSUTF8StringEncoding error:&error])
	{
		NSLog(@"OKAY %@", TARGET);
	}
	else
	{
		NSLog(@"error: %@", error);
	}
	[AP release];
    return 0;
ERROR:
	NSLog(@"Usage: %s --source SOURCE --dtd DTD [--target TARGET] [--macros MACROS]\n", argv[0]);
    return -1;
}
