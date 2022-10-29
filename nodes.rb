require 'rest-client'
require 'json'
require 'logger'

# Set up logger. The levels are:
# +UNKNOWN+:: An unknown message that should always be logged.
# +FATAL+:: An unhandleable error that results in a program crash.
# +ERROR+:: A handleable error condition.
# +WARN+::  A warning.
# +INFO+::  Generic (useful) information about system operation.
# +DEBUG+:: Low-level information for developers.
@logger       = Logger.new(STDOUT)
# @@logger = Logger.new('logfile.log')
@logger.level = Logger::INFO

@id_map = {"089ef556-dfff-4ff2-9733-654645be56fe" => 1}

def get_nodes node_id

  base_url = "https://nodes-on-nodes-challenge.herokuapp.com/nodes"
  url = "#{base_url}/#{node_id}"
  @logger.info "Getting #{url}"

  resp = RestClient.get(url)
  body = JSON.parse(resp.body)

  new_nodes = []
  
  body.each do |item|
    child_nodes = item['child_node_ids']
    @logger.info "Found #{child_nodes.length} child nodes"

    child_nodes.each do |child_node|

      if @id_map[child_node].nil?
        @id_map[child_node] = 0
      end

      @id_map[child_node] += 1

    end

    new_nodes.concat child_nodes
  end

  if !new_nodes.empty?
    get_nodes new_nodes.join(',')
  end
end

node_id = "089ef556-dfff-4ff2-9733-654645be56fe"

get_nodes node_id
