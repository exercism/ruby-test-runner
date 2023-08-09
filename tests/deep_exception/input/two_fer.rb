module TwoFer
  def self.two_fer(name = nil)
    "One for #{work_out_name(name)}, one for me"
  end

  def self.work_out_name(name)
    # raise "FoobaR"
    name.non_existant_method
  end
end
