require 's3/command'
require 's3/client'

module CogCmd::S3::File
  class Destroy < S3::Command
    def run_command
      require_valid_region!
      require_bucket!
      require_key!

      file = client.destroy_file(bucket, key)

      response.template = 'file_destroy'
      response.content = [file.to_h]
    end

    def require_bucket!
      unless bucket
        raise(Cog::Error, 'Bucket not provided. Provide a bucket as the first argument.')
      end
    end

    def require_key!
      unless key
        raise(Cog::Error, 'Key not provided. Provide a key as the second argument.')
      end
    end

    def bucket
      request.args[0]
    end

    def key
      request.args[1]
    end
  end
end
