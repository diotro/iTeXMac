# this is iTM2_Command_Compile.rb for iTeXMac2
# version 2iTM2ProjectDocumentKit.m: //=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  baseProjectName

# © 2006 jlaurens AT users DOT sourceforge DOT net
# Usage: not a standalone script

class CompileWrapper < CommandWrapper

	def execute(project)
		self.project = project
		# entry point
		# first consistency test
		if !master_name.extension.length?
			bail("The master file has no extension, I don't know what to do...")
		end
		# get the script mode for the master path name
		return if execute_in_mode($launcher.engine_mode)
		bail('There is no rule to Compile '+master_name.to_s) unless engines
		bail('No Compile action defined for '+master_name.to_s+', use the project settings panel') unless engine_mode.length?
		execute_in_mode(engine_mode)
	end
	
	def execute_in_mode(mode)
		if mode == "Base"
			cmd = 'iTM2_Compile_'+master_name.extension
			if system(cmd)
				exit 0
			else
				cmd+='.rb'
				$:.each{|p|
					q = Pathname.new(p)+cmd;
					if(q.exist?)
						load q.to_s
						return true
					end
				}
			end
		else
			# for example "iTM2_Engine_PDFTeX"
			# is it a custom script?
			if(script = engine_script_for_mode(mode))
				cmd = $iTM2+mode
				bail('! A script is ignored.')
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
					puts "iTM2: loading "+r.to_s
					load r.to_s
					puts "iTM2:"+r.to_s+' wrapper:'+$launcher.engine_wrapper.to_s
					return true
				end
			}
			system(cmd.to_s)
		end
	end

end
CompileWrapper.new.execute($launcher.project)
