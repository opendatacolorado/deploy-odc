DB_USER = "odc-user"
DB_NAME = "opendata"
DB_PASSWORD = "abc123"
ODC_DIR = "opendatacatalog1"

GIT_REPO = "git@github.com:joannecheng/Open-Data-Catalog.git"
OVERLAY_GIT_REPO = "git@github.com:joannecheng/odc-co.git"

#

# install virtualenv
puts "installing virtualenv"
system "sudo pip install virtualenv"

# set up virtualenv for opendatacatalog
puts "set up virtualenv for odc"
system "virtualenv #{ODC_DIR}"

# clone opendatacatalog (remove old catalog first)
puts "removing old odc if it exists"
Dir.chdir ODC_DIR
system "rm -rf Open-Data-Catalog || true"

puts "pulling from #{GIT_REPO}"
system "git clone #{GIT_REPO}"

# pip install requirements.txt
puts "installing odc requirements"
system "source bin/activate"
Dir.chdir "Open-Data-Catalog"
system "../bin/pip install -r requirements.txt"

# links and permissions
puts "links and permissions"
Dir.chdir "OpenDataCatalog"
system "mkdir media"
system "chmod 755 media"
system "ln -s ../../lib/python2.7/site-packages/django/contrig/admin admin_media"

# Database stuff (syncdb)
system "sudo createuser -S -d -R -P #{DB_USER}"
system "sudo psql template1 -c 'CREATE DATABASE #{DB_NAME} OWNER \"#{DB_USER}\"';" 
puts "running syncdb"
system "../../../bin/python manage.py syncdb"

# overlay
puts "getting templates and overlay files from #{OVERLAY_GIT_REPO}"
Dir.chdir "../"
system "pwd"
system "git clone #{OVERLAY_GIT_REPO}"
system "cp odc-co/local_settings.py OpenDataCatalog/"
system "cp odc-co/local_assets.py OpenDataCatalog/"
system "deactivate"

