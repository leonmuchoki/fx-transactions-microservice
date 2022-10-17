require 'active_support/json'

class Float
    def as_json(options={})
      if options[:decimals]
        value = round(options[:decimals])
        (i=value.to_i) == value ? i : value
      else
        super
      end
    end
  end