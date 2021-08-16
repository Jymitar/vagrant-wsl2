require "time"

module VagrantPlugins
  module CommandServe
    module Client
      class Target

        extend Util::Connector

        STATES = [
          :UNKNOWN,
          :PENDING,
          :CREATED,
          :DESTROYED,
        ].freeze

        attr_reader :broker
        attr_reader :client

        def initialize(conn, broker=nil)
          @logger = Log4r::Logger.new("vagrant::command::serve::client::target")
          @logger.debug("connecting to target on #{conn}")
          @client = SDK::TargetService::Stub.new(conn, :this_channel_is_insecure)
          @broker = broker
        end

        def self.load(raw_target, broker:)
          t = raw_target.is_a?(String) ? SDK::Args::Target.decode(raw_target) : raw_target
          self.new(connect(proto: t, broker: broker), broker)
        end

        # @return [String] resource identifier for this target
        def resource_id
          client.resource_id(Empty.new).resource_id
        end

        # @return [SDK::Ref::Target] proto reference for this target
        def ref
          SDK::Ref::Target.new(resource_id: resource_id)
        end

        # Save the state of the target
        def save
          client.save(Empty.new)
        end

        # @return [String] name of target
        def name
          client.name(Empty.new).name
        end

        # Set name of target
        #
        # @param [String] name Name of target
        def set_name(name)
          client.set_name(
            SDK::Target::SetNameRequest.new(
              name: name
            )
          )
        end

        # @return [String] Unique identifier of machine
        def get_uuid
          client.get_uuid(Empty.new).uuid
        end

        # Set the unique identifier fo the machine
        #
        # @param [String] uuid Uniqe identifier
        def set_uuid(uuid)
          client.set_uuid(
            SDK::Target::Machine::SetUUIDRequest.new(
              uuid: uuid
            )
          )
        end

        # @return [Pathname] target specific data directory
        def data_dir
          Pathname.new(client.data_dir(Empty.new).data_dir)
        end

        # @return [Provider] provider for target
        # TODO: This needs to be loaded proeprly
        def provider
          client.provider(Empty.new)
        end

        # TODO: needs to be added
        def provider_name
          "virtualbox"
        end

        # @return [Project] project this target is within
        def project
          Project.load(client.project(Empty.new), broker: broker)
        end

        # @return [Time] time target was last updated
        def updated_at
          Time.parse(client.updated_at(Empty.new).updated_at)
        end

        # @return [Symbol] state of the target
        def state
          client.state(Empty.new).state
        end

        # @return [Machine] specialize target into a machine client
        def to_machine
          Machine.load(
            client.specialize(Google::Protobuf::Any.new).value,
            broker: broker
          )
        end
      end
    end
  end
end
