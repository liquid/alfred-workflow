module Alfred
  class CachedFeedback < Feedback
    def initialize(alfred, &blk)
      super()
      @core = alfred

      instance_eval(&blk) if block_given?
    end

    def use_cache_file(opts = {})
      @cf_file = opts[:file] if opts[:file]
      @cf_file_valid_time = opts[:expire] if opts[:expire]
    end

    def cache_file
      @cf_file ||= File.join(@core.volatile_storage_path, "cached_feedback")
    end
    def get_cached_feedback
      return nil unless File.exist?(cache_file)
      if @cf_file_valid_time
        return nil if Time.now - File.ctime(cache_file) > @cf_file_valid_time
      end
      Feedback.load(@cf_file)
    end

    def put_cached_feedback
      dump(cache_file)
    end
  end
end