import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.*; 
import java.util.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Dijkstra extends PApplet {



public void setup() {
    

    Graph g = new Graph("graph1.csv");

    List<Node> path = getPath(g);    

    drawGraph(g, path);
    printNodeList(path, "Shortest path");
}

public List<Node> getPath(Graph g) {
    List<Node> path = new ArrayList<Node>();
    Node start = g.getFirstNode();

    start.setDistance(0);
    start.finish();
    calculateDijkstra(start, g);
    
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

public void calculateDijkstra(Node current, Graph g) {
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

public void printNodeList(List<Node> nodes, String label) {
    println(label + ": " + nodeListToString(nodes));
}

public String nodeListToString(List<Node> nodes) {
    String str = "";
    for(Node node : nodes) {
        str += (node.getName() + " ");
    }
    return str;
}

public void drawGraph(Graph g, List<Node> path) {
    fill(0);
    textSize(20);

    text("Kürzester Weg\nLänge: " + g.getLastNode().getDistance() + "\nWeg: " + nodeListToString(path) , 0, 20);

    translate(width / 2, height / 2 + 50);
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

                int c = path.contains(nodes[i]) && nodes[j] == nodes[i].getSource() ? color(0, 200, 0) : color(0);
                fill(c);
                stroke(c);

                line(from.x, from.y, to.x, to.y);
                text(table[i][j], (from.x + to.x) / 2.0f, (from.y + to.y) / 2.0f);
            }
        }
    }
}


public class Graph {
    private int[][] table;
    private Node[] nodes;

    public Graph(String sourcePath) {
        Table csv = loadTable(sourcePath, "header");
        int numNodes = csv.getRowCount();
        
        this.table = new int[numNodes][numNodes];
        this.nodes = new Node[numNodes];

        for(int i = 0; i < numNodes; i++) {
            char name = (char) ((int) 'a' + i);
            this.nodes[i] = new Node(name);

            for(int j = 0; j < numNodes; j++) {
                table[i][j] = csv.getInt(j, Character.toString(name));
                print(table[i][j] + " ");
            }
            print("\n");
        }
    }

    public Node getNode(char name) {
        return this.nodes[(int) name - (int) 'a'];
    }

    public Node getFirstNode() {
        return this.nodes[0];
    }

    public Node getLastNode() {
        return this.nodes[nodes.length - 1];
    }

    public Node[] getNodes() {
        return this.nodes;
    }

    public int[][] getTable() {
        return this.table;
    }

    public int getDistanceBetween(Node a, Node b) {
        int indexA = (int) a.getName() - (int) 'a';
        int indexB = (int) b.getName() - (int) 'a';

        return this.table[indexA][indexB];
    }

    public List<Node> getConnectedNodes(Node node) {
        List<Node> connectedNodes = new ArrayList<Node>();

        for(int i = 0; i < nodes.length; i++) {
            int distance = this.getDistanceBetween(node, nodes[i]);
            if(distance != 0) {
                nodes[i].setSourceDistance(distance);
                connectedNodes.add(nodes[i]);
            }
        }

        Collections.sort(connectedNodes);
        return connectedNodes;
    }

    public Node getNearestNode(Node source) {
        Node nearestNode = null;
        int minDistance = Integer.MAX_VALUE;

        for(Node node : this.getConnectedNodes(source)) {
            int distance = node.getDistance() + this.getDistanceBetween(source, node);
            if(distance < minDistance && node.getDistance() != Integer.MAX_VALUE) {
                minDistance = distance;
                nearestNode = node;
            }
        }
        println("Nearest Node for '" + source.getName() + "' is '" + nearestNode.getName() + "'");
        return nearestNode;
    }

    @Override
    public String toString() {
        String str = "Nodes:\n";
        for(Node node : this.nodes) {
            str += (node.getName() + " ");
        }
        return str;
    }
}
public class Node implements Comparable<Node> {
    private char name;
    private int distance;
    private boolean finished;
    private Node source;

    private Integer sourceDistance;
    private PVector drawPosition;

    Node(char name) {
        this.name = name;
        this.finished = false;
        this.distance = Integer.MAX_VALUE;
        this.source = null;
        this.drawPosition = new PVector();
        this.sourceDistance = new Integer(0);
    }

    public char getName() {
        return this.name;
    }

    public int getDistance() {
        return this.distance;
    }

    public void setDistance(int distance) {
        this.distance = distance;
    }

    public void finish() {
        this.finished = true;
    }

    public boolean isFinished() {
        return this.finished;
    }

    public void setSource(Node source) {
        this.source = source;
    }

    public Node getSource() {
        return this.source;
    }

    public void setSourceDistance(Integer sourceDistance) {
        this.sourceDistance = sourceDistance;
    }

    public Integer getSourceDistance() {
        return this.sourceDistance;
    }

    public void setDrawPosition(PVector drawPosition) {
        this.drawPosition = drawPosition;
    }

    public PVector getDrawPosition() {
        return this.drawPosition;
    }

    @Override
    public int compareTo(Node node) {
        return this.getSourceDistance().compareTo(node.getSourceDistance());
    }
}
  public void settings() {  size(400, 500); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Dijkstra" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
