#!/usr/bin/perl
$SOURCE_DIRECTORY = ".";
$BUILD_DIRECTORY = ".";
use Getopt::Long;
GetOptions ('s|source_directory:s' => \$SOURCE_DIRECTORY, 'b|build_directory:s' => \$BUILD_DIRECTORY);
print "warning: $SOURCE_DIRECTORY\n";
print "warning: $BUILD_DIRECTORY\n";
$ITEM = "Main_Page";
if (! open (INPUT, "$SOURCE_DIRECTORY/$ITEM.html"))
{
    my $CURCONTENT=`curl -s http://wiki.contextgarden.net/$ITEM`;
    if(open INPUT, ">$SOURCE_DIRECTORY/$ITEM.html")
    {
       print "warning: iTeXMac2 INFO: creating $SOURCE_DIRECTORY/$ITEM.html\n";
       print INPUT $CURCONTENT;
       close INPUT;
    }
    open (INPUT, "$SOURCE_DIRECTORY/$ITEM.html") || die "FAILURE...";
}
if(! open(OUTPUT, ">$SOURCE_DIRECTORY/$ITEM.xml"))
{
    die "warning: iTeXMac2 ERROR: SILLY FAILURE...\n";# no need to go further
}
$CONTENT = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<root>
";
$IDT="    ";
$CLOSE_TAG ="";
$ITEMS = "";
while ( <INPUT> )
{
    if(/Official Documentation/)
    {
        if(/^<a\s*name=".*<h(?:2|3)>.*?(\b.*\b).*?<\/h(?:2|3)>/)
        {
    #        $CONTENT = $CONTENT . "A:". $_;
            $TITLE = $1;
            $CONTENT = $CONTENT . "$IDT<item>\n$IDT$IDT<title>$TITLE</title>\n";
            $CLOSE_TAG ="$IDT</item>\n";
        }
        last;
    }
}
while ( <INPUT> )
{
    if(/General ConTeXt Documents/)
    {
        last;
    }
    elsif(/^<a\s*name=".*<h(?:2|3)>.*?(\b.*\b).*?<\/h(?:2|3)>/)
    {
        $TITLE = $1;
        if(length $ITEMS > 0)
        {
            $CONTENT = $CONTENT . "$IDT$IDT<items>\n$ITEMS$IDT$IDT</items>\n";
            $ITEMS = "";
        }
#$CONTENT = $CONTENT . "A:". $_;
        $CONTENT = $CONTENT . "$IDT</item>\n$IDT<item>\n$IDT$IDT<title>$TITLE</title>\n";
    }
    elsif(/<a href="\/(.*?)".*title="(.*?)"/)
    {
#$ITEMS = $ITEMS . "B:". $_;
        my $HREF = $1;
        my $TITLE = $2;
        my $CURCONTENT = "";
print "warning: IN: $HREF.html\n";
        if(open IN, "<$BUILD_DIRECTORY/$HREF.html")
        {
print "warning: CACHED\n";
           local $/ = undef;# no more EOL separator
           $CURCONTENT = <IN>;# perl sees only one line
           close IN;
        }
        else
        {
            $CURCONTENT=`curl -s http://wiki.contextgarden.net/$HREF`;
            if(open IN, ">$BUILD_DIRECTORY/$HREF.html")
            {
print "warning: NOT CACHED\n";
               print IN $CURCONTENT;
               close IN;
               print "warning: iTeXMac2 INFO: $BUILD_DIRECTORY/$HREF.html successfully created\n";
            }
            else
            {
                print "warning: iTeXMac2 ERROR: Could not create $BUILD_DIRECTORY/$HREF.html";
            }
       }
        my @LINES = split /\n/, $CURCONTENT;
        my $ENDLINES = scalar(@LINES);
        my $SUBITEMS = "";
        # @Array returns a scalar in this context
        for($COUNTER=0 ; $COUNTER < $ENDLINES ; $COUNTER++)
        {
            $LINE = @LINES[$COUNTER];
#print "current line: $COUNTER, $LINE\n";
            if($LINE =~ /Main_Page/)
            {
                $COUNTER++;
                while($COUNTER < $ENDLINES)
                {
                    $LINE = @LINES[$COUNTER];
#print "current line: $COUNTER, $LINE\n";
                    if($LINE =~ /Retrieved from/)
                    {
#print "SAVED $ENDLINES - $COUNTER\n";
                        $COUNTER = $ENDLINES;
                    }
                    elsif($LINE =~ /f-lastmod/ || $LINE =~ /index\.php/ || $LINE =~ /Installation/)
                    {
#                        print "IGNORED\n";
                    }
                    elsif($LINE =~ /.*?href="\/(.*?)".*?title="(.*?)".*?<\/a>.*?(\b.*?)<a.*?href="\/(.*?)".*?title="(.*?)".*?<\/a>.*?(\b.*?)<a.*?href="\/(.*?)".*?title="(.*?)".*?<\/a>[:^alnum:]*(.*)/)
                    {
                        my $HREF = $1;
                        if($HREF !~ /Category:ToDo/)
                        {
                            my $TITLE = $2;
                            my $TOOLTIP = $3;
#$SUBITEMS = $SUBITEMS . "a: $LINE\n";
                            $SUBITEMS = $SUBITEMS . "$IDT$IDT$IDT$IDT<item href=\"$HREF\">\n$IDT$IDT$IDT$IDT$IDT<title>$TITLE</title>\n$IDT$IDT$IDT$IDT$IDT<tooltip>$TOOLTIP</tooltip>\n$IDT$IDT$IDT$IDT</item>\n";
                            $HREF = $4;
                            $TITLE = $5;
                            $TOOLTIP = $6;
                            $SUBITEMS = $SUBITEMS . "$IDT$IDT$IDT$IDT<item href=\"$HREF\">\n$IDT$IDT$IDT$IDT$IDT<title>$TITLE</title>\n$IDT$IDT$IDT$IDT$IDT<tooltip>$TOOLTIP</tooltip>\n$IDT$IDT$IDT$IDT</item>\n";
                            $HREF = $7;
                            $TITLE = $8;
                            $TOOLTIP = $9;
                            $SUBITEMS = $SUBITEMS . "$IDT$IDT$IDT$IDT<item href=\"$HREF\">\n$IDT$IDT$IDT$IDT$IDT<title>$TITLE</title>\n$IDT$IDT$IDT$IDT$IDT<tooltip>$TOOLTIP</tooltip>\n$IDT$IDT$IDT$IDT</item>\n";
                        }
                    }
                    elsif($LINE =~ /.*?href="\/(.*?)".*?title="(.*?)".*?<\/a>.*?(\b.*?)<a.*?href="\/(.*?)".*?title="(.*?)".*?<\/a>[:^alnum:]*(.*)/)
                    {
                        my $HREF = $1;
                        if($HREF !~ /Category:ToDo/)
                        {
#$SUBITEMS = $SUBITEMS . "b: $LINE\n";
                            my $TITLE = $2;
                            my $TOOLTIP = $3;
#$SUBITEMS = $SUBITEMS . $LINE;
                            $SUBITEMS = $SUBITEMS . "$IDT$IDT$IDT$IDT$IDT<item href=\"$HREF\">\n$IDT$IDT$IDT$IDT$IDT$IDT<title>$TITLE</title>\n$IDT$IDT$IDT$IDT$IDT$IDT<tooltip>$TOOLTIP</tooltip>\n$IDT$IDT$IDT$IDT$IDT</item>\n";
                            $HREF = $4;
                            $TITLE = $5;
                            $TOOLTIP = $6;
                            $SUBITEMS = $SUBITEMS . "$IDT$IDT$IDT$IDT$IDT<item href=\"$HREF\">\n$IDT$IDT$IDT$IDT$IDT$IDT<title>$TITLE</title>\n$IDT$IDT$IDT$IDT$IDT$IDT<tooltip>$TOOLTIP</tooltip>\n$IDT$IDT$IDT$IDT$IDT</item>\n";
                        }
                    }
                    elsif($LINE =~ /.*?href="\/(.*?)".*?title="(.*?)".*?<\/a>[:^alnum:]*(.*)/)
                    {
                        my $HREF = $1;
                        if($HREF !~ /Category:ToDo/)
                        {
#$SUBITEMS = $SUBITEMS . "c: $LINE\n";
                            my $TITLE = $2;
                            my $TOOLTIP = $3;
 #$SUBITEMS = $SUBITEMS . $LINE;
                           $SUBITEMS = $SUBITEMS . "$IDT$IDT$IDT$IDT$IDT<item href=\"$HREF\">\n$IDT$IDT$IDT$IDT$IDT$IDT<title>$TITLE</title>\n$IDT$IDT$IDT$IDT$IDT$IDT<tooltip>$TOOLTIP</tooltip>\n$IDT$IDT$IDT$IDT$IDT</item>\n";
                        }
                    }
                    else
                    {
#print "IGNORED\n";
                    }
                    $COUNTER++;
                }
            }
        }
        if(length $SUBITEMS > 0)
        {
            $ITEMS = $ITEMS . "$IDT$IDT$IDT<item href=\"$HREF\">\n$IDT$IDT$IDT$IDT<title>$TITLE</title>\n$IDT$IDT$IDT$IDT<items>\n$SUBITEMS$IDT$IDT$IDT$IDT</items>\n$IDT$IDT$IDT</item>\n";
            $SUBITEMS = "";
        }
        else
        {
            $ITEMS = $ITEMS . "$IDT$IDT$IDT<item href=\"$HREF\">\n$IDT$IDT$IDT$IDT<title>$TITLE</title>\n$IDT$IDT$IDT$IDT<items/>\n$IDT$IDT$IDT</item>\n";
        }
    }
    else
    {
#print "IGNOR: ", $_;
    }
}
close (INPUT);
if(length $ITEMS > 0)
{
    $CONTENT = $CONTENT . "$IDT$IDT<items>\n$ITEMS$IDT$IDT</items>\n";
    $SUBITEMS = "";
}
$CONTENT = $CONTENT . "$CLOSE_TAG</root>\n";
print OUTPUT $CONTENT;
close(OUTPUT);
print "warning: iTeXMac2 INFO: $SOURCE_DIRECTORY/$ITEM.xml successfully created\n";
exit 0;

#print "-------\n\n";


#<?xml version="1.0" encoding="UTF-8"?>
#<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
#<plist version="1.0">
#<array>
#	<dict>
#		<key>title</key>
#		<string>TITLE</string>
#		<key>items</key>
#		<array>
#			<dict>
#				<key>title</key>
#				<string>SUBTITLE</string>
#				<key>ref</key>
#				<string>REFERENCE</string>
#			</dict>
#		</array>
#	</dict>
#</array>
#</plist>

#opendir MYDIR, ".";
#@contents = grep /.*\.text/, readdir MYDIR;
#closedir MYDIR;
#$CONTENT = "PARTI\n";
#foreach $ITEM ( @contents )
#{
#    open (INPUT, "$ITEM") || die ("Could not open file <br> $!");
#    $CONTENT = $CONTENT . "\n\n\n---  $ITEM:\n\n";
#    while ( <INPUT> )
#    {
#        $CONTENT = $CONTENT . $_;
#    }
#}
#open(OUTPUT, ">EXTENSIONS.TXT");
#print OUTPUT "NOUVEAU\n\n";
#close(OUTPUT);
#open(OUTPUT, ">>EXTENSIONS.TXT");
#print OUTPUT $CONTENT;
#close(OUTPUT);
#exit 0;
#
#print "Content-type: text/html\n\n";
#
#print "This program will open an example file. <br>";
#open (INPUT, "example.txt") || die ("Could not open file <br> $!");
#while ( <INPUT> )
#{
#  $CONTENT = $CONTENT . $_;
#}
#close (INPUT);
