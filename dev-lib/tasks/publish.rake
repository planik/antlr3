#!/usr/bin/ruby
desc('publish the package to rubyforge/gemcutter if the tests are clean')
# task 'publish' => %w(test package) do
task 'publish' do
  cmd = $project.expand(
    'rubyforge add_%s $(name) $(name) $(version) $(package.base)/$(name)-$(version).%s'
  )
  sh(format(cmd, release, gem))
  sh(format(cmd, file, zip))
  sh($project.expand('gem push $(package.base)/$(name)-$(version).gem'))
end
