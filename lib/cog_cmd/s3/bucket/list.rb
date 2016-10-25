require 's3/command'
require 's3/client'

module CogCmd::S3::Bucket
  class List < S3::Command
    def run_command
      require_valid_region!

      buckets = client.list_buckets

      if pattern
        buckets.select! { |b| matches_pattern?(b.name) }
      end

      response.template = 'bucket_list'
      response.content = buckets.map(&:to_h)
    end

    def matches_pattern?(string)
      Regexp.new(pattern).match(string)
    end

    def pattern
      request.args.first
    end
  end
end
