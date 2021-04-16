#
# Author:: Manuel David Franco Barrios (<mafraba@gmail.com>)
# © Copyright IBM Corporation 2015.
#
# LICENSE: MIT (http://opensource.org/licenses/MIT)
#
module Fog
  module Compute
    class Softlayer

      class Mock

        # Stop a VM
        # @param [Integer] id
        # @return [Excon::Response]
        def power_off_vm(id, use_hard_poweroff)
          response = Excon::Response.new
          response.status = 200
          found = self.get_vms.body.map{|server| server['id']}.include?(id)
          if not found
            response.status = 404
            response.body = {
              "error" => "Unable to find object with id of '#{id}'.",
              "code" => "SoftLayer_Exception_ObjectNotFound"
            }
          else
            response.body = true
          end
          response
        end
      end

      class Real

        def power_off_vm(id, use_hard_poweroff)
          if use_hard_poweroff
            request(:virtual_guest, "#{id.to_s}/powerOff", :http_method => :GET)
          else
            request(:virtual_guest, "#{id.to_s}/powerOffSoft", :http_method => :GET)
          end
        end

      end
    end
  end
end
