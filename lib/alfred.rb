require 'rubygems' unless defined? Gem # rubygems is only needed in 1.8

require 'plist'
require 'fileutils'
require 'yaml'

require 'alfred/core'
require 'alfred/ui'
require 'alfred/errors'
require 'alfred/feedback'
require 'alfred/cached_feedback'

module Alfred
  class << self

    def with_friendly_error(alfred = Alfred::Core.new, &blk)
      begin
        yield alfred
      rescue AlfredError => e
        alfred.ui.error e.message
        alfred.ui.debug e.backtrace.join("\n")
        puts alfred.rescue_feedback(
          :title => "#{e.class}: #{e.message}") if alfred.with_rescue_feedback
        exit e.status_code
      rescue Interrupt => e
        alfred.ui.error "\nQuitting..."
        alfred.ui.debug e.backtrace.join("\n")
        puts alfred.rescue_feedback(
          :title => "Interrupt: #{e.message}") if alfred.with_rescue_feedback
        exit 1
      rescue SystemExit => e
        puts alfred.rescue_feedback(
          :title => "SystemExit: #{e.status}") if alfred.with_rescue_feedback
        exit e.status
      rescue Exception => e
        alfred.ui.error(
          "A fatal error has occurred. " \
          "You may seek help in the Alfred supporting site, "\
          "forum or raise an issue in the bug tracking site.\n" \
          "  #{e.inspect}\n  #{e.backtrace.join("  \n")}\n")
        puts alfred.rescue_feedback(
          :title => "Fatal Error!") if alfred.with_rescue_feedback
        exit(-1)
      end
    end

    # launch alfred with query
    def search(query = "")
      %x{osascript <<__APPLESCRIPT__
      tell application "Alfred 2"
        search "#{query.gsub('"','\"')}"
      end tell
      __APPLESCRIPT__}
    end
  end

end

