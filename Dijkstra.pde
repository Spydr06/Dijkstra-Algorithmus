import java.util.*;

void setup() { //Einstiegspunkt
    size(400, 500);
  
    Graph g = new Graph("graph1.csv"); //Laden des Graphen

    List<Node> path = getPath(g); //Berechnen des kürzesten Weges durch den Dijkstra-Algorithmus

    drawGraph(g, path); //Zeichnen des "gelösten" Graphens
    printNodeList(path, "Shortest path");
}

List<Node> getPath(Graph g) {
    List<Node> path = new ArrayList<Node>(); //Liste aus allen Knoten im kürzesten Weg
    Node start = g.getFirstNode(); //Startknoten

    start.setDistance(0);
    start.finish();
    calculateDijkstra(start, g); //startet das Berechnen des Kürzersten Weges
    
    if(g.getLastNode().getDistance() == Integer.MAX_VALUE) {
        println("No path found connecting 'a' and '" + g.getLastNode().getName() + "'");
        path.clear();
        return path;
    } else {
        println("The shortest distance between 'a' and '" + g.getLastNode().getName() + "' is " + g.getLastNode().getDistance());
    }

    Node currentNode = g.getLastNode();
    while (currentNode != null) {
        path.add(currentNode);
        currentNode = currentNode.getSource();
    }

    Collections.reverse(path);
    return path;
}

void calculateDijkstra(Node current, Graph g) {
    List<Node> connectedNodes = g.getConnectedNodes(current);

    println("==> Entering Node '" + current.getName() + "'");

    for(Node node : connectedNodes) {
        if(node == current.getSource() || node.isFinished()) {
            continue;
        }

        println("Checking Node '" + node.getName() + "'");

        int distance = current.getDistance() + g.getDistanceBetween(current, node);
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
            calculateDijkstra(node, g);
        }
    }
}

void printNodeList(List<Node> nodes, String label) {
    println(label + ": " + nodeListToString(nodes));
}

String nodeListToString(List<Node> nodes) {
    String str = "";
    for(Node node : nodes) {
        str += (node.getName() + " ");
    }
    return str;
}

void drawGraph(Graph g, List<Node> path) {
    fill(0);
    textSize(20);

    text("Kürzester Weg\nLänge: " + g.getLastNode().getDistance() + "\nWeg: " + nodeListToString(path) , 0, 20);

    translate(width / 2, height / 2 + 50); //<>//
    textSize(20);

    Node[] nodes = g.getNodes();
    PVector drawPosition = new PVector(0, 150);
    for(Node node : nodes) {
        drawPosition.rotate(TWO_PI / nodes.length);
        node.setDrawPosition(new PVector(drawPosition.x, drawPosition.y));

        fill(path.contains(node) ? color(0, 200, 0) : color(0));

        circle(drawPosition.x, drawPosition.y, 12.0f);
        text(node.getName(), drawPosition.x - 6, drawPosition.y - 16);
    }   

    int[][] table = g.getTable();
    for(int i = 0; i < nodes.length; i++) {
        for(int j = 0; j < i; j++) {
            if(table[i][j] != 0) {
                PVector from = nodes[i].getDrawPosition();
                PVector to = nodes[j].getDrawPosition();

                color c = path.contains(nodes[i]) && nodes[j] == nodes[i].getSource() ? color(0, 200, 0) : color(0);
                fill(c);
                stroke(c);

                line(from.x, from.y, to.x, to.y);
                text(table[i][j], (from.x + to.x) / 2.0f, (from.y + to.y) / 2.0f);
            }
        }
    }
}
