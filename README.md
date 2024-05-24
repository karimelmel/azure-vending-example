# Azure Landing Zone Vending Repository

This repository automatically provisions new subscriptions for application teams needing to deploy workloads.


### Archetype: Online

For workloads that might require direct internet inbound/outbound connectivity or for workloads that might not require a virtual network.

### Archetype: Corp

The Corp archetype is for subscriptions that require an Azure Virtual Network and access towards on-premise.

### Archetype: Sandbox

These subscriptions are securely disconnected from the corporate and online landing zones. Sandboxes also have a less restrictive set of policies assigned to enable testing, exploration, and configuration of Azure services. This archetype has a fixed expiration date, and its resources will automatically be deleted after the expiration date. Typically, this archetype comes without a GitHub repository and service principal.

