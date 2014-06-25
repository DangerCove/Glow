task :default => :preview

desc 'Add updates to site'
task :add do
  sh 'ruby glow.rb'
end

desc 'Build site with Jekyll'
task :build do
  jekyll 'build'
end

desc 'Build site, start server and watch for changes'
task :preview do
  jekyll 'serve --watch'
end

desc 'Setup the basics'
task :setup do
  sh 'bundle install'
  sh 'mkdir -p _posts/'
  sh 'mkdir -p _site/download'
  puts "---\nThat's it. Now add some files and type: rake add" 
end

desc 'Deploy the site'
task :deploy => [:build] do
  if File.exist?('_site/deploy.sh')
    sh 'cd _site && ./deploy.sh'
  else
    puts "First, create a deploy.sh script in _site/"
  end
end

def jekyll(opts = '')
  sh 'rm -rf _site/update'
  sh 'bundle exec jekyll ' + opts
end
