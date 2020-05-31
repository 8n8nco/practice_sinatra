# frozen_string_literal: true

module MemoApp
  class File
    attr_reader :name

    def initialize(name = created_time)
      @name = name
    end

    def read
      ::File.read(path)
    end

    def write(content)
      ::File.write(path, content)
    end

    def delete
      ::File.delete(path)
    end

    private
      def path
        "files/#{name}"
      end

      def created_time
        Time.now.strftime("%Y%m%d%H%M%S%N")
      end
  end
end
