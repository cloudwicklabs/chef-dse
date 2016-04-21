
## Uncomment to clear the screen before every task
guard 'rake', :task => 'style' do
  watch('Gemfile')
  watch(%r{.+\.rb$}) { |m| m[0] }
  watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
end

guard 'rake', :task => 'spec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch('spec/spec_helper.rb')  { 'spec' }
  watch(%r{^(libraries|providers|recipes|resources)/(.+)\.rb$}) { |m| "spec/#{m[2]}_spec.rb"  }
end
