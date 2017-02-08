require 'thor'
require 'creq'

class Promo < Thor
  include Thor::Actions

  desc "priority", "Create priority.csv file"
  def priority
    doc = get_document
    File.open('priority.csv', 'w') do |f|
      f.write "id;title;risk;effort;priority\n"
      doc.visit do |r|
        f.write "#{r.id};#{r.title};low;low;low\n"
      end
    end
    say "File 'priority.csv' created!"
  end

end
