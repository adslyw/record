module Record
  class Result
    include Enumerable
    attr_reader :columns, :rows, :column_types
    def initialize(columns, rows, column_types = {})
      @columns = columns
      @rows = rows
      @hash_rows = nil
      @column_types = column_types
    end

    def length
      @rows.length
    end

    def each
      if block_given?
        hash_rows.each { |row| yield row }
      else
        hash_rows.to_enum { @rows.size}
      end
    end

    def to_hash
      hash_rows
    end

    alias :map! :map
    alias :collect! :map

    def empty?
      rows.empty?
    end

    def to_array
      hash_rows
    end

    def [](idx)
      hash_rows[idx]
    end

    def last
      hash_rows.last
    end

    private

      def hash_rows
        @hash_rows ||=
          begin
            columns = @columns
            @rows.map { |row|
              hash = {}
              index = 0
              length = columns.length
              while index < length
                hash[columns[index]] = row[index]
                index += 1
              end
              hash
            }
          end
      end

  end
end
