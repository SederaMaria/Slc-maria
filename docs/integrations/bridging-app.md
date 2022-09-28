# Speed Leasing - Bridging App

## Development

### FAQ

#### How to connect `slc-los` docker container to `bridging-app` docker container locally?

1. Get Docker bridge gateway IP address
    * Ubuntu (or other linux distro)
        1. Check `docker network ls` and find `bridge` and its network ID
        1. Use the network ID to check its details as such `docker network inspect NETWORK_ID_HERE`.
        1. Find the Gateway, which should look something like `172.17.0.1`
            * You can add `grep Gateway` optionally. `docker network inspect NETWORK_ID_HERE | grep Gateway`
    * MacOS -> TODO
    * Windows -> TODO

1. Go to Rails Container and configure `LeaseManagementSystem`
    1. [Access Rails container](README.md#accessing-the-rails-container)
    1. Access rails console `bundle exec rails console` and use the following snippet:
      ```ruby
        record = LeaseManagementSystem.first
        address = "YOUR_GATEWAY_IP_ADDRESS"
        record.update(api_destination: "http://#{address}:3008/api/v1/lease", send_leases_to_lms: true)
      ```

1. Test
    1. Start `slc-los` and `bridging-app` containers (`docker-compose up`)
    1. [Access Rails container](README.md#accessing-the-rails-container)
    1. Simulate an API call inside rails console (run `bundle exec rails console`)
        1. Get the document status condition to run the API call
          ```ruby
            record = LeaseManagementSystem.first
            record.document_status
            # => "funding_approved"
          ```
        1. In, Admin Portal Lease Applications, find a record that has the required document status and get its ID
        1. Go back to rails console and run the following snippet
          ```ruby
            record = LeaseApplication.find(ID)
            record.send_leases_to_lms
            # {"status"=>"ok"}
            # => true
          ```
    1. Double check in `bridging-app`
        1. Check the logs with the API request of `Started POST "/api/v1/lease"`
        1. Compare the request params if it matches the data (example: `leaseApplication.id` in params should be equal to `LeaseApplicaiton.id` in your snippet)
