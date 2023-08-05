class ErrorSerializer
  include JSONAPI::Serializer

  def self.serialize(errors, status)
    {
      errors: [
        {
          status: status.to_s,
          title: "Record Invalid",
          detail: errors.message
        }
      ]
    }
  end
end
