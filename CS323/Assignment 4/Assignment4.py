# Assignment 4 (Graph Algorithms)
# CSCI 323
# Timothy Dakis
# Websites used: https://www.geeksforgeeks.org

import sys
from os import listdir
from os.path import isfile, join
import time
import pandas as pd


def read_graph(file_name):
    with open(file_name, 'r') as file:
        graph = []
        lines = file.readlines()
        for line in lines:
            costs = line.split(" ")
            row = []
            for cost in costs:
                row.append(int(cost))
            graph.append(row)
        return graph


def desc_graph(graph):
    message = ""
    num_vertices = len(graph)
    message += "Number of vertices = " + str(num_vertices) + "\n"
    non_zero = 0
    for i in range(num_vertices):
        for j in range(num_vertices):
            if graph[i][j] > 0:
                non_zero += 1
    num_edges = non_zero // 2
    message += "Number of edges = " + str(num_edges) + "\n"
    message += "Symmetric = " + str(is_symmetric(graph))
    return message


def print_graph(graph, sep=" "):
    str_graph = ""
    for row in range(len(graph)):
        str_graph += sep.join(str(c) for c in graph[row]) + "\n"
    return str_graph


def is_symmetric(graph):
    num_vertices = len(graph)
    for i in range(num_vertices):
        for j in range(num_vertices):
            if graph[i][j] != graph[j][i]:
                return False
    return True


# https://www.geeksforgeeks.org/depth-first-search-or-dfs-for-a-graph/
# A function used by DFS
def dfs_util(graph, v, visited):
    # Mark the current node as visited and print it
    visited.append(v)
    # Recur for all the vertices adjacent to this vertex
    for col in range(len(graph[v])):
        if graph[v][col] > 0 and col not in visited:
            dfs_util(graph, col, visited)


# The function to do DFS traversal. It uses# recursive DFSUtil()
def dfs(graph):
    # Create a set to store visited vertices
    visited = []
    # Call the recursive helper function to print DFS traversal
    dfs_util(graph, 0, visited)
    return visited


# https://www.geeksforgeeks.org/breadth-first-search-or-bfs-for-a-graph/
def bfs(graph):
    # Mark all the vertices as not visited
    visited = []
    # Create a queue for BFS
    queue = [0]
    # Mark the source node as visited and enqueue it
    visited.append(0)
    while queue:
        # Dequeue a vertex from queue and print it
        s = queue.pop(0)
        # Get all adjacent vertices of the dequeued vertex s. If a adjacent
        # has not been visited, then mark it visited and enqueue it
        for col in range(len(graph[s])):
            if graph[s][col] > 0 and col not in visited:
                queue.append(col)
                visited.append(col)
    return visited


# https://www.geeksforgeeks.org/prims-minimum-spanning-tree-mst-greedy-algo-5/
# A utility function to find the vertex with minimum distance value, from the set of vertices
# not yet included in shortest path tree
def min_key(graph, key, mst_set):
    # Initialize min value
    min_val = sys.maxsize

    for v in range(len(graph)):
        if key[v] < min_val and mst_set[v] == False:
            min_val = key[v]
            min_index = v

    return min_index


# https://www.geeksforgeeks.org/prims-minimum-spanning-tree-mst-greedy-algo-5/
# Function to construct and print MST for a graph represented using adjacency matrix representation
def prim_mst(graph):
    # Key values used to pick minimum weight edge in cut
    key = [sys.maxsize] * len(graph)
    parent = [None] * len(graph) # Array to store constructed MST
    # Make key 0 so that this vertex is picked as first vertex
    key[0] = 0
    mst_set = [False] * len(graph)

    parent[0] = -1  # First node is always the root of
    for cout in range(len(graph)):
        # Pick the minimum distance vertex from the set of vertices not yet processed.
        # u is always equal to src in first iteration
        u = min_key(graph, key, mst_set)

        # Put the minimum distance vertex in
        # the shortest path tree
        mst_set[u] = True

        # Update dist value of the adjacent vertices of the picked vertex only if the current
        # distance is greater than new distance and the vertex in not in the shortest path tree
        for v in range(len(graph)):
            # graph[u][v] is non zero only for adjacent vertices of m
            # mstSet[v] is false for vertices not yet included in MST
            # Update the key only if graph[u][v] is smaller than key[v]
            if 0 < graph[u][v] < key[v] and mst_set[v] == False:
                key[v] = graph[u][v]
                parent[v] = u

    # Build a string to return containing edges and total cost
    output_str = "Edges = ["
    total_cost = 0
    for i in range(1, len(graph)):
        output_str += ("{" + str(parent[i]) + "," + str(i) + "}")
        total_cost += graph[i][parent[i]]
        if i is not len(graph) - 1:
            output_str += ", "
    output_str += ("]\nTotal Weight = " + str(total_cost))
    return output_str


# A utility function to find set of an element i (uses path compression technique)
def find(graph, parent, i):
    if parent[i] == i:
        return i
    return find(graph, parent, parent[i])


# A function that does union of two sets of x and y (uses union by rank)
def union(graph, parent, rank, x, y):
    x_root = find(graph, parent, x)
    y_root = find(graph, parent, y)

    # Attach smaller rank tree under root of high rank tree (Union by Rank)
    if rank[x_root] < rank[y_root]:
        parent[x_root] = y_root
    elif rank[x_root] > rank[y_root]:
        parent[y_root] = x_root

    # If ranks are same, then make one as root and increment its rank by one
    else:
        parent[y_root] = x_root
        rank[x_root] += 1


def get_edges(graph):
    edges = []
    for row in range(len(graph)):
        for col in range(len(graph[row])):
            if row == col:
                break
            else:
                if graph[row][col] > 0:
                    edges.append([row, col, graph[row][col]])
    return edges


# https://www.geeksforgeeks.org/kruskals-minimum-spanning-tree-algorithm-greedy-algo-2/
# The main function to construct MST using Kruskal's algorithm
def kruskal_mst(graph):
    result = []  # This will store the resultant MST
    # An index variable, used for sorted edges
    i = 0

    # An index variable, used for result[]
    e = 0

    all_edges = get_edges(graph)

    # Step 1:  Sort all the edges in non-decreasing order of their weight.  If we are not allowed to change the
    # given graph, we can create a copy of graph
    all_edges = sorted(all_edges, key=lambda item: item[2])

    parent = []
    rank = []

    # Create V subsets with single elements
    for node in range(len(graph)):
        parent.append(node)
        rank.append(0)

    # Number of edges to be taken is equal to V-1
    while e < (len(graph) - 1):

        # Step 2: Pick the smallest edge and increment the index for next iteration
        u, v, w = all_edges[i]
        i = i + 1
        x = find(graph, parent, u)
        y = find(graph, parent, v)

        # If including this edge doesn't cause cycle, include it in result
        # and increment the index of result for next edge
        if x != y:
            e = e + 1
            result.append([u, v, w])
            union(graph, parent, rank, x, y)
        # Else discard the edge

    # creating output string of what MST is
    total_cost = 0
    edges_in_output = 0
    output_string = "Edges = ["
    for u, v, w in result:
        total_cost += w
        edges_in_output += 1
        output_string += ("{" + str(v) + "," + str(u) + "}")
        if edges_in_output != len(graph) - 1:
            output_string += ", "
    output_string += ("]\nTotal Cost = " + str(total_cost))
    return output_string


# https://www.geeksforgeeks.org/dijkstras-shortest-path-algorithm-greedy-algo-7/
def min_distance(graph, dist, spt_set, src):
    # Initialize minimum distance for next node
    min_val = sys.maxsize

    # Search not nearest vertex not in the shortest path tree
    for u in range(len(graph)):
        if dist[u] < min_val and spt_set[u] == False:
            min_val = dist[u]
            min_index = u
    return min_index


# https://www.geeksforgeeks.org/dijkstras-shortest-path-algorithm-greedy-algo-7/
# Function that implements Dijkstra's single source shortest path algorithm for a graph represented
# using adjacency matrix representation
def dijkstra(graph):

    dist = [[sys.maxsize for j in range(len(graph))] for i in range(len(graph))]
    pred = [[0 for j in range(len(graph))] for i in range(len(graph))]
    for src in range(len(graph)):
        dist[src][src] = 0
        pred[src][src] = -1
        spt_set = [False] * len(graph)
        for cout in range(len(graph)):
            # Pick the minimum distance vertex from the set of vertices not yet processed.
            # x is always equal to src in first iteration
            x = min_distance(graph, dist[src], spt_set, src)

            # Put the minimum distance vertex in the
            # shortest path tree
            spt_set[x] = True

            # Update dist value of the adjacent vertices
            # of the picked vertex only if the current
            # distance is greater than new distance and
            # the vertex in not in the shortest path tree
            for y in range(len(graph)):
                if graph[x][y] > 0 and spt_set[y] == False and dist[src][y] > dist[src][x] + graph[x][y]:
                    dist[src][y] = dist[src][x] + graph[x][y]
                    pred[src][y] = x
    output_string = "Dist Array: " + str(dist) + "\nPred Array: " + str(pred)
    return output_string


# adapted from code from class
def floyd_apsp(graph):
    # create the 2d arrays
    dist = [[0 for j in range(len(graph))] for i in range(len(graph))]
    pred = [[0 for j in range(len(graph))] for i in range(len(graph))]
    # init loop
    for i in range(len(graph)):
        for j in range(len(graph)):
            dist[i][j] = graph[i][j]  # path of length 1, i.e. just the edge
            pred[i][j] = i  # predecessor will be vertex i
            if dist[i][j] == 0:
                dist[i][j] = sys.maxsize
        dist[i][i] = 0  # no cost
        pred[i][i] = -1  # indicates end of path

    # main loop
    for k in range(len(graph)):
        for i in range(len(graph)):
            for j in range(len(graph)):
                if dist[i][j] > dist[i][k] + dist[k][j]:  # use intermediate vertex k
                    dist[i][j] = dist[i][k] + dist[k][j]
                    pred[i][j] = pred[k][j]

    output_string = "Dist Array: " + str(dist) + "\nPred Array: " + str(pred)
    return output_string


def main():
    dict_graph_algs = {}
    graph_algs = [dfs, bfs, prim_mst, kruskal_mst, dijkstra, floyd_apsp]
    for graph_alg in graph_algs:
        dict_graph_algs[graph_alg.__name__] = {}
    mypath = "C:\\Users\\timos\\PycharmProjects\\Assignment4\\"
    files = [f for f in listdir(mypath) if isfile(join(mypath, f))]
    for file in files:
        if file[0:5] == "graph" and file.find("_report") < 0:
            graph = read_graph(file)
            output_str = "Analysis of graph: " + file + "\n" + print_graph(graph, " ") + "\n" + desc_graph(graph) + "\n"
            for graph_alg in graph_algs:
                dict_graph_algs[graph_alg.__name__][len(graph)] = 0
            for graph_alg in graph_algs:
                output_str += "\n" + graph_alg.__name__ + ":\n"
                start_time = time.time()
                output_str += str(graph_alg(graph)) + "\n"
                end_time = time.time()
                net_time = end_time - start_time
                dict_graph_algs[graph_alg.__name__][len(graph)] += net_time
            print(output_str)
            output_file_name = file[0:len(file) - 4] + "_report.txt"
            with open(output_file_name, "w") as output_file:
                output_file.write(output_str)

    pd.set_option('display.max_rows', 500)
    pd.set_option('display.max_columns', 500)
    pd.set_option('display.width', 1000)
    df = pd.DataFrame.from_dict(dict_graph_algs).T
    print(df)


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    main()
