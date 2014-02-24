module Uas
  class Error < StandardError
  end

  class InternalError < Error
  end

  class InvalidCredentials < Error
  end

  class InvalidArguments < Error
  end

end