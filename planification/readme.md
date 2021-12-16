**RRT+ Algorithm**

The design and implementation of an algorithm based on Rapidly Exploring Random Trees, hereafter referred to as RRT+, as a subtype of Rapidly Exploring Dense Trees with the use of random sampling techniques is described. Possible modifications that can be implemented as a continuation of the work presented are provided.

A solution has to be given to a planning problem on a plane for a mobile robot that can move over the configuration space R^2 xS_1=SE(2), to move between any two points of the map, under the assumption that the plane is known beforehand, and it is static. To achieve these objectives, a variant of the RRT algorithm described in [1], called RRT+, has been developed, which allows to realize an obstacle-free connection path between the initial point q_i and the final point q_f, without the need to complete the random sampling of all points in the free configuration space C_free, resulting in the shortest connection path between q_i and q_f, according to the connectivity graph G that has been formed, or showing that there is no possible path due to insufficient sampling of random points over the C_free space.


