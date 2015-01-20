module Bandwidth
  CALL_PATH = 'calls'
  class Call
    extend ClientWrapper
    include ApiItem

  end
end
