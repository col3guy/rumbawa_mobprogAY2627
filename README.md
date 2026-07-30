# Sarah Kaye S. Rumbawa, IT Student
## INF233
## CTADMOBL Advance Mobile Programming

setState comes built right into Flutter and handles state that belongs to just one widget — when it's called, only that widget rebuilds, and once the widget is gone, so is the data, which makes it perfect for small, local things like a counter or a checkbox. Provider, by contrast, needs the separate provider package and keeps its state outside of any single widget, allowing that data to be accessed and shared across many different screens, with every listening widget automatically rebuilding whenever the data updates. Put simply, setState suits quick, one-off, widget-level data, whereas Provider is meant for information — like theme settings or login state — that the whole app needs to keep track of.

## Lab Activity Instance