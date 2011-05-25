#!/usr/bin/env bash
# this is iTM2_Index for iTeXMac2
# © 2007 jlaurens AT users DOT sourceforge DOT net

$me = File.basename($0)

require 'rexml/document'
include REXML

$pwd = `pwd`.chomp
$project = File.dirname($pwd)

# on unrecoverable error
def bail(msg)
	puts "! ERROR in #{$me}: "+msg
	raise "See console"
end

# utility to log message to the notifier
$notifier = 'iTeXMac2'
def notify(type,msg)
	if($notifier)
		system($notifier,"notify",type,msg)
	end
end

$Version = "2.0"

module Model

	def initialize_model
		info = $project+"/frontends/comp.text.tex.iTeXMac2/Info.plist"
		bail("Corrupted project, missing file at: "+info) if (!FileTest.exist?(info))
		document = Document.new(File.new(info))
		@model = document.root.elements[1]
		name = @model.elements['key[text()="BaseProjectName"]/following-sibling::string[1]/text()']
		bail("Corrupted project, bad file at: "+info) if (!name)
		info = ENV['iTM2_Base_Projects_Directory']+"/#{name}.texp/frontends/comp.text.tex.iTeXMac2/Info.plist"
		@base = Document.new(File.new(info)).root.elements[1]
	end

	def mode(model,kind,type=@type,command=@command)
		xpath = 'key[text()="'+type+'s"]/following-sibling::dict[1]/key[text()="'+command+'"]/following-sibling::dict[1]/key[text()="'+kind+'Mode"]/following-sibling::string[1]'
		if(result = model.elements[xpath])
			result=result.to_s
		end
		result
	end

	def initialize_env(kind)
		@env = mode(@model,kind)
		@is_basic = true
		if(@env == 'Base')
			if(@env = mode(@base,kind))
				if(@env == 'Base')
					@env = nil
				end
			end
		else
			@is_basic = false
		end
		@env
	end

	def config(key,type=@type,env=@env)
		xpath_ = 'key[text()="'+type+'Environments"]/following-sibling::dict[1]/key[text()="_"]/following-sibling::dict[1]/key[text()="'+key+'"]/following-sibling::*[1]'
		if(@is_basic or !(result = @model.elements[xpath_]))
			xpath = 'key[text()="'+type+'Environments"]/following-sibling::dict[1]/key[text()="'+env+'"]/following-sibling::dict[1]/key[text()="'+key+'"]/following-sibling::*[1]'
			if(@is_basic or !(result = @model.elements[xpath]))
				xpath__ = 'key[text()="'+type+'Environments"]/following-sibling::dict[1]/key[text()="__"]/following-sibling::dict[1]/key[text()="'+key+'"]/following-sibling::*[1]'
				if(@is_basic or !(result = @model.elements[xpath__]))
					if(!(result = @base.elements[xpath_]) and !(result = @base.elements[xpath]) and !(result = @base.elements[xpath__]))
						return '0'
					end
				end
			end
		end
		if(result.has_name?('false'))
			'0'
		elsif(result.has_name?('true'))
			'1'
		elsif(result = result.text())
			result.to_s
		else
			'0'
		end
	end

	def save_and_execute(script)
		path = 'iTM2/bin/'+@master+'.'+@command
		file = File.new(path,"w")
		file.puts(script)
		file.close
		File.chmod(0755,path)
		if(system(path))
			exit -1
		end
		exit 0
	end

end


class Launcher

	include Model

	def initialize()
		super()
		@master = nil
		@type='Command'
		@command='Index'
		parse_arguments
		initialize_model
		if(!initialize_env('Environment'))
			@env = 'iTM2_Engine_BibTeX'
		end
		setup_model
		execute
	end
	
	def setup_model
		if(!@master)
			@all = true
			@master = `pwd`.chomp
			@root = @master
		elsif(FileTest.directory?(@master))
			@all = true
			@root = @master
		elsif(@all and ! FileTest.directory?(@master))
			@root = File.dirname(@master)
		else
			@root = @master
		end
		if(!@engine)
			@engine = "makeindex"
			if(@minXRefs.to_i>0)
				@engine = @engine+' -min-crossrefs='+@minXRefs
			end
			if(@quiet)
				@engine = @engine+' -terse'
			end
		end
	end
	
	def execute
		if(@all)
			execute_all
		else
			execute_one
		end
	end
	
	def execute_all
		puts '! ALL: DO NOTHING'
	end
	
	def execute_one
		puts '! ONE'
		@root=@root.gsub(/(.*)?\..*/,'\1')
		command = @engine+' "'+@root+'.aux"'
		puts command.gsub(/"/,'\"')
		path = "iTM2/bin/"+@master+".Index"
		file = File.new(path,"w")
		text = <<EOF
#!/usr/bin/env ruby
# this is a one shot script, you might remove it safely, iTeXMac2 would recreate it on demand
$me = File.basename($0)
puts "\#{$me} entrance: %.2f" % Time.now.to_f
def notify(type,msg)
	system("iTeXMac2","notify",type,msg)
end
$pwd = "#{$pwd}"
Dir.chdir($pwd)
ENV['PATH'] = "#{ENV['PATH']}"
command = "#{command.gsub(/"/,'\"')}"
notify("comment","Performing \#{command}")
system(command)
puts "\#{$me} exit: %.2f" % Time.now.to_f
exit $?
EOF
		file.puts(text)
		file.close
		File.chmod(0755,path)
		system(path)
	end

	def parse_arguments
		system($0,"-h") if (ARGV.length<1)
		@master = ARGV[0]
		if ( /^-/.match(@master) )
			i = 0
			@master = nil
		else
			i = 1
		end
		while(i<ARGV.length)
			case(ARGV[i])
				when '-v', '--version'
					puts $Version
					exit 0
				when '-h', '--help'
					out = <<EOF
Welcome to #{$me} version #{$Version}
This is iTeXMac2 built in script to make the index with makeindex
© 2007 jlaurens AT users DOT sourceforge DOT net
Usage: #{$me} input options, where options are
       -h, --help: print this message and return.
       -v, --version: print the version and return.
       -c, --compress-intermediate-blanks: By default, blanks in the index key are retained.
       -g, --german-ordering: in accord with rules set forth in DIN 5007.
           see makeindex manual for problems with German TeX commands like \"a, \"o...
       -l, --letter-ordering: blanks don't count.
       -o name, --output name: a number or one of 'any', 'odd', 'even'.
       -p, --starting-page-number: a number or one of 'any', 'odd', 'even'.
       -q, --quiet: runs silently.
       -r, --no-implicit-page-range: disable implicit page range formation.
       -s, --style styleFile: Employ styleFile as the style file.
       -t, --log logFile: Employ logFile as the log file.
       -L: not available.
       -T: not available.
       -e command, --engine command: replace #{$me} by command.
           all other options are ignored.
           example: #{$me} --engine \"makeindex --quiet\"
EOF
					puts out
					exit 0
				when '-e','--engine'
					i+=1
					system($0,'-h')if(i>=ARGV.length)
					@engine = ARGV[i]
				when '-c,','--compress-intermediate-blanks'
					@compress = true
				when '-g','--german-ordering'
					@german = true
				when '-l','--letter-ordering'
					@letter = true
				when '-o','--output'
					i+=1
					system($0,'-h')if(i>=ARGV.length)
					@output = ARGV[i]
				when '-p','--starting-page-number'
					i+=1
					@IsSeparate = true
					system($0,'-h')if(i>=ARGV.length)
					@starting = ARGV[i]
					case(@starting)
						when 'any','even','odd'
							@separate_mode = true
						when /.*/
							@separate_start = true
					end
				when '-r','--no-implicit-page-range'
					@no_implicit = true
				when '-s','--style'
					i+=1
					system($0,'-h')if(i>=ARGV.length)
					@style = ARGV[i]
				when '-t','--log'
					i+=1
					system($0,'-h')if(i>=ARGV.length)
					@log = ARGV[i]
				when /.*/
					puts "Error: "+ARGV[i]
					system($0,"-h")
					exit -1
			end
			i+=1
		end
	end

end

Launcher.new

puts "#{$me} exit: %.2f" % Time.now.to_f

#####iTM2_INDEX_USAGE="Welcome to `basename "$0"` version #{$Version}
#####This is iTeXMac2 built in script to make the index with MakeIndex
#####© 2007 jlaurens AT users DOT sourceforge DOT net
#####Usage: `basename "$0"` options input where options are
#####       -h, --help: print this message and return.
#####       -c, --compress-intermediate-blanks: By default, blanks in the index key are retained.
#####       -g, --german-ordering: in accord with rules set forth in DIN 5007.
#####           see makeindex manual for problems with German TeX commands like \"a, \"o...
#####       -l, --letter-ordering: blanks don't count.
#####       -o name, --output name: a number or one of any, odd, even.
#####       -p, --starting-page-number: a number or one of any, odd, even.
#####       -q, --quiet: runs silently.
#####       -r, --no-implicit-page-range: disable implicit page range formation.
#####       -s, --style styleFile: Employ styleFile as the style file.
#####       -t, --log logFile: Employ logFile as the log file.
#####       -L: not available.
#####       -T: not available.
#####       -e command, --engine command: replace `basename "$0"` by command.
#####           all other options are ignored.
#####           example: `basename "$0"` --engine \"makeindex --quiet\"
#####       The options given override some environment variables."
#####@Engine=""
#####IFS='
#####'
#####iTM2_VAR="${TWSMaster:=""}"
#####@RunSilently="${iTM2_RunSilently}"
#####while [ $# -gt 0 ]
#####do
#####	case $1 in
#####		-h|--help)
#####				"${iTM2_CMD_Notify}" notify comment "$iTM2_INDEX_USAGE"
#####		;;
#####		-e|--engine)
#####			shift 1
#####			if [ $# -gt 0 ]
#####			then
#####				@Engine="$1"
#####				"${iTM2_CMD_Notify}" notify comment "engine: $@Engine"
#####			else
#####				"${iTM2_CMD_Notify}" notify comment "$iTM2_INDEX_USAGE"
#####			fi
#####		;;
#####		-q|--quiet)
#####			@RunSilently="YES"
#####		;;
#####		-c|--compress-intermediateBlanks)
#####			@CompressBlanks="YES"
#####		;;
#####		-g|--german-ordering)
#####			@GermanOrdering="YES"
#####		;;
#####		-l|--letter-ordering)
#####			@LetterOrdering="YES"
#####		;;
#####		-p|--starting-page-number)
#####			@IsSeparate="YES"
#####                        shift 1
#####                        case $1 in
#####                                any|even|odd)
#####                                        @SeparateMode="$1"
#####                                ;;
#####                                *)
#####                                        @SeparateStart="$1"
#####                        esac
#####		;;
#####		-r|--no-implicit-page-range)
#####			@NoImplicitPageRange="YES"
#####		;;
#####		-s|--style)
#####			@UseStyle="YES"
#####                        shift 1
#####			@Style="$1"
#####		;;
#####		-t|--log)
#####			@UseLog="YES"
#####                        shift 1
#####			@Log="$1"
#####			="YES"
#####		;;
#####		-o|--output)
#####			@UseOutput="YES"
#####                        shift 1
#####			@Output="$1"
#####		;;
#####		*)
#####			if [ ${#@Targets} -gt 0 ]
#####			then
#####				@Targets="$iTM2_Index_Targets$IFS"
#####			fi
#####			if [ -d ${1} ]
#####			then
#####				@Targets="$iTM2_Index_Targets`ls -1 -R $1`"
#####			else
#####				@Targets="$iTM2_Index_Targets$1"
#####			fi
#####	esac
#####	shift 1
#####done
#####if [ "${@RunSilently:-1}" -eq 0 ]
#####then
#####        "${iTM2_CMD_Notify}" notify error "Welcome to `basename "$0"` version $@Version
#####This is iTeXMac2 built in script to make the index with MakeIndex or another engine
#####© 2005 jlaurens AT users DOT sourceforge DOT net"
#####fi
#####if [ ${#@Engine} == 0 ]
#####then
#####	@Engine="makeindex"
#####	if [ "${@RunSilently:-0}" -gt 0 ]
#####	then
#####		@Engine="${iTM2_Index_Engine} -q"	
#####	fi
#####	if [ "${@CompressBlanks:-0}" -gt 0 ]
#####	then
#####		@Engine="${iTM2_Index_Engine} -c"	
#####	fi
#####	if [ "${@GermanOrdering:-0}" -gt 0 ]
#####	then
#####		@Engine="${iTM2_Index_Engine} -g"	
#####	fi
#####	if [ "${@LetterOrdering:-0}" -gt 0 ]
#####	then
#####		@Engine="${iTM2_Index_Engine} -l"	
#####	fi
#####	if [ "${@NoImplicitPageRange:-0}" -gt 0 ]
#####	then
#####		@Engine="${iTM2_Index_Engine} -r"	
#####	fi
#####fi
#####if [ ${#@Targets} == 0 ]
#####then
#####	if [ ${#TWSMaster} == 0 ]
#####	then
#####		@Targets="`ls -1 -R *`$IFS"
#####	elif [ "${@All:-0}" -gt 0 ]
#####	then
#####		@Targets="`dirname ${TWSMaster}|ls -1 -R`$IFS"
#####	else
#####		@Targets="${TWSMaster%.*}.idx"
#####	fi
#####fi
#####@Current=""
#####for @Var in ${iTM2_Index_Targets}; do
#####	if [ ${@Var##*.} == "idx" ]
#####	then
#####		if [ ${#@Current} -gt 0 ]
#####		then
#####			@Var="${iTM2_Index_Current}/${iTM2_Index_Var}"
#####		fi
#####                "${iTM2_CMD_Notify}" notify comment "Making the index of: ${@Var}"
#####		if [ -e "${@Var}" ]
#####		then
#####			"${iTM2_CMD_Notify}" notify start comment
#####			if [ "${@Var%.*}.tex" -nt "${iTM2_Index_Var}" ]
#####			then
#####				"${iTM2_CMD_Notify}" notify error "The LaTeX source file ${@Var%.*}.tex is newer than ${iTM2_Index_Var}.
#####LaTeX index ${@Var%.*}.idx not updated: Please compile first."
#####			elif [ "${@Var}" -nt "${iTM2_Index_Var%.*}.ind" ]
#####			then
#####				iTM2_IndexCommand="${@Engine} \"${iTM2_Index_Var%.*}\""
#####				"${iTM2_CMD_Notify}" notify echo "${iTM2_IndexCommand}"
#####				eval "${iTM2_IndexCommand}"
######touch "${@Var%.*}.idx"
#####				"${iTM2_CMD_Notify}" notify echo "LaTeX index ${@Var%.*}.ind updated";
#####			else
#####				"${iTM2_CMD_Notify}" notify echo "LaTeX index ${@Var%.*}.ind is already up to date";
#####			fi
#####			"${iTM2_CMD_Notify}" notify stop comment
#####		fi
#####	else
#####		@Var1="`dirname ${iTM2_Index_Var}`/`basename ${iTM2_Index_Var} ":"`"
#####		if [ "${@Var}" == "${iTM2_Index_Var1}:" ]
#####		then
######			echo "this is a directory"
#####			@Current="${iTM2_Index_Var1}"
######			echo "$@Current"
#####		fi
#####	fi
#####done
#####if [ "${@RunSilently:-1}" -eq 0 ]
#####then
#####        "${iTM2_CMD_Notify}" notify comment "`basename "$0"` complete"
#####fi
#####exit


