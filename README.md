# PTRef
This is SQL & PL/SQL utility to extract information about the PeopleTools tables in a PeopleSoft database to a set of HTML files that can be navigated via a browser.

Like many other PeopleSoft professionals, I spend a lot of time look at the PeopleTools tables.  In general, these tables contain meta-data about the PeopleSoft application.  Much of the application is stored in PeopleTools tables. Some provide information about the Data Model.   Many of my utility scripts reference the PeopleTools tables.  Thus, it is very helpful to be able to understand what is in these tables.
In PeopleSoft for the Oracle DBA I discussed some tables that are of regular interest.  I included the tables that correspond to the database catalogue, and that are used during the PeopleSoft login procedure.  The tables that are maintained by the process scheduler are valuable because they contain information about who ran what process when, and how long they ran.

I am not the only person to have started to document the PeopleTools tables on their website or blog, most people have picked a few tables that are of particular interest.  However, I want to tackle the problem in a slightly different way.  There are over 3000 PeopleTools tables and view.  Tackling all of them manually would be a monumental task. 

Nevertheless, I do want a complete reference.  So, I have written code to dynamically generate a page for each PeopleTools table and view, and I have put as much information about these records as I can find in the PeopleTools tables themselves.  Reference to other objects appear as link to those pages. 

I have started to manually add my own annotation to the generated pages.  So far I have only added descriptions to a few tables (marked with an asterisk).  I would like to make this a collaborative project, and I have already had updates to some pages.

There is a page for each PeopleTools table and view.  


David Kurtz