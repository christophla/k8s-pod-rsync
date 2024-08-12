# #############################################################################
# Script for watching a directory and syncing files to a destination
# directory when they change.
#
# USAGE
# post-start.sh <source_dir> <target_dir>
#
# EXAMPLE
# post-start.sh /mnt/s3/bucket/* /data
#
# DEPENDENCIES
#   - inotify-tools (https://github.com/inotify-tools/inotify-tools)
#   - apache        (https://www.apache.org)
#   - rsync         (https://rsync.samba.org)

# #############################################################################
# GLOBAL VARIABLES
#
source_dir=$1
target_dir=$2

# #############################################################################
# LOAD DEPENDENCIES

apk update
apk add inotify-tools
apk add rsync

# #############################################################################
# EXECUTE WATCHER
#

while inotifywait -r $source_dir; do
  # stop apache
  /etc/init.d/apache2 stop

  # sync files
  rsync -avz $source_dir $target_dir

  # start apache
  /etc/init.d/apache2 start
done

# #############################################################################
