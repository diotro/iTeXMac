// jlaurens AT users DOT sourceforge DOT net
#import <Cocoa/Cocoa.h>
int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSString * descriptionKey = @"iTM2Documentation";
	NSProcessInfo * PI = [NSProcessInfo processInfo];
	NSArray * arguments = [PI arguments];
	if(arguments.count)
	{
		NSString * path = [arguments objectAtIndex:0];// bundlePath/Contents/MacOS/GetVersion
		path = path.stringByDeletingLastPathComponent;// bundlePath/Contents/MacOS
		path = path.stringByDeletingLastPathComponent;// bundlePath/Contents
		path = path.stringByDeletingLastPathComponent;// bundlePath
		NSBundle * B = [NSBundle bundleWithPath:path];
		NSString * description  = [B objectForInfoDictionaryKey:descriptionKey];
		if([description isKindOfClass:[NSString class]])
		{
			NSString * descriptionPath = [B pathForResource:description ofType:nil];
			NSURL * url = [NSURL fileURLWithPath:descriptionPath];
			NSWorkspace * SWS = [NSWorkspace sharedWorkspace];
			if(![SWS openURL:url])
			{
				NSLog(@"iTM2Readme: Could not open:%@",url);
			}
		}
	}
    [pool release];
    return 0;
}
