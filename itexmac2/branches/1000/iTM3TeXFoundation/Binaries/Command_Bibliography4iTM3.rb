# this is iTM2_Command_Compile.rb for iTeXMac2
# version 2
# © 2006 jlaurens AT users DOT sourceforge DOT net
# Usage: not a standalone script

class BibliographyWrapper < CommandWrapper

	def execute(project)
		self.project = project
		# entry point
		# first consistency test
		if !master_name.extension.length?
			bail('No extension given for the master file')
		end
		# get the script mode for the master path name
		bail('No rule to make the Bibliography of '+master_name.to_s) unless engines
		mode = script_mode
		bail('Bad settings, setup your project for '+master_name.to_s+' but do not use the Base engine') unless mode
		if mode == "Base"
			cmd = 'iTM2_Bibliography_'+master_name.extension
			if system(cmd)
				exit 0
			else
				cmd+='.rb'
				$:.each{|p|
					q = Pathname.new(p)+cmd;
					if(q.exist?)
						load q.to_s
						return
					end
				}
			end
		else
			# for example "iTM2_Engine_BibTeX"
			# is it a custom script?
			if(script = engine_script_for_mode(mode))
				cmd = $iTM2+mode
				#where.open("w"){
				#	|F|
				#	F.puts script
				#	where.chmod(0755)
				#}
			else
				cmd = Pathname.new(mode)
			end
			# then launch it
			q = cmd.to_s+'.rb'
			$:.each{|p|
				r = Pathname.new(p)+q;
				if(r.exist?)
				puts '!!!!load:'+r.to_s
					load r.to_s
					return
				end
			}
			system(cmd.to_s)
		end
	end

end

BibliographyWrapper.new.execute($launcher.project)



$me = File.basename($0)

puts "#{$me} entrance: %.2f" % Time.now.to_f

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
		@building = $pwd
		@minXRefs = '2'
		@type='Command'
		@command='Bibliography'
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
			@engine = "bibtex"
			if(@minXRefs.to_i>0)
				@engine = @engine+' -min-crossrefs='+@minXRefs
			end
			if(@quiet)
				@engine = @engine+' -terse'
			end
		end
	end
	
	def command_arguments
		args = " "
		cfg = config('iTM2_Bibliography_MinXReferences')
		if(cfg and (cfg.to_i>0))
			args+='-min-crossrefs='+cfg+' '
		elsif(@minXRefs.to_i>0)
			args+='-min-crossrefs='+@minXRefs+' '
		end
		cfg = config('iTM2_Bibliography_RunSilently')
		if(cfg != '0' or @quiet)
			args+='-terse '
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
		command = ""
		@root=@root.gsub(/(.*)?\..*/,'\1')
		if(@engine)
			command = @engine+' "'+@root+'.aux"'
		else
			args = self.command_arguments
			command = 'bibtex'+args+'"'+@root+'.aux"'
		end
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
		save_and_execute(text)
	end
	
	def summary
		puts '! @master:'
		puts @master
		puts '! @building:'
		puts @building
		puts '! @project:'
		puts @project
		puts '! @engine:'
		puts @engine
		puts '! @quiet:'
		puts @quiet
		puts '! @minXReferences:'
		puts @minXReferences
		puts '! @all:'
		puts @all
		puts '! @verbose:'
		puts @verbose
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
This is iTeXMac2 built in script to make the bibliography with BibTeX
© 2007 jlaurens AT users DOT sourceforge DOT net
Usage: #{$me} input options, where options are
       -h, --help: print this message and return.
       -e command, --engine command: replace bibtex by command.
           all other options are ignored.
           example: #{$me} --engine "bibtex -terse"
       -q, --quiet: runs silently.
       -x, --minXReferences: the minimum number of cross references.
       -v, --verbose: does nothing special yet.
       -a, --all: process all the possible .aux files (recursive deep search, unimplemented yet).
       input is either a filename.aux, a directory name, or the current directory when missing.
       The options given override some environment variables.
EOF
					puts out
					exit 0
				when '-e','--engine'
					i+=1
					system(__FILE__,'-h')if(i>=ARGV.length)
					@engine = ARGV[i]
				when '-q','--quiet'
					@quiet = true
				when '-x','--minXReferences'
					i+=1
					system(__FILE__,'-h')if(i>=ARGV.length)
					@minXReferences = ARGV[i]
				when '-a','--all'
					@all = true
				when '-v','--verbose'
					@verbose = true
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
