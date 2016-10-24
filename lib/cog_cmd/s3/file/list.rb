require 's3/command'
require 's3/client'

module CogCmd::S3::File
  class List < S3::Command
    def run_command
      require_valid_region!
      require_bucket!

      files = client.list_files(bucket)

      response.template = 'file_list'
      response.content = files.map(&:to_h)
    end

    def require_bucket!
      unless bucket
        raise(Cog::Error, 'Bucket not provided. Provide a bucket as the first argument.')
      end
    end

    def bucket
      request.args.first
    end
  end
end
