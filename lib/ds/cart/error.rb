module Ds
  module Cart

  class Error < StandardError
  end

  class InternalError < Error
  end

  class NotAuthorized < Error
  end

  class InvalidCredentials < Error
  end

  class InvalidArguments < Error
  end

  end
end
