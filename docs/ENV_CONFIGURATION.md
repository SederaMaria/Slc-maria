# ENV Configuration

## Morpheus

* `MORPHEUS_URL`:  URL for Morpheus API integration

  Examples:
  `MORPHEUS_URL=https://api.morpheus.domain/`
  `MORPHEUS_URL=http://localhost:3005/`

  [**Docker**] In development, if **LOS** is running inside a docker container and **Morpheus** is not (running locally or in *localhost*), you can use a pre defined host `host.docker.internal`. This will enable you to bridge the network without modifying `docker-compose.yml`.

  Example: `MORPHEUS_URL=http://host.docker.internal:3005`

  More info on Docker Desktop networking: [Mac](https://docs.docker.com/desktop/mac/networking/), [Windows](https://docs.docker.com/desktop/windows/networking/)

## Mailer

* `MAILER_OUTGOING_LESSEE`: All emails going out to `Lessee.email_address`

  Collaborates with ENV `NOTIFY_LESSEE_ATTACHMENT` and `EmailTemplate.lease_package_recieved.enable_template`

## Dealer Mailer

* `DEALER_MAILER_CREDIT_EVENT_EMAIL`: Email to send credit related notification

  Examples:
  `DEALER_MAILER_CREDIT_EVENT_EMAIL=credit@speedleasing.com`

## Rack Attack

* `RACK_THROTTLE_ADMIN_ACTIONS_SECONDS` <!-- TODO -->

## Bridging App

* `BRIDGING_EMAIL` <!-- TODO -->
* `BRIDGING_PASSWORD` <!-- TODO -->
