$LOAD_PATH.unshift(__dir__)

module Yayaml
  autoload :Command, "yayaml/command"
  autoload :Handler, "yayaml/handler"
  autoload :Matcher, "yayaml/matcher"
end
