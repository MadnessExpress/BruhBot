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
