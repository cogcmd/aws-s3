require 's3/command'
require 's3/client'

module CogCmd::S3::Bucket
  class Create < S3::Command
    def run_command
      require_valid_region!
      require_name!

      bucket = client.create_bucket(acl: acl, name: name, region: region)

      response.template = 'bucket_create'
      response.content = [bucket]
    end

    def require_name!
      unless name
        raise(Cog::Error, 'Name not provided. Provide a name as the first argument.')
      end
    end

    def name
      request.args.first
    end

    def acl
      request.options['acl']
    end
  end
end
