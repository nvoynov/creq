# encoding: UTF-8

require_relative 'settings'

module Creq

  # All commands retrive nothing/info or exception
  class ReqCommand

    def self.call(id, title = '', template = nil)
      title = id if title.empty?
      body = ''

      file_name = "#{Settings::REQ}/#{id}.md"
      raise CreqCmdError, FILE_EXISTS % file_name if File.exist?(file_name)

      if template
        body = read_template_body(template)
        body = replace_macros(body, {id: id, title: title})
      end

      req = Requirement.new(id: id, title: title, body: body)
      File.open(file_name, 'w') { |f| Writer.(req, f) }
      return file_name
    end

    protected

    def self.read_template_body(template)
      template_file = "#{Settings::TT}/#{template}"
      template_file += '.md.tt' unless File.exist?(template_file)
      raise CreqCmdError, TT_NOT_FOUND % template unless File.exist?(template_file)

      body = File.read(template_file)
      TT_WARNING % template_file + body
    end

    def self.replace_macros(body, params)
      new_body = String.new(body)
      new_body.gsub!('@@id', params[:id])
      new_body.gsub!('@@title', params[:title])
      new_body
    end

    TT_NOT_FOUND = "Template file '%s' is not found.".freeze
    FILE_EXISTS  = "File '%s' already exists. Command aborted.".freeze
    TT_WARNING = "TODO: The contents of this file were generated automatically based on '%s'\n\n".freeze
  end

end
