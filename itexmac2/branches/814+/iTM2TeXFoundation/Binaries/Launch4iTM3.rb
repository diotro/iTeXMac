#!/usr/bin/env ruby
# this is iTM2_Launch for iTeXMac2 1.0
# © 2007 jlaurens AT users.sourceforge.net
# setting the link
# Usage: see $me -h
# this should be called at least each time we execute something against a project
# this script should live in $iTM2_HOME/Library/TeX/bin/iTeXMac2.app/Contents/Frameworks/iTM2TeXFoundation.framework/bin/iTM2_Launch
# The purpose is:
# 1 - create shortcuts to standard location where iTeXMac2 expects to find bins.
# 2 - create building directories.
# 3 - Branch to the correct helper
# All information, except the action is given through the environment
#
#iTM2_CMD_Notify comment "iTM2: STARTING "#{$0}""

$Version_Launch = "2.0"
$me = File.basename("#{$0}")
puts "#{$me} entrance: %.2f" % Time.now.to_f
at_exit{
puts "#{$me} exit: %.2f" % Time.now.to_f
}

def bail(msg)
	puts "! ERROR in #{$me}: "+msg
	system("#{$0}",'-h')
	raise "See console"
end

# utility to log message to iTeXMac2
$notifier = ENV['iTM2_TemporaryDirectory']
if($notifier)
	$notifier+="/bin/iTeXMac2"
else
	$notifier="iTeXMac2"
end
def notify(type,msg)
	system($notifier,"notify",type,msg)
end

require 'fileutils'
require 'pathname'

$iTM2 = Pathname.new('iTM2')

class Pathname

	def standard_name
		p = to_s
		if( /\/Projects.put_aside\/Projects(\/.*)[^\/]*\.texd\/(.*\.texp$)/.match(p))
			Pathname.new($1)+$2
		elsif(/\/Projects.put_aside\/Wrappers(\/.*[^\/]*\.texd\/.*\.texp$)/.match(p))
			Pathname.new($1)
		else
			nil
		end
	end	

	def helper_name
		return self if(put_aside?)
		return nil if(!project?)
		return nil if writable?
		return Pathname.new(ENV['HOME'])+'Library/Application Support/iTeXMac2/Projects.put_aside/Wrappers'+to_s if(project_in_wrapper?)
		q = 'Library/Application Support/iTeXMac2/Projects.put_aside' + dirname.to_s
		r = basename.to_s
		q = Pathname.new(ENV['HOME'])+q+r.gsub('.texp','.texd')
		p = q+r
		return p if p.exist?
		q = q.enclosed_project_name
		return q if q
		return p
	end

	def put_aside?
		to_s =~ /.*\/iTeXMac2\/Projects\.put_aside\/.*/
	end

	def helper?
		to_s =~ /.*\/iTeXMac2\/Projects\.put_aside\/Projects\/.*/
	end

	def helper_in_wrapper?
		to_s =~ /.*\/iTeXMac2\/Projects\.put_aside\/Wrappers\/.*/
	end

	def standalone?
		(put_aside? and !helper? and !helper_in_wrapper?)
	end

	def project_in_wrapper?
		(to_s =~ /\.texd\/.*\.texp$/ and !put_aside?)
	end

	def project?
		return (to_s =~ /\.texp$/ and !put_aside?)
	end

	def build_folder
		return self+'Build' if project? and writable?
		return dirname+'Build' if project_in_wrapper? and dirname.writable? or put_aside?
		return h.dirname+'Build' if h=helper_name
		nil
	end

	def enclosed_project_name
		return nil if !exist?
		return self if /\.texp$/.match(realpath)
		each_entry{|p|
			return self+p if /\.texp$/.match(p.to_s)
		}
		nil
	end

	def enclosing_wrapper_name
		return nil if put_aside?
		if to_s =~ /(.*\.texd)\/.*\.texp$/
			return Pathname.new($1)
		end
		nil
	end

	def extension
		self.extname.downcase.gsub(/\./,'')
	end

	def smart_remove
		if(symlink?)
			File.delete(to_s)#remove the link, not what it points to
			bail("Could not delete file:"+realpath) if(exist?)
		elsif(exist?)
			delete
			bail("Could not delete file:"+realpath) if(exist?)
		end
	end
	
end

class Launcher

	attr_reader :project_name, :master_name, :action, :mode

	# initializer
	def initialize(project,action='Compile', master=nil, mode=nil)
		@project_name = (project)?(project.realpath):(Pathname.pwd)
		@project_name = @project_name.enclosed_project_name
		@project_name = @project_name.standard_name if @project_name.helper? or @project_name.helper_in_wrapper?
		@master_name = master;
		@action = action
		return self
	end
	
	def do_execute
		if(action == 'Clean')
			$:.unshift(File.dirname(__FILE__))
			load 'iTM2_Command_Clean.rb'
			exit -1# if the above script does not exit, this is an error
		end
		execute
	end
	
	def shortcut
		return @shortcut if !@shortcut.nil?
		@shortcut = $iTM2+'bin'+(@master_name.to_s+'.'+action+'.rb')
	end
	
	def execute
		build_folder.mkpath
		Dir.chdir(build_folder.realpath)
		exit 0 if system(shortcut.to_s)
		0
	end
	
	def build_folder
		if ! @build_folder
			@build_folder = @project_name.build_folder
		end
		@build_folder
	end

	def itexmac2_error(reason)
		system("iTeXMac2","error","-project",@project_name.to_s,"-reason",reason)
	end

	def setup_bin_links
		@counter = 0
		if ENV.key?('iTM2_TemporaryDirectory')
			link(ENV['iTM2_TemporaryDirectory'])
		end
		if ENV.key?('iTM2UseNetwork')
			link("/Network/Library/texmf")
			link("/Network/Library/TeX")
			link("/Network/Library/Application Support/iTeXMac2")
		end
		link("/Library/texmf")
		link("/Library/TeX")
		link("/Library/Application Support/iTeXMac2")
		link(File.dirname(File.dirname(__FILE__)))
		if ENV.key?('HOME')
			link(ENV['HOME']+"/Library/texmf")
			link(ENV['HOME']+"/Library/TeX")
			link(ENV['HOME']+"/Library/Application Support/iTeXMac2")
		end
		link(ENV['iTM2_PATH_Other_Programs'],nil)
		link(ENV['iTM2_PATH_TeX_Programs'],nil)
		link(ENV['iTM2_PATH_Prefix'],nil)
		p = ($iTM2+'bin:').to_s
		q = Regexp.escape(p)
		q = Regexp.new('(^'+q+'($|:)|:'+q+'(?=$|:))')
		ENV['PATH'] = p+':'+ENV['PATH'].gsub(q,'')
		$:.delete(p)
		$:.unshift(p)
	end

	def link(path,type='bin')
		return if path.nil? or path.length == 0
		link = $iTM2+@counter.to_s
		destination = Pathname.new(path)
		if !type.nil?
			destination = destination+type
		end
		if(destination.directory?)
			link.smart_remove
			link.dirname.mkpath
			link.make_symlink(destination)
			link = link.to_s
			$:.delete(link)
			$:.unshift(link)
			p = link
			q = Regexp.escape(p)
			q = Regexp.new('(^'+q+'($|:)|:'+q+'(?=$|:))')
			ENV['PATH'] = p+':'+ENV['PATH'].gsub(q,'')
			@counter += 1
		end
	end

end

require 'pp'
pp ENV
pp ARGV

# parsing arguments
i = 0
while i < ARGV.length
	case(ARGV[i])
		when '-v', '--version'
			puts $Version_Launch
			exit 0
		when '-h', '--help'
			puts <<EOF
! Usage: #{$me} --project PROJECT --action ACTION --master MASTER
ACTION is one of Compile, Typeset, Index...
PROJECT is the path of a project
MASTER is the master of the project...
or #{$me} [--version] [--help]
EOF
			exit 0
		when '-a', '--action'
			i+=1
			if i < ARGV.length
				$action = ARGV[i]
				i+=1
			else
				system("#{$0}",'-h')
				puts "! Error: "+$me+" "+ARGV.join(' ')+": Missing an action name, please report the problem.\n"
				exit 0
			end
		when '-p', '--project'
			i+=1
			if i < ARGV.length
				$project_name = Pathname.new(ARGV[i])
				i+=1
			else
				system("#{$0}",'-h')
				puts "! Error: "+$me+" "+ARGV.join(' ')+": Missing a project path, please report the problem.\n"
				exit 0
			end
		when '-m', '--master'
			i+=1
			if i < ARGV.length
				$master_name = Pathname.new(ARGV[i])
				i+=1
			else
				system("#{$0}",'-h')
				puts "! Error: "+$me+" "+ARGV.join(' ')+": Did you specify a master file in the project documents window?\n"
				exit 0
			end
		when '-e', '--engine'
			i+=1
			if i < ARGV.length
				$engine_mode = ARGV[i]
				$action = 'Compile'
				i+=1
			else
				system("#{$0}",'-h')
				puts "! Error: "+$me+" "+ARGV.join(' ')+": Missing an engine name, please report the problem.\n"
				exit 0
			end
	end
end
$launcher = Launcher.new($project_name,$action,$master_name,$engine_mode)
$launcher.do_execute
$launcher.setup_bin_links
# known public variables
# $launcher
puts "Creating shortcut:"+$launcher.shortcut.to_s
load 'Launch_Concrete4iTM3.rb'
#
$launcher.execute