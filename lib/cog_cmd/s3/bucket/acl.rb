require 's3/command'
require 's3/client'

module CogCmd::S3::Bucket
  class Acl < S3::Command
    def run_command
      require_valid_region!
      require_name!

      acls = client.list_bucket_acls(name)

      response.template = 'bucket_acl'
      response.content = acls.map(&:to_h)
    end

    def require_name!
      unless name
        raise(Cog::Error, 'Name not provided. Provide a name as the first argument.')
      end
    end

    def name
      request.args.first
    end
  end
end
