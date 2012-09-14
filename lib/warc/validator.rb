require 'active_model'

module Warc
  class Validator < ::ActiveModel::Validator
    def validate(record)
      ["WARC-Record-ID","Content-Lenght","WARC-Date","WARC-Type"].each do |key|
        unless record.header.has_key?(key)
          record.errors[:base] << "#{key} is a required field"
        end
      end
    end
  end
end