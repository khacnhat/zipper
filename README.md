
[![Build Status](https://travis-ci.org/cyber-dojo/zipper.svg?branch=master)]
(https://travis-ci.org/cyber-dojo/zipper)

<img src="https://raw.githubusercontent.com/cyber-dojo/nginx/master/images/home_page_logo.png"
alt="cyber-dojo yin/yang logo" width="50px" height="50px"/>

# cyberdojo/zipper docker image

- Work in progress. Not used yet.

- A micro-service for [cyber-dojo](http://cyber-dojo.org).
- Creates tgz files of a kata in two formats.

- API:
  * All methods receive their arguments in a json object.
  * All methods return a json object with a single key.
  * If successful, the key equals the method's name.
  * If unsuccessful, the key equals "exception".

- - - -

# zip_json
Creates a tgz file of the kata with the given kata_id, in json format
(the format [storer](https://github.com/cyber-dojo/storer) uses).
The caller must share the tgz directory (/tmp/cyber-dojo/zips/) with zipper.
- parameter, eg
```
  {  "kata_id": "A551C528C3" }
```
- returns the filename of the created tgz file, eg
```
  { "zip_json": "/tmp/cyber-dojo/zips/A551C528C3.tgz" }
```

- - - -

# zip_git
Creates a tgz file of the kata with the given kata_id, in git format.
The caller must share the tgz directory (/tmp/cyber-dojo/zips/) with zipper.
Use this format to get individual source files to create a start-point from.
- parameter, eg
```
  {  "kata_id": "A551C528C3" }
```
- returns the filename of the created tgz file, eg
```
  { "zip_git": "/tmp/cyber-dojo/zips/A551C528C3.tgz" }
```
