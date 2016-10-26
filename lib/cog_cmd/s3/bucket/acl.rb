require 's3/command'
require 's3/client'

module CogCmd::S3::Bucket
  class Acl < S3::Command
    def run_command
      require_valid_region!
      require_bucket!

      acls = client.list_bucket_acls(bucket)

      response.template = 'bucket_acl'
      response.content = acls.map(&:to_h)
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
