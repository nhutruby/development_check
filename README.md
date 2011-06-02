iTourSmart
===

Javascript Compression
---
`gem install jammit`

To include a new javascript in the application:

- If only used in single page
  1. Decide a module name eg. maps
  2. Copy js file to `app/javascripts/maps/`
  3. Add the module & files in `config/assets.yml` under `javascripts > maps`
  4. Include in template:

<pre>
     - content_for :head do
     = javascript_include_tag 'maps'
</pre>

- If used in every page
  1. Copy js file to `app/javascripts/library/`
  2. Add the file in `config/assets.yml` under `javascripts > library`

Js is ready to use after running `jammit` in application root

Delayed Job
---
`rake jobs:work`


Database Data
---
To load default database data as defined in db/fixtures/*.rb, run:

`rake db:seed_fu`
Importing New Category Data	
`rake db:seed_fu FILTER=categories` to update categories data

Importing Postal Code data
To load postal code data to database:
(data are saved to db for every 1000 records)
`rake import:codes`
will fetch data from iTourSmart Amazon S3 CDN
`rake import:codes source=file offset=345`
will import data from `RAILS_ROOT/.

Importing Organization data (must run `rake db:seed_fu` first to create categories)
To load organization data to database:
`rake import:org_seeds`

To Export the Page data - 
`rake page_seeds:build`
Then copy what is output to the terminal into "db/fixtures/pages.rb"
all double quotes " need to be escaped \" to avoid errors

To Import Account_Type data
`rake db:seed_fu FILTER=account_type`

To Export current account_type data to new seed file
`rake account_type_seeds:build`