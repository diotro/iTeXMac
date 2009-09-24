// jlaurens AT users DOT sourceforge DOT net
#if 0
This should change to something like
defaults read "FULL PATH/iTeXMac2.app/Contents/Info" iTM2SourceVersion
#endif
#import <Foundation/Foundation.h>
int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSString * versionKey = @"iTM2SourceVersion";
	//NSString * versionKey = (NSString *)kCFBundleVersionKey;
	NSProcessInfo * PI = [NSProcessInfo processInfo];
	NSArray * arguments = [PI arguments];
	if([arguments count])
	{
		NSString * path = [arguments objectAtIndex:0];// bundlePath/Contents/MacOS/GetVersion
		path = [path stringByDeletingLastPathComponent];// bundlePath/Contents/MacOS
		path = [path stringByDeletingLastPathComponent];// bundlePath/Contents
		path = [path stringByDeletingLastPathComponent];// bundlePath
		NSBundle * B = [NSBundle bundleWithPath:path];
		NSDictionary * info = [B infoDictionary];
		NSString * version = [info objectForKey:versionKey];
		if([version respondsToSelector:@selector(UTF8String)])
		{
			printf("%s",[version UTF8String]);
		}
	}
    [pool release];
    return 0;
}
