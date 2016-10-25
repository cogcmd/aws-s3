require 'aws-sdk'

module S3
  class Client
    attr_reader :client

    def initialize(region)
      @client = Aws::S3::Client.new(region: region)
    end

    def list_buckets
      response = @client.list_buckets
      response.buckets
    end

    def create_bucket(params)
      params = { acl: params[:acl],
                 bucket: params[:name] }.reject { |_, v| v.nil? }

      bucket_location = bucket_location_for_region(params[:region])

      if bucket_location
        params[:create_bucket_configuration]  = { location_constraint: bucket_location }
      end

      response = @client.create_bucket(params)
      { location: response.location }
    end

    def destroy_buckets(names)
      names.map do |name|
        client.delete_bucket(bucket: name)
        { name: name }
      end
    end

    def list_bucket_acls(name)
      response = @client.get_bucket_acl(bucket: name)
      response.grants
    end

    # TODO: Handle listing over continuation (pagination)
    def list_files(bucket)
      response = @client.list_objects_v2(bucket: bucket)
      response.contents
    end

    def create_file(bucket, key, body, params = {})
      params.merge!(bucket: bucket, key: key, body: to_json_or_string(body))
      @client.put_object(params)
      params
    end

    def info_file(bucket, key, params = {})
      params.merge!(bucket: bucket, key: key)
      response = @client.get_object(params)
      body = response.body.read
      { bucket: bucket, key: key, body: body }
    end

    private

    def bucket_location_for_region(region)
      bucket_location = { 'us-east-1' => nil,
                          'us-east-2' => nil,
                          'eu-west-1' => 'EU' }[region]
      bucket_location || region
    end

    def to_json_or_string(body)
      case body
      when Enumerable
        body.to_json
      else
        body.to_s
      end
    end
  end
end
