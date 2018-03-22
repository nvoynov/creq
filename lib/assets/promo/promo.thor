require 'thor'
require 'creq'

class Promo < Thor
  include Thor::Actions
  include Creq

end
