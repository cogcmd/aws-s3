require 's3/command'
require 's3/client'

module CogCmd::S3::Bucket
  class Destroy < S3::Command
    def run_command
      require_valid_region!
      require_names!

      acls = client.destroy_buckets(names)

      response.template = 'bucket_destroy'
      response.content = acls.map(&:to_h)
    end

    def require_names!
      if names.empty?
        raise(Cog::Error, 'Name not provided. Provide one or more bucket names as arguments.')
      end
    end

    def names
      request.args
    end
  end
end
