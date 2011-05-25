# this is iTM2_Command_Clean for iTeXMac2 2.0
# © 2007 jlaurens AT users DOT sourceforge DOT net
notify('comment','Cleaning '+$launcher.project_name.basename.to_s)
f = $launcher.project_name.build_folder
if(f.exist?)
	FileUtils.rm_rf(f.to_s)
end
exit 0