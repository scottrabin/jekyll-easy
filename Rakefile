require 'yaml'
config_file = 'jekyll-easy-config.yml'
config      = YAML::load(File.open config_file)
jekyll_config_file = './_config.yml'
jekyll_config = YAML::load(File.open jekyll_config_file)

def ask question, answers = nil, default = nil
	message = question
	message += " [#{answers.join '/'}]" if not answers.nil?
	message += " [default: #{default}]" if not default.nil?
	begin
		print message, ": "
		answer = STDIN.gets.chomp
	end until answers.nil? or answers.include? answer
	if not default.nil? and answer.length == 0
		default
	else
		answer
	end
end

def project_name repository_url
	repository_url[/\/([^\/]*?)(?:\.git)?$/, 1]
end

desc "Initialize your project's adaptation of Jekyll-Easy"
task :init do |t|
	repository_url = ask "Enter the read/write url for your Github repository (e.g. git@github.com:/scottrabin/jekyll-easy)"
	base_url       = ask "Enter the subdirectory your pages will be hosted from", nil, project_name(repository_url)

	# update the local configuration for the proper baseurl
	jekyll_config['baseurl'] = "/#{base_url}"
	File.open(jekyll_config_file, 'w') do |f|
		f.puts jekyll_config.to_yaml
	end

	# set the correct remote for this repository - if origin still points to the primary repository, rename origin
	if `git remote -v`.match /origin.+?scottrabin\/jekyll-easy/
		system "git remote rename origin jekyll-easy"
		system "git remote add origin #{repository_url}"
		system "git config branch.master.remote origin"
	end
	# move the gh-pages source to its own branch
	system 'git branch -m master gh-pages-source'
	# wipe the local deploy directory
	rm_r config['deploy_dir'], :force => true
	# clone the repository into that location
	system 'git', 'clone', repository_url, config['deploy_dir']
	# check out the appropriate branch, or create it if necessary
	cd config['deploy_dir'] do
		if `git branch -r` =~ /origin\/gh-pages/
			# if there is already a remote origin/gh-pages branch, set it up to track
			system 'git checkout -b gh-pages origin/gh-pages'
		else
			# otherwise, set it up as recommended by Github
			# https://help.github.com/articles/creating-project-pages-manually
			system 'git checkout --orphan gh-pages'
			system 'git rm -rf .'
		end
	end
end

desc "Synchronize your Jekyll compiled output to your deployed site files"
task :deploy do |t|
	# clear out the old files from the deploy subdirectory (except vendor)
	Dir["./#{config['deploy_dir']}/*"].each do |dir|
		rm_rf dir if not dir =~ Regexp.new(config['deploy_dir'] + '/vendor')
	end
	# rebuild the site
	system 'jekyll'
	# copy over the built site files
	cp_r "#{jekyll_config['destination']}/.", config['deploy_dir']
	# prep the commit
	cd config['deploy_dir'] do
		system 'git add . && git add -u && git commit'
	end
end

desc "Start a Jekyll server with the configured properties"
task :server => ['submodule:sync'] do |t|
	# copy the vendor files from the deploy directory to the source directory
	cp_r "#{config['deploy_dir']}/vendor/.", "#{config['source_dir']}/vendor"
	# run the server
	system 'jekyll --auto --server'
end

desc "Manage deployed site submodules"
namespace :submodule do
	desc "Add a submodule as vendor code"
	task :add do |t|
		repository = ask "Vendor repository url"
		module_name = ask "Local library name", nil, project_name(repository)

		# go into the deploy directory and add the module there
		cd config['deploy_dir'] do
			system "git submodule add #{repository} vendor/#{module_name}"
		end

		# sync the module
		Rake::Task['submodule:sync'].reenable
		Rake::Task['submodule:sync'].invoke
	end
	desc "Initialize and update any deploy submodules"
	task :sync do |t|
		cd config['deploy_dir'] do
			system 'git submodule init && git submodule update'
		end
	end
end
