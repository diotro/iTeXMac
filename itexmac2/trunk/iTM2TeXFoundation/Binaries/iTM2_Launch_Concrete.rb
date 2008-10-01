# these are project utilities for iTeXMac2 1.0
# iTM2_Launch.rb loads this dependant script if it did not find a direct script engine
# The purpose is to create the common interface for all the possible actions
# © 2007 jlaurens AT users.sourceforge.net

require 'rexml/document'
include REXML

class Object

	def yes?
		false
	end
	
	def no?
		!yes?
	end
	
	def to_i
		0
	end
	
	def ok?
		!nil?
	end
	
	def length?
		false
	end
	
end

class String

	def yes?
		self == "1" or self == "true"
	end
	
	def length?
		length > 0
	end
	
	def properties
		if self =~ /(?:\((.*?)\))?([^\+-]*)(?:\+([^-]*))?(?:-(.*))?/
			return {'E'=>$1,'M'=>$2,'V'=>$4,'O'=>$3}
		end
		{}
	end
	
	def compare_properties(rhs)
		ps = self.properties
		lhs_mode = (ps['M'])?(ps['M']):('')
		lhs_output = (ps['O'])?(ps['O']):('')
		lhs_variant = (ps['V'])?(ps['V']):('')
		lhs_extension = (ps['E'])?(ps['E']):('')
		ps = rhs.properties
		rhs_mode = (ps['M'])?(ps['M']):('')
		rhs_output = (ps['O'])?(ps['O']):('')
		rhs_variant = (ps['V'])?(ps['V']):('')
		rhs_extension = (ps['E'])?(ps['E']):('')
		if(lhs_mode == "Default")
			if(rhs_mode == "Default")
				if(lhs_extension == rhs_extension || lhs_extension == "*" || rhs_extension == "*")
					if(lhs_variant == rhs_variant || lhs_variant == "*" || rhs_variant == "*")
						if(lhs_output == "*" || rhs_output == "*")
							return 0
						end
						return lhs_output <=> rhs_output
					end
					return lhs_variant <=> rhs_variant
				end
				return lhs_extension <=> rhs_extension
			end
			return -1
		elsif(rhs_mode == "Default")
			return +1
		elsif(lhs_mode == "Plain" || lhs_mode == "TeX")
			if(rhs_mode == "Plain" || rhs_mode == "TeX")
				if(lhs_extension == rhs_extension || lhs_extension == "*" || rhs_extension == "*")
					if(lhs_variant == rhs_variant || lhs_variant == "*" || rhs_variant == "*")
						if(lhs_output == "*" || rhs_output == "*")
							return 0
						end
						return lhs_output <=> rhs_output
					end
					return lhs_variant <=> rhs_variant
				end
				return lhs_extension <=> rhs_extension
			end
			return -1
		elsif(rhs_mode == "Plain" || rhs_mode == "TeX")
			return +1
		elsif(lhs_mode == rhs_mode || lhs_mode == "*" || rhs_mode == "*")
			if(lhs_extension == rhs_extension || lhs_extension == "*" || rhs_extension == "*")
				if(lhs_variant == rhs_variant || lhs_variant == "*" || rhs_variant == "*")
					if(lhs_output == "*" || rhs_output == "*")
						return 0
					end
					return lhs_output <=> rhs_output
				end
				return lhs_variant <=> rhs_variant
			end
			return lhs_extension <=> rhs_extension
		end
		return lhs_mode <=> rhs_mode
	end

end

class Hash

	def base_name
		result = ''
		if self['E'].length?
			result = "(#{self['E']})"
		end
		result += self['M']
		if self['O'].length?
			result += "+#{self['O']}"
		end
		if self['V'].length?
			result += "-#{self['V']}"
		end
		return result
	end
	
end

class Pathname

	def standard_directory
		p = to_s
		if(p=~/\/Projects.put_aside\/Projects(\/.*\/)[^\/]*\.texd\/(.*\.texp$)/)
			(Pathname.new($1)+$2).dirname
		elsif(p=~/\/Projects.put_aside\/Wrappers(\/.*\.texd\/.*\.texp$)/)
			Pathname.new($1).dirname
		elsif(p=~/\/Projects.put_aside(\/.*\/)[^\/]*\.texd\/(.*\.texp$)/)
			(Pathname.new($1)+$2).dirname
		else
			nil
		end
	end	

	def source_folder
		p = standard_directory
		q = p+'Source'
		return q if q.exist?
		p
	end

	def read_real_link
		candidate = readlink
		return candidate if candidate.absolute?
		Pathname.new(realpath).dirname+candidate
	end

	def pathname_by_appending_extension(extension)
		Pathname.new(to_s+'.'+extension)
	end

	def base?
		to_s =~ Regexp.new('^'+ENV['iTM2_Base_Projects_Directory'])
	end

end

class Named_document

	attr_accessor :name
	private_class_method :new

	def Named_document.documents
		nil
	end

	def Named_document.real_pathname(pathname)
		pathname
	end

	def Named_document.create(pathname)
		bail('Bad parameter: pathname must not be nil') if pathname.nil?
		bail('BUG: only subclassers are allowed to create!') if documents.nil?
		pathname = real_pathname(pathname)
		return documents[pathname] if documents.has_key?(pathname)
		documents[pathname] = new(pathname)
	end

	def initialize(pathname)
		bail('Bad parameter') if pathname.nil?
		self.name = pathname
		return self
	end

	def last_modification_time
		name.mtime
	end
THIS MODEL DESIGN IS BAD
	def model
		return @model if @model
		bail("Missing file at #{name.to_s}") if !name.exist?
		@model = Document.new(File.new(name.realpath))
		bail("No file at #{name.realpath}") if @model.nil?
		@model = @model.root.elements[1]# xml
		bail("Corrupted file at #{name.to_s}") if @model.nil?
		@model
	end

	def ==(rhs)
		return false if !rhs.is_a?(Named_document)
		name == rhs.name
	end

	def to_s
		"<#{super.to_s}\nname:#{name.to_s}\nmodel:#{(model)?(model.to_s):('None')}>"
	end

end

# This is the main Info.plist where we find relevant information about files
class Info < Named_document

	@@documents= Hash.new
	def Info.documents
		@@documents
	end

	def name=(pathname)
		@name = pathname+"Info.plist"
	end

	def main_key
		n = model.elements['key[text()="main"]'].next_element().get_text()
		return n.to_s if n
		""
	end
	def filename_for_key(key)
		n = model.elements['key[text()="files"]/following-sibling::dict[1]/child::key[text()="'+key+'"]'].next_element().get_text()
		return n.to_s if n
		nil
	end

	def each_file_name
		model.elements['key[text()="files"]/following-sibling::dict[1]'].each_element('key[!start_with(text(),"_")]'){
			|x|
			yield Pathname.new(filename_for_key(x.text.to_s))
		}
	end

	def source_folder
		(p = model.elements['key[text()="files folder"]'].next_element().get_text())?(p.to_s):(nil)
	end

end

# This is the command Info.plist where stands any information about engines.
class CommandInfo < Named_document

	@@documents= Hash.new
	def CommandInfo.documents
		@@documents
	end

	def CommandInfo.real_pathname(pathname)
		pathname+"frontends"+"comp.text.tex.iTeXMac2"+"Info.plist"
	end

	def command_mode_for_action(action)
		(n=model.elements['key[text()="Commands"]/following-sibling::dict[1]/child::key[text()="'+action+'"]/following-sibling::dict[1]/child::key[text()="ScriptMode"]'].next_element().get_text())?(n.to_s):("Base")
	end

	def command_script_for_mode(mode)
		return nil unless mode
		(n = model.elements['key[text()="CommandScripts"]/following-sibling::dict[1]/child::key[text()="'+mode+'"]/following-sibling::dict[1]/child::key[text()="content"]'].next_element().get_text())?(n.to_s):(nil)
	end

	def engine_for_name(name)	
		name = name.to_s
		# get all the keys of the Engines dictionary
		# try to match the given name
###		if keys = self.model.elements['key[text()="Engines"]/following-sibling::dict[1]/child::key']
### the above line is buggy in ruby 1.8.2 (2004-12-25) [universal-darwin8.0] (Mac OS X Tiger)
		if k = self.model.elements['key[text()="Engines"]/following-sibling::dict[1]/child::key[1]']
			keys = Array.new.push(k)
			while k = k.next_element
				keys.push(k) if k.name == 'key'
			end
### end of the workaround
			# return if there is an engine for that name
			keys.each{|k|
				return k.next_element if k.to_s == name
			}
			# return if there is an engine key matching that name
			keys.each{|k|
				return k.next_element if Regexp.new(k.to_s) =~ name
			}
			if name =~ /.*\.([^\.]*)/
				name = $1
				# return if there is an engine key for that name extension
				keys.each{|k|
					return k.next_element if k.text().to_s == name
				}
				# return if there is an engine key for that name extension, array version (ever used?)
				keys.each{|k|
					k.text().to_s.split(/ *, */).each{|l|
						return k.next_element if l == name
					}
				}
			end
		end
		nil
	end

	def engine_mode_for_name(name)
		if x = engine_for_name(name)
			return x.elements['child::key[text()="ScriptMode"]'].next_element().get_text().to_s
		end
		nil
	end

	def engine_script_for_mode(mode)
		return nil unless mode.length?
		(n = self.model.elements['key[text()="EngineScripts"]/following-sibling::dict[1]/child::key[text()="'+mode+'"]/following-sibling::dict[1]/child::key[text()="content"]'].next_element().get_text())?(n.to_s):(n)
	end

	def engine_environment_mode_for_name(name)
		if x = engine_for_name(name)
			return x.elements['child::key[text()="EnvironmentMode"]'].next_element().get_text().to_s
		end
		nil
	end

	def engine_environment_for_mode(mode)
		model.elements['key[text()="EngineEnvironments"]/following-sibling::dict[1]/child::key[text()="'+mode+'"]/following-sibling::dict[1]']
	end

	def engine_environment_for_name(name)
		if mode = engine_environment_mode_for_name(name)
			return model.elements['key[text()="EngineEnvironments"]/following-sibling::dict[1]/child::key[text()="'+mode+'"]/following-sibling::dict[1]']
		end
		nil
	end

	def to_s
		"<#{super.to_s}\nname:#{name.to_s}>"
	end

end

class Project < Named_document

	attr_accessor :master_name

	@@documents= Hash.new

	def Project.documents
		@@documents
	end

	def helper
		return @helper if @helper_is_set
		@helper_is_set = 1
		bail('No name for this project!') if name.nil?
		# if a project is put aside, it is has no helper, it is its own helper
		return nil if name.base?
		if !name.put_aside? and name.helper_name
			@helper = Project.create(name.helper_name)
		end
		@helper
	end

	def base_name
		n = command_info.model.elements['key[text()="BaseProjectName"]'].next_element().get_text()
		n = 'LaTeX' if ! n
		bail("Unknown base project named: #{n}\n you should change your project settings in\n#{p}.") if ! $launcher.base_project_names.include?(n.to_s)
		n.to_s
	end

	def all_base_names
		return @all_base_names if @all_base_names
		@all_base_names = $launcher.base_project_names_of base_name
	end

	def base
		bail("Deprecated")
	end

	def main_info
		return @main_info if @main_info
		@main_info = Info.create(name)
	end

	def command_info
		return @command_info if @command_info
		@command_info = CommandInfo.create(name)
	end

	def main_infos
		# the array of all available Infos.plist
		# It is sorted according to file modification date if the project is not writable
		# the first object is the most recent or the writable one
		# the last object MUST come from the base project
		return @main_infos if @main_infos
		@main_infos = Array.new
		@main_infos.push(main_info)
		if helper and helper.main_info
			@main_infos.push(helper.main_info)
			if !name.writable?
				@main_infos.sort!{|x,y| y.modification_time <=> x.modification_time }
			end
		end
		@main_infos.push(base.main_info) if base.main_info
		@main_infos
	end

	def all_commands
		return @all_commands if @all_commands
		@all_commands = Array.new
		command_infos.each{|infos|
			if dict = infos.model.elements["key[text()='Commands']/following-sibling::dict"]
				key = dict.elements["key"]
				while key
					@all_commands.push key.text
					key = key.elements["following-sibling::key"]
				end
			end
		}
		@all_commands.uniq!
		@all_commands
	end

	def all_engines
		return @all_engines if @all_engines
		@all_engines = Array.new
		command_infos.each{|infos|
			if dict = infos.model.elements["key[text()='Engines']/following-sibling::dict"]
				key = dict.elements["key"]
				while key
					@all_engines.push key.text
					key = key.elements["following-sibling::key"]
				end
			end
		}
		@all_engines.uniq!
		@all_engines
	end

	def command_infos
		# the array of all available commands Infos.plist
		# For the 2 first, it is sorted according to file modification date
		# the first object is the most recent
		# the other ones come from the base projects
		return @command_infos if @command_infos
		@command_infos = Array.new
		@command_infos.push(command_info)
		if helper.ok? and helper.command_info.ok?
			@command_infos.push(helper.command_info)
			if !name.writable?
				@command_infos.sort!{|x,y| y.modification_time <=> x.modification_time }
			end
		end
		# now list all the other stuff
		all_base_names.each{|name|
			$launcher.base_project_entries[name].each{|base|
				p = Pathname.new(ENV['iTM2_Base_Projects_Directory'])+base
				@command_infos.push(CommandInfo.create(p))
			}
		}
		@command_infos
	end

	def command_mode_for_action(action)
		command_infos.each {|info|
			if x = info.command_mode_for_action(action)
				return x
			end
		}
		"Base"
	end

	def command_script_for_mode(mode)
		command_infos.each {|info|
			if result = info.command_script_for_mode(mode)
				return result.to_s
			end
		}
		return nil
	end

	def build_folder
		return nil if name.base?
		return name.build_folder	
	end

	def job_name
		return @job_name if @job_name
		@job_name = Pathname.new(master_name.to_s.sub(/\.[^\.\/]*$/,''))	
	end

	def source_folder?(folder)
		# folder must ne a non nil full pathname
		main_info.each_file_name{|name|
			return folder if (folder+name).exist?
		}
		return nil
	end

	def source_folder
		# first explore what is available
		# the Source directory is the one containing all the source.
		# when relative, the files registered by the project are given relative to this directory.
		# This foo.texd/Source when the wrapper is not put aside
		# This is the directory pointed to by foo.texd/Source when the wrapper is put aside
		# This is foo/bar.texp/.. when the project is not put aside and is not enclosed in a TeX wrapper
		return @source_name if @source_name
		return nil if name.base?
		if @source_name = main_info.source_folder
			@source_name = name.dirname+@source_name
			return @source_name if @source_name.exist?
		end
		# no source folder was recorded in the main_info
		return @source_name = name.standard_directory if name.standalone?
		return nil if name.project.nil?
		d = name.dirname
		if(b = main_info.source_folder)
			@source_name = d+b
			return @source_name if source_folder?(@source_name)
		end
		d.each_entry{|b|
			@source_name = d+b
			return @source_name if source_folder?(@source_name)
		}
		@source_name = d
		return @source_name if source_folder?(@source_name)
		bail('!! this project has no valid Source folder... please try to fix this in the files project inspector.')
	end

	def to_s
		'<'+super.to_s+"\nname:"+name.to_s+"\nsource_folder:"+((source_folder)?(source_folder.to_s):'None')+"\nbuild_folder:"+((build_folder)?(build_folder.to_s):'None')+"\njob_name:"+((job_name)?(job_name.to_s):'None')+"\nmaster_name:"+((master_name)?(master_name.to_s):'None')+"\nhelper:"+((helper)?(helper.to_s):'None')+"\nbase:"+((base)?(base.to_s):'None')+"\n>"
	end

	def job_name
		Pathname.new(master_name.to_s.sub(/(\.[^\/\.]*$)/,''))
	end

	def setup_file_links
		# the purpose is to make a sym link in the build directory to all the files that are declared in the project
		main_info.each_file_name{|relative_file|
			next if(relative_file.absolute?) # we only link to relative files, absolute files should be managed by kpsewhich
			destination = source_folder+relative_file # the target of the link, the real file
			link = build_folder+relative_file # the link to the real file
			if(destination.symlink?)
				# do not symlink to a link that already points to the forthcoming new symlink, does not work...
				if ( relative_file == destination.readlink )
					puts "*********** WE SHOULD DEFINITELY IGNORE THIS"
					# shall we ever get there?
					next
				end
			end
			if(destination.exist?)
				# if there is something at the destination
				# Safety: do not remove the file named link if it is not a symlink
				File.delete(link) if link.symlink?
				if !link.exist?
					link.dirname.mkpath
					link.make_symlink(destination)
				end
			elsif(link.symlink?)
				File.delete(link)
			end
		}
	end

	def setup_master
		if master_name
			if !(build_folder+master_name).exist?
				# maybe the key was given instead of the file name
				self.master_name = main_infos.first.filename_for_key(master_name.to_s)
				if master_name.nil? or !(build_folder+master_name).exist?
					notify('error','The master file is not properly set up, please fix it.')
					bail("! bad master file")
				end
				# just in case there is a shortcut 
				return 1
			end
		else
			key = main_infos.main_key
			if key.nil?
				notify("error","Undefined master document in "+name.basename.to_s)
				bail("Missing required master document in project")
			end
			self.master_name = main_infos.filename_for_key(key)
			if master_name.nil?
				notify("error","Corrupted master document in "+name.basename.to_s)
				bail("Bad required master document in project")
			end
			# just in case there is a shortcut 
			return 1
		end
		return 0
	end
	
	def engines
		return @engines if @engines	
		@engines = Array.new
		command_infos.each do
			|info|
			if(engine = info.engine_for_name(master_name))
				@engines.push(engine)
			end
			if(engine = info.engine_for_name("__"))
				@engines.push(engine)
			end
		end
		@command_infos.each do
			|info|
			if(engine = info.engine_for_name("_"))
				@engines.push(engine)
			end
		end
	end
	
	def engine_script_for_mode(mode)
		command_infos.each{
			|info|
			if x=info.engine_script_for_mode(mode)
				# Found an engine script mode that is not "Base"
				return x
			end
		}
		nil
	end

	def engine_mode
		base = nil
		command_infos.each{
			|info|
			if x = info.engine_mode_for_name(master_name)
				# An engine script mode that is not "Base"?
				return x if  x != "Base"
				base = x unless base
			end
		}
		base
	end

	def engine_models
		return @engine_models if @engine_models
		# the engine models are XML documents that contain informations about engines
		# they are actually in the private folder but should be movedd somewhere else when sufficiently strong
		# There can be 2 data storages, one is a working project stored in the .put_aside folder
		# the other one is visible one, which means the one the user is expected to deal with from the finder.
		# If the visible project is not writable, we use a clone in the .put_aside folder, which is writable.
		# Some date management is required to deal with updates.
		# Remark: when opening a file which is not writable, we should ask the user to copy the file or folder(it depends)
		# somewhere writable...
		
		# where does it find information?
		# each engine has a dedicated environment.
		# The environments may appear in different locations and different part of the file.
		# Each environment is uniquely identified by a key, a string called the environment mode.
		# There are 2 reserved environment modes: "_" for default and "__" for common
		# common means shared by different environments
		# default means... default
		# It assumes that whenever an environment mode(including the common environment)is edited in a project,
		# the modification are also recorded in the default environment mode of that very same project
		# Environments with the same mode may appear in the different projects involved: source(normal), build and base.
		# There are some rules of inheritance for these environments:
		# assuming that newer, older represent build and base ordered by file modification date/write acces
		# base.default < older.default < newer.default < base.common < base.mode < older.common < older.mode < newer.common < newer.mode
		# This rule is not perfect but it works
		
		@engine_models = Array.new
		@command_infos.each do
			|info|
			if(model = info.engine_environment_for_name(master_name))
				@engine_models.push(model)
			end
			if(model = info.engine_environment_for_name("__"))
				@engine_models.push(model)
			end
		end
		@command_infos.each do
			|info|
			if(model = info.engine_environment_for_name("_"))
				@engine_models.push(model)
			end
		end
		@engine_models
	end
	
	def config(key,default=nil)# default should be a string!
		xpath = 'key[text()="'+key+'"]/following-sibling::*[1]'
		result = nil
		engine_models.each do
			|model|
			if(result = model.elements[xpath])
				break
			end
		end
		return default if result.nil?
		if(result.has_name?('false'))
			"0"
		elsif(result.has_name?('true'))
			"1"
		elsif(result = result.text())
			result.to_s
		else
			default
		end
	end

end

class CommandWrapper

	attr_accessor :project
	
	def method_missing(symbol,*args)
		project.send(symbol,*args)
	end

end

class EngineWrapper
	
	attr_accessor :project
	
	def key_prefix
		#subclassers will override this
		''
	end
	
	def method_missing(methId,*args)
		if args.length>1
			super.method_missing(methId,*args)
		elsif methId.id2name =~ /^_(.*)/
			if args.length>0
				config($1,args[0])
			else
				config($1)
			end
		end
	end

	def config(key,default=nil)
		result = project.config(key,default)
		return result if result != default
		result = project.config(key_prefix+key,default)
	end
		
	def verb
		#subclassers might want to override this
		type.to_s.sub(/Wrapper/,'').downcase
	end
	
	def engine_shortcut
		#subclassers will override this
		''
	end
	
	def engine(project)
		self.project = project
		@job = Pathname.new(project.master_name.to_s.sub(/\.[^\.\/]*$/,''))
		# This is the engine_shortcut wrapped
		preamble = <<EOF
#!/usr/bin/env ruby
# this is a one shot script, you might remove it safely, iTeXMac2 would recreate it on demand
$me = File.basename($0)
puts "iTM2: \#{$me} entrance: %.2f" % Time.now.to_f
require 'fileutils'
def notify(type,msg)
	system("iTeXMac2","notify",type,msg)
end
$pwd = "#{Pathname.pwd.to_s}"
Dir.chdir($pwd)
ENV['PATH'] = "#{ENV['PATH']}"
$project = "#{project.name.to_s}"
$source_folder = "#{project.source_folder.to_s}"
$master = "#{project.master_name.to_s}"
$job = "#{project.master_name.to_s.sub(/\.[^\.\/]*$/,'')}"
EOF
		postamble = <<EOF
puts "iTM2: \#{$me} exit: %.2f" % Time.now.to_f
EOF
		preamble+engine_shortcut+postamble
	end
	
end	

class Launcher
	
	attr_accessor :engine_wrapper
	
	def project
		return @project if @project
		@project = Project.create(project_name)# must exist, verification made in iTM2_Launch.rb
		@project.master_name = master_name
		@project
	end

	def execute_concrete
		project.setup_file_links
		execute if project.setup_master
		# the above can exit if the master has been resolved and has a command
		mode = project.command_mode_for_action(@action)
		if(mode == "Base")
			mode = project.base.command_mode_for_action(@action)
			if(mode == "Base")
				self.engine_wrapper = nil
				load 'iTM2_Command_'+@action+'.rb'
				if engine_wrapper.ok?
					# save engine_shortcut in shortcut
					shortcut.dirname.mkpath
					engine = engine_wrapper.engine(project)
					bail("! PLease report ERROR: No #{@action} action for #{project.master_name.to_s}") if !engine.length?
					file = File.new(shortcut.to_s,"w")
					file.puts(engine)
					self.engine_wrapper = nil
					file.close
					shortcut.chmod(0755)
					execute
					bail('Undefined or corrupted command at '+shortcut)
				end
				bail('PLEASE REPORT THIS BUG: the engine wrapper is missing!')
			else
				# is it the key of an embedded script?
				content = project.base.command_script_for_mode(mode)
				if(content)
					File.open(shortcut, "w"){
						|aFile|
						aFile.puts content
						File.chmod(0755, shortcut)
					}
					system(shortcut)
					puts "! DONE 2"
				else
					puts "! Nothing to execute in base"
					return "-1"
				end
			end
		else
			# is it the key of an embedded script?
			content = project.command_script_for_mode(mode)
			if(content)
				puts "Executing custom "+action
				File.open(shortcut, "w"){
					|aFile|
					aFile.puts content.text
					File.chmod(0755, shortcut)
				}
				system(shortcut)
				puts "! DONE 3"
			else
				puts "Nothing to execute"
				return "-1"
			end
		end
	end
	
	def base_project_entries
		return @base_project_entries if @base_project_entries
		@base_project_entries = Hash.new
		Dir.chdir(ENV['iTM2_Base_Projects_Directory'])
		Dir["*.texps"].each {|x|
			Dir.entries(x).each {|y|
				if /(^.*)\.texp$/ =~ y
					if ! @base_project_entries.key?($1)
						@base_project_entries[$1]=Array.new
					end
					@base_project_entries[$1].unshift(x+'/'+$1+'.texp')
				end
			}
		}
		return @base_project_entries
	end

	def base_project_names
		self.base_project_entries.keys
	end

	def base_project_names_of(name)
		result = Array.new
		result.push(name) if base_project_names.include?(name)
		ps = name.properties
		if(ps['M']=='Default')
		elsif(ps['M']=='TeX')
			ps['M']='Default'
			result.concat(base_project_names_of(ps.base_name))
		elsif(ps['M']=='Plain')
			ps['M']='TeX'
			result.concat(base_project_names_of(ps.base_name))
		else
			ps['M']='Plain'
			result.concat(base_project_names_of(ps.base_name))
		end
		ps = name.properties
		ps['E']=nil
		n = ps.base_name
		result.concat(base_project_names_of(n)) if n.length<name.length
		ps = name.properties
		ps['V']=nil
		n = ps.base_name
		result.concat(base_project_names_of(n)) if n.length<name.length
		ps = name.properties
		ps['O']=nil
		n = ps.base_name
		result.concat(base_project_names_of(n)) if n.length<name.length
		result.uniq!
		result.sort!{|x,y|
			y.compare_properties x
		}
		return result
	end

end
print "! What are the commands?
"
$launcher.project.all_commands.each{|cmd|
print "cmd:#{cmd}
"
}
print "! What are the engines?
"
$launcher.project.all_engines.each{|cmd|
print "ngs:#{cmd}
"
}
print "! What are the infos?
"
print $launcher.project.command_infos
print "
"
exit -1
$launcher.execute_concrete

