
zipper-client's container can volume mount
both tmp_zipper:rw and storer's kata-container volume.
Then it can
  o) call zip on zipper-server
  o) untar
  o) compare the untarred dir in tmp_zipper to the master
     in kata-container volume.


See if any methods can be dropped from external_disk

