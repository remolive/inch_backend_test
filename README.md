# INCH BACKEND TEST

 * Rails 6

Importing Person and Building from CSV files  
Sample files can be found under `csv` directory

## Models:
 * **Person**
 * **Building**
 * **AttributeVersion:** Belongs to models with versionable attributes, used to store previous values of the attribute  
 * **VersionableConcern:** Module used to manage attribute versions and import rules
 * **ImportableConcern:** Module used to add import class method to versionable models
 
