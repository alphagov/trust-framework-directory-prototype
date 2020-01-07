# trust-framework-directory-prototype

The Trust Framework Directory Prototype serves as a point of trust for Brokers. 

### The Directory responsibilities
The Directory Prototype performs a range of roles, the main ones being the following - 
* Hosting a list of Brokers/IDPs that have successfully registered onto the Directory.
* Generating and Signing a Software Statement Assertions (SSA) for each Broker that has registered to the Directory. 
* Hosting the Public Key which signed the SSA so Brokers registering to third parties can be validated during Dynamic Registration. 
* Issuing Public Certificates from a CSR and hosting the corresponding Public Key so it can be validated by third parties. 
* Generating and Suppling Access Token's to ensure that the access to the Directory API is restricted.

## Running the Directory

### Prerequisites
* Ruby

### Starting the app
The Directory can be started independently by running the `startup-directory.sh` or together with the rest of the Trust Framework Prototype applications using the [start-all-services.sh](https://github.com/alphagov/stub-oidc-broker/blob/master/start-all-services.sh) in the Stub OIDC Broker repository.

When running locally, logs are outputted to `log/development.log`.

### Visiting the Admin page
The Broker has an admin page where you can view which third parties have been registered along with the SSA and Private Key which corresponds to that third party. Please note that all Private Keys used are for testing purposes and that Private Keys are only hosted on the Directory prototype to simpify demonstrating the Dynamic Registration process. When running locally the admin page is located at http://localhost:3000/admin. 

### Trust Framework Directory runs on the PAAS
* To deploy Trust Framework Directory  simply login to the PAAS and select the build-learn space. 
* Run `cf push` and this will deploy the app.
* The admin page on the PAAS is located at https://directory-prototype.cloudapps.digital/admin.

## License

[MIT](https://github.com/alphagov/trust-framework-directory-prototype/blob/master/LICENCE)