require 's3/command'
require 's3/client'

module CogCmd::S3::File
  class Create < S3::Command
    def run_command
      require_valid_region!
      require_bucket!
      require_key!
      require_body!

      file = client.create_file(bucket, key, body)

      response.template = 'file_create'
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

    def require_body!
      unless body
        raise(Cog::Error, 'Body not provided. Provide a body as the third argument or as input from a previous command.')
      end
    end

    def bucket
      request.args[0]
    end

    def key
      request.args[1]
    end

    def body
      request.args[2]
    end
  end
end
