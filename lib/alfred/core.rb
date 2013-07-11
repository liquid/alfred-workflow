module Alfred
  class Core
    attr_accessor :with_rescue_feedback

    def initialize(with_rescue_feedback = false, &blk)
      @with_rescue_feedback = with_rescue_feedback

      instance_eval(&blk) if block_given?
    end

    def ui
      raise NoBundleIDError unless bundle_id
      @ui ||= LogUI.new(bundle_id)
    end

    def setting(&blk)
      @setting ||= Setting.new(self, &blk)
    end

    def with_cached_feedback(&blk)
      @feedback = CachedFeedback.new(self, &blk)
    end

    def feedback
      raise NoBundleIDError unless bundle_id
      @feedback ||= Feedback.new
    end

    def info_plist
      @info_plist ||= Plist::parse_xml('info.plist')
    end

    # Returns nil if not set.
    def bundle_id
      @bundle_id ||= info_plist['bundleid'] unless info_plist['bundleid'].empty?
    end

    def volatile_storage_path
      raise NoBundleIDError unless bundle_id
      path = "#{ENV['HOME']}/Library/Caches/com.runningwithcrayons.Alfred-2/Workflow Data/#{bundle_id}"
      unless File.exist?(path)
        FileUtils.mkdir_p(path)
      end
      path
    end

    # Non-volatile storage directory for this bundle
    def storage_path
      raise NoBundleIDError unless bundle_id
      path = "#{ENV['HOME']}/Library/Application Support/Alfred 2/Workflow Data/#{bundle_id}"
      unless File.exist?(path)
        FileUtils.mkdir_p(path)
      end
      path
    end


    def rescue_feedback(opts = {})
      default_opts = {
        :title    => "Failed Query!",
        :subtitle => "Check the log file below for extra debug info.",
        :uid      => 'Rescue Feedback',
        :icon     => {
          :type => "default" ,
          :name => "/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/AlertStopIcon.icns"
        }
      }
      opts = default_opts.update(opts)

      items = []
      items << Feedback::Item.new(opts[:title], opts)
      items << Feedback::FileItem.new(ui.log_file)

      feedback.to_alfred('', items)
    end
  end
end