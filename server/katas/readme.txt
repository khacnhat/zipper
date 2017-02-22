
I want zipper to be decoupled from web for its testing so
I'm unable to create new katas in the storer.
So I
  o) extract known katas from a live storer (extract_katas.sh).
  o) create a new data-container (create_data_container.sh)
  o) save them into a volume (using fill_data_container.sh) which I then
     mount as storer's volume.

This volume provides the known katas. Specifically

DADD67B4EF is an empty kata
F6986222F0 is a kata with one avatar and no traffic-lights
1D1B0BE42D is a kata with one avatar and one traffic-lights
697C14EDF4 is a kata with one avatar and three traffic-lights
7AF23949B7 is a kata with three avatar each with three traffic-lights