import java.util.*;

/*int[][] table = {
    { 0,  6,  0,  2,  0,  0},
    { 6,  0,  4,  5,  4,  9},
    { 0,  4,  0,  6,  4,  7},
    { 2,  5,  6,  0,  9,  0},
    { 0,  4,  4,  9,  0,  2},
    { 0,  9,  7,  0,  2,  0}
};*/

int[][] table = {
    { 0,  4,  0,  2,  0,  0},
    { 4,  1,  5,  0,  0,  0},
    { 0,  5,  0,  6,  4,  2},
    { 2,  0,  6,  0,  5,  0},
    { 0,  0,  4,  5,  0,  5},
    { 0,  0,  2,  0,  5,  0}
};


void setup() {
    size(400, 400);
    Graph g = new Graph(table);

    Node start = g.getNode('A');
    start.setDistance(0);
    start.finish();
    getPathLength(start, g);
    println("The shortest distance between 'A' and '" + g.getLastNode().getName() + "' is " + g.getLastNode().getDistance());

    printNodeList(getPath(g), "Shortest path");
}

void getPathLength(Node current, Graph g) {
    List<Node> connectedNodes = g.getConnectedNodes(current);

    println("==> Entering Node '" + current.getName() + "'");

     for(Node node : connectedNodes) {
        if(node == current.getSource() || node.isFinished()) {
            continue;
        }

        println("Checking Node '" + node.getName() + "'");

        int distance = current.getDistance() + g.getDistance(current, node);
        if(node.getDistance() > distance) { 
            node.setDistance(distance);
            node.setSource(current);
            println("Added Node '" + node.getName() + "' connected from Node '" + current.getName() + "' with distance " + node.getDistance());
        }
    }

    for(Node node : connectedNodes) {
        if(node == current.getSource() || node.isFinished()) {
            continue;
        }

        if(g.getNearestNode(node).isFinished()) {
            node.finish();
            println("Finished '" + node.getName() + "'");
            getPathLength(node, g);
        }
    }
}

List<Node> getPath(Graph g) {
    List<Node> path = new ArrayList<Node>();

    Node currentNode = g.getLastNode();
    while (currentNode != null) {
        path.add(currentNode);
        currentNode = currentNode.getSource();
    }

    return path;
}

void printNodeList(List<Node> nodes, String label) {
    println(label + ":");
    for(Node node : nodes) {
        print(node.getName() + " ");
    }
    print("\n");
}