require 'active_model'

module Warc
  class Record::Validator < ::ActiveModel::Validator
    def validate(header)
      ["WARC-Record-ID","Content-Length","WARC-Date","WARC-Type"].each do |key|
        unless header.has_key?(key)
          header.errors[:base] << "#{key} is a required field"
        end
      end
    end
  end
end