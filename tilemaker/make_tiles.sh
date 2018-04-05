#!/bin/sh
source ./mapbox_token.sh
rm -f power.mbtiles cut.osm.pbf overpass.osm
curl --compressed -o overpass.osm 'https://overpass-api.de/api/interpreter?data=%5Bout%3Axml%5D%5Btimeout%3A350%5D%3B%28node%5B%22power%22%5D%28area%3A3600114690%29%3Bway%5B%22power%22%5D%28area%3A3600114690%29%3Brelation%5B%22power%22%5D%28area%3A3600114690%29%3Bnode%5B%22power%22%5D%28area%3A3600224922%29%3Bway%5B%22power%22%5D%28area%3A3600224922%29%3Brelation%5B%22power%22%5D%28area%3A3600224922%29%3B%29%3B%28._%3B%3E%3B%29%3Bout%20meta%3B'
osmosis --read-xml file=overpass.osm --sort --bounding-polygon file=txla.poly clipIncompleteEntities=true --write-pbf file=cut.osm.pbf
tilemaker cut.osm.pbf --output power.mbtiles
mapbox-upload kre3d.do0jz1kb power.mbtiles
