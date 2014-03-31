require 'rubygems'
require 'plist'
require 'yaml'
require 'time'

# Load config from Jekyll
cnf = YAML::load(File.open("_config.yml"))

# Settings
post_path = "_posts"
download_path = cnf['download_path'] == nil ? "_site/download" : cnf['download_path'] 
binary_path = cnf['binary_path'] == nil ? ".." : cnf['binary_path']
beta_indicator = cnf['beta_indicator'] == nil ? "b" : cnf['beta_indicator']

# Discover app name
app_name = nil
app_path = nil
Dir["#{binary_path}/*.app"].each do |path|
  app_name = path.sub("#{binary_path}/", "").sub(".app", "")
  app_path = path
  break
end

if app_name == nil
  puts "Couldn't find .app in #{app_path}/."
  exit
end

# Retrieve bundle info
plist = Plist::parse_xml("#{app_path}/Contents/Info.plist")
short_version = plist['CFBundleShortVersionString']
bundle_version = plist['CFBundleVersion']
is_beta = short_version.match(/#{beta_indicator}$/)

# Set filename and path
filename = "#{app_name}-v#{short_version}"
file_path = nil
file_format = nil
Dir["#{download_path}/#{filename}*"].each do |path|
  file_path = path
  file_format = File.extname(path).sub(".","")
  break
end

if file_path == nil
  puts "Please add the compressed update to #{download_path}."
  exit
end

# Check if the update has already been added
if Dir["#{post_path}/*v#{short_version}*"].length > 0
  puts "#{app_name} version #{short_version} has already been added."
  exit
end

# Retrieve compressed file info
file_size = File.size(file_path)

# Generate signature
unless File.exist?("#{binary_path}/sign_update.rb")
  puts "Couldn't find #{binary_path}/sign_update.rb."
  exit
end
unless File.exist?("#{binary_path}/dsa_priv.pem")
  puts "Couldn't find #{binary_path}/dsa_priv.pem."
  exit
end
signature = `ruby #{binary_path}/sign_update.rb #{file_path} #{binary_path}/dsa_priv.pem`.strip!

# Retrieve app file info
file_created = Time.parse(`mdls -name kMDItemContentCreationDate -raw #{file_path}`)
date = file_created.strftime('%Y-%m-%d')
time = file_created

# Store information in new post
File.open("#{post_path}/#{date}-v#{short_version}.md", 'w') { |file|
  file.write("---\n")
  file.write("layout: update\n")
  file.write("title: \n")
  file.write("time: #{time}\n")
  file.write("version: #{short_version}\n")
  file.write("bundle: #{bundle_version}\n")
  file.write("signature: #{signature}\n")
  file.write("file_size: #{file_size}\n")
  file.write("file: #{filename}.#{file_format}\n")
  if is_beta
    file.write("beta: true\n")
  end
  file.write("---\n\n")
  file.write("* Bugfix\n") 

  puts "#{app_name} v#{short_version} has been added."
}

# Add a symbolic link to the latest version
unless is_beta
  `cd #{download_path} && rm #{app_name}-latest.#{file_format} ; ln -s #{filename}.#{file_format} #{app_name}-latest.#{file_format}`
  puts "Added a symbolic link from #{filename}.#{file_format} to #{app_name}-latest.#{file_format}"
end