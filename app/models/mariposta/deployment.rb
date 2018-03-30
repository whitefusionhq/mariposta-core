class Mariposta::Deployment
  attr_accessor :status

  def initialize(payload)
    self.status = payload["state"]
  end

  def building?
    status == "building"
  end

  def succeeded?
    status == "ready"
  end

  def failed?
    !(building? || succeeded?)
  end

  def display_status
    case
      when building?
        "building"
      when succeeded?
        "succeeded"
      when failed?
        "failed"
    end
  end
end
