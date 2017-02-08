# encoding: UTF-8
require 'pp'
require 'minitest/autorun'
require_relative '../../lib/creq'

def in_tmp
  Dir.chdir(Creq.root)
  Dir.mkdir('tmp') unless Dir.exist?('tmp')
  Dir.chdir('tmp'){ yield if block_given? }
end

describe 'gem cli' do
  include FileUtils

  let(:repo) {'test'}

  before do
    @gem_installed ||= /Creq v#{Creq::VERSION}/ =~ `creq -v`
    skip("Creq v#{Creq::VERSION} must be installed") unless @gem_installed
    in_tmp { rm_rf(Dir.glob("#{repo}/**/*") << repo) if Dir.exist?(repo) }
  end

  describe 'creq new' do
    it 'must create new folder and place project folders and files' do
      in_tmp do
        `creq new #{repo}`.must_match /'#{repo}' successfully created!/
        Dir.exist?("#{repo}/doc").must_equal true
        Dir.exist?("#{repo}/req").must_equal true
        Dir.exist?("#{repo}/lib").must_equal true
        Dir.exist?("#{repo}/tt").must_equal true
        File.exist?("#{repo}/req/contents.md").must_equal true
        File.exist?("#{repo}/#{repo}.thor").must_equal true
        File.exist?("#{repo}/README.md").must_equal true
      end
    end
  end

  describe 'creq promo' do
    it 'must copy promo project content and do doc, chk and req' do
      in_tmp do
        `creq new #{repo}`.must_match /'#{repo}' successfully created!/
        Dir.chdir(repo) do
          # HACK remove conflicted files
          rm ['README.md', 'req/contents.md']
          `creq promo`
          File.exist?("README.md").must_equal true
          File.exist?("promo.thor").must_equal true
          File.exist?("req/contents.md").must_equal true

          `creq doc`.must_match /'doc\/requirements.md' created/
          File.exist?("doc/requirements.md").must_equal true
          `creq chk` # .must_match /Everything is fine!/
          `creq req new.req.1 "New req 1"`.must_match /'req\/new.req.1.md' created/
        end
      end
    end
  end

end
