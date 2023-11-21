Functional tests for the TEKSI Wastewater Datamodel
=======================================

Here are functional tests for the TEKSI wastewater datamodel.

In utils.py there are methods to insert, update, select and check rows.

Every file should be run in a single transaction which is rolled back in the end. This way every test knows that it starts with a clean database.

If existing data is required for a test there are two possibilities:

 * Create the data in a method early executed in the test.
 * Create a helper script that sets up the database (in an uncommitted transaction) which is called from YourTest.setUpClass(cls). This way you may use the same setup procedure for several tests.
