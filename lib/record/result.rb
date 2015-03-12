module Record
  class Result
    include Enumerable
    attr_reader :columns, :rows
    def initialize(columns, rows)
      @columns = columns
      @rows = rows.each{ |row| Row.new(row)}
    end
    alias :length :count
    def length
      @rows.length
    end

    def each
      if block_given?
        @rows.each { |row| yield row }
      else
        @rows.to_enum { @rows.size}
      end
    end

    def to_hash
      @rows
    end

    def empty?
      @rows.empty?
    end
    alias :to_array :to_a
    def to_array(column_names = false)
      rows_a = @rows.map{ |row| row.to_array}
      column_names ? [@columns].concat(rows_a) : rows_a
    end

    def [](idx)
      @rows[idx]
    end

    def last
      @rows.last
    end

    class Row
      def initialize(row)
        @row = row
      end
      def to_s(header = false)
        header ? [@row.keys,@row.values] : @row.values
      end
      def to_array
        @row.values
      end
      def method_missing(method)
        @row.fetch method.to_sym
      end
    end
  end
end
