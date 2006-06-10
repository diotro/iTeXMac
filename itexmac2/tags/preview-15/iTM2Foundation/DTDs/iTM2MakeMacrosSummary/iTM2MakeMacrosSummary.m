#import <Foundation/Foundation.h>

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSDictionary * environment = [[NSProcessInfo processInfo] environment];
	NSString * SOURCE = [environment objectForKey: @"Source"];
	NSString * TARGET = [environment objectForKey: @"Target"];
	NSString * DTD = [environment objectForKey: @"DTD"];
	NSString * SOURCE_ROOT = [environment objectForKey: @"SOURCE_ROOT"];
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
		else if(!strncmp(argv[index], "-t", 2)  || !strncmp(argv[index], "--target", 13))
		{
			if(++index < argc)
			{
				TARGET = [NSString stringWithUTF8String: argv[index]];
			}
			else
				goto ERROR;
		}
		else if(!strncmp(argv[index], "-d", 2)  || !strncmp(argv[index], "--dtd", 10))
		{
			if(++index < argc)
			{
				DTD = [NSString stringWithUTF8String: argv[index]];
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
		goto ERROR;
	}
	if(![[NSFileManager defaultManager] isReadableFileAtPath: DTD]) 
	{
		DTD = [[[NSFileManager defaultManager] currentDirectoryPath] stringByAppendingPathComponent:DTD];
		if(![[NSFileManager defaultManager] isReadableFileAtPath: DTD]) 
		{
			DTD = [[[[[SOURCE_ROOT stringByAppendingPathComponent:@".."]
				stringByAppendingPathComponent:@"iTM2Foundation"]
					stringByAppendingPathComponent:@"DTDs"]
						stringByAppendingPathComponent:@"Actions"]
							stringByAppendingPathExtension:@"DTD"];
			if(![[NSFileManager defaultManager] isReadableFileAtPath: DTD]) 
			{
				NSLog(@"%s ERROR: no readable file at %@", argv[0], DTD);
				goto ERROR;
			}
		}
	}
	if([TARGET length])
	{
		BOOL isDirectory = NO;
		if(![[NSFileManager defaultManager] fileExistsAtPath:[TARGET stringByDeletingLastPathComponent] isDirectory:&isDirectory] && isDirectory) 
		{
			TARGET = [[[NSFileManager defaultManager] currentDirectoryPath] stringByAppendingPathComponent:TARGET];
			if(![[NSFileManager defaultManager] fileExistsAtPath:[TARGET stringByDeletingLastPathComponent] isDirectory:&isDirectory] && isDirectory) 
			{
				NSLog(@"%s ERROR: no readable file at %@", argv[0], TARGET);
				goto ERROR;
			}
			goto ERROR;
		}
	}
	else
	{
		TARGET = [[[SOURCE stringByDeletingLastPathComponent]
					stringByAppendingPathComponent: @"Summary"]
						stringByAppendingPathExtension: @"xml"];
	}
	NSLog(@"%s\nConverting\n%@\ninto\n%@", argv[0], SOURCE, TARGET);
    // insert code here...
	NSURL * sourceURL = [NSURL fileURLWithPath:SOURCE];
	NSError * localError = nil;
	NSXMLDocument * source = [[[NSXMLDocument alloc] initWithContentsOfURL:sourceURL options:0 error:&localError] autorelease];
	if(localError)
	{
		NSLog(@"There was an error while creating the document: %@", localError);
		goto ERROR;
	}
	NSXMLElement * root = [source rootElement];
	NSArray * items = [root nodesForXPath:@"//ITEM" error:&localError];
	if(localError)
	{
		NSLog(@"There was an error while looking for //ITEM: %@", localError);
		goto ERROR;
	}
	NSMutableArray * KEYS = [NSMutableArray array];
	NSMutableDictionary * CUTS = [NSMutableDictionary dictionary];
	NSEnumerator * E = [items objectEnumerator];
	id item;
	while(item = [E nextObject])
	{
		NSArray * args = [item nodesForXPath:@"./ARG" error:&localError];
		if(localError)
		{
			NSLog(@"There was an error while looking for /ARG: %@", localError);
			goto ERROR;
		}
		NSString * KEY = [[item attributeForName:@"KEY"] stringValue];
		if(KEY)
		{
			[KEYS addObject:KEY];
			NSString * action = [[item attributeForName:@"ACT"] stringValue];
			if([action isEqual:@"insertMacro:"] || ![action length])
			{
				NSString * arg = [[args lastObject] stringValue];
				if([arg length]>3)
				{
					[CUTS setObject:KEY forKey:arg];
				}
			}
		}
		else
		{
			NSLog(@"Missing a required KEY for item: %@", item);
			goto ERROR;
		}
	}
	NSMutableArray * ITEMS = [NSMutableArray array];
	E = [[KEYS sortedArrayUsingSelector:@selector(compare:)] objectEnumerator];
	NSString * KEY;
	while(KEY = [E nextObject])
	{
		id attribute = [NSXMLNode attributeWithName:@"KEY" stringValue:KEY];
		NSArray * attributes = [NSArray arrayWithObject:attribute];
		id ITEM = [NSXMLNode elementWithName:@"ITEM" children:nil attributes:attributes];
		[ITEMS addObject:ITEM];
	}
	NSMutableArray * cuts = [NSMutableArray array];
	E = [[[CUTS allKeys] sortedArrayUsingSelector:@selector(compare:)] objectEnumerator];
	while(KEY = [E nextObject])
	{
		id cut = [KEY substringWithRange:NSMakeRange(0,3)];
		cut = [NSXMLNode attributeWithName:@"CUT" stringValue:cut];
		KEY = [CUTS objectForKey:KEY];
		id attribute = [NSXMLNode attributeWithName:@"KEY" stringValue:KEY];
		NSArray * attributes = [NSArray arrayWithObjects:attribute,cut,nil];
		id element = [NSXMLNode elementWithName:@"CUT" children:nil attributes:attributes];
		[cuts addObject:element];
	}
	root = [NSXMLNode elementWithName:@"SUMMARY" children:[NSArray arrayWithObjects:[NSXMLNode elementWithName:@"LIST" children:ITEMS attributes:nil],[NSXMLNode elementWithName:@"CUTS" children:cuts attributes:nil],nil] attributes:nil];
	NSXMLDocument *xmlDoc = [[[NSXMLDocument alloc] initWithRootElement:nil] autorelease];
	[xmlDoc setVersion:@"1.0"];
	[xmlDoc setCharacterEncoding:@"UTF-8"];
	[xmlDoc setRootElement: root];
	[xmlDoc setStandalone:YES];
	// add the embedded DTD
	[xmlDoc setDTD: [[[NSXMLDTD alloc] initWithContentsOfURL:[NSURL fileURLWithPath: DTD] options:0 error:&localError] autorelease]];
	NSMutableString * MS = [[[xmlDoc XMLStringWithOptions: NSXMLNodePrettyPrint|NSXMLDocumentIncludeContentTypeDeclaration] mutableCopy] autorelease];
	[MS replaceOccurrencesOfString:@"></ITEM>" withString:@"/>" options:0 range:NSMakeRange(0,[MS length])];
	[MS replaceOccurrencesOfString:@"></CUT>" withString:@"/>" options:0 range:NSMakeRange(0,[MS length])];
	if([MS writeToURL:[NSURL fileURLWithPath: TARGET] atomically:YES encoding:NSUTF8StringEncoding error:&localError])
	{
		NSLog(@"OKAY");
	}
	else
	{
		NSLog(@"error: %@", localError);
		goto ERROR;
	}
    [pool release];
    return 0;
ERROR:
	NSLog(@"Usage: %s --source SOURCE --dtd DTD [--target TARGET]\n", argv[0]);
    [pool release];
    return -1;
}
