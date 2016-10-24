require 's3/command'
require 's3/client'

module CogCmd::S3::Bucket
  class List < S3::Command
    def run_command
      require_valid_region!

      buckets = client.list_buckets

      response.template = 'bucket_list'
      response.content = buckets.map(&:to_h)
    end
  end
end
