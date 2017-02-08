# encoding: UTF-8
require_relative '../test_helper'

describe 'creq new PROJECT' do
  include FileUtils
  include Creq::Helper

  let(:command) { 'new' }
  let(:project) { 'demo'}

  it 'must create project' do
    inside_sandbox do
      rm_rf(Dir.glob("#{project}/*") << project) if Dir.exist?(project)
      proc {
        Cli.start [command, project]
      }.must_output /Project '#{project}' successfully created!/
      Dir.chdir("#{project}") do
        PROJECT_FOLDERS.each{|f| Dir.exist?(f).must_equal true }
        ["#{project}.thor", "README.md"]
          .each{|f| File.exist?(f).must_equal true }
      end
    end
  end

  # the second command execution bumps into unknown problem
  # it 'must abort operation if folder exists' do
  #   inside_sandbox do
  #     rm_rf(Dir.glob("#{project}/*") << project) if Dir.exist?(project)
  #     Dir.mkdir project
  #     proc {
  #       Cli.start [command, project]
  #     }.must_output /Project '#{project}' successfully created!/
  #
  #     proc {
  #       Cli.start [command, project]
  #     }.must_output /Directory '#{project}' already exists./
  #   end

  # end

end
