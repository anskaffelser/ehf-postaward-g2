# EndpointID/Legal RegistrationID

Endpoint ID  is used for specifying the electronic addresses issuers and receivers are using in their message collaboration.  Electronic addresses for norwegian participants in the PEPPOL infrastructure are the legal registration ID of the company and must be registered in ELMA.

Legal registration ID (Company ID) is used for identifying the legal entity the invoice is linked to, ie. the legal entity responsible for the obligation.

Small businesses normally have just one legal registration ID.  For these the endpoint ID and the legal registration ID  will be compliant.

Major businesses may have several legal registration IDs based on for instance location. If processing of incoming invoices are centralized for all legal entities within the business, the content of the endpoint ID and legal registration ID (Company ID) may be different. In this context it is recommended that all legal entities are registrered in ELMA.   Dissemination to a centralized invoice processing function is implemented as part of the registration by the actual accesspoint.  (Several invoice receivers share the same endpointID).

The alternative to the solution above is to handle the endpointID as an «invoice receiver address». This means that the invoice receiver manually has to inform the trading partners of the endpointID to use in the message collaboration.
