# Drainage Database

A collection of schemas, queries, and command templates used for the analysis of urban drainage systems. Together, these provide a foundation for building future urban drainage databases.

This repository serves as a historical archive of schema definitions for urban drainage systems. The current implementations in this repository (especially the `manhole_survey`) are deprecated as discussed below in the documentation. A future update will update the database to better standards.

## Documentation

The repository holds two schemas, each with a purpose:
- **Manhole Survey** - A drainage system specifications database. To verify the as-built conditions, surveyors are sent to conduct geodetic surveys of the city's drainage system. At each manhole of the drainage system, the surveyor can measure the size of the drainage pipes, their elevations at each end, their connectivity, and much more.
- **Inundation Survey** - Collects flood *experiences* among the affected population. This data is often compared against flood simulations as a verification step. It also collects data about modes of evacuation.

### Deprecation

For future projects, the project recommends to separate the manhole database with the pipe database. One manhole can have more than two (2) connections, thus the current implementation using upstream and downstream connections is too limiting.

### A Recommended Future Implemenation

A one-to-many (manhole and pipe, respectively) relationship would be a better approximation of the drainage system. It is also closer to a Graph Network model. Which would unlock features associated with [Graph Theory](https://en.wikipedia.org/wiki/Graph_theory).
