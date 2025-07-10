$LOAD_PATH.unshift(__dir__)

module Yayaml
  DEBUG = false

  autoload :Command, "yayaml/command"
  autoload :Handler, "yayaml/handler"
  autoload :Matcher, "yayaml/matcher"
end
