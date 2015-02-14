class Place
  include ActiveModel::Model

  attr_accessor :id, :name, :status, :reviewlink, :proxylink, :blogmap, :street, :city, :state, :zip, :country, :phone, :overall, :imagecount

  #staattinen metodi
  def self.rendered_fields
  	[ :id, :name, :status, :street, :city, :zip, :country, :overall ]
  end

  def to_s
  	details = "#{name}, in #{city}, #{country}"
  end

  def address_to_s
    add = street + "\n"
    add << self.zip
    add << " " + self.city + "," + country
  end
end