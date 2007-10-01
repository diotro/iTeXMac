#!/usr/bin/perl
# this is Googlator
# Googlator is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
use Getopt::Long;
use Cwd;
use Cwd 'abs_path';
use File::Path;
use utf8;# it is not necessary on perl 5.8
use Encode;
#use open ':utf8';
# action
sub glgUsage
{
    print "\nUsage: Googlator action options arguments\n";
    print "\n";
    print "2. Action translate:\n";
    print "   * Description:  Use curl to ask google for translations.\n";
    print "     Fine tuning is necessary and you certainly have to edit the strings file with an UTF8 aware text editor. \n";
    print "   * Options:\n";
    print "     -f|--from the old language you want a translation from, one of en|de|es|fr|it|pt|ja|ko|zh-CN (Goolgle choices).\n";
    print "     -t|--to the new language you want a translation to, one of en|de|es|fr|it|pt|ja|ko|zh-CN (Goolgle choices).\n";
    my @encodings = Encode->encodings(":all");
    print "     -e|--encoding the encoding of the Google answer (default is iso-8859-1, available @encodings).\n";
    print "   * Argument: the string you'd like to be translated.\n";
    print "\n";
    print "4. Action glossary:\n";
    print "   * Description:  Use curl to ask google for translations.\n";
    print "     Fine tuning is necessary and you certainly have to edit the strings file with an UTF8 aware text editor. \n";
    print "   * Options:\n";
    my @encodings = Encode->encodings(":all");
    print "     -e|--encoding the encoding of the Google answer (default is iso-8859-1, available @encodings).\n";
    print "   * Argument: the .wg files you'd like to be translated. Those files contain the relevant information concerning the language.\n";
    print "\n";
}

if(scalar(@ARGV)>0)
{
    $ACTION = $ARGV[0];
    shift(@ARGV);
}
else
{
    glgUsage;
    exit 1;
}
#print "Action: $ACTION\n";
sub translation
{
    my($OLD_LANGUAGE, $NEW_LANGUAGE, $ENCODING, $LINE) = @_;
#print "LINE: $LINE\n";
    %short2long = (
            'en' => 'English',
            'de' => 'German',
            'es' => 'Spanish',
            'fr' => 'French',
            'it' => 'Italian',
            'pt' => 'pt',
            'ja' => 'Japanese',
            'ko' => 'ko',
            'zh-CN' => 'zh-CN'
        );
    %long2short = (
            'English' => 'en',
            'German' => 'de',
            'Spanish' => 'es',
            'French' => 'fr',
            'Italian' => 'it',
            'pt' => 'pt',
            'Japanese' => 'ja',
            'ko' => 'ko',
            'zh-CN' => 'zh-CN'
        );
    $LONG_LANGUAGE=$short2long{ $OLD_LANGUAGE };
#print "$LONG_LANGUAGE";
    if ( length($LONG_LANGUAGE) == 0 )
    {
        glgUsage;
        exit 3;
    }
    $LONG_LANGUAGE=$short2long{ $NEW_LANGUAGE };
#print "$LONG_LANGUAGE";
    if ( length($LONG_LANGUAGE) == 0 )
    {
        glgUsage;
        exit 4;
    }
    if ( $OLD_LANGUAGE =~ /$NEW_LANGUAGE/ )
    {
        glgUsage;
        exit 5;
    }
    if( $LINE =~ /( *)(.*\b)(.*)/ )
    {
        $PREFIX = $1;
        $VALUE = $2;
        $SUFFIX = $3;
        # rfc2396: ";", "/", "?", ":", "@", "&", "=", "+", ",", and "$" are reserved in queries
        $OLD_VALUE = $VALUE;
        $VALUE =~ s|%|,YQPQY,|g;
        $VALUE =~ s|;|%38|g;
        $VALUE =~ s|/|%2F|g;
        $VALUE =~ s|\?|%3F|g;
        $VALUE =~ s|:|%3A|g;
        $VALUE =~ s|@|,ZQPQZ,|g;
        $VALUE =~ s|&|%26|g;
        $VALUE =~ s|=|%3D|g;
        $VALUE =~ s|\+|%2B|g;
        $VALUE =~ s|,|%2C|g;
        $VALUE =~ s|\$|%24|g;
        $VALUE =~ s|,|%20|g;
        $VALUE =~ s|\\n|;;;. |g;# trick to catch multilines
        my $GOOGLATOR=`curl -s --user-agent "Mozilla/4.0" -d "langpair=$OLD_LANGUAGE|$NEW_LANGUAGE" -d text="$VALUE" "http://translate.google.com/translate_t"`;
        if($GOOGLATOR =~ m|<textarea .*?>(.*?)</textarea>|)
        {
            $TRANSLATION = $1;
            $TRANSLATION =~ s|;;;\.  |\\n|g;# see above
            $TRANSLATION =~ s|,YQPQY,|%|g;# see above
            $TRANSLATION =~ s|,ZQPQZ,|@|g;# see above
            eval{
                $NEW_TRANSLATION = encode ("utf8", $TRANSLATION);
                #print "$TRANSLATION ...> $NEW_TRANSLATION\n";
                #$NEW_TRANSLATION = decode ($ENCODING, $TRANSLATION);
                #print "$TRANSLATION ...> $NEW_TRANSLATION\n$NEW_TRANSLATION ...> ";
                #$NEW_TRANSLATION = encode ( "utf8", decode("$ENCODING", $NEW_TRANSLATION ));
                #print "$NEW_TRANSLATION\n";
                #$NEW_TRANSLATION = encode ( "utf8", decode("$ENCODING", $TRANSLATION ));// works on terminal output
                #$NEW_TRANSLATION = $TRANSLATION;
            };
            if($@)
            {
                print "Error $ENCODING";
            }
            #<textarea name=q rows=5 cols=45 wrap=PHYSICAL>ailé de taureau</textarea>
            return "$PREFIX$NEW_TRANSLATION$SUFFIX";
        }
    }
    return "No translation ($LINE)";
}

sub wg_translation
{
    my($FILE) = @_;
#print "FILE: $FILE";
    if( ! open INPUT, "<$FILE" )
    {
        die("Unable to read $FILE\n");
    }
    my $LINE = "";
    my $NEW_LINES = "";
    while($LINE = <INPUT>)
    {
#print "LINE: $LINE";
        if( $LINE =~ /<base.*loc="(.*?)".*?>(.*?)</ )
        {
            my $OLD_LANGUAGE = $1;
#print "********        OLD_LANGUAGE: $OLD_LANGUAGE";
            my $STRING = $2;
            # this is a '/* ... */' line, copy it as is
            $NEW_LINES = $NEW_LINES . "$LINE";
            my $TEMP_LINES = "";
            while($LINE = <INPUT>)
            {
                if( $LINE =~ /<tran.*loc="(.*?)".*?>(.*?)</ )
                {
                    my $NEW_STRING = $2;
#print "NEW_STRING: <$NEW_STRING>";
                    if ( length $NEW_STRING == 0 )
                    {
                        my $NEW_LANGUAGE = $1;
                        my $TRANSLATION = translation $OLD_LANGUAGE, $NEW_LANGUAGE, $ENCODING, $STRING;
                        $LINE =~ s/>.*</>$TRANSLATION</;
                    }
                    $NEW_LINES = $NEW_LINES . "$LINE";
                    last;
                }
                else
                {
                    $NEW_LINES = $NEW_LINES . "$LINE";
                }
            }
        }
        else
        {
            $NEW_LINES = $NEW_LINES . "$LINE";
        }
    }
    close INPUT;
#    open(G, ">:utf8",                 "data.utf") or die $!;
    if(! open OUTPUT, ">$FILE" )
    {
        print "warning: iTeXMac2 ERROR: SILLY FAILURE WHILE OPENING $FILE...\n";# no need to go further
    }
    print OUTPUT "$NEW_LINES";
    close OUTPUT;
    return;
}
if( $ACTION =~ /^translate$/ )
{
    GetOptions ('f|from:s' => \$OLD_LANGUAGE, 't|to:s' => \$NEW_LANGUAGE, 'e|encoding:s' => \$ENCODING);
    if( length $OLD_LANGUAGE == 0)
    {
        $OLD_LANGUAGE="en";
    }
    if( length $NEW_LANGUAGE == 0)
    {
        $NEW_LANGUAGE="fr";
    }
    if( length $ENCODING == 0)
    {
        $ENCODING="iso-8859-1";
    }
    my $LINE = "";
    while ( $LINE = shift @ARGV )
    {
        my $RESULT = translation($OLD_LANGUAGE, $NEW_LANGUAGE, $ENCODING, $LINE);
        print "$RESULT\n";
    }
}
elsif( $ACTION =~ /^glossary$/ )
{
    GetOptions ('e|encoding:s' => \$ENCODING);
    if( length $ENCODING == 0)
    {
        $ENCODING="iso-8859-1";
    }
    my @LIST = ();
    undef %IS_ALREADY_IN_LIST;
    my $FILE = "";
    while($FILE = shift @ARGV)
    {
        $FILE = abs_path($FILE);
        if( $FILE =~ m|(.*)/([^/])*\.wg$|,)
        {
            my $DIR = $1;
            if ( -w "$DIR" )
            {
                if( $IS_ALREADY_IN_LIST{$FILE} != 1 )
                {
                    $IS_ALREADY_IN_LIST{$FILE} = 1;
                    @LIST = (@LIST, $FILE);
                }
                else
                {
                    print "$FILE is already in the list...";
                }
            }
            else
            {
                print "SORRY, \"$DIR\" is not writable...\n";
            }
        }
        elsif( -d $FILE )
        {
            print "Finding enclosed WGs:\nfind \"$FILE\" -regex \".*\\.wg\" -type f -print\n";
            my $FOUND = `find "$FILE" -regex ".*\.wg" -type f -print`;
            my @FILES = split /\n/, $FOUND;
            print "Result:\n$FOUND";
            while($FILE = shift @FILES)
            {
                $FILE = abs_path($FILE);
                if( $IS_ALREADY_IN_LIST{$FILE} != 1 )
                {
                    $IS_ALREADY_IN_LIST{$FILE} = 1;
                    @LIST = (@LIST, $FILE);
                }
                else
                {
                    print "$FILE is already in the list...";
                }
            }
        }
        else
        {
            print "*** Ignoring $FILE: it is neither a directory nor a .wg file\n";
        }
    }
    while($FILE = shift @LIST)
    {
        print "Processing $FILE\n";
        wg_translation $FILE;
        print "Processed $FILE\n";
    }
}
else
{
    glgUsage;
    exit 2;
}
#print "Saint-Cloud very moche...\n";
exit 0;
