class String
  def numeric?
    begin
      Integer(self)
    rescue
      false # not numeric
    else
      true # numeric
    end
  end
end

class Object
  def blank?
    if self.nil? || self.empty?
      true # no value or nil value
    else
      false # numeric
    end
  end
end
