module Warc
  class HeaderHash < ::Hash
    def initialize(hash={})
      super()
      @names = {}
      hash.each { |k, v| self[k] = v }
    end

    def each
      super do |k, v|
      yield(k, v.respond_to?(:to_ary) ? v.to_ary.join("\n") : v)
      end
    end

    def to_hash
      hash = {}
      each { |k,v| hash[k] = v }
      hash
    end

    def [](k)
      super(k) || super(@names[k.downcase])
    end

    def []=(k, v)
      canonical = k.downcase
      delete k if @names[canonical] && @names[canonical] != k # .delete is expensive, don't invoke it unless necessary
      @names[k] = @names[canonical] = k
      super k, v
    end

    def delete(k)
      canonical = k.downcase
      result = super @names.delete(canonical)
      @names.delete_if { |name,| name.downcase == canonical }
      result
    end

    def include?(k)
      @names.include?(k) || @names.include?(k.downcase)
    end

    alias_method :has_key?, :include?
    alias_method :member?, :include?
    alias_method :key?, :include?

    def merge!(other)
      other.each { |k, v| self[k] = v }
      self
    end

    def merge(other)
      hash = dup
      hash.merge! other
    end

    def replace(other)
      clear
      other.each { |k, v| self[k] = v }
      self
    end
  end
end