class User < ActiveRecord::Base
  validates_uniqueness_of :guid

  def to_json
    super
  end

end
