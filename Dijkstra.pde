/**
Dies ist eine Programm zum Finden der kürzesten Strecke in 
einem Graphen durch Benutzung des Dijkstra Algorithmus

Gelöste Aufgaben: Schwierigere Aufgabe (Dijkstra-Algorithmus) mit allen Zusatzaufgaben.

Achtung!
- Das Programm kann momentan nur mit 52 Knoten rechnen, 
  da die Knoten anhand eines chars gespeichert werden.
- Negative Zahlen sind nicht unterstützt 
- Es muss eine gültige Adjazenzmatrix gegeben sein, 
  sonst KANN es zu Fehlern kommen.

GitHub:
  https://github.com/Spydr06/Dijkstra-Algorithmus
**/

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
    
    if(g.getLastNode().getDistance() == Integer.MAX_VALUE) { //Herausfinden, ob es einen Weg gibt
        println("No path found connecting 'a' and '" + g.getLastNode().getName() + "'");
        path.clear();
        return path;
    } else {
        println("The shortest distance between 'a' and '" + g.getLastNode().getName() + "' is " + g.getLastNode().getDistance());
    }

    Node currentNode = g.getLastNode(); //Zurückverfolgen des gelösten Wegs
    while (currentNode != null) {
        path.add(currentNode);
        currentNode = currentNode.getSource();
    }

    Collections.reverse(path); //Umdrehen des Weges (=> Startpunkt am Anfang)
    return path;
}

void calculateDijkstra(Node current, Graph g) { //rekursive Methode zum Lösen des Dijkstra-Algorithmus
    List<Node> connectedNodes = g.getConnectedNodes(current); //Alle mit current verbundenen Knoten

    println("==> Entering Node '" + current.getName() + "'"); //debug

    for(Node node : connectedNodes) {
        if(node == current.getSource() || node.isFinished()) { //falls der Knoten die Quelle ist oder bereits abgeschlossen ist, ignorieren
            continue;
        }

        println("Checking Node '" + node.getName() + "'"); //debug

        int distance = current.getDistance() + g.getDistanceBetween(current, node);
        if(node.getDistance() > distance) { //ist die Distanz zwischen dem aktuellen Knoten und current kleiner, wird current als Quelle definiert 
            node.setDistance(distance);
            node.setSource(current);
            println("Added Node '" + node.getName() + "' connected from Node '" + current.getName() + "' with distance " + node.getDistance()); //debug
        }
    }

    for(Node node : connectedNodes) {
        if(g.getNearestNode(node).isFinished() && !(node == current.getSource() || node.isFinished())) { //falls der Knoten mit dem kürzesten Weg zu current abgeschlossen ist,                                                                                            
                                                                                                         //gibt es keinen kürzeren Weg zu current mehr -> current abschließen
            node.finish();
            println("Finished '" + node.getName() + "'");
            calculateDijkstra(node, g);
        }
    }
}

void printNodeList(List<Node> nodes, String label) { //Hilfsfunktion zum ausdrucken einer Knotenliste
    println(label + ": " + nodeListToString(nodes));
}

String nodeListToString(List<Node> nodes) { //Hilfsfunktion zum konvertiren einer Knotenliste in einen String
    String str = "";
    for(Node node : nodes) {
        str += (node.getName() + " ");
    }
    return str;
}

void drawGraph(Graph g, List<Node> path) { //Funktion zum Zeichnen des gelösten Graphen
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
