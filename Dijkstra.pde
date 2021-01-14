import java.util.*;

void setup() {
    size(400, 400);
    Graph g = new Graph("graph1.csv");

    List<Node> path = getPath(g);    
    drawGraph(g, path);
    printNodeList(path, "Shortest path");
}

List<Node> getPath(Graph g) {
    List<Node> path = new ArrayList<Node>();
    Node start = g.getFirstNode();

    start.setDistance(0);
    start.finish();
    getPathLength(start, g);
    println("The shortest distance between 'a' and '" + g.getLastNode().getName() + "' is " + g.getLastNode().getDistance());

    Node currentNode = g.getLastNode();
    while (currentNode != null) {
        path.add(currentNode);
        currentNode = currentNode.getSource();
    }

    return path;
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
        if(g.getNearestNode(node).isFinished() && !(node == current.getSource() || node.isFinished())) {
            node.finish();
            println("Finished '" + node.getName() + "'");
            getPathLength(node, g);
        }
    }
}

void printNodeList(List<Node> nodes, String label) {
    println(label + ":");
    for(Node node : nodes) {
        print(node.getName() + " ");
    }
    print("\n");
}

void drawGraph(Graph g, List<Node> path) {

}