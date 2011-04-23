POINTLAYER2ANGLES
=================

Ever create a bunch of fault lines on a map in ArcGIS and need to calculate their angles in order to create a rose diagram?

Ever notice how ArcGIS does not make this easy for you?

This is a little script that will take the output of exporting the attribute table of a points layer and calculate the angles for you (from the vertical).  All three of you may find this helpful.

How to use
----------

 * In ArcGIS, draw a bunch of fault lines (or whatever) using a point layer.
 * Add the XY coordinates to your attributes (see: http://ic.ucdavis.edu/information/AddXYCoordsArcGIS9.pdf)
 * export your attributes to a TXT file.  The basic structure should look something like this:
    "OBJECTID","ORIG_FID","POINT_X","POINT_Y"
    1,11,-33.336199,-23.817999
    2,11,-33.310700,-23.795400
    3,12,-33.341099,-23.825799
    4,12,-33.342799,-23.839100
    etc....

 * Make sure you have Ruby installed (Mac users are all set for this, Windows user: http://rubyinstaller.org/)
 * Clone this repository via git:
    git clone git://github.com/daphonz/arcgis_pointlayer2angles.git
 * Go into the arcgis_pointlayer2angles directory and run:
    ruby ./pointlayer2angles.rb your-points-file.txt > your-points-file-with-angles.txt

Configuration
-------------

It's relatively easy to subclass out the FileReader and read in different formats if you like.  You can also set the output to be pretty much whatever you want by modifying the 'puts' statement at the bottom of the file.